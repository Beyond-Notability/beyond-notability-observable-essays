---
theme: dashboard
title: Residence
---

# Residence

*This is a work-in-progress data essay*

Places connect people to understandings, practices, and conceptions of space. Residences are particular kinds of places, private - in most cases - spheres of experience whose character is deeply personal. For the historian encountering residence information - the places people lived, the periods in which they lived there, the people they lived with - the impenetrability of these private realms can provoke a retreat to place: to putting dots on maps and to using those maps as proxies for where people did things, the spaces they encountered and fashioned. Where people live is of course strongly connected to the work they do, the networks they form, their understandings, practices, and conceptions of space. And Beyond Notability has collected lots of information about where people lived. But when we began to put residence data from [our wikibase](https://beyond-notability.wikibase.cloud/) on a map, apart from highlighting geographical hot and cold spots in our data, it didn't tell us much about the relationship between residences and work. Much more generative, we found, were those queries that used residence data to tell us who moved between residences on multiple occasions, whether those residence were far apart, if those residences were *within* a given city or local area; in short, the intersections between residences, space, and time. And so as we turned to visualising our residence data, we began by putting maps aside, took a more lifecourse-oriented approach, and tried to use the appearance of residence data in our sources to get at when women's work in archaeology, history, and heritage became present in those fields. This was not, as we'll explain, without complication.

## How residence data is recorded

As we encountered residence data in the archive, we recorded it in our wikibase. This may seem straightforward at first: a letter, fellowship application, or membership list records that someone lived at a given place, so that is where they lived. But those letters, applications, and lists rarely record anything other than where that person [resided at](https://beyond-notability.wikibase.cloud/wiki/Property:P29) a given '[point in time](https://beyond-notability.wikibase.cloud/wiki/Property:P1)'. We *may* reasonably infer that that person resided at that address before and after the letter, application, or list was produced, but for how long before - a '[start time](https://beyond-notability.wikibase.cloud/wiki/Property:P27)' - or for how long after - an '[end time](https://beyond-notability.wikibase.cloud/wiki/Property:P28)' - is unknown. Then when we - as we often have in our research - encounter, say, a latter subsequent residence address for that same person, the difficulties remain. Because although we now have a new residence (let's call it Residence B) that marks a point at time at which they no longer lived at the first residence (let's call that Residence A), we have no knowledge of the points of transition between the Residence A and Residence B. What we do now have is a '[latest date](https://beyond-notability.wikibase.cloud/wiki/Property:P51)' at which it was possible they resided at Residence A, but this is not the same as an '[end time](https://beyond-notability.wikibase.cloud/wiki/Property:P28)'. Whilst we were able to find some '[start time](https://beyond-notability.wikibase.cloud/wiki/Property:P27)' and '[end time](https://beyond-notability.wikibase.cloud/wiki/Property:P28)' data, most of what we have in [our wikibase](https://beyond-notability.wikibase.cloud/) are points in time recorded in the archive, points connected at fluid, uncertain moments of overlap between residence at one place or another.

<div class="grid grid-cols-1">
  <div class="card">
    ${resize((width) => residedTypesChart(resided, {width}))}
  </div>
</div>

## Residence data and the lifecycle

The good thing, though, is that we have assembled a lot of residence date data in [our wikibase](https://beyond-notability.wikibase.cloud/): around 1,300 occurances, roughly 1.4 residences per the number of women in our wikibase. We also have a lot of other types of date that enable us to contextualise that residence date data. One of those is the type of date information captured by our '[date of birth](https://beyond-notability.wikibase.cloud/wiki/Property:P26)' statements. Of the 900 or so [women in our wikibase](https://beyond-notability.wikibase.cloud/w/index.php?title=Special:WhatLinksHere/Item:Q3&limit=500), around two-thirds have a '[date of birth](https://beyond-notability.wikibase.cloud/wiki/Property:P26)' recorded. Given that roughly three-quarters of the women in the wikibase have residence data recorded, plotting the two together enables us to see representative patterns in our data. One way of doing so is below: the occurances residence date data (the orange bars) by age of a person plotted in comparison - and therefore making a pleasing dome iceberg shape - with all place related date data (e.g. a statement about attendance at a meeting that includes both the location of that meeting and a date of its occurence) in our wikibase (in blue).

```js
//datesResidedAges
```

<div class="grid grid-cols-1">
  <div class="card">
    ${resize((width) => residedStackedDot(datesResidedAges, {width}))}
  </div>
</div>

Before we dig into this plot, a few explantory notes are needed:

- First, only data relating to women with '[date of birth](https://beyond-notability.wikibase.cloud/wiki/Property:P26)' statements has been included.
- Second, data has been excluded for women whose residence information is undated.
- Third, anyone born before 1831 or after 1910 has been excluded as they are few in number.

These caveats noted, what do we see in this snapshot across the lifecourse?

- First, that all dateable location data for women in our wikibase peaks between their early-20s to late-50s. This corresponds with [women's life expectancy across our period](https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/lifeexpectancies/articles/howhaslifeexpectancychangedovertime/2015-09-09): the bulk of things happen when we would expect people to be alive, with a long tail of recorded place related date data into later life.
- Second, dateable residence data is smoother across the lifecourse than all other dateable location data, peaking between women's mid-30s to late-40s, with a healthy volume of data during earlier childhood.
- Third, whilst there is much less dateable residence data than other dateable location data, the volume (roughly two pieces of dateable residence data for all women with residence data) and spread of the data indicates mobility.
- But, fourth, the plot is mute on the nature of that mobility. That is, we have no way of disagregating the home a person grow up in, from a residence they lodged at, from a married home, from a seasonal residence, from a residence used during extended fieldwork.
- Rather, fifth and finally, we know that dateable residence data is an important feature of our dataset, and in turn in our archival materials. Teasing out how it helps us understand the nature of women's work in archaeology, history, and heritage requires some more creative thinking.

### Some creative thinking

What then, we wondered, would this visualation look like if we filtered for those women for whomw we only have residence data relating to early or late in their lives? Well, below on the left is a plot relating to people with dateable residence data up to and include the age of 30 (excluding anyone who has start time that has no corresponding end time, and any with earliest date). And on the right is a plot relating to people with dateable residence data from the age of 60 onwards (excluding anyone who has end time with no corresponding start time, and any with latest date). Like the previous plot, in both instances this residence data has been plotted alongside the other dateable place data for each of those women, *including* those occurences after the age of 30 (for the left plot) and before the age of 60 (for the right plot). 

<div class="grid grid-cols-1">
  <div class="card">
    ${resize((width) => residedFacetedStackedDot(datesResidedEarlyLate, {width}))}
  </div>
</div>

The result: two intriguing icebergs, two plots that begin to offer insights.

- First, that similar numbers of women in [our wikibase](https://beyond-notability.wikibase.cloud/) have residence data for *only* their late-teens to late-20s or the early-60s to late-70s.
- Second, dateable residence data for this sub-set of women in [our wikibase](https://beyond-notability.wikibase.cloud/) peaks at 25, 30, and 60.
- Third, where datetable residence data clusters, the other dateable place data cluster as well, creating a rough - and extended - shadow under the proverbial water line.
- But, forth, and - we think - significantly the dateable place data peak in both plots is slightly *before* the corresponding residence peak. This group of women, therefore, seem to be doing things that get them into our data *before* they do things that get their residence information into into our data. That is, in the records we have consulted, it appears that a person's residence data is slighlty more archivable once that person's life - their work - makes it more worthwhile to record.
- Fifth, the left plot shows women with dateable residence data only for their early lives drift out of the records, though with a scattering of dateable place data into their 90s. And the right plot shows women with dateable residence data only for their latter lives having appeared in our records since, in some cases, their teens.

## Hummocks and bummocks

In [our wikibase](https://beyond-notability.wikibase.cloud/) then, the women who shine brightly are those with single dateable instances of [resided at](https://beyond-notability.wikibase.cloud/wiki/Property:P29) statements - or, close temporal clusters - towards the beginning or end the average life expentancy shine brightly. The datable and locatable activities relating to these women are closely bonded to points in time at which we know their place of residence. This opens up questions that go beyond the plot, beyond taking women in aggregate

What does it all mean Data in the aggregate. But we don't want to aggregate. Brining in examples of people with gaps: look at place data between those gaps, does it help explain absent residence data?


## to add

- final section.
- Reading Room records as access to temporary local residence in London
- we can assume not loads of movement ---- n residences as a proxy for some stability, not everything in flux










```js
// Import components
import {residedTypesChart, residedEarlyLateBeeswarm, residedStackedDot, residedFacetedStackedDot} from "./components/resided.js";
```




```js

const datesResidedAges = FileAttachment("./data/l_resided_at/dates-ages.csv").csv({typed: true})

const resided = FileAttachment("./data/l_resided_at/resided.csv").csv({typed: true})

//const residedDated = FileAttachment("./data/l_resided_at/resided-dated.csv").csv({typed: true})

const datesResidedEarlyLate = FileAttachment("./data/l_resided_at/dates-resided-early-late.csv").csv({typed: true})

//const datesResidedOther = FileAttachment("./data/l_resided_at/dates-resided-other.csv").csv({typed: true})

```
