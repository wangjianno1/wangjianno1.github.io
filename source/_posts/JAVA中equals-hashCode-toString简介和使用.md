---
title: JAVA中equals | hashCode | toString简介和使用
date: 2018-06-06 15:41:17
tags:
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

`equals()`方法用来判断两个对象是否“相等”，在`Object`中`equals()`方法中是判断两个对象的引用是否相等，开发者可以在自定义类中根据具体需求覆写`equals()`方法。

# hashCode()

`hashCode()`方法返回该对象的哈希码值。支持此方法是为了提高哈希表（例如 `java.util.Hashtable`提供的哈希表）的性能。关于`hashCode()`有几点注意事项：

- 在Java应用程序执行期间，如果没有修改对象进行`equals`比较时所用的信息，在对同一对象多次调用`hashCode`方法时，必须一致地返回相同的整数。从某一应用程序的一次执行到同一应用程序的另一次执行，该整数无需保持一致。
- 如果根据`equals(Object)`方法，两个对象是相等的，那么对这两个对象中的每个对象调用`hashCode`方法都必须生成相同的整数结果。
- 如果根据`equals(java.lang.Object)`方法，两个对象不相等，那么对这两个对象中的任一对象上调用`hashCode`方法不要求一定生成不同的整数结果。但是，程序员应该意识到，为不相等的对象生成不同整数结果可以提高哈希表的性能。

实际上，由Object类定义的hashCode方法确实会针对不同的对象返回不同的整数。开发者可以根据实际需求覆写该方法。

# toString()

`toString()`方法返回该对象的字符串表示。通常`toString`方法会返回一个“以文本方式表示”此对象的字符串。结果应是一个简明但易于读懂的信息表达式。开发者可以根据实际需求覆写该方法。

Object类的`toString()`方法返回一个字符串，该字符串由类名（对象是该类的一个实例）、at标记符`"@"`和此对象哈希码的无符号十六进制表示组成。
