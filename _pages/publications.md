---
title: "LIQ - Publications"
layout: gridlay
excerpt: "Publications"
sitemap: false
permalink: /publications/
---


# Publications

Our group's publications can also be found on [Google Scholar](https://scholar.google.be/citations?hl=en&user=vtzT0VAAAAAJ&view_op=list_works&sortby=pubdate).

{% bibliography %}



# Generated using liquid

<!-- Get a unique array of publication years -->
{% assign years = "" | split: ',' %}
{% for pub in site.data.publist %}
  {% assign years = years | push: pub.year %}
{% endfor %}
{% assign years = years | rsort | uniq %}



{% for year in years %}

## {{ year }}

<div class="col-sm-12 clearfix">

{% for p in site.data.publist %}

{% if p.year == year %}

  <em>{{ p.title }}</em> <br />
  {{ p.authors }} <br />
  {% if p.journal %}<a href="https://doi.org/{{ p.journal.doi }}">{{ p.journal.name }} <b>{{ p.journal.volume }}</b>, {{ p.journal.pages }}</a>; {% endif %}<a href="https://arxiv.org/abs/{{ p.arxiv.eprint }}">arXiv:{{ p.arxiv.eprint}} [{{ p.arxiv.class }}]</a>

{% endif %}

{% endfor %}

</div>

{% endfor %}
