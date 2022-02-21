---
title: "LIQ - Publications"
layout: gridlay
excerpt: "Publications"
sitemap: false
permalink: /publications/
---


# Publications

(Also on [Google Scholar](https://scholar.google.be/citations?hl=en&user=vtzT0VAAAAAJ&view_op=list_works&sortby=pubdate).)

{% for publi in site.data.publist %}

  <em>{{ publi.title }}</em> <br />
  {{ publi.authors }} <br />
  <a href="{{ publi.link.url }}">{{ publi.link.display }}</a>

{% endfor %}
