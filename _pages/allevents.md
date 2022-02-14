---
title: "LIQ - Events"
layout: textlay
excerpt: "Events"
sitemap: false
permalink: /allevents.html
---

# Events and seminars

{% for article in site.data.events %}

<p>{{ article.date }}</p>

<p style="margin-left: 40px">
<i>
{% if article.url %}
<a href="{{ article.url }}">{{ article.title }}</a>
{% else %}
{{ article.title }}
{% endif %}
</i>
<br />
{{ article.author }}
</p>

{% if article.abstract %}
<p style="margin-left: 40px">
{{ article.abstract | newline_to_br }}
</p>
{% endif %}

{% endfor %}
