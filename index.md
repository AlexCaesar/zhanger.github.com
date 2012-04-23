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

将一点点把原来的笔记和感悟整理到这里。。。。恩，期限是 ～ **1万年** 。


