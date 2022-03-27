---
title: JAVA中容器类或集合类
date: 2018-01-30 19:34:15
tags: JAVA基础
categories: JAVA
---

# 复杂数据类型

（1）枚举Enumeration

枚举（Enumeration）接口虽然它本身不属于数据结构,但它在其他数据结构的范畴里应用很广。 枚举（The Enumeration）接口定义了一种从数据结构中取回连续元素的方式。例如，枚举定义了一个叫nextElement 的方法，该方法用来得到一个包含多元素的数据结构的下一个元素。

（2）位集合BitSet

位集合类实现了一组可以单独设置和清除的位或标志。该类在处理一组布尔值的时候非常有用，你只需要给每个值赋值一"位"，然后对位进行适当的设置或清除，就可以对布尔值进行操作了。

（3）向量Vector

向量（Vector）类和传统数组非常相似，但是Vector的大小能根据需要动态的变化。和数组一样，Vector对象的元素也能通过索引访问。

使用Vector类最主要的好处就是在创建对象的时候不必给对象指定大小，它的大小会根据需要动态的变化。

（4）栈Stack

栈（Stack）实现了一个后进先出（LIFO）的数据结构。你可以把栈理解为对象的垂直分布的栈，当你添加一个新元素时，就将新元素放在其他元素的顶部。当你从栈中取元素的时候，就从栈顶取一个元素。换句话说，最后进栈的元素最先被取出。

（5）字典Dictionary

字典（Dictionary） 类是一个抽象类，它定义了键映射到值的数据结构。当你想要通过特定的键而不是整数索引来访问数据的时候，这时候应该使用Dictionary。由于Dictionary类是抽象类，所以它只提供了键映射到值的数据结构，而没有提供特定的实现。

（6）哈希表Hashtable

Hashtable类提供了一种在用户定义键结构的基础上来组织数据的手段。例如，在地址列表的哈希表中，你可以根据邮政编码作为键来存储和排序数据，而不是通过人名。哈希表键的具体含义完全取决于哈希表的使用情景和它包含的数据。

（7）属性Properties
Properties继承于Hashtable。Properties类表示了一个持久的属性集.属性列表中每个键及其对应值都是一个字符串。Properties类被许多Java类使用。例如，在获取环境变量时它就作为System.getProperties()方法的返回值。

# 集合类 | 容器类

在Java 2之前，Java是没有完整的集合框架的。它只有一些简单的可以自扩展的容器类，比如Vector，Stack，Hashtable等。这些容器类在使用的过程中由于效率问题饱受诟病，因此在Java 2中，Java设计者们进行了大刀阔斧的整改，重新设计，于是就有了现在的集合框架。需要注意的是，之前的那些容器类库并没有被弃用而是进行了保留，主要是为了向下兼容的目的，但我们在平时使用中还是应该尽量少用。

在Java2中集合框架中的接口或类，我们称之为“集合类”或“容器类”。

必须指出的是，虽然容器号称存储的是Java对象，但实际上并不会真正将Java对象放入容器中，只是在容器中保留这些对象的引用。也就是说，Java容器实际上包含的是引用变量，而这些引用变量指向了我们要实际保存的Java对象。

# 容器类的框架图

容器类的框架图如下：

![](/images/java_syntax_9_1.png)

备注：窄虚线框代表的是“接口”；宽虚线框代表的是实现了部分方法的“抽象类”；实线框代表的是“类”；粗实线框代表的是日常常用的“类”。

上图中有一点疑惑，水平的实心箭头的produces是什么含义？一个Collection的类可以产生一个Iterator的对象？

![](/images/java_syntax_8_1.png)

如上是一个简化版的容器类关系图，图中只列举了主要的继承派生关系，并没有列举所有关系。比方省略了AbstractList，NavigableSet等抽象类以及其他的一些辅助类，如想深入了解，可自行查看源码。

# JAVA常用集合类

常用的接口和类：

（1）List接口

有序、可重复。如ArrayList、LinkedList以及Vector等。

（2）Set接口

无序、不能重复。如HashSet以及TreeSet等。

（3）Map接口

大都是无序（有些LinkedHashMap是有序的），键值对、键唯一、值不唯一。如HashMap、Hashtable以及TreeMap等。

备注：有序，指的是遍历读取集合中元素的顺序，和集合中元素添加时的先后次序保持一样。

# 集合类的遍历操作

集合类的遍历操作有如下几种方式：

- 普通for循环，形如`for(int i=0; i<arr.size(); i++) {…}`
- 增强for循环foreach，形如`for(Object i : arr) {…}`
- 迭代器Iterator，形如`Iterator it = arr.iterator(); while(it.hasNext()) { Object o =it.next(); …}`

List类型的集合类的遍历示例代码如下：

```java
List<String> list = new ArrayList<String>();
list.add("aaa");
list.add("bbb");
list.add("ccc");
//使用for循环遍历
for (int index=0; index<list.size(); index++) {
    String elem = list.get(index);
    System.out.println(elem);
}
//使用增强for循环遍历
for (String elem : list) {
    System.out.println(elem);
}
//使用迭代器Iterator遍历
Iterator iter = list.iterator();
while (iter.hasNext()) {
    Object obj = iter.next();
    System.out.println(obj);
}
//使用forEach + Lambda表达式遍历（需要JDK1.8及以上版本）
list.forEach(item -> System.out.println(item));
```

Map类型的集合类的遍历示例代码如下：

```java
Map<String, Integer> map = new HashMap<String, Integer>();
map.put("zhangsan", 23);
map.put("lisi", 43);
map.put("wangwu", 32);
//遍历Map的key值
for (Object key : map.keySet()) {
    System.out.println(key);
}
//遍历Map的value值
for (Object value : map.values()) {
    System.out.println(value);
}
//使用key集合或者values集合的迭代器来遍历
for (Iterator it = map.keySet().iterator(); it.hasNext();) {
    Object obj = it.next();
    System.out.println(obj);
}
//使用Map.Entry来遍历，Map.Entry是Map的内部接口，在HashMap会实现这个接口，而成为HashMap的内部类
for (Map.Entry<String, Integer> entity : map.entrySet()) {
    String key1 = entity.getKey();
    Integer value1 = entity.getValue();
    System.out.println(key1);
    System.out.println(value1);
}
//使用forEach + Lambda表达式遍历（需要JDK1.8及以上版本）
map.forEach((k, v) -> {
        System.out.println("key=" + k);
        System.out.println("value=" + v);
});
```

Set类型的集合类的遍历示例代码如下：

```java
Set<String> set = new HashSet<String>();
set.add("beijing");
set.add("shanghai");
set.add("tianjin");
set.add("chongqing");
//使用增强for循环来遍历
for (Object obj : set) {
    System.out.println(obj);
}
//使用迭代器Iterator来遍历
Iterator iter = set.iterator();
while (iter.hasNext()) {
    Object obj = iter.next();
    System.out.println(obj);
}
//使用forEach + Lambda表达式遍历（需要JDK1.8及以上版本）
set.forEach(item -> System.out.println(item));
```