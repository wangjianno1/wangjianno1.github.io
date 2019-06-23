---
title: P2P技术BitTorrent协议
date: 2019-06-23 17:36:10
tags:
categories: Network
---

# 基于BT协议的P2P技术组成

基于BT协议的文件分发系统由以下几个实体构成：

（1）一个Web服务器

用于保存种子文件，供P2P网络中的下载者下载。

（2）一个种子文件（.torrent文件）

.torrent文件使用B encode表示，整个是一个字典数据结构，它有多个key值，包括一些是可选的，这里介绍最关键的几个键值对：

    info：存储资源文件的元信息
        piece length
        pieces
        name/path
    announce：描述tracker服务器的URL

info键对应的值又是一个字典结构，BT协议将一个文件分成若干片，便于客户端从各个主机下载各个片。其中的piece length键值对表示一个片的长度，通畅情况下是2的n次方，根据文件大小有所权衡，通长越大的文件piece length越大以减少piece的数量，降低数量一方面降低了.torrent保存piece信息的大小，一方面也减少了下载需要对片做的确认操作，加快下载速度。目前通常是256kB，512kB或者1MB。

pieces则是每个piece的正确性验证信息，每一片均对应一个唯一的SHA1散列值，该键对应的值是所有的20字节SHA1散列值连接而成的字符串。

name/path比较笼统的说，就是具体文件的信息。因为BitTorrent协议允许将数个文件和文件夹作为一个BitTorrent下载进行发布，因此下载方可以根据需要勾选某一些下载文件。注意，这里将数个文件也砍成一个数据流，因此一个piece如果在文件边界上，可能包含不同文件的信息。

announce保存的是tracker服务器的URL，也就是客户端拿到.torrent文件首先要访问的服务器，在一些扩展协议中，announce可以保存多个tracker服务器作为备选。

（3）一个Tracker服务器

Tracker服务器，又称索引服务器。Tracker服务器核心功能记录了哪些下载者有资源可以下载，并提供给其他下载者。

（4）一个原始文件提供者

（5）一个或多个下载者

# BT协议分享过程

![](/images/bittorrent_1_1.png)

## 原始文件提供者分享过程

假设原始资源提供者要分享“海贼王.flv”这个视频文件，那么过程为：

（1）使用BitTorrent客户端工具，生成.torrent文件

.torrent文件是有一定格式标准的，主要的信息包括文件资源的基本信息、文件分片信息、分片的HASH值、Tracker服务器的地址等等。

（2）连接Tracker服务器

生成好.torrent文件之后，发布者需要先作为下载者一样根据.torrent文件进行下载，这样就会连接到Tracker服务器。由于发布者已经有了完整的资源文件，Tracker服务器会得知这是一个完全下载完成的用户，会把发布者的信息保存在Tracker服务器中。

（3）原始资源提供者将.torrent种子文件上传到WEB服务器

发布者还要做的最后一件事就是将.torrent文件放在服务器上，可以通过HTTP或者FTP协议供用户下载这个.torrent文件。相比于直接将整个资源文件提供给用户下载，只传输一个.torrent文件大大降低了服务器的负荷。

## 文件下载者下载资源过程

（1）搜索和下载.torrent种子文件

可以通过HTTP或者FTP协议直接从服务器上得到.torrent文件。

（2）解析.torrent种子文件

使用BitTorrent软件客户端打开.torrent文件，软件会根据.torrent的name/path元信息告诉我这个.torrent文件可以下载到一个.mkv文件，一个字幕文件，在这个阶段我可以进行一些勾选，选择下载某些而不是全部的资源。同时，根据.torrent种子文件，获取到Tracker服务器的地址信息。

（3）连接Tracker服务器获取Peers信息

客户端的第一步任务根据.torrent上的URL使用HTTP GET请求，这个请求包含了很多参数，这里只介绍从客户端发送到Tracker的请求最关键的几个参数：

    info_hash
    peer_id
    ip
    port

info_hash是元信息.torrent文件中info键所对应的值的SHA1散列，可以被Tracker服务器用来索引唯一的对应资源。

peer_id是20Byte的串，没有任何要求，被Tracker服务器用于记录客户端的名字。

ip可以从HTTP GET请求中直接获取，放在参数中可以解决使用代理进行HTTP GET的情况，Tracker服务器可以记录客户端的IP地址。

port客户端监听的端口号，用于接收response。一般情况下为BitTorrent协议保留的端口号是6881-6889，Tracker服务器会记录下端口号用于通知其他客户端。

在Tracker服务器收到客户端的HTTP GET请求后，会返回B encode形式的text/plain文本，同样是一个字典数据结构，其中最关键的一个键值对是peers，它的值是个字典列表结构，列表中的每一项都是如下的字典结构。

    peers
        peer_id
        ip
        port

这些信息在每个客户端连接Tracker服务器的时候都发送过，并且被Tracker服务器保存了下来。

（4）开始下载分片和提供分享

BT客户端根据Tracker服务器提供的Peers信息，直接去与这些Peers客户端连接，下载相应的分片，当某些分片下载完成后，也会被Tracker记录下来，后面其他的BT客户端也会从连接本客户端，从而本客户端也称为了资源分享者。

备注：一般说来，下载者和WEB服务器使用HTTP/FTP协议进行种子文件的获取与上传。下载者和Tracker服务器之间是通过HTTP协议。下载者和下载者之间是通过BT协议，也就是TCP/UDP协议来进行数据的传输。

学习资料参考于：
https://blog.azard.me/2015/10/24/introduction-to-bittorrent/
