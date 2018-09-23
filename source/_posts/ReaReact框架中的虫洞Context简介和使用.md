---
title: ReaReact框架中的虫洞Context简介和使用
date: 2018-09-24 02:03:48
tags:
categories: ReactJS
---

# context的介绍

当开发React应用时，我们总是通过改变State和传递Prop对view进行控制。但是随着我们的应用变的越来越复杂，组件嵌套也变的越来越深，有时甚至需要从最外层将一个数据一直传递到最里层（比如当前user的信息）。 

理论上，通过prop一层层传递下去当然是没问题的。不过这也太麻烦啦，要是能在最外层和最里层之间开一个穿越空间的虫洞就好了。 幸运的是，React的开发者也意识到这个问题，为我们开发出了这个空间穿越通道—context。

# context的使用

假设我们有下面这样的组件结构，若D组件需要获取在A组件中用户信息，就可以使用context来获取到。

![](/images/react_context_1_1.png)

代码的实现如下：

```javascript
// 外层组件A的定义
class A extends React.Component {
    getChildContext() {
        return {
            user: "testuser123"
        }
    }

    render() {
        <div>{this.props.children}</div>
    }
}
A.childContextTypes = {
    user: React.PropTypes.object
}

// 内层组件D的定义
class D extends React.Component {
    render() {
        <div>{this.context.user}</div>
    }
}
D.contextTypes = {
    user: React.PropTypes.object
}
```

或如下写法：

```javascript
// 外层组件A的定义
class A extends React.Component {
    getChildContext() {
        return {
            user: "testuser123"
        }
    }

    childContextTypes = {
        user: React.PropTypes.object
    }

    render() {
        <div>{this.props.children}</div>
    }
}

// 内层组件D的定义
class D extends React.Component {
    render() {
        <div>{this.context.user}</div>
    }

    contextTypes = {
        user: React.PropTypes.object
    }
}
```

备注：只要在外层组件A定义一个getChildContext方法以及childContextTypes声明。在里层组件D中声明contextTypes，则就可以在里层组件D中使用this.context.xxx来获取外层组件A传递出来的值了。另外，组件A的其他子组件均可以像组件D一样地获取到组件A传递过来的context值。

学习资料参考于：
https://segmentfault.com/a/1190000004636213