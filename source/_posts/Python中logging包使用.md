---
title: Python中logging包使用
date: 2019-02-24 12:11:45
tags:
categories: Python
---

# logging 简介

Python的logging package提供了通用的日志系统，可以方便第三方模块或者是应用使用。这个模块提供不同的日志级别，并可以采用不同的方式记录日志，比如文件，HTTP GET/POST，SMTP，Socket等，甚至可以自己实现具体的日志记录方式。

logging包中定义了Logger、Formatter、Handler和Filter等重要的类，除此之外还有config模块。

Logger是日志对象，直接提供日志记录操作的接口。

Formatter定义日志的记录格式及内容。

Handler定义日志写入的目的地，你可以把日志保存成本地文件，也可以每个小时写一个日志文件，还可以把日志通过socket传到别的机器上。python提供了十几种实用handler，比较常用的有StreamHandler,BaseRotatingHandler,SocketHandler,DatagramHandler,SMTPHandler等。我们可以通过Logger对象的addHandler()方法，将log输出到多个目的地。

# logging包使用

在Python编程中，引入了logging package，那么可以存在一个名称为root的logging对象，以及很多其他名称的logging对象。不同的Logger对象的Handler，Formatter等是分开设置的。

（1）logging.getLogger()

如果getLogging中不带参数，那么返回的是名称为root的Logger对象，如果带参数，那么就以该参数为名称的Logger对象。同名称的Logger对象是一样的。

（2）logging.basicConfig()

此方法是为名称为root的Logger对象进行配置。

（3）logging.info()/logging.debug()等

使用的root Logger对象进行信息输出。如果是用其他的Logging对象进行log输出，可以使用Logging.getLogger(name).info()来实现。

（4）日志的等级

    CRITICAL = 50
    ERROR = 40
    WARNING = 30
    INFO = 20
    DEBUG = 10
    NOTSET = 0

在Python中有0，10，20，30，40，50这6个等级数值，这6个等级数值分别对应了一个字符串常量，作为等级名称，如上。但是可以通过`logging.addLevelName(20, "NOTICE:")`这个方法来改变这个映射关系，来定制化日志等级名称。

通过Logger对象的setLevel()方法，可以配置Logging对象的默认日志等级，只有当一条日志的等级大于等于这个默认的等级，才会输出到log文件中。

当使用logging.info(msg)输出log时，内部封装会用数字20作为日志等级数值，默认情况下20对应的是INFO，但如果通过addLevelName()修改了20对应的等级名称，那么log中打印的就将是个性化的等级名称。

# logging包使用配置文件

在前面描述中，对一个Logger对象的Handler，Formatter等都是在程序中定义或绑定的。而实际上Logging的个性化的配置可以放到配置文件中。

logging的配置文件举例如下：

```text
[loggers]
keys=root,simpleExample

[handlers]
keys=consoleHandler

[formatters]
keys=simpleFormatter

[logger_root]
level=DEBUG
handlers=consoleHandler

[logger_simpleExample]
level=DEBUG
handlers=consoleHandler
qualname=simpleExample
propagate=0

[handler_consoleHandler]
class=StreamHandler
level=DEBUG
formatter=simpleFormatter
args=(sys.stdout,)

[formatter_simpleFormatter]
format=%(asctime)s - %(name)s - %(levelname)s - %(message)s
datefmt=
```

对应程序为：

```python
import logging  
import logging.config  
  
logging.config.fileConfig("logging.conf")   #采用配置文件   
  
# create logger   
logger = logging.getLogger("simpleExample")  
  
# "application" code   
logger.debug("debug message")  
logger.info("info message")  
logger.warn("warn message")  
logger.error("error message")  
logger.critical("critical message")
```

# 一个常用的Logging封装工具

```python
#!/usr/bin/env python
#-*- coding:utf-8 -*-
import logging
import os

class Logger(object):
    """
    封装好的Logger工具
    """
    def __init__(self, logPath):
        """
        initial
        """
        log_path = logPath
        logging.addLevelName(20, "NOTICE:")
        logging.addLevelName(30, "WARNING:")
        logging.addLevelName(40, "FATAL:")
        logging.addLevelName(50, "FATAL:")
        logging.basicConfig(level=logging.DEBUG,
                format="%(levelname)s %(asctime)s [pid:%(process)s] %(filename)s %(message)s",
                datefmt="%Y-%m-%d %H:%M:%S",
                filename=log_path,
                filemode="a")
        console = logging.StreamHandler()
        console.setLevel(logging.DEBUG)
        formatter = logging.Formatter("%(levelname)s [pid:%(process)s] %(message)s")
        console.setFormatter(formatter)
        logging.getLogger("").addHandler(console)

    def debug(self, msg=""):
        """
        output DEBUG level LOG
        """
        logging.debug(str(msg))

    def info(self, msg=""):
        """
        output INFO level LOG
        """
        logging.info(str(msg))

    def warning(self, msg=""):
        """
        output WARN level LOG
        """
        logging.warning(str(msg))

    def exception(self, msg=""):
        """
        output Exception stack LOG
        """
        logging.exception(str(msg))

    def error(self, msg=""):
        """
        output ERROR level LOG
        """
        logging.error(str(msg))

    def critical(self, msg=""):
        """
        output FATAL level LOG
        """
        logging.critical(str(msg))
    

if __name__ == "__main__":
    testlog = Logger("oupput.log")
    testlog.info("info....")
    testlog.warning("warning....")
    testlog.critical("critical....")
    try:
        lists = []
        print lists[1]
    except Exception as ex:
        """logging.exception()输出格式：
        FATAL: [pid:7776] execute task failed. the exception as follows:
        Traceback (most recent call last):
            File "logtool.py", line 86, in <module>
                print lists[1]
        IndexError: list index out of range
        """
        testlog.exception("execute task failed. the exception as follows:")
        testlog.info("++++++++++++++++++++++++++++++++++++++++++++++")
        """logging.error()输出格式：
        FATAL: [pid:7776] execute task failed. the exception as follows:
        """
        testlog.error("execute task failed. the exception as follows:")
        exit(1)
```

备注：exception()方法能够完整的打印异常的堆栈信息。error()方法只会打印参数传入的信息。按照官方文档的介绍，logging是线程安全的，也就是说，在一个进程内的多个线程同时往同一个文件写日志是安全的。但是多个进程往同一个文件写日志是不安全的。
