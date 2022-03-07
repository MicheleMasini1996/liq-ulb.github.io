---
title: "LIQ - Team"
layout: gridlay
excerpt: "Team members"
sitemap: false
permalink: /team/
---



# Group Members



{% for role in site.data.team_roles %}

## {{ role.title }}

{% assign number_printed = 0 %}

{% for member in site.data.team %}

{% if role.role == member.role %}

{% assign even_odd = number_printed | modulo: 2 %}

{% if even_odd == 0 %}
<div class="row">
{% endif %}

<div class="col-sm-6 clearfix">
  <img src="{{ site.url }}{{ site.baseurl }}/images/team/{{ member.photo }}" class="img-responsive" width="25%" style="float: left" />
  <h4>{{ member.name }}</h4>
  {%if member.info %}<i>{{ member.info }}</i><br />{% endif %}
  {%if member.page %}<a href="{{ site.url }}{{ site.baseurl }}/{{ member.page }}/"><span class="fa-stack" style="vertical-align: top; width: 1.75em;"><i class="fas fa-square fa-stack-2x"></i><i class="fas fa-house fa-stack-1x fa-stack-inner fa-inverse"></i></span></a>{% endif %} {% if member.identifier %}<a href="mailto:{{ member.identifier }}@ulb.be"><i class="fas fa-envelope-square fa-2x"></i></a>{% endif %} {% if member.arxiv %}<a href="https://arxiv.org/a/{{ member.arxiv }}"><i class="ai ai-arxiv-square fa-2x"></i></a>{% endif %} {% if member.scholar %}<a href="https://scholar.google.com/citations?hl=en&user={{ member.scholar }}"><i class="ai ai-google-scholar-square fa-2x"></i></a>{% endif %} {% if member.github %}<a href="https://github.com/{{ member.github }}"><i class="fa-brands fa-github-square fa-2x"></i></a>{% endif %} {% if member.linkedin %}<a href="https://linkedin.com/in/{{ member.linkedin }}"><i class="fa-brands fa-linkedin fa-2x"></i></a>{% endif %}  {% if member.orcid %}<a href="https://orcid.org/{{ member.orcid }}"><i class="ai ai-orcid-square fa-2x"></i></a>{% endif %}
</div>

{% assign number_printed = number_printed | plus: 1 %}

{% if even_odd == 1 %}
</div>
{% endif %}

{% endif %}

{% endfor %}

{% assign even_odd = number_printed | modulo: 2 %}
{% if even_odd == 1 %}
</div>
{% endif %}

{% endfor %}



## Past members

<div class="row">

<div class="col-sm-6 clearfix">
{% for member in site.data.alumni %}
{{ member.name }} {% if member.info %}, {{ member.info }}{% endif %}
{% endfor %}
</div>

</div>
