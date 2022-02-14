---
title: "LIQ - Publications"
layout: gridlay
excerpt: "Publications"
sitemap: false
permalink: /publications/
---


# Recent Publications

{% for publi in site.data.publist %}

  <em>{{ publi.title }}</em> <br />
  {{ publi.authors }} <br />
  <a href="{{ publi.link.url }}">{{ publi.link.display }}</a>

{% endfor %}
