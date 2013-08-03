--- 
categories: SHELL/ENV
tags: vim
layout: post
date: 2011-08-08 17:11:49 +08:00
title: "VIM中换行替换之迷"

---
{% include JB/setup %}
我们在shell下生成一个test文件：

    $ echo -e "i\rlove\rWQ." >test

然后，用vim打开，果然是 

    I^Mlove^MWQ. 

这时执行： :%s/\r/\r/g 发现文件正常了。
但是这里面有一个不正常，:%s/\r/\r/g 这个命令是把\r替换成了\r , 应该什么都没变化,怎么就把文件的换行符给替换了呢？

仔细检查了一下，发现这个问题还要从各个系统不同的换行符开始，下面的这个表格大家比较熟悉了：    

 | windows/dos | unix | mac
-|-|-|-
换行符  　　  | CRLF      |     LF |　　 CR
在SHELL中的表示 | \r\n  　 |      \n |　\r
16进制符    　　| 0d0a  　 |      0a | 　0d

:%s/\r/\r/g 这个命令中，第一个\r与第二个\r的意义是可能不相同的；
第一个\r代表 0d ,也就是CR；
而第二个\r，是VIM自行根据fileformat内置变量判断决定的，见下表：

　　　　　      |    　　　 \n  |　　 \r
----------------|---------------|---------------
:set ff=dos 　　|   　　　 00   | 　 0d0a(\n\r)
:set ff=unix 　 |   　　　 00   | 　 0a(\n)
:set ff=mac 　　|   　　　 00   | 　 0d(\r)

OK,现在就可以解释上面的 :%s/\r/\r/g 为什么会把 0d变成0a了。

另外还有两个小Tip:

 *  根据fileformat的不同，vim会自动在文件的最未尾添加一个换行符，除非启动时vim -b xxx , 同时还要开启 set noeol才行。
 *  任何情形下，VIM中的\n都是00, 在VIM中会显示为^@
