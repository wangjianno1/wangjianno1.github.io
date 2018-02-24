---
title: Linux中top命令的使用和理解
date: 2018-02-24 16:15:26
tags:
categories: Linux
---

# top命令的帮助

进入top视图后，输入h可以查看在top视图中可以操作的命令，很重要的哈。

# top输出结果解析

![](/images/linux_top_1_1.png)

top的输出结果中包括两个部分。上半部分是显示这个系统的资源使用状态。下半部分是显示每个进程使用的资源情况。

（1）上半部分
 
第一行：包含的信息有当前的时间、开机到现在所经过的时间、系统当前登录的用户数、最近一分钟CPU负载均值、最近五分钟CPU负载均值、最近十五分钟CPU负载均值。

第二行：显示的是目前进程的总数和各状态下进程的数量。

第三行：是各个项目占用CPU时间的比例，详细解释如下：

	us：用户态使用的cpu时间比  
	sy：系统态使用的cpu时间比  
	ni：用做nice加权的进程分配的用户态cpu时间比  
	id：空闲的cpu时间比  
	wa：cpu等待磁盘写入完成时间  
	hi：硬中断消耗时间  
	si：软中断消耗时间  
	st：虚拟机偷取时间

备注，以上列出来的几项的数值加起来等于100%.

第四行和第五行：表示物理内存和虚拟内存(MEM/SWAP)的使用情况。参见[linux中free命令详解](http://blog.csdn.net/wangjianno2/article/details/48886093)

第六行：top工具与用户交互的位置。

（2）下半部分

显示每个进程使用的资源情况：

	VIRT：进程的虚拟内存空间大小，包括进程目前已经映射到物理内存，以及未映射到物理内存的总大小。注意，这里可不是SWAP的东东哦
	RES：进程使用的物理内存的大小。公式为RES = CODE + DATA
	SHR：进程所使用内存中是和其他进程共享的内存的大小。
	%MEM：进程的RES占总物理内存的大小。

备注：看进程内存占用大小，看RES就好了。它们的详细区别参见[关于进程的虚拟内存VIRT|物理内存RES|共享内存SHR](https://wangjianno1.github.io/2018/02/03/%E5%85%B3%E4%BA%8E%E8%BF%9B%E7%A8%8B%E7%9A%84%E8%99%9A%E6%8B%9F%E5%86%85%E5%AD%98VIRT-%E7%89%A9%E7%90%86%E5%86%85%E5%AD%98RES-%E5%85%B1%E4%BA%AB%E5%86%85%E5%AD%98SHR/)

# 关于CPU平均负载load average

（1）对于单核CPU

假设我们的系统是单CPU单内核的，把它比喻成是一条单向马路，把CPU任务比作汽车。当车不多的时候，load<1；当车占满整个马路的时候，load=1；当马路都站满了，而且马路外还堆满了汽车的时候，load>1。

+ Load < 1

![](/images/linux_top_load_less_1.png)

+ Load = 1

![](/images/linux_top_load_equal_1.png)

+ Load > 1

![](/images/linux_top_load_more_1.png)

（2）对于多核CPU

我们经常会发现服务器Load > 1但是运行仍然不错，那是因为服务器是多核处理器（Multi-core）。假设我们服务器CPU是2核，那么将意味我们拥有2条马路，我们的Load = 2时，所有马路都跑满车辆。

![](/images/linux_top_load_equal_2.png)

备注：Load = 2时马路都跑满了

总结来说，load average指CPU运行队列的平均长度，也就是等待CPU的平均进程数。如果机器是多核CPU，那么除以核数，就是每个核的load average。单核的load average小于1，说明CPU的负载较轻；单核的load average等于1，说明CPU的负载正常。单核的load average大于1，说明在运行队列中的进程数大于1，也就是有进程在等待CPU调度，当然这种情况下，CPU是超负载的。

# top中%CPU理解

对于多核CPU，在Irix mode模式下，显示的是该进程占用一个核的计算时间的比例，也就说当前进程比较耗费资源的时候，那这个比例就大于了100%。例如200%就表示该进程用了两个核。在Solaris mode模式下，是在将进程占用的单核的CPU比例除以总核数。也就是说分摊到每个核上面的负载。

总之，无论在那个模式下，这个比例就是指以一个核的计算资源为基数的。一个体现的是总的消耗，一个体现的是分摊到各个核之后每个核的消耗。

# CPU的iowait/wait IO/wa时间

iowait/wait IO/wa等，表示某些进程已经获取了CPU的时间片，但由于磁盘IO性能低，或进程IO请求过多超过了磁盘的处理能力，那么CPU就会等待IO完成，这段时间其实CPU是空闲的，这个CPU消耗就称为CPU的iowait/wait IO/wa时间。虽然CPU在waitIO时，CPU是空闲的，但这时的CPU资源也不能分配给其他的进程。

# top命令的常用用法

```bash
top -b -n 1     #-b参数开启top的batch mode，也即top像普通命令一样，直接在控制台输出结果，而不是交互模式。-n表示top命令刷新的次数，-n 2表示刷新两次，-n 1表示刷新一次。使用top -b -n 1 > output可以将top命令的结果写入到文件中。
top -H -b -n 1  #查看一台机器上完整的进程和线程信息，-H表示开启线程信息
top -H -p {pid} #显示一个进程的所有thread
```

另外，`pstree -p {pid}`也可以显示一个进程的子进程以及线程的信息。


# 闲杂

（1）在top视图中，可以使用P和M直接进行cpu和mem的使用率列进行排序，和用h中的操作是一样的.

（2）可以使用`top -p pid`来监视进程号为pid的进程


学习资料参考于：
http://www.penglixun.com/tech/system/how_to_calc_load_cpu.html
http://heipark.iteye.com/blog/1340384