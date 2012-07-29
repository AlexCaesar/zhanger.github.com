---
layout: page
title: Hello World!
tagline:
---
{% include JB/setup %}

<!--
![n_n](http://pemsys.duapp.com/blog/b1.png)
-->
<div class="section">
  {% for post in site.posts  offset : 0 limit :1%}
  <div class="page-header">
    <h1><a href="{{ post.url }}">{{ post.title }}</a> <small>{{ post.tagline }}</small></h1>
  </div>
  <div class="span8">

    <!-- <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>  -->
    {{post.content}}

    <div class="pagination">
      <ul>
      {% if post.previous %}
        <li class="prev"><a href="{{ BASE_PATH }}{{ post.previous.url }}" title="{{ post.previous.title }}">&larr; Previous</a></li>
      {% else %}
        <li class="prev disabled"><a>&larr; Previous</a></li>
      {% endif %}
        <li><a href="{{ BASE_PATH }}{{ site.JB.archive_path }}">Archive</a></li>
      {% if page.next %}
        <li class="next"><a href="{{ BASE_PATH }}{{ post.next.url }}" title="{{ post.next.title }}">Next &rarr;</a></li>
      {% else %}
        <li class="next disabled"><a>Next &rarr;</a>
      {% endif %}
      </ul>
    </div>

    </div>
  {% endfor %}


  <div class="span3">
<h2>Categories </h2>
<ul class="tag_box inline">
    {% assign categories_list = site.categories %}
    {% include JB/categories_list %}
</ul>


<h2>Tags</h2>
<ul class="tag_box inline">
  {% assign tags_list = site.tags %}  
  {% include JB/tags_list %}
</ul>

<!--
## To-Do

*   **iOS：Code highlight.......**
*   [深入理解PHP内核(Thinking In PHP Internal)](http://www.php-internal.com)
*   一点点把原来的笔记和感悟整理到这里。。。。恩，期限是 ～ **一万年** 
*   苦练SC2, 枪兵大叔～ 
*   通关大菠萝2
*   通关阿玛拉王国：惩罚
*   蛋疼时，美化一下博客 
-->
<h2>Friends</h2>
<ul class="tag_box inline friends ">
<li><a href="http://www.startfeel.com">FU体验馆</a></li>
<li><a href="http://www.son1c.cn" title="一个朋友的小站。">Son1c.cn</a></li>
<li><a href="http://www.reeze.cn">Zen Space</a></li>
<li><a href="http://www.artskin.cn" title="一个朋友的博客:)">前端思考</a></li>
<li><a href="http://www.lanbolee.com/blog" title="一很有喜感的同事的好玩的博客。">博之博</a></li>
<li><a href="http://xiezhenye.com/" title="神仙的仙居" target="_blank">神仙的仙居</a></li>
<li><a href="http://www.phppan.com" title="一个非常勤奋的小强！">胖子的空间</a></li>
<li><a href="http://www.laruence.com/" title="一只很帅的牛。">风雪之隅</a></li>
<li><a href="http://blog.eddie.com.tw/" title="爱玩又爱现的家伙，哈哈。">高見龍</a></li>
<li><a href="http://www.jack-y.com" title="帅锅。">Jack-Y</a></li>
</ul>
</div>
</div>