--- 
categories: php
tags: php, extension, internal
wordpress_id: 285
layout: post
wordpress_url: http://www.zhangabc.com/?p=285
date: 2010-11-15 11:21:11 +08:00
title: !binary |
  UEhQ5omp5bGV5Lit6Ieq5a6a5LmJ5Ye95pWw6L+U5Zue5YC85LiOWlZBTA==

---
如要在PHP扩展中返回一个整数，那是相当的容易滴：<!--more-->
    PHP_FUNCTION(rv_long)
    {
        RETURN_LONG(9999);
    }
也可以写成这样子：

    PHP_FUNCTION(rv_long)
    {
        RETVAL_LONG(9999);
        return;
    }
还可以写成这样子：
PHP_FUNCTION(rv_long)
{
    Z_TYPE_P(return_value) = IS_LONG;
    Z_LVAL_P(return_value) = 9999;
    return;
}

方法看起来很多么……其实是同一种方法的“渐进版”。

如下图：
![php_zend_return^_^]( http://zhangabc.my.phpcloud.com/wp-content/uploads/2010/11/return_value.png)

OK,本质是搞了个叫returen_value的zval,……至于zval , 是PHP的C源代码级别的最核心的结构。

PHP所有类型的变量都是以zval这个结构体来存储。PHP在源代码级别提供了大量用于操作zval变量的宏。

上面是整数的例子，其他类型也类似：
    ZVAL_NULL(return_value)
    RETVAL_NULL()

    ZVAL_BOOL(return_value, bval)
    RETVAL_BOOL(bval)

    ZVAL_TRUE(return_value)
    RETVAL_TRUE

    ZVAL_FALSE(return_value)
    RETVAL_FALSE

    ZVAL_LONG(return_value, lval)
    RETVAL_LONG(lval)

    ZVAL_DOUBLE(return_value, dval)
    RETVAL_DOUBLE(dval)

    ZVAL_STRING(return_value, str, dup)
    RETVAL_STRING(str, dup)

    ZVAL_STRINGL(return_value, str, len, dup)
    RETVAL_STRINGL(str,len,dup)

    ZVAL_RESOURCE(return_value, rval)
    RETVAL_RESOURCE(rval)

不过，引用和数组还是稍有不同的……（未完不续）




