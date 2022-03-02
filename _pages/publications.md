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
{% bibliography -f %}



# Generated using liquid


<script>function pubgroup(evt, group) {
  // Declare all variables
  var i, tabcontent, tablinks;

  // Get all elements with class="tabcontent" and hide them
  tabcontent = document.getElementsByClassName("tabcontent");
  for (i = 0; i < tabcontent.length; i++) {
    tabcontent[i].style.display = "none";
  }

  // Get all elements with class="tablinks" and remove the class "active"
  tablinks = document.getElementsByClassName("tablinks");
  for (i = 0; i < tablinks.length; i++) {
    tablinks[i].className = tablinks[i].className.replace(" active", "");
  }

  // Show the current tab, and add an "active" class to the button that opened the tab
  document.getElementById(group).style.display = "block";
  evt.currentTarget.className += " active";
}</script>

<style>
/* Style the tab */
.tab {
  overflow: hidden;
  border: 1px solid #ccc;
  background-color: #f1f1f1;
}

/* Style the buttons that are used to open the tab content */
.tab button {
  background-color: inherit;
  float: left;
  border: none;
  outline: none;
  cursor: pointer;
  padding: 10px 20px;
  transition: 0.3s;
}

/* Change background color of buttons on hover */
.tab button:hover {
  background-color: #ddd;
}

/* Create an active/current tablink class */
.tab button.active {
  background-color: #ccc;
}

/* Style the tab content */
.tabcontent {
  display: none;
  padding: 6px 12px;
  border: 1px solid #ccc;
  border-top: none;
}
</style>

<!-- Tab links -->
<div class="tab">
  <button class="tablinks active" onclick="pubgroup(event, 'years')">By Year</button>
  <button class="tablinks" onclick="pubgroup(event, 'topics')">By Topic</button>
</div>

<!-- Tab content -->
<div id="years" class="tabcontent">
<!-- Get a unique array of publication years -->
{% assign years = "" | split: ',' %}
{% for pub in site.data.publist %}
  {% assign years = years | push: pub.year %}
{% endfor %}
{% assign years = years | rsort | uniq %}



{% for year in years %}

## {{ year }}

{% for p in site.data.publist %}

{% if p.year == year %}

  <p style="margin-left:3ex"><em>{{ p.title }}</em> <br />
  {{ p.authors }} <br />
  {% if p.journal %}<a href="https://doi.org/{{ p.journal.doi }}">{{ p.journal.name }} <b>{{ p.journal.volume }}</b>, {{ p.journal.pages }}</a>; {% endif %}<a href="https://arxiv.org/abs/{{ p.arxiv.eprint }}">arXiv:{{ p.arxiv.eprint}} [{{ p.arxiv.class }}]</a></p>

{% endif %}

{% endfor %}

{% endfor %}
</div>

<div id="topics" class="tabcontent">
(publications grouped by topic here)
</div>

<script>document.getElementById("years").style.display = "block";</script>
