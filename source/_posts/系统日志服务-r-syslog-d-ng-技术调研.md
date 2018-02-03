---
title: '系统日志服务[r]syslog[{d-ng}]技术调研'
date: 2018-02-03 23:12:18
tags:
categories: Linux
---

对于日志管理，老版本的Linux缺省使用syslog，虽然syslog中规中矩，但是随着时间的推移，无论是功能还是性能，它都显得捉襟见肘，于是出现了rsyslog和syslog-ng，它们不仅涵盖了sysLog的基本功能，而且在功能和性能上更为出色。目前多数Linux发行版均选择了rsyslog。下面一一介绍syslog、syslog-ng以及rsyslog。

# syslog

（1）syslog简介

syslog日志记录器由两个守护进程klogd/syslogd和一个配置文件/etc/syslog.conf组成。klogd不使用配置文件，它负责截获内核消息，它既可以独立使用也可以作为syslogd的客户端运行，也就是klogd可以将捕获的内核日志直接记录到文件中，也可以转发给syslogd。syslogd默认使用/etc/syslog.conf作为配置文件，它负责截获应用程序消息，还可以截获klogd向其转发的内核消息。Linux系统启动时，/etc/init.d/syslogd脚本会同时启动syslogd和klogd.

备注：其实syslog还有一个配置文件/etc/sysconfig/syslog，这个文件用来配置syslog在启动syslogd和klogd时的一些启动参数，例如如果想让syslogd作为日志服务器来接受其他syslog发过来的日志，就需要修改/etc/sysconfig/syslog的配置。

（2）syslogd的配置

syslog.conf是syslogd进程的配置文件，将在程序启动时读取，默认位置是/etc/syslog.conf 。它指定了一系列日志记录规则。规则的格式如下：

	facility.level    action

这个配置文件中的空白行和以"#"开头的行将被忽略。"facility.level"部分也被称为选择符(seletor)。seletor和action之间使用一个或多个空白分隔。

A）facility

选择符由facility和level两部分组成，之间用一个句点(.)连接。facility指定了产生日志的子系统，可以是下面的关键字之一：

	auth      #由pam_pwdb报告的认证活动
	authpriv  #包括私有信息(如用户名)在内的认证活动
	cron      #与cron和at有关的信息
	daemon    #与inetd守护进程有关的信息
	ftp       #与FTP有关的信息
	kern      #内核信息，首先通过klogd传递
	lpr       #与打印服务有关的信息
	mail      #与电子邮件有关的信息
	mark      #syslog内部功能用于生成时间戳
	news      #来自新闻服务器的信息
	syslog    #由syslog生成的信息
	user      #由用户程序生成的信息
	uucp      #由uucp生成的信息
	local0 ~ local7  #由自定义程序使用，例如使用local5做为ssh功能
	*                #通配符代表除了mark以外的所有facility

备注：在大多数情况下，任何程序都可以通过任何facility发送日志消息，但是一般都遵守约定俗成的规则。比如，只有内核才能使用"kern" facility.

B）level

level指定了消息的优先级，可以是下面的关键字之一(降序排列，严重性越来越低)：

	emerg   #系统不可用
	alert   #需要立即被修改的条件
	crit    #阻止某些工具或子系统功能实现的错误条件
	err     #阻止工具或某些子系统部分功能实现的错误条件
	warning #预警信息
	notice  #具有重要性的普通条件
	info    #提供信息的消息
	debug   #不包含函数条件或问题的其他信息
	none    #没有优先级，通常用于排错
	*       #除了none之外的所有级别

备注：facility部分可以是用逗号(,)分隔的多个子系统，而多个seletor之间也可以通过分号(;)组合在一起。需要注意的是，多个组合在一起的选择符，后面的会覆盖前面的，这样就允许从模式中排除一些优先级。

C）动作action

这个字段定义了对符合条件的消息进行何种操作，可以选择下列操作之一：

+ 普通文件，将消息记录到这个文件中，必须使用绝对路径。如果在文件名之前加上减号(-)，则表示不将日志信息同步刷新到磁盘上(使用写入缓存)，这样可以提高日志写入性能，但是增加了系统崩溃后丢失日志的风险。

+ 命名管道，在绝对路径表示的FIFO文件（使用mkfifo命令创建）前加上管道符号(|)即可。通常用于调试。比如：|/usr/adm/debug。

