--- 
categories: php
tags: opcodes, internal
wordpress_id: 301
layout: post
wordpress_url: http://www.zhangabc.com/?p=301
date: 2010-11-23 15:11:49 +08:00
title: "从opcodes看{$a}与${a}的区别"

---
突然用到类似{$a}与${a}这样子的表达式，大约知道两者的区别，用OPCODE来做一个验证，记录如下:


### 程序一：
{% highlight php %}
<?php
    $a = 'abc';
    $abc = 'ok';
    echo ${abc};
?>
{% endhighlight %}
#### opcode ：(点击图片放大)
![php_zend_return^_^]( http://pemsys.duapp.com/blog/opcode_array_1.jpg)

### 程序二：

{% highlight php %}
<?php
$a = 'abc';
$abc = 'ok';
echo {$abc};
?>
{% endhighlight %}

#### opcode ：(点击图片放大)
![php_zend_return^_^]( http://pemsys.duapp.com/blog/opcode_array_2.jpg)

### 程序一 ${abc} 解释：
ASSIGN 就是赋值，所以第一二步，都是赋值的操作，关键是第三步的 FETCH_CONSTANT 。
FETCH_CONSTANT 是在所有的常量中寻找abc 这个变量(当然没找到)，然后将abc赋值给临时变量~2
然后FETCH_R取到~2变量名的值，ECHO输出；

### 程序二 {$abc} 解释：
减少了FETCH_CONSTANT的步骤，多了ADD_VAR,这是一个赋值语句。
由于使用了“{$abc}” 语法，需要另一个临时变量来存储结果。

### 结论：

${abc} 会先去常量中寻求abc，如果有值则替代之，没有，则进行与{$abc}相同的操作；

{$abc} 与 $abc 相同；
