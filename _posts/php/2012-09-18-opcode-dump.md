--- 
categories: php
tags: internal 
layout: post
date: 2011-08-28 3:02:49 +08:00
title: "自动查找opcodes的处理函数"

---
{% include JB/setup %}

#打印出opcode的处理函数

一年前写了[由opcodes找到其处理函数的方法](http://zhangabc.com/2011/08/27/find-opcodes-to-implements/), 然后很长一段时间之内，
都使用vld输出opcodes，再去人肉寻找其处理函数。

后来，发现对于opcodes, 很多人都实现了输出，但对于opcode的处理函数，则没有关注;

而我们在分析PHP脚本代码到opcodes，再到具体的C实现的过程，opcode的处理是比较重要的一个环节；

于是升级了鸟哥的opcode dumper，对opcode handler进行了输出：

如图：
![小截图](http://ww3.sinaimg.cn/large/a74ecc4cjw1dwzbmmlzi9j.jpg)


实现原理，使用opcode -> opcode_handler的转化公式进行转化，(只支持CALL的分发方式):

{% highlight c %}
    code * 25 + zend_vm_decode[op->op1.op_type] * 5 + zend_vm_decode[op->op2.op_type];
{% endhighlight  %}

看了前面的 [由opcodes找到其处理函数的方法](http://zhangabc.com/2011/08/27/find-opcodes-to-implements/), 比较容易就能在zend_init_opcodes_handlers数组中遍历到需要导出的函数名。


升级后已经push request到鸟哥的github: https://github.com/laruence/opcodesdumper


#关于构建

鸟哥使用比较“高级”的autotools来自动构建，不过我认为这么一个小工具，Makefile足够了。
于是还有一个Makefile版本：

https://github.com/zhanger/opcodesdumper

#TODO 
<!--
目前处理函数的查找还要依赖外部的文本文件 opcodes_handlers_php5_310 , 需要添加其他版本的处理函数文本，
同时，代码要实现对PHP版本的自动检测 
-->