+ 终端或者控制台，比如/dev/tty1或/dev/console。

+ 远程主机，syslogd能够将消息发送到远程主机或从远程主机接收消息，不过默认并不转发接收到的消息。要将消息发送到远程主机，可以在主机名前加一个"@"即可。

+ 逗号分隔的用户名列表，critical级别的消息除了记录到日志之外，通常还转发到root用户。

+ 所有当前登录的用户，如果写上一个星号(*)则表示向当前所有登录的用户显示这条消息。

备注： syslogd默认从Unix domain socket读取本地日志消息，而klogd默认首选从/proc/kmsg中获取内核消息。

（3）syslogd和klogd启动参数的配置

/etc/sysconfig/syslog文件可以用来配置syslogd和klogd的启动参数，在该文件中有SYSLOGD_OPTIONS和KLOGD_OPTIONS两个属性，分别用来控制syslogd和klogd启动时的命令行参数。具体配置选项有：

	-r —— 打开接受外来日志消息的功能，其监控514 UDP端口
	-x —— 关闭自动解析对方日志服务器的FQDN信息，这能避免DNS不完整所带来的麻烦
	-m —— 修改syslog的内部mark消息写入间隔时间（0为关闭），例如240为每隔240分钟写入一次“--MARK--”信息
	-h —— 默认情况下，syslog不会发送从远端接受过来的消息到其他主机，而使用该选项，则把该开关打开，所有接受到的信息都可根据syslog.conf中定义的@主机转发过去

（4）用户程序使用syslog记录日志信息

Linux C中提供一套系统日记写入接口，包括三个函数：openlog，syslog和closelog。举例来说：

```c++
#include <syslog.h>   
int main(int argc, char *argv[]) {   
    openlog("testsyslog", LOG_CONS | LOG_PID, 0);   
    syslog(LOG_USER | LOG_INFO, "syslog test message generated in program %s \n", argv[0]);   
    closelog();   
    return 0;   
}
```

编译生成可执行文件后，每运行一次，程序将往/var/log/messages添加一条如下的记录。

备注：其中LOG_USER是指定往syslog的哪个facility中写入日志，LOG_INFO表示这条日志的等级。

（5）一些常见的日志

```
/var/log/messages   #包含整个系统的信息，包括系统启动期间被记录的日志。mail, cron, daemon, kern, auth等相关的日志信息在这里记录
/var/log/dmesg      #系统的启动日志信息
/var/log/auth.log   #包括系统的授权信息，包括用户登陆和使用的权限机制等
/var/log/boot.log   #包含系统启动时记录的日志
/var/log/daemon.log #包括多种后台守护进程的日志信息
/var/log/dpkg.log   #包括使用dpkg命令安装或删除包时记录的信息
/var/log/kern.log   #内核记录的信息。可以帮助定位定制内核的问题(注：在ArchLinux中为kernel.log)
/var/log/lastlog    #最近所有用户的登陆信息，这不是一个ascii文件，应该使用lastlog命令来查看文件信息
/var/log/maillog /var/log/mail.log #包含系统中运行的邮件服务的日志。例如sendmail的日志信息都会在这里被记录
/var/log/user.log    #包括所有用户等级的日志
/var/log/Xorg.x.log  #X系统的日志信息
/var/log/alternatives.log  #关于更新替代的信息，Ubuntu中，不同的默认命令，会有不同的符号链接到对应的文件（？）On Ubuntu, update-alternatives maintains symbolic links determining default commands.
/var/log/btmp         #包含尝试登陆失败的信息，使用last 命令查看，例如 “last -f /var/log/btmp | more”
/var/log/cups         #所有的打印机和打印相关的
/var/log/anaconda.log #存储安装相关的信息
/var/log/yum.log      #使用yum安装包时的相关信息
/var/log/cron         #每当cron守护进程（或anacron）开始cron定时操作时，都会将日志信息记录再这里
/var/log/secure       #包含认证和授权相关的信息。例如sshd登陆记录的所有信息，包括失败的信息
/var/log/wtmp 或 /var/log/utmp  #包含登陆记录。使用wtmp可以查出都有谁登陆过系统，非ASCII文件。who命令通过这个文件来显示信息。（wtmp 编程）
/var/log/faillog      #包含用户的失败登陆尝试，使用faillog命令显示文件内容。非ASCII文件
```

除了以上的日志文件，/var/log目录也包含一些子目录，这取决于你系统上运行的应用，

