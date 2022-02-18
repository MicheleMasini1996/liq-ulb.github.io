---
title: "LIQ - Events"
layout: textlay
excerpt: "Events"
sitemap: false
permalink: /allevents.html
---

# Events and seminars

<iframe src="https://calendar.google.com/calendar/embed?height=600&wkst=2&bgcolor=%23ffffff&ctz=Europe%2FBrussels&showNav=1&showTitle=0&showDate=1&showPrint=0&showTabs=1&showCalendars=0&showTz=1&mode=AGENDA&src=bnUwdjNyaDBtdDdhOWd0cjgwdDQyMmpobDBAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ&src=dHQ0ZmVjbmJkY2Q1ZWpmZjNqczkyc2VpN29AZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ&color=%234285F4&color=%234285F4" style="border-width:0" width="800" height="600" frameborder="0" scrolling="no"></iframe>

{% for article in site.data.events %}

<p>{{ article.date }}{% if article.time %}, {{ article.time }}{% endif %}</p>

<p style="margin-left: 40px">
{% if article.title %}
<i>
{% assign title = article.title %}
{% else %}
{% assign title = "TBA" %}
{% endif %}
{% if article.url %}
<a href="{{ article.url }}">{{ title }}</a>
{% else %}
{{ title }}
{% endif %}
{% if article.title %}
</i>
{% endif %}
<br />
{{ article.author }}
</p>

{% if article.abstract %}
<p style="margin-left: 40px">
{{ article.abstract | newline_to_br }}
</p>
{% endif %}

{% endfor %}
