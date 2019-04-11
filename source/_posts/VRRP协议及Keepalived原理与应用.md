---
title: VRRP协议及Keepalived原理与应用
date: 2019-02-18 11:37:41
tags:
categories: SRE
---

# VRRP简介

VRRP，Virtual Router Redundancy Protocol，虚拟路由器冗余协议。VRRP由IETF提出，目的是为了解决局域网中配置默认网关的单点失效问题，1998年已推出正式的RFC2338协议标准。VRRP广泛应用在边缘网络中，它的设计目标是支持特定情况下IP数据流量失败转移不会引起混乱，允许主机使用单路由器，以及及时在实际第一跳路由器使用失败的情形下仍能够维护路由器间的连通性。

VRRP将局域网的一组路由器（包括一个Master即活动路由器和若干个Backup即备份路由器）组织成一个虚拟路由器，称之为一个备份组。这个虚拟的路由器拥有自己的IP地址10.100.10.1（这个IP地址可以和备份组内的某个路由器的接口地址相同，相同的则称为ip拥有者），备份组内的路由器也有自己的IP 地址（如Master的IP地址为10.100.10.2，Backup 的IP地址为10.100.10.3）。局域网内的主机仅仅知道这个虚拟路由器的IP地址10.100.10.1，而并不知道具体的Master路由器的IP地址10.100.10.2以及Backup路由器的IP地址10.100.10.3。它们将自己的缺省路由下一跳地址设置为该虚拟路由器的IP地址10.100.10.1。于是，网络内的主机就通过这个虚拟的路由器来与其它网络进行通信。如果备份组内的Master路由器坏掉，Backup路由器将会通过选举策略选出一个新的Master路由器，继续向网络内的主机提供路由服务，从而实现网络内的主机不间断地与外部网络进行通信。

VRRP说白了就是实现IP地址漂移的，是一种容错协议。在下图中，Router A、Router B和Router C组成一个虚拟路由器。各虚拟路由器都有自己的IP地址。局域网内的主机将虚拟路由器设置为缺省网关。Router A、Router B和Router C中优先级最高的路由器作为Master路由器，承担网关的功能。其余两台路由器作为Backup路由器。当master路由器出故障后，backup路由器会根据优先级重新选举出新的master路由器承担网关功能。Master路由器周期性地发送VRRP报文，在虚拟路由器中公布其配置信息（优先级等）和工作状况。Backup路由器通过接收到VRRP报文的情况来判断Master路由器是否工作工常。

![](/images/sre_keepalived_1_1.png)

配置VRRP时，需要路由器支持VRRP功能。同时VRRP管理的机器，需要在同一个二层网络下，或同一个VLAN下。

# Keepalived简介

Keepalived使用的是VRRP协议方式。简单的说就是，Keepalived的目的是模拟路由器的高可用，Keepalived是模块化设计，不同模块负责不同的功能，下面是keepalived的组件：

（1）core
core组件是keepalived的核心，负责主进程的启动和维护，全局配置文件的加载解析等。

（2）check

check组件负责healthchecker（健康检查），包括了各种健康检查方式，以及对应的配置的解析包括LVS的配置解析。

（3）vrrp

VRRPD子进程，VRRPD子进程就是来实现VRRP协议的。

（4）libipfwc

iptables（ipchains）库，配置LVS会用到。

（5）libipvs*

配置LVS会用到。

备注：Keepalived和LVS完全是两码事，只不过他们各负其责相互配合而已。

# Keepalived安装和配置

编译Keepalived时，如果不加参数可以编译，那么将只包含VRRP相关的功能，用来搭建HA集群，实现IP漂移。当加上--with-kernel-dir=可以将IPVS相关的特性编译进去，用于配置LVS。直白地说，我们将LVS相关的配置（例如realserver、调度算法、工作模式等）写入到keepalived配置中，由Keepalived帮配置LVS，其他这部分配置工作和使用ipvsadm是差不多的。

Keepalived的配置主要有全局配置段和VRRP配置段两部分，如果需要配置lvs，还需要有lvs相关的配置。

## 全局配置段

包括邮件报警、SMTP服务器的配置等等，例如：

```
global_defs  { 
    notification_email { 
        admin@example.com 
    } 
    notification_email_from admin@example.com 
    smtp_server 127.0.0.1 
    stmp_connect_timeout 30 
    lvs_id my_hostname 
}
```

## VRRP配置段

VRRP配置时Keepalived核心，就是IP漂移相关的配置。举例如下：

```
vrrp_instance VI_1 { 
    state BACKUP  #为BACKUP节点
    interface eth0 
    virtual_router_id 51 
    priority 100 
    nopreempt 
    advert_int 1 
    authentication { 
        auth_type PASS 
        auth_pass 123456 
    } 
    virtual_ipaddress { 
        192.168.1.199/24  #VIP为192.168.1.199
    } 
}
```

备注：如上是一个VRRP的配置，该实例是BACKUP节点，还需要再另外台机器上配置MASTER节点，这样才能达到IP漂移的效果。作为Master/Slave架构的keepalived，主备都正常时，是由priority来决定的，谁的priority值大，就由谁来做主节点。当vrrp_instance中包含了自定义的健康检查脚本并包含了weight，那么主备的角色是由priority加weight的和值来决定的，谁大就由谁来做主。需要注意的是，主备角色与state设置没有任何关系。

## LVS配置段

LVS配置只在要使用Keepalived来配置和管理LVS时使用，如果仅仅使用Keepalived做HA的话就可以完全不用配置LVS。Keepalived关于LVS的配置如下：

