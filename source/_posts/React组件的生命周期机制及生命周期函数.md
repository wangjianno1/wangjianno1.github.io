---
title: React组件的生命周期机制及生命周期函数
date: 2018-07-09 00:38:02
tags:
categories: ReactJS
---

# React组件的生命周期机制

![](/images/react_lifecycle_1_1.png)

![](/images/react_lifecycle_1_2.png)

# React组件的生命周期函数

React组件本质上是一个状态机，输入确定，则输出一定确定。React组件的生命周期包括初始化阶段、运行中阶段、销毁阶段三个阶段。React框架为组件的不同生命阶段，提供了近十个钩子Hook函数。 例如：

（1）初始化阶段钩子函数

```javascript
getDefaultProps()
getInititalState()
componentWillMount()
render  //render函数中只能访问this.props和this.state，只能有一个顶层组件，不允许修改状态和DOM输出
componentDidMount
```

备注：上述五个钩子是按执行顺序排序的。

（2）运行中阶段的钩子函数

此时组件已经渲染好并且用户可以与它进行交互，比如鼠标点击，手指点按，或者其它的一些事件，导致应用状态的改变，将会看到下面的方法依次被调用：

```javascript
componentWillReceiveProps()
shouldComponentUpdate()  //如果该函数返回false，那么会阻止接下来的render函数调用
componentWillUpdate()
render  //和上面的是同一个render函数哦
componentDidUpdate //该函数中可以修改DOM
```

（3）销毁阶段的钩子函数

```javascript
componentWillUnmount
```

举例来说，组件可以通过Ajax请求，从服务器获取数据。Ajax请求一般在`componentDidMount()`方法里面发出，代码如下：

```javascript
componentDidMount() {
    const url = '...';
    $.getJSON(url)
      .done()
      .fail();
}
```

# 各钩子函数的说明

（1）getDefaultProps()

对于每个组件实例来讲，这个方法只会调用一次，该组件类的所有后续应用，getDefaultPops将不会再被调用，其返回的对象可以用于设置默认的props(properties的缩写) 值。该函数只在`React.createClass({})`创建的组件中存在，在`class Welcome extends React.Component {}`创建的组件中是不存在该函数的。

（2）getInitialState()

对于组件的每个实例来说，这个方法的调用有且只有一次，用来初始化每个实例的state，在这个方法里，可以访问组件的props。每一个React组件都有自己的state，其与props的区别在于state只存在组件的内部，props在所有实例中共享。该函数只在`React.createClass({})`创建的组件中存在，在`class Welcome extends React.Component {}`创建的组件中是不存在该函数的。

（3）componentWillMount()

该方法在首次渲染之前调用，也是在render方法调用之前修改state的最后一次机会。

（4）render()

render方法会创建一个虚拟DOM，用来表示组件的输出。对于一个组件来讲，render方法是唯一一个必需的方法。render方法返回的结果并不是真正的DOM元素，而是一个虚拟的表现，类似于一个DOM tree的结构的对象。react之所以效率高，就是这个原因。render()函数执行结果就是页面被重新渲染啦。

（5）componentDidMount()

该方法不会在服务端被渲染的过程中调用。该方法被调用时，已经渲染出真实的DOM，可以在该方法中通过this.getDOMNode()访问到真实的DOM（推荐使用ReactDOM.findDOMNode()）。

（6）componentWillReceiveProps()

组件的props属性可以通过父组件来更改，这时componentWillReceiveProps将来被调用。可以在这个方法里更新state，以触发render方法重新渲染组件。

（7）shouldComponentUpdate()

如果你确定组件的props或者state的改变不需要重新渲染，可以通过在这个方法里通过返回false来阻止组件的重新渲染，返回false则不会执行render 以及后面的componentWillUpdate，componentDidUpdate方法。这个函数必须返回值必须是布尔型，若返回false，则不重新渲染页面，若返回true，则会重新渲染页面。

（8）componentWillUpdate()

这个方法和componentWillMount类似，在组件接收到了新的props或者state即将进行重新渲染前，componentWillUpdate(object nextProps, object nextState) 会被调用，注意不要在此方面里再去更新props或者state。

（9）componentDidUpdate()

这个方法和componentDidMount类似，在组件重新被渲染之后，componentDidUpdate(object prevProps, object prevState) 会被调用。可以在这里访问并修改DOM。

（10）componentWillUnmount()

每当React使用完一个组件，这个组件必须从DOM中卸载后被销毁，此时componentWillUnmout会被执行，完成所有的清理和销毁工作，在componentDidMount中添加的任务都需要再该方法中撤销，如创建的定时器或事件监听器。

# 一点补充说明

（1）当我们在组件中调用setState函数去更新组件的this.state时，就会依次调用shouldComponentUpdate、componentWillUpdate、render以及componentDidUpdate等函数，可能还会去调用其他函数啦。

（2）当我们的组件的属性props变化时，也会调用一些组件的生命周期函数，会依次调用componentWillReceiveProps、shouldComponentUpdate、componentWillUpdate、render以及componentDidUpdate等函数。也就是说，当React组件的props被修改时，也是会重新渲染该组件的啦。

（3）一般来说，我们很少重写componentWillReceiveProps、shouldComponentUpdate、componentWillUpdate以及componentDidUpdate这四个函数。componentWillUnmount我们一般也很少重写啦。

学习资料参考于：
https://segmentfault.com/a/1190000004168886
