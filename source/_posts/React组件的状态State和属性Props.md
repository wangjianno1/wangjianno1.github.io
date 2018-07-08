---
title: React组件的状态State和属性Props
date: 2018-07-08 13:52:59
tags:
categories: ReactJS
---

# 组件状态State

React把组件看成是一个状态机（State Machines）。通过与用户的交互，实现不同状态，然后渲染UI，让用户界面和数据保持一致。React里，只需更新组件的state，然后根据新的state重新渲染用户界面（不要操作DOM）。

以下实例中创建了`LikeButton`组件，`getInitialState`方法用于定义初始状态，也就是一个对象，这个对象可以通过`this.state`属性读取。当用户点击组件，导致状态变化，`this.setState`方法就修改状态值，每次修改以后，React框架会自动调用`this.render`方法来渲染组件。

```javascript
var LikeButton = React.createClass({
    getInitialState: function() {
        return {liked: false};
    },

    handleClick: function(event) {
        this.setState({liked: !this.state.liked});
    },

    render: function() {
        var text = this.state.liked ? '喜欢' : '不喜欢';
        return (
            <p onClick={this.handleClick}>
              你<b>{text}</b>我。点我切换状态。
            </p>
        );
    }
});

ReactDOM.render(
    <LikeButton />,
    document.getElementById('example')
);
```

关于组件状态State的一些API如下：

（1）setState()

`setState()`用来设置状态，合并nextState和当前state，并重新渲染组件。setState是React事件处理函数中和请求回调函数中触发UI更新的主要方法。语法如下：

```javascript
setState(object nextState[, function callback])
```

nextState，将要设置的新状态，该状态会和当前的state合并。也就是说如果`this.setState({xxoo: somedata})`设置state中xxoo字段，会合并原来的state，也就是在原来的state中多了一个xxoo字段。

callback，可选参数，回调函数。该函数会在setState设置成功，且组件重新渲染后调用。

备注：每次调用this.setState，render方法都会被再次调用，同时也会调用一些相关的生命周期函数。this.setState接受一个对象作为新状态的patch，也就是说这个对象不会覆盖现有的this.state，而是一个类似extend的行为。

（2）replaceState()

replaceState()用来替换状态，replaceState()方法与setState()类似，但是方法只会保留nextState中状态，原state不在nextState中的状态都会被删除。语法如下：

```javascript
replaceState(object nextState[, function callback])
```

nextState，将要设置的新状态，该状态会替换当前的state。

callback，可选参数，回调函数。该函数会在replaceState设置成功，且组件重新渲染后调用。

# 组件属性Props

state和props主要的区别在于props是不可变的，而state可以根据与用户交互来改变。这就是为什么有些容器组件需要定义state来更新和修改数据。而子组件只能通过props来传递数据。因此，一定要注意的是，开发者一般不需要在组件中去修改props的值哦，当然修改了props前台也不会报错，只是一个开发规范或约束的问题。

```javascript
var HelloMessage = React.createClass({
    render: function() {
        return <h1>Hello {this.props.name}</h1>;
    }
});

ReactDOM.render(
    <HelloMessage name="Runoob" />,
    document.getElementById('example')
);
```

可以通过`getDefaultProps()`方法为props设置默认值，实例如下：

```javascript
var HelloMessage = React.createClass({
    getDefaultProps: function() {
        return {
            name: 'Runoob'
        };
    },
    render: function() {
        return <h1>Hello {this.props.name}</h1>;
    }
});

ReactDOM.render(
    <HelloMessage />,
    document.getElementById('example')
);
```

Props验证使用propTypes，它可以保证我们的应用组件被正确使用，React.PropTypes提供很多验证器(validator) 来验证传入数据是否有效。当向 props传入无效数据时，JavaScript控制台会抛出警告。举例来说：

```javascript
var title = "菜鸟教程";
var MyTitle = React.createClass({
    propTypes: {
        title: React.PropTypes.string.isRequired,
    },

    render: function() {
        return <h1> {this.props.title} </h1>;
    }
});
ReactDOM.render(
    <MyTitle title={title} />,
    document.getElementById('example')
);
```

# 关于组件state和props的初始化

若使用`React.createClass({})`来定义React组件，可以使用`getDefaultProps()`和`getInititalState()`来初始化组件的state和props。若使用`class Welcome extends React.Component {}`来定义组件，那么则没有`getDefaultProps()`和`getInititalState()`，则可以在构造函数中初始化state，如下：

```javascript
class Welcome extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
        	xxoo: 'wahaha'
        }
}
```

至于属性props的初始化待确认。
