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


General
-------

Find out how to toggle between dark and light mode so I can test how things look!

nicer styling esp on front page!

general credits


All the dates
------------
 
- category filters (maybe)


Childbirth
----------

- Plot.axis to show label at both top and bottom is not working (cf education) and Idk why (should) (lowish priority: not essential but desirable given that it's a tall chart, and for consistency between similar charts)

notes

- work includes `employed as` (only about 3 instances?) - maybe separate these out
- named children included (if they have a date of birth) as well as `had child in`
- upper age cutoff at 70; v few data points beyond this, doesn't significantly change interpretation but does make chart less readable (because it's trying to squish more into the same space)
- handling more than one activity in the same year:
	- there's been some reduction in preprocessing, so that only one activity per type per year is included in chart (doesn't remove that many instances)
	- if there's more than one type of activity in the same year, all symbols are visible but *only one tooltip* (order of priority should be: work / served / spoke)


Education
--------

- custom d3 shapes? (esp for start/end pairs) [maybe]


Residence
--------

- examples of people with gaps: look at place data between those gaps, does it help explain absent residence data? [maybe]


Networks
-------

- a few outstanding TODOs on the page