```bash
/var/log/httpd/ 或 /var/log/apache2  #包括apache web服务器的access_log和error_log信息
/var/log/lighttpd/                   #包含lighthttpd的access_log和error_log信息
/var/log/conman/                     #ConMan客户端的日志文件（ConMan是一个console manager，需要有conmand守护进程运行）
/var/log/mail/                       #包含邮件服务的额外日志。例如，sendmain会收集邮件的统计信息保存在/var/log/mail/statistics文件中
/var/log/prelink/           #预链接（prelink program）修改（modifies?）已共享的库文件以及已链接的二进制文件来加速启动新的进程。/var/log/prelink/prelink.log 包含被prelink修改过的.so文件的信息
/var/log/audit/             #包含Linux audit daemon (auditd).存储的信息（？）
/var/log/setroubleshoot/    #SELinux使用setroubleshootd (SE Trouble Shoot Daemon) 来通告关于文件的安全上下文问题，这里存储其日志信息
/var/log/samba/   #Samba的日志信息, Samba用来能使Windows连接到Linux的共享内容
/var/log/sa/      #包含sysstat软件包收集的每天的sar文件
/var/log/sssd/    #系统安全服务守护进程的相关日志。它用来管理远端目录的访问和授权
```

# syslog-ng

（1）syslog-ng的简介

syslog-ng(syslog next generation)是syslog的升级版，是由Balabit IT Security Ltd.公司维护的一套开源的Unix和类Unix系统的日志服务套件。它是一个灵活的、可伸缩的系统日志记录程序。syslog-ng有两个版本，一个是收费的，一个是开源的。 作为syslog的下一代产品，Syslog-ng主要特性有：

	支持SSL/TSL协议
	支持将日志写入数据库中,支持的数据库有MySQL, Microsoft SQL (MSSQL),Oracle, PostgreSQL, and SQLite.
	支持标准的syslog协议
	支持filter、parse以及rewrite
	支持更多的平台
	更高的负载能力

syslog-ng的工作原理结构图如下：

![](/images/syslogd_1_1.png)

（2）syslog-ng的配置

syslog-ng的配置文件在syslog-ng的安装目录下的${SYSLOG-NG_HOME}/etc/syslog-ng.conf中。 syslog-ng.conf文件里的内容有以下几个部分组成：

```
# 全局选项,多个选项时用分好";"隔开
options { .... };
# 定义日志源,
source s_name { ... };
# 定义过滤规则，规则可以使用正则表达式来定义,这里是可选的,不定义也没关系
filter f_name { ... };
# 定义目标
destination d_name { ... };
# 定义消息链可以将多个源,多个过滤规则及多个目标定义为一条链
log { ... };
```

syslog-ng的学习资料参考于：
http://cyr520.blog.51cto.com/714067/1245650
http://ant595.blog.51cto.com/5074217/1080922

# rsyslog

（1）rsyslog简介

在CentOS 6中，日志是使用rsyslogd守护进程进行管理的，该进程是syslog的升级版，对原有的日志系统进行了功能的扩展，提供了诸如过滤器，日志加密保护，各种配置选项，输入输出模块，支持通过TCP或者UDP协议进行传输等。如下为官方的rsyslog的架构：

![](/images/syslogd_1_2.png)

rsyslog的消息流是从`输入模块->预处理模块->主队列->过滤模块->执行队列->输出模块`。 在rsyslog的架构图中，输入、输出、过滤三个部分称为module。输入模块有imklg/imsock/imfile等，输出模块有omudp/omtcp/omfile/omprog/ommysql/omruleset等，过滤模块有mmnormalize等。其中输入模块以im为前缀，输出模块以om为前缀。

如下为rsyslog官网上发布的所支持的数据源和输出设备：

![](/images/syslogd_1_3.png)

（2）rsyslog的配置

rsyslog的配置文件有/etc/rsyslog.conf、/etc/rsyslog.d/*.conf以及/etc/sysconfig/rsyslog。其中/etc/rsyslog.d/*.conf会被包含Include到/etc/rsyslog.conf中，/etc/sysconfig/rsyslog是用来配置rsyslog启动时的命令行参数。

rsyslog的学习资料参考于：
http://www.rsyslog.com
http://www.cnblogs.com/tobeseeker/archive/2013/03/10/2953250.html
http://blog.csdn.net/wangjianno2/article/details/50199639