```
virtual_server 192.168.1.199 80 {  #LVS的VIP
    delay_loop 6 
    lb_algo rr 
    lb_kind NAT 
    nat_mask 255.255.255.0 
    persistence_timeout 10 
    protocol TCP 

    real_server 192.168.1.13 80 {   #RealServer的机器
        weight 1 
        TCP_CHECK {  #健康检查
            connect_timeout 3 
            nb_get_retry 3 
            delay_before_retry 3 
            connect_port 80 
        } 
    } 

    real_server 192.168.1.14 80 {   #RealServer的机器
        weight 1 
        TCP_CHECK {    #健康检查
            connect_timeout 3 
            nb_get_retry 3 
            delay_before_retry 3 
            connect_port 80 
        } 
    } 
}
```

备注：如果我们是需要IP漂移的HA集群，LVS相关的配置可以没有哦。

# 其他相关点

## LVS/Keepalived/ipvsadm三者的关系

LVS，在功能层面，已经被集成进了当前流行的Linux kernel，随时可用。keepalived和ipvsadm都是lvs的管理工具，功能层面作用相同，二选一即可。keepalived是第三方的，支持lvs node本身的HA以及real server故障检测等功能，而ipvsadm是lvs作者原创的, 只支持lvs自身的功能管理。通常情况下，我们安装了lvs的内核模块后，需要再安装ipvsadm工具来配置LVS。而使用keepalived时，可以将lvs的配置写入keepalived的配置文件keepalived.conf中，然后由keepalived加载即可，不需要再使用ipvsadm来配置了。

keepalived和lvs结合使用，keepalived可以完成两项工作，一是对Real Server中的机器进行健康检查，如果有问题，从服务器池中剔除；二是在LoadBalance间进行容灾切换。

keepalived编译的时候，可以将lvs的管理接口编译到keepalived中，这样keepalived就可以和LVS模块交互，就不只有IP漂移功能了。 

## keepalived的容灾切换原理

keepalived中优先级高的节点为MASTER。MASTER其中一个职责就是响应VIP的ARP包，将VIP和MAC地址映射关系告诉局域网内其他主机，同时，它还会以多播的形式向局域网中发送VRRP通告，告知自己的优先级。网络中的所有BACKUP节点只负责处理MASTER发出的多播包，当发现MASTER的优先级没自己高，或者没收到MASTER的VRRP通告时，BACKUP将自己切换到MASTER状态，然后做MASTER该做的事（1.响应ARP包；2.发送VRRP通告）。

备注：响应ARP包，告诉本机的MAC地址，也意味着告诉发送方，本机才是虚拟IP的拥有者。这个IP漂移的关键哦。

## keepalived进程的说明

keepalived启动后会有三个进程，如下：

    父进程用来内存管理，子进程管理等
    VRRP子进程
    healthchecker子进程

## keepalived集群组脑裂问题

在HA架构中，如果出现两个节点同时认为自已是唯一处于活动状态的服务器从而出现争用资源的情况，这种争用资源的场景即是所谓的"脑裂"（split-brain）或"partitioned cluster"。在两个节点共享同一个物理设备资源的情况下，脑裂会产生相当可怕的后果。

## keepalived/heartbeat/HAProxy的比较

keepalived主要是控制IP的漂移，其配置、应用简单，而heartbeat则不但可以控制IP漂移，更擅长对资源服务的控制，其配置、应用比较复杂。

一般Keepalived是实现前端高可用，常用的前端高可用的组合有，就是我们常见的LVS+Keepalived、Nginx+Keepalived、HAproxy+Keepalived。而Heartbeat或Corosync是实现服务的高可用，常见的组合有Heartbeat v3(Corosync)+Pacemaker+NFS+Httpd实现Web服务器的高可用，Heartbeat v3(Corosync)+Pacemaker+NFS+MySQL实现MySQL服务器的高可用。

## virtual_router_id冲突问题

virtual_router_id，一般简称为VRID，全称为虚拟路由器的标识，有相同VRID的一组路由器构成一个虚拟路由器。

keepalived的主、备机的virtual_router_id必须相同，取值范围为0-255。但是同一局域网或同一交换机中不应有相同virtual_router_id的其他keepalived集群，这样会导致keepalived冲突。

## keepalived日志中一些关键字段

    Transition to MASTER STATE    #VIP漂移到该机器上
    Entering BACKUP STATE         #VIP漂移到其他机器上

## VRRP通告报文

在一套部署了Keepalived组成的高可用中，正常来说，只有Master节点才会发送VRRP通告，各个Slave是不会发送VRRP通告。但是当Master故障或Slave收到的VRRP通告的优先级没有自己高的时候，Slave在遇到这种状况下，就会向外广播VRRP通告。如下为在Slave节点通过`tcpdump -nni any vrrp | grep 'vrid 123'`命令获取到的VRRP通告报文：

    14:30:37.034353 IP 10.13.100.16 > 224.0.0.18: VRRPv2, Advertisement, vrid 123, prio 130, authtype simple, intvl 2s, length 20

## VRRP协议栈结构

![](/images/sre_keepalived_1_2.png)

可见VRRP协议是工作在IP层协议之上的，也就是VRRP报文需要IP地址传递。


学习资料参考于：
http://zhaoyuqiang.blog.51cto.com/6328846/1166840
http://hugnew.com/?p=745
http://www.361way.com/keepalived-framework/5208.html
http://freeloda.blog.51cto.com/2033581/1280962
http://asram.blog.51cto.com/1442164/359093/
