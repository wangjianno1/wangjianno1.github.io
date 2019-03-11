---
title: 虚拟机器监视器Hypervisor简介
date: 2019-03-10 18:42:09
tags:
categories: Virtualization
---

# Hypervisor

Hypervisor，又称虚拟机器监视器，全称为Virtual Machine Monitor，缩写为VMM。虚拟化就是通过某种方式隐藏底层物理硬件的过程，从而让多个操作系统可以透明地使用和共享它。这种架构的另一个更常见的名称是平台虚拟化。在典型的分层架构中，提供平台虚拟化的层称为Hypervisor（有时称为虚拟机管理程序或VMM）。来宾操作系统称为虚拟机（VM），因为对这些VM而言，硬件是专门针对它们虚拟化的。

# Hypervisor的两种类型

## 本地或裸机Hypervisor

这些虚拟机管理程序直接运行在主机的硬件来控制硬件和管理客体操作系统上，如Xen、KVM等。

## Hosted Hypervisor

这些虚拟机管理程序运行在传统的操作系统上，就像其他计算机程序那样运行。例如VMware Workstation、QEMU及WINE等。

![](/images/virtualization_1_1.png)

学习资料来源于：
http://www.ibm.com/developerworks/cn/linux/l-hypervisor/
https://zh.wikipedia.org/wiki/Hypervisor
