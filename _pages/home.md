---
title: "LIQ - Home"
layout: homelay
excerpt: "LIQ @ ULB."
sitemap: false
permalink: /
---

We are a research group at the [Université libre de Bruxelles](http://www.ulb.be), working on quantum information and bio-inspired information processing, both at the theoretical and experimental level.



<div markdown="0" id="carousel" class="carousel slide" data-ride="carousel" data-interval="4000" data-pause="hover">
  <!-- Menu -->
  <ol class="carousel-indicators">
    {% assign slide_number = 0 %}
    {% for image in site.data.home_slider %}
    {% if slide_number == 0 %}
    <li data-target="#carousel" data-slide-to="{{ slide_number }}" class="active"></li>
    {% else %}
    <li data-target="#carousel" data-slide-to="{{ slide_number }}"></li>
    {% endif %}
    {% assign slide_number = slide_number | plus: 1 %}
    {% endfor %}
  </ol>

  <!-- Items -->
  <div class="carousel-inner" markdown="0">
    {% assign slide_number = 0 %}
    {% for image in site.data.home_slider %}
    {% if slide_number == 0 %}
    <div class="item active">
    {% else %}
    <div class="item">
    {% endif %}
      <img class="centerd-image" src="{{ site.url }}{{ site.baseurl }}/images/home/{{ image.name }}" style="height: 350px">
    </div>
    {% assign slide_number = slide_number | plus: 1 %}
    {% endfor %}
  </div>
  <a class="left carousel-control" href="#carousel" role="button" data-slide="prev">
    <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
    <span class="sr-only">Previous</span>
  </a>
  <a class="right carousel-control" href="#carousel" role="button" data-slide="next">
    <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
    <span class="sr-only">Next</span>
  </a>
</div>



On the theory side, we are interested in many aspects of quantum information, including quantum correlations, quantum cryptography, and quantum foundations. On the experimental side, we focus on the development and manipulation of novel sources of entangled photons, both in fibers and in silicon waveguides. We also develop bio-inspired photonic processing systems, such as reservoir computing.

We are part of the Physics Department of ULB. We exchange ideas and work with our colleagues from the [Center for Quantum Information and Communication (QuIC)](http://quic.ulb.ac.be/) and [OPERA-Photonique](http://www.ulb.ac.be/polytech/soa/index.html).
