---
theme: dashboard
title: Notes
toc: true
---

About
-----

This set of essays has been created using [Observable Framework](https://observablehq.com/framework/), a [static site generator](https://en.wikipedia.org/wiki/Static_site_generator) focused on data analysis and visualisation. 

It facilitates bringing together the strengths of different coding tools; in this case, R is used for the bulk of data processing and Observable Plot or D3.js for interactive visualisations of the data. The essays are written in Markdown, interwoven with code chunks in Javascript.

Finally, the essays are deployed to the web using Github Pages and Github Actions.


Much of the R data processing was originally done for an R/Quarto blog [BN Notes](https://beyond-notability.github.io/bn_notes/). Code is on [Github](https://github.com/Beyond-Notability/beyond-notability-observable-essays).


Credit where it's due
----------

Observable Framework is quite new and still evolving ([launched February 2024](https://observablehq.com/blog/observable-2-0)), so there isn't always detailed documentation or help for all the niche-y things you might want to do with it. The issues and discussions tabs in the [Framework Github repository](https://github.com/observablehq/framework) have been vital resources.

There has been a *lot* of googling, stack overflow-ing, teeth-gnashing and learning (especially for D3). It's not possible to list everything used in the course of writing the code; there are some more specific links on individual essays. So this is just a few key resources.


### Observable and D3 

- [Observable Framework](https://observablehq.com/framework/what-is-framework)
- [Observable Plot](https://observablehq.com/plot/getting-started)
- [D3.js](https://d3js.org/getting-started)


### R 

- [R](https://cran.r-project.org/)
- [Tidyverse](https://www.tidyverse.org/)


### Javascript

- [Learn Just Enough Javascript](https://observablehq.com/@observablehq/learn-javascript-introduction)
- [learn X in Y minutes: Javascript](https://learnxinyminutes.com/javascript/)


### Github 

(As a complete Github Actions novice, this part was tricky.)

- [github workflow for publishing an observable framework](https://notes.billmill.org/programming/observable_framework/github_workflow_for_publishing_an_observable_framework.html)
- [GitHub Actions for R developers](https://www.tidyverse.org/blog/2022/06/actions-2-0-0/) (helpful for understanding how to include R packages in a Github workflow even if not using the R package documented in the post)


### Other bits and pieces

- [Interesting ideas in Observable Framework](https://simonwillison.net/2024/Mar/3/interesting-ideas-in-observable-framework/)
- [Building OSS Map Apps With Observable Framework](https://mclare.blog/posts/building-oss-map-apps-with-observable-framework/)
- [Examples](https://observablehq.com/explore)

