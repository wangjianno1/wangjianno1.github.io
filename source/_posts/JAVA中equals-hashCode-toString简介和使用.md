---
title: JAVA中equals | hashCode | toString简介和使用
date: 2018-06-06 15:41:17
tags: JAVA基础
categories: JAVA
---

# JAVA中equals | hashCode | toString方法简介

在`java.lang.Object`类中有`equals`、`hashCode`和`toString`这些基础的方法。如下所示：

```java
public class Object {
    public boolean equals(Object obj) {
        return (this == obj);
    }

    public native int hashCode();
    
    public String toString() {
        return getClass().getName() + "@" + Integer.toHexString(hashCode());
    }
}
```

# equals()

`equals()`方法用来判断两个对象是否“相等”，在`Object`中`equals()`方法中是判断两个对象的引用地址是否相等。若开发者在自定义类中根据具体需求覆写了`equals()`方法，那就会是另外的比较策略了，例如，String类中就重写了`equals()`方法，重写后的`equals()`方法用来判断两个字符串的内容是否相等。

另外，Math、Integer、Double等这些类都是重写了Object类的equals()方法的，都进行的是内容的比较。

总之，不管是否覆写了`equal()`方法，`equal()`目的就是用来判断两个对象是否“**相等/相同**”。

补充：对于基本数据类型，`==`比较的是两个变量的值是不是相等；而对于抽象数据类型，`==`比较的是两个变量的引用是否相等，即变量在内存中的地址是否相等。

# hashCode()

`hashCode()`方法返回该对象的哈希码值。Object的`hashCode()`方法是本地方法，也就是用C/C++语言实现的，该方法通常用来将对象的内存地址转换为整数之后返回。在Java中，`hashCode()`方法的主要作用是为了配合基于散列/哈希的集合类使用，这样的散列集合包括HashSet、HashMap以及HashTable，用来快速判断两个对象是否相等/相同。

要想了解hashcode()，要和equal()放在一起学习。在Java中，不管一个类是否覆写了`hashcode()`和`equal()`，要遵循如下规则：

（1）经过`equal()`判断相等的两个对象，必须二者的`hashcode()`是一样的。

（2）若两个对象的`hashcode()`不一样，两个对象通过`equal()`比较也一定不相等

（3）若两个对象的`hashcode()`一样，但是不能保证两个对象通过`equal()`比较也一定相等，因为存在哈希函数冲突碰撞

一定要注意的是，在重新某个类的`equal()`方法，也一定需要重写该类的`hashcode()`方法，保证满足上面的原则，不然该类的对象在用到一些基于散列的集合类就会出现问题。

拿HashSet来说，Set中不能存储相等的元素。当往集合中增加一个对象时，HastSet对象先要判断该对象是否已经存在于集合中了，若存在就不添加了，若不存在才需要添加。对于这个判断是否集合中已经有相等的元素了，如果都用`equal()`来判断，若集合中的对象数量多，那效率会非常低。这时`hashcode()`就派上用场了，先比较`hashcode()`，若在哈希表中Hash到的位置没有元素，那HashSet中一定没有相等的对象，直接插入即可，若在哈希表中Hash到的位置已经有元素了，即有冲突了，说明可能存在相等的元素，这时再拿`equal()`来比较一下，若相等不插入，若不相等再插入。整个过程就大大降低了执行`equal()`的次数。

# toString()

`toString()`方法返回该对象的字符串表示。通常`toString`方法会返回一个“以文本方式表示”此对象的字符串。结果应是一个简明但易于读懂的信息表达式。开发者可以根据实际需求覆写该方法。

Object类的`toString()`方法返回一个字符串，该字符串由类名（对象是该类的一个实例）、at标记符`"@"`和此对象哈希码的无符号十六进制表示组成。
