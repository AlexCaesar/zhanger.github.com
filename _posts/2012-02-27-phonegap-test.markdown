--- 
categories: mobile
tags: app, phonegap, android
wordpress_id: 752
layout: post
wordpress_url: http://www.zhangabc.com/?p=752
date: 2012-02-27 17:50:50 +08:00
title:  Phonegap超级浅尝
tagline: Hello Word!

---
前阵子听 [@leiyi同学](http://www.startfeel.com/) 聊到可以用PhoneGap来搞移动应用，回家做了功课，发现这货相当强大，可以使用HTML+JS+CSS来写出适用于ios/andorid/...等等平台的应用，正如它网站的宣传图：

![官方广告^_^](http://pemsys.duapp.com/blog/phonegap-test.png)


然后我决定试用一下，费了18牛72虎之力终于下好了种种SDK（唉，家里的风速跟公司真是天上地下）… 最后小试了一把“Hello World”。

实现相当简单，跟着官方的 [Get Started Guide](http://phonegap.com/start) 基本上完全不用太用力就可以在模拟器中完成。顺手记一句解决中文乱码问题…跟普通网页一样，文件编码与声明一致就OK。

接着去看phonGap的官方API，看了一些特效以及功能的实现，记几个想法：

* 跨平台很帅，基本上真的做到了为一个平台编写应用，代码基本不更改的情况下搬到其他平台去。而代价就是显示效果和功能的削弱，ios可以做到1、3、5、7 ， android可以做到2、3、4、5 ， 那么phoneGap就只能做到3、5 ;

* 可以用js来控制界面元素，添加事件，调用资源; 相信这点一定吸引了很多人，不过，其实用java 也是一样，其实学习一种新的语法可能并不困难，而且有时新手开跑车，还真不一定就慢过职业自行车手，所以感觉与其用C基础上的JAVA中虚拟出来的JS环境来做这些事情，还真不如脱去一层，直接用JAVA语法来搞;

* 用CSS来进行界面布局很爽，不得不说，这个爽是来自于学习成本的降低，原生的布局方式是需要学习和理解的，其实花点时间学习和理解一下之后，同样可以搞掂，很可能还而且会更好，原因同上;

最后，如果只是写一个信息类的，或者展示类的东东，又灰常熟悉js/css, 完全对java无爱，phoneGap 的确是一把利器; 但如果你写的东西，你还打算随着时间的推移而不断维护，同时又勇于学些新的东东，还是用java写android,用object-C写ios吧。。。
