---
layout: page
title: Hello World!
tagline: I Love U.
---
{% include JB/setup %}

![n_n](http://pemsys.duapp.com/blog/b1.png)

<!--
<ul class="posts">
  {% for post in site.posts %}
    <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>
-->
## Categories
<ul class="tag_box inline categories">
    {% assign categories_list = site.categories %}
    {% include JB/categories_list %}
</ul>

## Tags
<ul class="tag_box inline">
  {% assign tags_list = site.tags %}  
  {% include JB/tags_list %}
</ul>

## To-Do

*   一点点把原来的笔记和感悟整理到这里。。。。恩，期限是 ～ **1万年** 。

## Friends
<ul class="tag_box inline friends ">
<li><a href="http://www.startfeel.com">FU体验馆</a></li>
<li><a href="http://www.son1c.cn" title="一个朋友的小站。">Son1c.cn</a></li>
<li><a href="http://www.reeze.cn">Zen Space</a></li>
<li><a href="http://www.artskin.cn" title="一个朋友的博客:)">前端思考</a></li>
<li><a href="http://www.lanbolee.com/blog" title="一很有喜感的同事的好玩的博客。">博之博</a></li>
<li><a href="http://www.leivli.com" title="LeiVli’s Blog">技术&amp;生活</a></li>
<li><a href="http://xiezhenye.com/" title="神仙的仙居" target="_blank">神仙的仙居</a></li>
<li><a href="http://www.phppan.com" title="一个非常勤奋的小强！">胖子的空间</a></li>
<li><a href="http://www.laruence.com/" title="一只很帅的牛。">风雪之隅</a></li>
<li><a href="http://blog.eddie.com.tw/" title="一只很帅的牛。">高見龍</a></li>
</ul>
