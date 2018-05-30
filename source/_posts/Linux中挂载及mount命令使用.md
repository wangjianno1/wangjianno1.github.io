---
title: Linux中挂载及mount命令使用
date: 2018-05-30 15:19:56
tags:
categories: Linux
---

# Linux挂载基本概念

通常概念的挂载mount的单位是一个文件系统，而非一个分区的，更非一个设备。
 
# 挂载和卸载的常用操作

```bash
mount /dev/hdc6 /mnt/hdc6   #表示将/dev/hdc6这个文件系统挂载到/mnt/hdc6这个挂载点上。
umount /dev/hdc6   #表示用设备名称（文件系统）进行卸载
umount /mnt/hdc6   #表示用挂载点进行卸载
mount -a           #根据/etc/fstab配置文件的内容，挂载所有的文件系统
mount -l           #查看所有被挂载的文件系统
mount -l -t ext2   #查看文件系统类型为ext2的被挂载的文件系统
```

# mount --bind 

mount --bind是一种特殊的用法，不再是将一个文件系统挂载到一个目录，而是将一个目录挂载到另外一个目录，在chroot中很有用哦。

```bash
mount --bind olddir newdir  #将一个目录olddir挂载到另外一个目录newdir上。等价于mount -B olddir newdir
mount --rbind olddir newdir #同mount --bind olddir newdir一样，只是若olddir中存在mount bind的操作，会在newdir中同样
```

# 设置重启自动挂载磁盘的方法

编辑/etc/fstab文件，添加一行要挂载的设备和挂载点。如下为某台机器的/etc/fstab文件内容：

```
[@someclienthost ~]# cat /etc/fstab
/dev/sda1               /                       ext3    defaults        1 1
/dev/sda6               /opt                    ext3    defaults,noatime,nodiratime        0 0
/dev/sda3               /var                    ext3    defaults        1 2
/dev/sda5               /usr                    ext3    defaults        1 2
tmpfs                   /dev/shm                tmpfs   defaults        0 0
devpts                  /dev/pts                devpts  gid=5,mode=620  0 0
sysfs                   /sys                    sysfs   defaults        0 0
proc                    /proc                   proc    defaults        0 0
LABEL=SWAP-sda2         swap                    swap    defaults        0 0
/dev/shm                /tmp                    none    rw,bind         0 0
/opt                    /var/named/opt          none    rw,bind         0 0
```

# 关于/etc/fstab和/etc/mtab配置文件

`/etc/fstab`配置信息，系统在重启的时候会依据此文件来挂载文件系统。

`/etc/mtab`配置信息，是当前系统中已经挂载的文件系统的状态。
