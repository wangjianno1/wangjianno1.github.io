---
title: WebSocket技术调研
date: 2022-02-27 00:58:43
tags: WebSocket
categories: HTTP
---

# WebSocket简介

WebSocket是一种网络通信协议。在2009年诞生，于2011年被IETF定为标准RFC 6455通信标准。并由RFC7936补充规范。WebSocket API也被W3C定为标准。

WebSocket是HTML5开始提供的一种在单个TCP连接上进行全双工（full-duplex）通讯的协议。没有了Request和Response的概念，两者地位完全平等，连接一旦建立，就建立了真正的持久性连接，双方可以随时向对方发送数据。

![](/images/websocket_1_1.png)

简单总结WebSocket，WebSocket是HTML5开始提供的一种独立在单个TCP连接上进行全双工通讯的有状态的协议（它不同于无状态的HTTP），并且还能支持二进制帧、扩展协议、部分自定义的子协议、压缩等特性。

目前看来，WebSocket是可以完美替代AJAX轮询和Comet。但是某些场景还是不能替代SSE，WebSocket和SSE各有所长。

# WebSocket的特点

WebSocket最大特点就是，服务器可以主动向客户端推送信息，客户端也可以主动向服务器发送信息，是真正的双向平等对话，属于服务器推送技术的一种。

![](/images/websocket_1_2.png)

其他特点包括：

（1）建立在TCP协议之上，服务器端的实现比较容易。

（2）与HTTP协议有着良好的兼容性。默认端口也是80和443，并且握手阶段采用HTTP协议，因此握手时不容易屏蔽，能通过各种HTTP代理服务器。

（3）数据格式比较轻量，性能开销小，通信高效。

（4）可以发送文本，也可以发送二进制数据。

（5）没有同源限制，客户端可以与任意服务器通信。

（6）协议标识符是ws（如果加密，则为wss），服务器网址就是URL，形如`ws://example.com:80/some/path`。

![](/images/websocket_1_3.png)

# WebSocket编程

（1）WebSocket客户端编写

```javascript
var ws = new WebSocket("wss://echo.websocket.org");
ws.onopen = function(evt) { 
    console.log("Connection open ..."); 
    ws.send("Hello WebSockets!");
};
ws.onmessage = function(evt) {
    console.log( "Received Message: " + evt.data);
    ws.close();
};
ws.onclose = function(evt) {
    console.log("Connection closed.");
};
``` 

# WebSocket与长链接的HTTP的联系区别

（1）WebSocket是也是基于TCP长连接技术上的，值得注意的是，WebSocket也是使用的是80/443端口。

（2）HTTP和WebSocket都是应用层协议。

（3）WebSocket协议有两部分阶段，一是握手阶段；另一个是数据传输阶段。WebSocket的握手阶段是基于HTTP Upgrade机制的，将HTTP协议协议升级到WebSocket协议。然后WebSocket数据传输阶段就和HTTP没关系了，使用的WebSocket协议。

![](/images/websocket_1_4.png)

# nginx支持websocket

nginx已支持websocket，只需要开启nginx的Upgrade机制即可。

学习资料参考于：
https://halfrost.com/websocket/
http://www.ruanyifeng.com/blog/2017/05/websocket.html
