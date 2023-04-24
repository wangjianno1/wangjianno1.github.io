---
title: 用户体系及用户访问控制HTTP Authorization|OAuth|JWT|SSO等
date: 2019-04-12 11:51:07
tags:
categories: 大前端
---

# 开放授权OAuth

OAuth，Open Authorization，中文名是开放授权。OAuth协议为用户资源的授权提供了一个安全的、开放而又简易的标准。与以往的授权方式不同之处是OAuth的授权不会使第三方触及到用户的帐号信息（如用户名与密码），即第三方无需使用用户的用户名与密码就可以申请获得该用户资源的授权，因此OAuth是安全的。

通俗的讲，OAuth是为解决不同公司的不同产品实现登陆的一种简便授权方案，通常这些授权服务都是由大客户网站提供的，如QQ，新浪微博，人人网等。而使用这些服务的客户可能是大客户网站，也可能是小客户网站。使用OAuth授权的好处是，在为用户提供某些服务时，可减少或避免因用户懒于注册而导致的用户流失问题。

OAuth是一个关于授权（Authorization）的开放网络标准，在全世界得到广泛应用，目前的版本是2.0版。作为互联网用户，我们很容易就看到有关OAuth的授权认证，例如我们登录某个网站或APP时，往往我们可以用第三方的平台的账户和密码（QQ、淘宝、百度或者新浪微博等账号体系）来登录。在这种情况下，该网站和APP就不需要维护一套用户体系，只需要使用一些大平台提供的OAuth服务就可以啦，透过OAuth可以获取一些用户基本的信息。

# HTTP Authorization Header

在HTTP Authentication是一种用来允许网页浏览器或其他客户端程序在请求时提供用户名和口令形式的身份凭证的一种登录验证方式。如HTTP Basic Authorization的请求格式，在HTTP的请求头中加入字段格式是`Authorization: Basic base64(username:password)`，如下：

![](/images/http_auth_1_1.png)

显然这种是不安全的，很容易被第三方截获用户名和密码。当然是用https协议就可以避免这个问题啦，因为HTTPS会将HTTP Header/Body都加密，第三方截取了HTTPS数据包也解密不出来啦。

当访问一个需要HTTP Basic Authentication的URL的时候，如果你没有提供用户名和密码，服务器就会返回401。在发送请求的时候添加HTTP Basic Authentication认证信息到请求中，有如下几种方法：

（1）直接在浏览器中打开，浏览器会弹出表单，提示你输入用户名和密码。当填写完成并提交后，浏览器会自动将用户名和密码组装到HTTP Authorization Header中，发送给服务端。

（2）在请求头中添加Authorization请求头，即`Authorization: "Basic 用户名和密码的base64加密字符串"`

![](/images/http_auth_1_2.png)

（3）在URL中添加用户名和密码，形如：

    http://username:password@api.minicloud.com.cn/statuses/friends_timeline.xml

# JWT

（1）JWT简介

JSON Web Token，简写JWT，是目前最流行的HTTP认证解决方案。我们知道HTTP session会将sessionid存储到客户端Cookie中，所以会面临两个问题，一个是浏览器禁用Cookie，另一个是若后端是多实例的架构，就涉及到session共享问题。而JWT可以解决这里面的一些问题。JWT将客户端的信息完全存储到浏览器端，服务器不需要保存session数据了，所有数据都保存在客户端，每次请求都将数据发回服务器。

（2）JWT原理

JWT的原理是，服务器认证以后，生成一个JSON对象，发回给浏览器，这个JSON对象的格式如下：

```json
{
  "姓名": "张三",
  "角色": "管理员",
  "到期时间": "2018年7月1日0点0分"
}
```

以后，用户与服务端通信的时候，都要发回这个JSON对象。服务器完全只靠这个对象认定用户身份。为了防止用户篡改数据，服务器在生成这个对象的时候，会加上签名。这样服务器就不保存任何session数据了，也就是说，服务器变成无状态了，从而比较容易实现扩展。

（3）JWT的数据结构

JWT的三个部分依次如下，

    Header，头部
    Payload，负载
    Signature，签名

写成一行，就是下面的样子：

    Header.Payload.Signature

![](/images/http_auth_1_3.png)

（4）JWT的使用方式

客户端收到服务器返回的JWT，可以储存在Cookie里面，也可以储存在localStorage。此后，客户端每次与服务器通信，都要带上这个JWT。你可以把它放在Cookie里面自动发送，但是这样不能跨域，所以更好的做法是放在HTTP请求的头信息Authorization字段里面。

    Authorization: Bearer <token>

