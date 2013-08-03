---
layout: post
title: "Autolayout in iOS"
tagline: "使用autolayout来绘制iOS视图"
description: ""
category: "mobile"
tags:  objective-c 
---


##Autolayout的优势
在autolayout之前，一般会使用frame来定位视图中的元素。

> frame是决定视图位置与宽高的属性，其值为CGRect对象, 可以用下面的方法来定义。
> CGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)


CGRect对象定义中的四个参数为 横坐标、纵坐标、宽、高。
把CGRect对象赋值并设置到UIView的frame属性，就可以实现视图的大小及位置的定义。
理论上这种方法是可以解决所有的问题，不过在实际操作中，有两种情况使用frame是非常不方便的：

   1. 设备翻转需要视图位置做出相应的调整；
   2. 可能发生内部元素位置变化的复用视图，如下图中的tableViewCell
   
![列表](http://farm6.staticflickr.com/5347/9431737148_10e116c3bf_o.png)

上面这两种情形出现时，一般要写大量的定位计算代码，而且升级比较麻烦，于是出现了Autolayout来改善frame计算工作过繁重的问题；


##Autolayout原理    
![UIView](https://developer.apple.com/library/ios/documentation/WindowsViews/Conceptual/ViewPG_iPhoneOS/Art/windowlayers.jpg)
【图片来自developer.apple.com】

iOS的视图是用tree来组织的，每个视图都有其父视图，根节点为Window对象。
这样就可以把相对关系划分在一定范围内，同时使用父子、兄弟的关系来组织视图。

##使用Autolayout 
Autolayout的使用是比较方便的，主要是生成NSLayoutConstraint对象，然后把constraint加到父视图就可以了。
###例一
![demo1](http://farm6.staticflickr.com/5444/9429251493_8a9958c5b1_o.png)

当设备进行翻转时，方块的位置和大小随之发生了变化，而这种变化，如果使用frame来进行计算的话，相对比较麻烦；而使用autolayout,代码要简单一些：
{% codeblock %}UIView * A = [[UIView alloc] init];
    UIView * B = [[UIView alloc] init];
    A.translatesAutoresizingMaskIntoConstraints = NO;
    B.translatesAutoresizingMaskIntoConstraints = NO;
    A.backgroundColor =[UIColor purpleColor];
    B.backgroundColor =[UIColor orangeColor];
    [self.view addSubview:A];
    [self.view addSubview:B];
    
    UIView * rootView = self.view;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(A, B, rootView);
    NSArray *verticalConstraints   = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[A(80)]-10-[B(80)]"
                                                                             options:0 metrics:nil
                                                                               views:viewsDictionary];
    NSArray *horizontalAConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[A]-10-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewsDictionary];
    NSArray *horizontalBConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[B]-10-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewsDictionary];
    
    [self.view addConstraints:verticalConstraints];
    [self.view addConstraints:horizontalAConstraints];
    [self.view addConstraints:horizontalBConstraints];{% endcodeblock %}
    
    
#to be continue…