---
title: Python中多进程编程
date: 2019-02-24 02:49:37
tags:
categories: Python
---

# Pyhton中多进程编程方式

## os.fork()

Python的os模块封装了常见的系统调用，其中就包括fork，可以在Python程序中轻松创建子进程，例程如下：

```python
import os

print('Process (%s) start...' % os.getpid())
# Only works on Unix/Linux/Mac:
pid = os.fork()
if pid == 0:
    print('I am child process (%s) and my parent is %s.' % (os.getpid(), os.getppid()))
else:
    print('I (%s) just created a child process (%s).' % (os.getpid(), pid))
```

运行结果如下：

    Process (6221) start...
    I (6221) just created a child process (6222).
    I am child process (6222) and my parent is 6221.

普通的函数调用，调用一次，返回一次，但是`fork()`调用一次，返回两次，因为操作系统自动把当前进程（称为父进程）复制了一份（称为子进程），然后，分别在父进程和子进程内返回。**子进程永远返回0，而父进程返回子进程的ID**。这样做的理由是，一个父进程可以fork出很多子进程，所以，父进程要记下每个子进程的ID，而子进程只需要调用`getppid()`就可以拿到父进程的ID。

值得注意的是，由于Windows没有fork调用，上面的Python代码在Windows上无法运行。

## multiprocessing.Process

multiprocessing模块就是跨平台版本的多进程模块。multiprocessing模块提供了一个Process类来代表一个进程对象。例程如下：

```python
from multiprocessing import Process
import os

# 子进程要执行的代码
def run_proc(name):
    print('Run child process %s (%s)...' % (name, os.getpid()))

if __name__=='__main__':
    print('Parent process %s.' % os.getpid())
    p = Process(target=run_proc, args=('test',))
    print('Child process will start.')
    p.start()
    p.join()
    print('Child process end.')
```

运行结果如下：

    Parent process 26656.
    Child process will start.
    Run child process test (26657)...
    Child process end.

创建子进程时，只需要传入一个执行函数和函数的参数，创建一个Process实例，用`start()`方法启动，这样创建进程比`fork()`还要简单。`join()`方法可以等待子进程结束后再继续往下运行，通常用于进程间的同步。

## multiprocessing.Pool

如果要启动大量的子进程，可以用进程池的方式批量创建子进程。例程如下：

```python
from multiprocessing import Pool
import os, time, random

def long_time_task(name):
    print('Run task %s (%s)...' % (name, os.getpid()))
    start = time.time()
    time.sleep(random.random() * 3)
    end = time.time()
    print('Task %s runs %0.2f seconds.' % (name, (end - start)))

if __name__=='__main__':
    print('Parent process %s.' % os.getpid())
    p = Pool(4)
    for i in range(5):
        p.apply_async(long_time_task, args=(i,))
    print('Waiting for all subprocesses done...')
    p.close()
    p.join()
    print('All subprocesses done.')
```

运行结果如下：

```text
Parent process 669.
Waiting for all subprocesses done...
Run task 0 (671)...
Run task 1 (672)...
Run task 2 (673)...
Run task 3 (674)...
Task 2 runs 0.14 seconds.
Run task 4 (673)...
Task 1 runs 0.27 seconds.
Task 3 runs 0.86 seconds.
Task 0 runs 1.41 seconds.
Task 4 runs 1.91 seconds.
All subprocesses done.
```

对Pool对象调用join()方法会等待所有子进程执行完毕，调用join()之前必须先调用close()，调用close()之后就不能继续添加新的Process了。
请注意输出的结果，task 0，1，2，3是立刻执行的，而task 4要等待前面某个task完成后才执行，这是因为Pool的的大小是4，因此，最多同时执行4个进程。如果Pool(5)那么就可以同时执行5个子进程。

## subprocess

subprocess模块可以让我们非常方便地启动一个子进程，然后控制其输入和输出。下面的例子演示了如何在Python代码中运行命令`nslookup www.python.org`，这和命令行直接运行的效果是一样的：

```python
import subprocess

print('$ nslookup www.python.org')
r = subprocess.call(['nslookup', 'www.python.org'])
print('Exit code:', r)
```

运行结果如下：

```
$ nslookup www.python.org
Server:         10.91.0.231
Address:        10.91.0.231#53

Non-authoritative answer:
www.python.org  canonical name = python.map.fastly.net.
Name:   python.map.fastly.net
Address: 103.245.222.223

('Exit code:', 0)
```

如果子进程还需要输入，则可以通过`communicate()`方法输入，可以做如下修改调整：

```python
import subprocess

print('$ nslookup')
p = subprocess.Popen(['nslookup'], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
output, err = p.communicate(b'set q=mx\npython.org\nexit\n')
print(output.decode('utf-8'))
print('Exit code:', p.returncode)
```

上面的代码相当于在命令行执行命令nslookup，然后手动输入：

    set q=mx
    python.org
    exit

# 进程间通信

Process之间肯定是需要通信的，操作系统提供了很多机制来实现进程间的通信。Python的multiprocessing模块包装了底层的机制，提供了Queue、Pipes等多种方式来交换数据。

我们以Queue为例，在父进程中创建两个子进程，一个往Queue里写数据，一个从Queue里读数据：

```python
from multiprocessing import Process, Queue
import os, time, random

# 写数据进程执行的代码:
def write(q):
    print('Process to write: %s' % os.getpid())
    for value in ['A', 'B', 'C']:
        print('Put %s to queue...' % value)
        q.put(value)
        time.sleep(random.random())

# 读数据进程执行的代码:
def read(q):
    print('Process to read: %s' % os.getpid())
    while True:
        value = q.get(True)
        print('Get %s from queue.' % value)

if __name__=='__main__':
    # 父进程创建Queue，并传给各个子进程：
    q = Queue()
    pw = Process(target=write, args=(q,))
    pr = Process(target=read, args=(q,))
    # 启动子进程pw，写入:
    pw.start()
    # 启动子进程pr，读取:
    pr.start()
    # 等待pw结束:
    pw.join()
    # pr进程里是死循环，无法等待其结束，只能强行终止:
    pr.terminate()
```

运行的结果如下：

```text
Process to write: 50563
Put A to queue...
Process to read: 50564
Get A from queue.
Put B to queue...
Get B from queue.
Put C to queue...
Get C from queue.
```

# 总结

在Unix/Linux下，可以使用fork()调用实现多进程。要实现跨平台的多进程，可以使用multiprocessing模块。进程间通信是通过Queue、Pipes等实现的。

参考资料来源于：
http://www.liaoxuefeng.com/wiki/0014316089557264a6b348958f449949df42a6d3a2e542c000/001431927781401bb47ccf187b24c3b955157bb12c5882d000
