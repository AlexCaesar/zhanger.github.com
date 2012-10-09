---
layout: post
title: "由opcodes找到其处理函数的方法"
categories: php
tags: internal 
date: 2011-08-28 3:02:49 +08:00
published: true
summary: opcode to handler
---
{% include JB/setup %}
##Debug法：
在学习研究PHP内核的过程中，经常通过opcode来查看代码的执行顺序，这些opcode会存储于一个数组op_array中，然后在zend_vm_execute.h中的execute函数中使用以下代码来依次执行：

{% highlight c %}
     ZEND_API void execute(zend_op_array *op_array TSRMLS_DC)
     {
     ...
     zend_vm_enter:
     ....
     if ((ret = EX(opline)->handler(execute_data TSRMLS_CC)) > 0) {
                 switch (ret) {
                     case 1:
                         EG(in_execution) = original_in_execution;
                         return;
                     case 2:
                         op_array = EG(active_op_array);
                         goto zend_vm_enter;
                     case 3:
                         execute_data = EG(current_execute_data);
                     default:
                         break;
                 }
     ｝
        ...
     }
{% endhighlight  %}


在执行的过程中，EX(opline)->handler（展开后为 *execute_data->opline->handler）存储了处理当前操作的函数名称。如果这时在gdb中 用p命令，就可以打印出类似这样的结果：

{% highlight c %}
     (gdb) p *execute_data->opline->handler
     $1 = {int (zend_execute_data *)} 0x10041f394 <ZEND_NOP_SPEC_HANDLER>
{% endhighlight  %}
就可以知道当前要执行的处理函数了，这种是debug的方法。

##计算法：
那么，在PHP内核中是如何将一个opcode转化为函数的呢？ 在PHP内部是使用zend_vm_get_opcode_handler()函数来进行转化的。

{% highlight c %}
     static opcode_handler_t
     zend_vm_get_opcode_handler(zend_uchar opcode, zend_op* op)
     {
             static const int zend_vm_decode[] = {
                 _UNUSED_CODE, /* 0              */
                 _CONST_CODE,  /* 1 = IS_CONST   */
                 _TMP_CODE,    /* 2 = IS_TMP_VAR */
                 _UNUSED_CODE, /* 3              */
                 _VAR_CODE,    /* 4 = IS_VAR     */
                 _UNUSED_CODE, /* 5              */
                 _UNUSED_CODE, /* 6              */
                 _UNUSED_CODE, /* 7              */
                 _UNUSED_CODE, /* 8 = IS_UNUSED  */
                 _UNUSED_CODE, /* 9              */
                 _UNUSED_CODE, /* 10             */
                 _UNUSED_CODE, /* 11             */
                 _UNUSED_CODE, /* 12             */
                 _UNUSED_CODE, /* 13             */
                 _UNUSED_CODE, /* 14             */
                 _UNUSED_CODE, /* 15             */
                 _CV_CODE      /* 16 = IS_CV     */
             };  
             return zend_opcode_handlers[
                  opcode * 25 + zend_vm_decode[op->op1.op_type] * 5
                          + zend_vm_decode[op->op2.op_type]];
                             }
{% endhighlight  %}
由上面的代码可以看到，opcode到php内部函数的转化是由下面的公式来进行的：

{% highlight c %}
 opcode * 25 + zend_vm_decode[op->op1.op_type] * 5
                 + zend_vm_decode[op->op2.op_type]
{% endhighlight  %}

然后将其计算的数值作为索引到zend_init_opcodes_handlers数组中进行查找。不过，这个数组实在是太大了，有3851个元素，查找和计算都比较麻烦。

##命名查找法：
上面的两种方法其实都是比较麻烦的，在定位某一opcode的实现执行代码的过程中，都不得不对程序进行执行或者计算中间值。而在追踪的过程中，我发现处理函数名称是有一定规则的。 这里以函数调用的opcode为例，调用某函数的opcode及其对应在php内核中实现的处理函数如下：

{% highlight c %}
     //函数调用：
     DO_FCALL  ==>  ZEND_DO_FCALL_SPEC_CONST_HANDLER

     //变量赋值：
     ASSIGN     =>      ZEND_ASSIGN_SPEC_VAR_CONST_HANDLER
                        ZEND_ASSIGN_SPEC_VAR_TMP_HANDLER
                        ZEND_ASSIGN_SPEC_VAR_VAR_HANDLER
                        ZEND_ASSIGN_SPEC_VAR_CV_HANDLER            
     //变量加法：
     ASSIGN_SUB =>   ZEND_ASSIGN_SUB_SPEC_VAR_CONST_HANDLER,
                         ZEND_ASSIGN_SUB_SPEC_VAR_TMP_HANDLER,
                         ZEND_ASSIGN_SUB_SPEC_VAR_VAR_HANDLER,
                         ZEND_ASSIGN_SUB_SPEC_VAR_UNUSED_HANDLER,
                         ZEND_ASSIGN_SUB_SPEC_VAR_CV_HANDLER,
                         ZEND_ASSIGN_SUB_SPEC_UNUSED_CONST_HANDLER,
                         ZEND_ASSIGN_SUB_SPEC_UNUSED_TMP_HANDLER,
                         ZEND_ASSIGN_SUB_SPEC_UNUSED_VAR_HANDLER,
                         ZEND_ASSIGN_SUB_SPEC_UNUSED_UNUSED_HANDLER,
                         ZEND_ASSIGN_SUB_SPEC_UNUSED_CV_HANDLER,
                         ZEND_ASSIGN_SUB_SPEC_CV_CONST_HANDLER,
                         ZEND_ASSIGN_SUB_SPEC_CV_TMP_HANDLER,
                         ZEND_ASSIGN_SUB_SPEC_CV_VAR_HANDLER,
                         ZEND_ASSIGN_SUB_SPEC_CV_UNUSED_HANDLER,
                         ZEND_ASSIGN_SUB_SPEC_CV_CV_HANDLER,
{% endhighlight  %}
在上面的命名就会发现，其实处理函数的命名是有以下规律的：

{% highlight c %}
   ZEND_[opcode]_SPEC_(变量类型1)_(变量类型2)_HANDLER
{% endhighlight  %}
这里的变量类型1和变量类型2是可选的，如果同时存在，那就是左值和右值，归纳有下几类： VAR TMP CV UNUSED CONST 可以根据相关的执行场景来判定。

##LOG记录法：
这种方法是上面计算方法的的升级，就是在zend_vm_get_opcode_handler 方法改写为以下代码：

{% highlight c %}
     static opcode_handler_t
     zend_vm_get_opcode_handler(zend_uchar opcode, zend_op* op)
     {
             static const int zend_vm_decode[] = {
                 _UNUSED_CODE, /* 0              */
                 _CONST_CODE,  /* 1 = IS_CONST   */
                 _TMP_CODE,    /* 2 = IS_TMP_VAR */
                 _UNUSED_CODE, /* 3              */
                 _VAR_CODE,    /* 4 = IS_VAR     */
                 _UNUSED_CODE, /* 5              */
                 _UNUSED_CODE, /* 6              */
                 _UNUSED_CODE, /* 7              */
                 _UNUSED_CODE, /* 8 = IS_UNUSED  */
                 _UNUSED_CODE, /* 9              */
                 _UNUSED_CODE, /* 10             */
                 _UNUSED_CODE, /* 11             */
                 _UNUSED_CODE, /* 12             */
                 _UNUSED_CODE, /* 13             */
                 _UNUSED_CODE, /* 14             */
                 _UNUSED_CODE, /* 15             */
                 _CV_CODE      /* 16 = IS_CV     */
             };  

             //很显然，我们把opcode和相对应的写到了/tmp/php.log文件中
             int op_index;
             op_index = opcode * 25 + zend_vm_decode[op->op1.op_type] * 5 + zend_vm_decode[op->op2.op_type];

             FILE *stream;
             if((stream = fopen("/tmp/php.log", "a+")) != NULL){
                 fprintf(stream, "opcode: %d , zend_opcode_handlers_index:%d\n", opcode, op_index);
             }    
             fclose(stream);


             return zend_opcode_handlers[
                  opcode * 25 + zend_vm_decode[op->op1.op_type] * 5
                          + zend_vm_decode[op->op2.op_type]];
                             }
{% endhighlight  %}
然后，就可以在/tmp/php.log文件中生成类似如下结果:

{% highlight c %}
    opcode: 38 , zend_opcode_handlers_index:970
{% endhighlight  %}

数字38是opcode的，我们可以这里查到： http://php.net/manual/en/internals2.opcodes.list.php
数字970是topcode_handler_t labels[] 索引，里面对应了处理函数的名称，对应源码文件是：Zend/zend_vm_execute.h （第30077行左右）。 这是一个超大的数组，php5.3.4中有3851个元素，在上面的例子里，看样子我们要数到第970个了，当然，有很多种方法来避免这种无意义的重劳动，你懂的。

经过鸟哥（@laruence)的提醒，本文仅适合于ZendVM分发方式为CALL的情形。
