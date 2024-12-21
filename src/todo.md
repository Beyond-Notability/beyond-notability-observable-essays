---
theme: dashboard
title: Todo and Notes
toc: true
---


Summary of pages
------

1. All the dates data
2. Childbirth and other activities before and after
3. Higher education and degrees timeline 
4. Something about residence and gaps in it 
5. Networks [events and committee service] 


Todo
----

general tech credits? Observable, D3, R, Tidyverse.


minor niggle on several charts: how to put filters/legend in the same div as the chart (or at least make them look as though they are)


Networks

- more info in tooltips
- toggle node size between degree and betweenness centrality (maybe) (will need to use rankings rather than measures, might not work)



Childbirth notes
----------

some of these conflict slightly with text so don't delete yet...

- work includes `employed as` (only about 3 instances?) - maybe separate these out
- named children included (if they have a date of birth) as well as `had child in`
- upper age cutoff at 75; v few data points beyond this, doesn't significantly change interpretation but does make chart less readable (because it's trying to squish more into the same space)
- handling more than one activity in the same year:
	- there's been some reduction in preprocessing, so that only one activity per type per year is included in chart (doesn't remove that many instances)
	- if there's more than one type of activity in the same year, all symbols are visible but *only one tooltip* (order of priority should be: work / served / spoke)


