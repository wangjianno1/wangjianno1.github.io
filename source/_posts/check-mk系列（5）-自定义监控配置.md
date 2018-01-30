---
title: check_mk系列（5）_自定义监控配置
date: 2018-01-30 15:56:24
tags: check_mk
categories: 监控
---

# check_mk自定义监控配置方法

下面以创建一个统计磁盘状态的监控为例来说明，check_mk自定义监控的配置步骤为：

（1）在check_mk agent端增加采集脚本

在/usr/lib/check_mk_agent/plugins目录中自定义一个script脚本，并赋予可执行权限，假设为usr/lib/check_mk_agent/plugins/rapid.sh，其内容如下：

```bash
#!/bin/sh
echo '<<<rapid>>>'

cat << EOF
/dev/sda   1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Always       -       0
/dev/sda   3 Spin_Up_Time            0x0027   129   127   021    Pre-fail  Always       -       6541
/dev/sda   4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       251
/dev/sda   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
/dev/sda   6 Temperature_Celsius     0x0022   106   098   000    Old_age   Always       -       41
/dev/sdb   1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Always       -       0
/dev/sdb   3 Spin_Up_Time            0x0027   129   127   021    Pre-fail  Always       -       6541
/dev/sdb   4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       251
/dev/sdb   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
/dev/sdb   6 Temperature_Celsius     0x0022   106   098   000    Old_age   Always       -       411
EOF
```

备注：

一定要注意的是，采集脚本的输出要以<<<XXXX>>>开头，该header将在check_mk的服务端标识该采集数据的来源。该采集脚本是模拟输出硬件磁盘的一些状态信息，每个设备都会有好多的指标及对应的数值。在agent端配置了采集脚本后，先在agent执行/usr/bin/check_mk_agent命令，看能够正常输出新增的采集，然后在check_mk的服务端执行./bin/check_mk -d HOSTNAME来查看新配置的采集脚本输出，若有输出，则说明采集脚本配置正确。

另外我们不在agent端新增脚本，直接编辑/usr/bin/check_mk_agent脚本，将自己的采集程序加入到该脚本也是可以的，但是我们一般不会这么做哦。

（2）在服务端编写check脚本，用于解析agent端返回的值

在/opt/omd/sites/XXX/local/share/check_mk/checks目录下新建名称为rapid的文本文件（文件名必须要于agent端采集脚本的header相同），内容如下：

```python
#!/usr/bin/python

rapid_temp_default_values = (40, 60)   #监控的阈值

#称为inventory函数，info是agent端返回的header为rapid的文本值
def inventory_rapid_temp(info):
    for line in info:
        disk = line[0]
        field = line[2]
        if field == "Temperature_Celsius":
            yield disk, "rapid_temp_default_values"

#称为check函数，item为inventory函数返回值的第一个字段，parms为inventory函数返回的第二个字段
def check_rapid_temp(item, params, info):
    warn, crit = params

    for line in info:
        if line[0] == item and line[2] == "Temperature_Celsius":
            celsius = int(line[10])
            if celsius > crit:
                return 2, "Temperature is %dC" % celsius
            elif celsius > warn:
                return 1, "Temperature is %dC" % celsius
            else:
                return 0, "Temperature is %dC" % celsius

#该部分是该自定义监控的声明，其中的temp值会被check函数的item替代
check_info["rapid.temp"] = {     
    'check_function':            check_rapid_temp,
    'inventory_function':        inventory_rapid_temp,
    'service_description':       'RAPID drive %s',    #%s是check函数的返回值的第二个字段，这个将作为check_mk上的服务名
}
```

备注：配置了如上内容，既可以在./bin/check_mk -L中有了rapid.temp的采集项

（3）测试验证

```bash
./bin/check_mk -L | grep rapid               #查看检查项已经正确配置到check_mk
./bin/check_mk --checks=rapid -I 10.8.18.53  #向指定的机器发起rapid的采集，并存储到服务端中
./bin/check_mk -nv 10.8.18.53                #查看监控状态
```

在check_mk页面上，点击到机器的WATO页面，会发现新增的服务被check_mk自动发现了，我们在页面上点击添加，并activate change即可。界面显示效果如下：

![](/images/check_mk_5_1.png)

# 自定义监控服务端脚本说明

check_mk服务端脚本有三部分组成：

（1）Inventory函数

（2）check函数

check函数接收三个参数，分别是items、检查参数、agent返回info。check函数返回值必须是一个元组，该元组的元素分别为：

	status code (0=OK, 1=WARN, 2=CRIT, 3=UNKNOWN)
	文本字符串，用来现在到check_mk或nagios的WEB界面上
	性能数据，该部分是可选的
	
（3）check声明

是一个字典形式。

# 为自定义监控加上性能数据

（1）修改服务端脚本

为自定义监控加上性能数据，既可以在check_mk页面展示PNP4Nagios的可视化界面了。增加性能数据只需要修改服务端脚本即可，我们在上面的例子基础上，做如下修改即可：

```python
#!/usr/bin/python

rapid_temp_default_values = (40, 60)

def inventory_rapid_temp(info):
    for line in info:
        disk = line[0]
        field = line[2]
        if field == "Temperature_Celsius":
            yield disk, "rapid_temp_default_values"

def check_rapid_temp(item, params, info):
    warn, crit = params

    for line in info:
        if line[0] == item and line[2] == "Temperature_Celsius":
            celsius = int(line[10])
            perfdata = [( "temp", celsius, warn, crit)]
            if celsius > crit:
                return 2, "Temperature is %dC" % celsius, perfdata
            elif celsius > warn:
                return 1, "Temperature is %dC" % celsius, perfdata
            else:
                return 0, "Temperature is %dC" % celsius, perfdata

check_info["rapid.temp"] = {
    'check_function':            check_rapid_temp,
    'inventory_function':        inventory_rapid_temp,
    'service_description':       'RAPID drive %s',
    'has_perfdata':              True,
}
```

备注：需要两处修改，第一处在check声明时，通过has_perfdata指明有性能数据。第二处是在check函数的返回值增加第三个字段，填充性能数据即可。其中性能数据的python列表，列表中每一个元素是元组类型，每个元组类型的字段如下（其中只有name和value是必需的，其他都是可选的）：

![](/images/check_mk_5_6.png)

举例来说：

![](/images/check_mk_5_2.png)

（2）check_mk界面上验证效果

增加了性能数据，在check_mk的显示效果为：

![](/images/check_mk_5_3.png)

![](/images/check_mk_5_4.png)

![](/images/check_mk_5_5.png)


学习资料参考于：
http://blog.csdn.net/dingyingguidyg/article/details/22674779
http://mathias-kettner.de/checkmk_devel_agentbased.html
