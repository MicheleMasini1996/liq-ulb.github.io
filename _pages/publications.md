---
title: "LIQ - Publications"
layout: gridlay
excerpt: "Publications"
sitemap: false
permalink: /publications/
---



# Publications

Our group's publications can also be found on [Google Scholar](https://scholar.google.be/citations?hl=en&user=vtzT0VAAAAAJ&view_op=list_works&sortby=pubdate).

<script src="{{ site.url }}{{ site.baseurl }}/js/pubgroup.js"></script>

<link rel="stylesheet" href="{{ "/css/pubtabs.css" | prepend: site.baseurl | prepend: site.url }}">

<!-- Tab links -->
<div class="tab">
  <button class="tablinks active" onclick="pubgroup(event, 'all')">All</button>
  {% for t in site.data.pubtopics %}{% if t.tag %}{% assign tag = t.tag %}{% else %}{% assign tag = t.class %}{% endif %}<button class="tablinks" onclick="pubgroup(event, '{{ tag }}')">{{ t.title }}</button>{% endfor %}
</div>

<!-- Tab content -->
<div id="all" class="tabcontent">
  {% bibliography %}
</div>

{% for topic in site.data.pubtopics %}
{% if topic.tag %}
<div id="{{ topic.tag }}" class="tabcontent">
  {% assign tag_queries = "" | split: "," %}
  {% assign tags = topic.tag | split: "," %}
  {% for tag in tags %}
    {% assign tagq = tag | prepend: "tag~=" %}
    {% assign tag_queries = tag_queries | push: tagq %}
  {% endfor %}
  {% assign tag_query = tag_queries | join: " || " %}
  {% bibliography --query @*[{{ tag_query }}] %}
</div>
{% endif %}
{% endfor %}

<script>document.getElementById("all").style.display = "block";</script>
