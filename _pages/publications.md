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

{% for t in site.data.pubtopics %}
{% if t.tag %}
{% assign tag = t.tag %}
{% else %}
{% assign tag = t.class %}
{% endif %}
<div id="{{ tag }}" class="tabcontent">
  {% if t.tag %}
  {% bibliography --query @*[tag~={{ t.tag }}]* %}
  {% else %}
  {% bibliography --query @*[primaryclass^={{ t.class }} || eprint^={{ t.class }}]* %}
  {% endif %}
</div>
{% endfor %}

<script>document.getElementById("all").style.display = "block";</script>
