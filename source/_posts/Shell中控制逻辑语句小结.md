---
title: Shell中控制逻辑语句小结
date: 2019-03-06 10:52:06
tags:
categories: Linux
---

# 选择结构

## if-then式

if-then式的结构形式如下：                 

```bash
if [条件表达式1]; then
    #当条件表达式1成立时，可以进行的命令工作内容
elif [条件表达式2]; then
    #当条件表达式2成立时，可以进行的命令工作内容
else
    #当条件表达式1和2均不成立时，可以进行的命令工作内容
fi
```

if-then式举例如下：

```bash
#!/bin/bash
read -p "Please input (Y/N): " yn

if [ X"$yn" == X"Y" ] || [ X"$yn" == X"y" ]; then
    echo "OK, continue..."
elif [ X"$yn" == X"N" ] || [ X"$yn" == X"n" ]; then
    echo "Oh, interrupt!"
else
    echo "I don't know what your choice is"
fi
```

## case-esac式

case-esac式的结构形式如下：

```bash
case X$variable in
   X"第一个变量内容")
        #程序段
        ;;
   X"第二个变量内容")
        #程序段
        ;;
   *)
        #程序段
        ;;
esac
```
case-esac式举例如下：

```bash
#!/bin/bash
case X$1 in
    X"hello")
        echo "Hello,how are you?"
        ;;
    X"world")
        echo "You must input parameter,ex> {$0 someword}"
        ;;
    *)
        echo "Usage $0 {hello}"
        ;;
esac
```

# 循环结构

## while-do-done式

while-do-done式的结构形式如下：

```bash
while [ 条件表达式 ]
do
    #程序段
done
```

while-do-done式举例如下：

```bash
while [ X"$yn" != X"yes" -a X"$yn" != X"YES" ]
do
    read -p "Please input yes/YES to stop this program: " yn
done
echo "OK! you input the correct answer."
```

## until-do-done式

until-do-done式的结构形式如下：

```bash
until [条件表达式]
do
    #程序段
done
```

until-do-done式举例如下：

```bash
until [ X"$yn" == X"yes" -a X"$yn" == X"YES" ]
do
    read -p "Please input yes/YES to stop this program: " yn
done
echo "OK! you input the correct answer."
```

## for-do-done固定循环式


for-do-done固定循环式的结构形式如下：

```bash
for variable in cond1 cond2 cond3 ...
do
    #程序段
done
```

for-do-done固定循环式举例如下：

```bash
for variable in $(seq 1 14)
do
    echo "The number is: $variable"
done
```

## for-do-done数值处理式

for-do-done数值处理式的结构形式如下：

```bash
for((初始值; 限制条件; 执行步长))
do
    #程序段
done
```

for-do-done数值处理式举例如下：

```bash
#1
sum=0;
for((i=1; i<=100; i=i+1))
do
    sum=$((sum+$i))
done
echo "The sum is: $sum"

#2
sum=0
for((i=1; i<=100; i=$(($i+1))))
do
    sum=$((sum+$i))
done
echo "The sum is: $sum"
```

其中，#1和#2经过验证都是正确的。可为什么在#1中执行步长可以写成`i=i+1`呢？严格来说是`i=$(($i+1))`的啊。难道说，这里的i相当于是`declare -i i`吗？待确认。


# 循环遍历实践举例

（1）遍历目录下面有哪些文件或目录

```bash
for file in ./*               #遍历当前目录下有哪些文件或目录
for file in *                 #同上
for file in `ls -1 pack_wzj`  #遍历目录pack_wzj下有哪些文件
for file in $(ls -1 pack_wzj) #同上
```

（2）遍历文件中内容

```bash
for file in $(cat list)  #逐行遍历文件list中的内容
for file in `cat list`   #同上

cat list | while read _line  #同上
do
    echo $_line
done

while read _line #同上，如果list文件中有多列，此处_line可以写成多个变量，例如while read name age;
do
    echo $_line
done < list
```

（3）使用for快速批量处理命令

```bash
for x in `cat hostlist`; do ssh $x "cd /home/wahaha/ $$ ls -1 | tail -1"; done      #串行
for x in `cat hostlist`; do ( ssh $x "cd /home/wahaha/ && ls -l | tail -1" )& done  #并行
for x in `cat hostlist`; do { ssh $x "cd /home/wahaha/ && ls -l | tail -1"; }& done #并行
```

（4）使用while快速批量处理命令

```bash
ps aux | grep -v grep | awk '{print $2}' | while read line; do kill -9 $line; done
```

备注：while read line这种形式，循环体内不能是ssh登录哦，否则只能登录一台，用上面的for循环就好了。

# 关于条件表达式闲杂知识

if中的条件判断式用的就是`[ ]`判断符号，因为`[ ]`用户和test命令几乎一样，所以如果不知道`[ ]`中某个符号的含义，就是man test看看喽。

多个条件形成一个复合表达式的方式有两种：

（1）写在一个`[ ]`内，例如`[ exp1 -o exp2 ]`

（2）通过逻辑操作符连接多个`[ ]`，例如`[ exp1 ] || [ exp2 ]`，`[ exp1 ] && [ exp2 ]`

`[ "$variable" == "Y" -o "$variable" == "y"]`与`[ "$variable" == "Y" ] || [ "$variable" == "y" ]`的含义是一样的。

`[ exp1 ] || [ exp2 ]`，`[ exp1 ] && [ exp2 ]`中的`||`，`&&`与`cmd1 || cmd2`，`cmd1 && cmd2`中的`||`，`&&` 意涵是不一样的。在`[ exp1 ] || [ exp2 ]`，`[ exp1 ] && [ exp2 ]`中`||`，`&&`是逻辑操作符的含义。
