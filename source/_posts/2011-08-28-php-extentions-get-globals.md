--- 
categories: php
tags: internal 
layout: post
date: 2011-08-28 3:02:49 +08:00
title: "[PHP扩展]获取$_SERVER变量的问题及解决"

---
{% include JB/setup %}
##背景
本文适用于希望在PHP扩展中获取到 $_SERVER/$_POST/$_GET/$_REQUEST/..的情形。

##经过
想在PHP扩展中获取$_SERVER['SCRIPT_FILENAME']，于是有如下代码：

{% highlight c %}
    PHP_FUNCTION(xx_get_path)
    {   
        HashTable *_SERVER;
        zval **stuff;
        char *path_info;

        _SERVER = Z_ARRVAL_P(PG(http_globals)[TRACK_VARS_SERVER]);
         if (SUCCESS == zend_hash_find(_SERVER, 
             "SCRIPT_FILENAME", sizeof("SCRIPT_FILENAME"), 
              (void **) &stuff)) {
             path_info = Z_STRVAL_PP(stuff);
             RETVAL_STRING(path_info, 1); 
         }   

    }   
{% endhighlight %}

##出现问题
在PHP中我这样使用这样的代码来调用：

{% highlight php %}
    <?php 
    echo xx_get_path();
    ?>  
{% endhighlight %}

结果 ：在浏览器中访问时，Apache报：child pid 52540 exit signal Segmentation fault (11)
在cli中，直接php index.php是正常的。
而且，如果改成这样子，浏览器中也正常了。

{% highlight php %}
    <?php 
    $_SERVER;   //这可也可以放到最后; 
    echo xx_get_path();
    ?>  
{% endhighlight %}


##分析
这里最让人费解就是在PHP代码中放一个$_SERVER; 就好了，很显然是这变量发生了什么 。。。。
没错，就是它，经过TIPI讨论组数秒的讨论，找到了这个：
http://www.php.net/manual/en/ini.core.php#ini.register-globals
原来_SERVER系列变量是可以访问时才生成了，于是在扩展中直接zend_hash_find就找不到了。

##解决办法
既然原因是没有自动注册_SERVER ，于是可以加以下代码暴力注册之。

{% highlight c %}
    zend_bool jit_init = (PG(auto_globals_jit) && !PG(register_globals) && 
                    !PG(register_long_arrays));
    if (jit_init) { 
        zend_is_auto_global(ZEND_STRL("_SERVER") TSRMLS_CC);
    }   
{% endhighlight %}

##附：另一种方法
还有另一种方法来获取$_SERVER['SCRIPT_NAME'],原理大同小异，不解释:

{% highlight c %}
    PHP_FUNCTION(peblog_get_html)
    {   

        zval **SERVER   = NULL;
        zval **ret      = NULL;


       zend_bool jit_init = (PG(auto_globals_jit) && !PG(register_globals) 
                         && !PG(register_long_arrays));
        if (jit_init) { 
            zend_is_auto_global(ZEND_STRL("_SERVER") TSRMLS_CC);
        }   

        (void)zend_hash_find(&EG(symbol_table), 
                     ZEND_STRS("_SERVER"), (void **)&SERVER);
        if (zend_hash_find(Z_ARRVAL_PP(SERVER), 
               ZEND_STRS("SCRIPT_FILENAME"),
                (void **)&ret) == FAILURE )
        {
            RETVAL_STRING("No SCRIPT_FILENAME. ", 1);
        }
        else
        {
            char *str = NULL;
            str     = estrdup(Z_STRVAL_P(*ret));

            RETVAL_STRING(str, 1);
        }
    }

{% endhighlight %}
