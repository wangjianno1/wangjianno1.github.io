---
title: 磁盘驱动器RAID查看与配置工具
date: 2018-02-02 18:54:47
tags: 硬盘
categories: HardWare
---

# 磁盘阵列卡

RAID有软RAID和硬RAID两种，其中硬RAID是通过磁盘阵列卡（一块专门的芯片）来完成RAID功能。通常来说，我们使用的DELL/HP/IBM三家的机架式PC级服务器磁盘阵列卡是由LSI公司生产的。DELL和IBM两家对LSI的磁盘阵列卡没有做太多封装，可以用原厂LSI提供的阵列卡工具进行配置和管理。而HP则对LSI的磁盘阵列卡做了很多的封装，因此需要使用自身特有的工具来配置和管理。

如下为一些常见的磁盘阵列卡产品：

（1）DELL SAS 6/iR卡

全称LSI Logic SAS1068E，只支持RAID 0, RAID 1, RAID 1+0, 不支持RAID 5等高级RAID特性，不支持阵列卡电池。

（2）DELL PERC PERC H700卡

全称LSI Logic MegaRAID SAS 2108，支持各种RAID级别及高级特性，可选配阵列卡电池。

（3）DELL PERC H310 Mini卡

全称LSI Logic / Symbios Logic MegaRAID SAS 2008，支持常见RAID级别，不支持高级RAID特性，不支持阵列卡电池。

（4）IBM ServeRAID M5014 SAS/SATA Controller卡

全称LSI Logic / Symbios Logic MegaRAID SAS 2108，支持各种RAID级别及高级特性，可选配阵列卡电池。

（5）IBM ServeRAID-MR10i SAS/SATA Controller卡

全称LSI Logic / Symbios Logic MegaRAID SAS 1078，支持常见RAID级别，不支持高级RAID特性，可选配阵列卡电池，这个卡其实和DELL的PERC 6/i卡是一样的，都是基于LSI MegaRAID SAS 1078基础上OEM出来的。

（6）等等

# 磁盘阵列卡的管理工具

一般来说，支持RAID 5的磁盘阵列卡，都可以使用LSI官方提供的MegaCli工具来管理。而不支持RAID 5的磁盘阵列卡，我们称其为SAS卡，使用lsiutil工具来管理。HP的服务器使用其特有的hpacucli工具来管理。

# MegaCli工具的常用用法

新版本的MegaCli-1.01.24-0.i386.rpm会把程序默认安装到/opt目录下，当然也可以自定义安装目录，例如下叙命令表示将MegaCli安装到/usr/bin目录下：

```bash
rpm --relocate /opt/=/usr/sbin/ -i MegaCli-1.01.24-0.i386.rpm
```

如下为MegaCli工具的一些常用命令：

（1）查看阵列卡信息

```bash
MegaCli -adpallinfo -aall
```

备注：如下为一台做了两个RAID（RAID1+RAID5）的机器的信息，其中虚拟磁盘驱动器有2个，也即经过做RAID后有/dev/sda, /dev/sdb两个磁盘设备。物理磁盘有16，当前在线的有14个（其中1个有故障），另外2个磁盘已彻底故障且离线。

![](/images/hardware_raid_1_1.png)

（2）查看阵列卡配置

```bash
MegaCli -cfgdsply -aall
```

备注：通通过RAID Level可以得知磁盘阵列的等级，规则如下：

![](/images/hardware_raid_1_2.png)

（3）查看阵列卡日志，关注里面的error/fail/warn等多个关键字

```bash
MegaCli -fwtermlog -dsply -aALL
```

（4）查看所有物理磁盘信息

```bash
MegaCli -PDList -aALL
```

备注：这个能够查看机器上所有物理磁盘的信息

（5）查看磁盘缓存策略

```bash
MegaCli -LDGetProp -Cache -L0 -a0
```

（6）创建一个RAID 5的阵列，由物理盘 2,3,4 构成，该阵列的热备盘是物理盘5

```bash
MegaCli -CfgLdAdd -r5 [1:2,1:3,1:4] WB Direct -Hsp[1:5] -a0
```

（7）删除一个RAID阵列

```bash
MegaCli -CfgLdDel -L1 -a0
```

# lsiutil工具的常见用法

（1）查看硬盘计数器

```bash
lsiutil -p 1 -a 20,12,0,0
```

（2）查看逻辑卷状态

```bash
lsiutil -p 1 -a 21,1,0,0,0
```

（3）查看物理硬盘状态

```bash
lsiutil -p 1 -a 21,2,0,0,0
```

# hpacucli工具的常见用法

hpacucli工具查看阵列、硬盘、电池信息，其实就只要一条指令。

（1）查看阵列详细信息、配置

```bash
hpacucli ctrl all show config detail
```

# 其他闲杂

假如有2块物理磁盘，做了RAID 1，那么在Linux系统上看，只有一个设备，例如/dev/sda，经过分区后，就会多出几个名称为/dev/sda*的设备。


学习资料参考于：
http://imysql.com/tag/megacli
http://imysql.cn/2008_06_13_megacli_usage
