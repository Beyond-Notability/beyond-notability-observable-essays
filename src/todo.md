---
theme: dashboard
title: Todo and Notes
toc: true
---



Todo
----

general tech credits

Observable and D3 (site generator and visualisations)

- [Observable Framework](https://observablehq.com/framework/what-is-framework)
- [Observable Plot](https://observablehq.com/plot/getting-started)
- [D3.js](https://d3js.org/getting-started)

R (data wrangling)

- [R](https://cran.r-project.org/)
- [Tidyverse](https://www.tidyverse.org/)


Networks

- more info in tooltips
- toggle node size between degree and betweenness centrality (maybe) (will need to use rankings rather than measures, might not work)



Childbirth notes
----------

some of these conflict slightly with text so don't remove yet...

- work includes `employed as` (only about 3 instances?) - maybe separate these out
- named children included (if they have a date of birth) as well as `had child in`
- upper age cutoff at 75; v few data points beyond this, doesn't significantly change interpretation but does make chart less readable (because it's trying to squish more into the same space)
- handling more than one activity in the same year:
	- there's been some reduction in preprocessing, so that only one activity per type per year is included in chart (doesn't remove that many instances)
	- if there's more than one type of activity in the same year, all symbols are visible but *only one tooltip* (order of priority should be: work / served / spoke)