另一种做法是，跨域的时候，JWT就放在POST请求的数据体里面。

# SSO

集中式认证服务，英文名称为Central Authentication Service，缩写CAS，是一种针对万维网的单点登录协议。它的目的是允许一个用户访问多个应用程序，而只需提供一次凭证（如用户名和密码）。它还允许web应用程序在没有获得用户的安全凭据（如密码）的情况下对用户进行身份验证。

Single Sign On，简称SSO，SSO使得在多个应用系统中，用户只需要登录一次就可以访问所有相互信任的应用系统。SSO主要技术点是CAS。

![](/images/http_auth_1_4.png)

从图中可以看出，用户第一次访问helloservice，helloservice发现客户端没有携带ticket，随即将用户请求重定向到SSO/CAS的登录页面，然后用户数据用户名和密码，并将请求提交到CAS Server，CAS Server对用户信息进行校验，若通过校验，CAS Server会返回给浏览器一个Ticket，并将页面重定向到helloservice的回调页面。这时，浏览器携带着Ticket再次访问helloserivce，helloservice获取到客户端发过来的Ticket，而这是helloservice并不知道这个Ticket是不是靠谱，然后helloservice会将Ticket发给CAS Server进行认证，最终Cas Server将认证结果返回给helloservice，helloservice根据认证结果决定是否返回正常结果给客户端。在此之后，客户端再访问其他的系统时，如helloservice1，helloservice2，同样会携带这个Ticket，若Ticket经由helloservice1，helloservice2提交给Cas Service且验证通过，用户可以直接访问这些系统，而不用再次输入用户名和密码啦。

简单来说，SSO就是在一个多系统共存的环境下，用户在一处登录后，就不用在其他系统中登录，也就是用户的一次登录能得到其他所有系统的信任。单点登录在大型网站里使用得非常频繁，例如像阿里巴巴这样的网站，在网站的背后是成百上千的子系统，用户一次操作或交易可能涉及到几十个子系统的协作，如果每个子系统都需要用户认证，不仅用户会疯掉，各子系统也会为这种重复认证授权的逻辑搞疯掉。

# 常看到的一种API用户验证管理API KEY

（1）客户端侧

client向服务端申请两个ID，一个是Api_key，另一个是Security_key。其中Api_key是客户端的唯一标识，Security_key仅仅是用来生成Signature串的因子，Security_key不会在调用HTTP API的时候传递给服务端，服务端会通过Api_key找出对应的Security_key。客户端生成url串的过程如下（生成签名串时，会将url的参数按字母大小写排序，这样服务端才能做同样的操作）：

![](/images/http_auth_1_5.png)

（2）服务端侧

服务端在收到请求后，通过Api_key找出Security_key，并使用和客户端同样的方法计算出签名串，然后和url传递过来的签名串进行比较，若一样则说明client身份是正确的，且url请求没被第三方拦截修改。

![](/images/http_auth_1_6.png)

# SSO和OAuth的区别

两者都是使用令牌的方式来代替用户密码访问应用，在需要用户访问控制的业务系统中都没有账号和密码，账号密码是存放在登录中心或新浪微博/微信服务器中的，这就是所谓的使用令牌代替账号密码访问应用。

OAuth是一种授权协议，只是为用户资源的授权提供了一个安全的、开放而又简易的标准。OAuth 2.0为客户端开发者开发Web应用，桌面端应用程序，移动应用及客厅设备提供特定的授权流程。SSO是在多个应用系统中，用户只需要登录一次就可以访问所有相互信任的应用系统。
通俗的讲，OAuth是为解决不同公司的不同产品实现登陆的一种简便授权方案，通常这些授权服务都是由大客户网站提供的，如QQ，新浪微博，人人网等。而使用这些服务的客户可能是大客户网站，也可能是小客户网站。使用OAuth授权的好处是，在为用户提供某些服务时，可减少或避免因用户懒于注册而导致的用户流失问题。SSO通常处理的是一个公司的不同应用间的访问登陆问题。如企业应用有很多业务子系统，只需登陆一个系统，就可以实现不同子系统间的跳转，而避免了登陆操作。

学习资料参考于：
https://www.imooc.com/learn/557
http://www.ruanyifeng.com/blog/2014/05/oauth_2_0.html
http://www.ruanyifeng.com/blog/2018/07/json_web_token-tutorial.html
