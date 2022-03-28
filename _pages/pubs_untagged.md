---
title: "LIQ - Untagged publications"
layout: gridlay
excerpt: "Untagged publications"
sitemap: false
permalink: /pubs_untagged/
---



# Untagged publications

Group publications missing all or a specific tag. This is nearly the opposite
of what the main [publications page]({{ site.url }}{{ site.baseurl
}}/publications/) shows. It is meant to help identify papers that haven't
been tagged yet or haven't been included in a topic they should be included
in.

The tags used are the following:

<table>
{% for t in site.data.pubtopics %}
<tr>
  <td style="font-family:'Lucida Console', monospace; font-size:10;">{{ t.tag }}</td>
  <td>&nbsp;:&nbsp;&nbsp;</td>
  <td>{{ t.title }}</td>
</tr>
{% endfor %}
</table><br />

The tabs below show publications that haven't been marked with the
corresponding tag. The tab "Untabbed" shows papers that either don't have any
of the above tags or are missing the "tag" attribute in the BibTeX entirely.

<br>

<script src="{{ site.url }}{{ site.baseurl }}/js/pubgroup.js"></script>

<link rel="stylesheet" href="{{ "/css/pubtabs.css" | prepend: site.baseurl | prepend: site.url }}">

<!-- Tab links -->
<div class="tab">
  <button class="tablinks active" onclick="pubgroup(event, 'all')">Untagged</button>
  {% for t in site.data.pubtopics %}{% if t.tag %}<button class="tablinks" onclick="pubgroup(event, '{{ t.tag }}')">{{ t.title }}</button>{% endif %}{% endfor %}
</div>

<!-- Tab content -->
<div id="all" class="tabcontent">
  {% assign untagged_query = "" | split: "," %}
  {% for topic in site.data.pubtopics %}
    {% assign tags = topic.tag | split: "," %}
    {% for tag in tags %}
      {% assign exclude_tag = tag | prepend: "tag!~" %}
      {% assign untagged_query = untagged_query | push: exclude_tag %}
    {% endfor %}
  {% endfor %}
  {% assign untagged_query = untagged_query | join: " && " %}
  {% bibliography --query @*[{{ untagged_query }}] %}
</div>

{% for topic in site.data.pubtopics %}
{% if topic.tag %}
<div id="{{ topic.tag }}" class="tabcontent">
  {% assign tag_queries = "" | split: "," %}
  {% assign tags = topic.tag | split: "," %}
  {% for tag in tags %}
    {% assign tagq = tag | prepend: "tag!~" %}
    {% assign tag_queries = tag_queries | push: tagq %}
  {% endfor %}
  {% assign tag_query = tag_queries | join: " && " %}
  {% bibliography --query @*[{{ tag_query }}] %}
</div>
{% endif %}
{% endfor %}

<script>document.getElementById("all").style.display = "block";</script>
