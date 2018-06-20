---
title: JAVA的序列化与反序列化机制
date: 2018-06-04 16:20:38
tags: JAVA基础
categories: JAVA
---

# JAVA的序列化与反序列化机制

Java提供了一种对象序列化的机制，该机制中，一个对象可以被表示为一个字节序列，该字节序列包括该对象的数据、有关对象的类型的信息和存储在对象中数据的类型。将序列化对象写入文件之后，可以从文件中读取出来，并且对它进行反序列化，也就是说，对象的类型信息、对象的数据，还有对象中的数据类型可以用来在内存中新建对象。整个过程都是Java虚拟机（JVM）独立的，也就是说，在一个平台上序列化的对象可以在另一个完全不同的平台上反序列化该对象。

在JAVA中，一个对象要想被序列化和反序列化，则必须满足两个条件：

- 该类必须实现 java.io.Serializable 对象。
- 该类的所有属性必须是可序列化的。如果有一个属性不是可序列化的，则该属性必须注明是短暂（transient）的。

# ObjectInputStream 与 ObjectOutputStream

类`ObjectInputStream`和`ObjectOutputStream`是高层次的数据流，它们包含反序列化和序列化对象的方法。`ObjectOutputStream`类用来序列化一个对象，即将一个对象序列化到一个文件中。需要注意的是，当序列化一个对象到文件时， 按照Java的标准约定，被序列化对象的文件的扩展名为`.ser`。

# 序列化机制中serialVersionUID作用

在进行对象序列号之前，我们需要在对象中增加一个`serialVersionUID`属性，因为Java的序列化机制是通过在运行时判断类的`serialVersionUID`来验证版本一致性的。在进行反序列化时，JVM会把传来的字节流中的`serialVersionUID`与本地相应实体（类）的`serialVersionUID`进行比较，如果相同就认为是一致的，可以进行反序列化，否则就会出现序列化版本不一致的异常。

一般来说，定义serialVersionUID的方式有两种，分别为：

（1）采用默认的`1L`，具体为`private static final long serialVersionUID = 1L;`

（2）根据类名、接口名、成员方法及属性等来生成一个64位的哈希字段，例如`private static final long serialVersionUID = XXXL;`

当你一个类实现了`Serializable`接口，如果没有显式地定义`serialVersionUID`，Eclipse会发出警告，告诉开发者去定义`serialVersionUID`属性 。在Eclipse中点击类中warning的图标一下，Eclipse就会自动给定两种生成的方式。如果不想定义它，在Eclipse的设置中关掉该特性。

当实现`java.io.Serializable`接口的实体（类）没有显式地定义一个名为`serialVersionUID`的long型的变量，Java序列化机制会根据编译的class（它通过类名，方法名等诸多因素经过计算而得，理论上是一一映射的关系，也就是唯一的）自动生成一个`serialVersionUID`作为序列化版本比较用。这种情况下，如果class文件（类名，方法明等）没有发生变化（增加空格、换行或增加注释等等），就算再编译多少次，`serialVersionUID`也是不会变化的。

# Java中对象的序列化和反序列化的代码范例

```java
package com.bat.testmaven;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

class Employee implements java.io.Serializable {
    public String name;
    public String address;
    public transient int SSN;
    public int number;

    public void mailCheck() {
        System.out.println("Mailing a check to " + name + " " + address);
    }
}

public class SerializeDeserializeDemo {
    public static void main(String[] args) {
        doSerializeObject();    //执行序列化操作
        doDeserializeObject();  //执行反序列化操作
    }


    /**
     * 将Employee对象序列化到D:\\workbench\\employee.ser文件中
     */
    public static void doSerializeObject() {
        Employee e = new Employee();
        e.name = "laotansuancai";
        e.address = "Beijing, China";
        e.SSN = 213219;
        e.number = 7304;
        try {
            FileOutputStream fileOut = new FileOutputStream("D:\\workbench\\employee.ser");
            ObjectOutputStream out = new ObjectOutputStream(fileOut);
            out.writeObject(e);
            out.close();
            fileOut.close();
            System.out.printf("Serialized data is saved in D:\\workbench\\employee.ser");
        } catch (IOException i) {
            i.printStackTrace();
        }
    }

    /**
     * 将D:\\workbench\\employee.ser文件中对象进行反序列化
     */
    public static void doDeserializeObject() {
        Employee e = null;
        try {
            FileInputStream fileIn = new FileInputStream("D:\\workbench\\employee.ser");
            ObjectInputStream in = new ObjectInputStream(fileIn);
            e = (Employee) in.readObject();
            in.close();
            fileIn.close();
        } catch (IOException i) {
            i.printStackTrace();
            return;
        } catch (ClassNotFoundException c) {
            System.out.println("Employee class not found");
            c.printStackTrace();
            return;
        }
        System.out.println("Deserialized Employee...");
        System.out.println("Name: " + e.name);
        System.out.println("Address: " + e.address);
        System.out.println("SSN: " + e.SSN);
        System.out.println("Number: " + e.number);
    }
}
```

备注：当对象被序列化时，属性SSN的值为213219，但是因为该属性是短暂的（transient），该值没有被发送到输出流。所以反序列化后Employee对象的SSN属性为0。