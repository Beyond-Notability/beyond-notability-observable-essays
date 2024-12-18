---
theme: dashboard
title: Residence
---

# Places of Residence

*This is a work-in-progress data essay*

[Places connect people to understandings, practices, and conceptions of space](https://thefutureoflandscape.wordpress.com/landscapespacepolitics-an-essay/). Residences are a particular type of place, private - in most cases - spheres of experience whose character is deeply personal. For the historian encountering residence information - the places people lived, the periods in which they lived there, the people they lived with - the impenetrability of these private realms can provoke a retreat to place: to putting dots on maps and to using those maps as proxies for where people did things, the spaces 'close to home' that they encountered and fashioned. Where people live is of course strongly connected to the work they do, the networks they form, their understandings, practices, and conceptions of space. And for those reasons Beyond Notability has collected lots of information about where people lived. But when we began to put residence data from [our wikibase](https://beyond-notability.wikibase.cloud/) on a map, apart from highlighting geographical hot and cold spots in our data, it didn't tell us that much about the relationship between residences and work. Much more generative, we started to find, were those queries that used residence data to tell us who moved between residences on multiple occasions, whether those residence were far apart, if those residences were *within* a given city or local area; in short, the intersections between residences, space, and time. And so as we turned to visualising our residence data, we put maps aside, took a more lifecourse-oriented approach, and tried to use the appearance of residence data in our sources to get at when women's work in archaeology, history, and heritage became present in those fields. This was not, as we'll explain, without complication.

## Recording Residence Data

But first a little aside on the nature of residence data. As we encountered residence data in the archive, ideally residence data specifically associated with women (rather than an address for a father or husband, with whom we cannot assume women lived) we recorded it in [our wikibase](https://beyond-notability.wikibase.cloud/). At first glance this may seem a straightforward process: a letter, fellowship application, or membership list - and many addresses in our wikibase are from members lists of scholarly societies, more on which later - records that someone lived at a given place, where their residence was. But those letters, applications, and lists rarely record anything other than where that person [resided](https://beyond-notability.wikibase.cloud/wiki/Property:P29) at a given '[point in time](https://beyond-notability.wikibase.cloud/wiki/Property:P1)'. We *may* reasonably infer that that person resided at that address before and after the letter, application, or list was produced, but for how long before - a '[start time](https://beyond-notability.wikibase.cloud/wiki/Property:P27)' - or for how long after - an '[end time](https://beyond-notability.wikibase.cloud/wiki/Property:P28)' - is often unknown. Even when we - as we often have in our research - encounter, say, a latter subsequent residence address for that same person, the difficulties remain. Because although we now have a new residence (let's call it Residence B) that marks a point at time at which a person no longer lived at the first residence (let's call that Residence A), we have no knowledge of the points of transition between the Residence A and Residence B. What we do now have is a '[latest date](https://beyond-notability.wikibase.cloud/wiki/Property:P51)' at which it was possible that person resided at Residence A, but this is not the same as an '[end time](https://beyond-notability.wikibase.cloud/wiki/Property:P28)'. And so whilst we were able to find some '[start time](https://beyond-notability.wikibase.cloud/wiki/Property:P27)' and '[end time](https://beyond-notability.wikibase.cloud/wiki/Property:P28)' data, most of the residence data we have in [our wikibase](https://beyond-notability.wikibase.cloud/) are points in time recorded in the archive, points connected at fluid, uncertain moments of overlap between residence at one place or another.

<div class="grid grid-cols-1">
  <div class="card">
    ${resize((width) => residedTypesChart(resided, {width}))}
  </div>
</div>

## Residences and Lifecycles

The good thing, though, is that we have assembled a lot of dateable residence data in [our wikibase](https://beyond-notability.wikibase.cloud/): around 1,300 occurances, roughly 1.4 residences per woman in our wikibase. And we also have a lot of other types of data that enable us to contextualise that dateable residence data. One such example is the type of date information captured by our '[date of birth](https://beyond-notability.wikibase.cloud/wiki/Property:P26)' statements. Of the 900 or so [women in our wikibase](https://beyond-notability.wikibase.cloud/w/index.php?title=Special:WhatLinksHere/Item:Q3&limit=500), around two-thirds have a '[date of birth](https://beyond-notability.wikibase.cloud/wiki/Property:P26)' statement. Given that roughly three-quarters of the women in our wikibase have residence data recorded, plotting the two together enables us to see relatively representative patterns in our data. One way of doing that plotting is shown below. Here the occurances of dateable residence data (the orange bars) by age of a person are plotted in comparison - and therefore making a pleasing dome iceberg shape - with all the dateable location data (e.g. a statement about attendance at a meeting that includes both the location of that meeting and a date of its occurence) in [our wikibase](https://beyond-notability.wikibase.cloud/) (in blue).

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
- Second, data has been excluded for women whose residence data is undated.
- Third, anyone born before 1831 or after 1910 has been excluded as they are few in number.

These caveats noted, what do we see in this snapshot across the lifecourse?

- First, that all dateable location data for women in our wikibase peaks between their early-20s and late-50s. This corresponds with [women's life expectancy across our period](https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/lifeexpectancies/articles/howhaslifeexpectancychangedovertime/2015-09-09) and is therefore a good pattern that makes sense: the bulk of things happen when we would expect people to be alive, with a long tail of dateable location data into later life.
- Second, dateable residence data is smoother across the lifecourse than all other dateable location data, peaking between women's mid-30s to late-40s (which makes sense given that dateable residence data is often found in members lists of scholarly societies), with a healthy volume of data during earlier childhood (though given our preference for only including residence data when women are mentioned explicitly in the records, this number is lower than if we'd used residences of fathers as proxies for residence of young women and girls).
- Third, whilst there is much less dateable residence data than other dateable location data, the volume (roughly two pieces of dateable residence data for all women with residence data) and spread of the data indicates some level of mobility, if stretched thinly across the lifecourse.
- But, fourth, the plot is mute on the nature of that mobility. That is, we have no way of disagregating the home a person grow up in, from a residence they lodged at, from a marital home, from a seasonal residence, from a residence used during extended fieldwork. For example, application for tickets to consult the British Museum Reading Room (records of which are held at the [British Museum](https://discovery.nationalarchives.gov.uk/details/r/C80)), indicate that many women took up temporary residence in London during periods of research. These mobilities, where accessible, are not disentangled from other forms of residence in our data.
- Nevertheless, fifth and finally, we know that dateable residence data is an important feature of our dataset, and in turn in our archival materials. But teasing out how it helps us understand the nature of women's work in archaeology, history, and heritage requires some more creative thinking.

## Creative Thinking

What then, we wondered, would the above visualation look like if we filtered for those women for whom we only have residence data relating to their early or later lives? Well, below on the left is a plot relating to people with dateable residence data up to and including the age of 30 (excluding anyone whose [resided at](https://beyond-notability.wikibase.cloud/wiki/Property:P29) statement has a start time with no corresponding end time, and any with earliest date). And on the right is a plot relating to people with dateable residence data from the age of 60 onwards (excluding anyone whose [resided at](https://beyond-notability.wikibase.cloud/wiki/Property:P29) statement has an end time with no corresponding start time, and any with latest date). Like the previous plot, in both instances this dateable residence data has been plotted alongside all other dateable location data for each of these women, *including* those occurences after the age of 30 (for the left plot) and before the age of 60 (for the right plot). 

<div class="grid grid-cols-1">
  <div class="card">
    ${resize((width) => residedFacetedStackedDot(datesResidedEarlyLate, {width}))}
  </div>
</div>

The result: two intriguing icebergs, two plots that begin to offer insights.

- First, that similar numbers of women in [our wikibase](https://beyond-notability.wikibase.cloud/) have dateable residence data for *only* their late-teens to late-20s or their early-60s to late-70s.
- Second, dateable residence data for this subset of women in [our wikibase](https://beyond-notability.wikibase.cloud/) peaks at 25, 30, and 60: that is, in early adulthood and around likely retirement.
- Third, where datetable residence data clusters, all other dateable location data clusters as well, creating a rough - and extended - shadow under the proverbial water line.
- But, forth, and - we think - significantly the dateable location data peak in both plots is slightly *before* the corresponding residence peak. This group of women, therefore, seem to be doing things that get them into our data *before* they do things that get their residence information into our data. That is, in the records we have consulted, it appears that a person's residence data is slighlty more archivable once that person's life - their work - makes it more worthwhile to record.
- Fifth, the left plot shows women with dateable residence data for only their early lives drift out of the records, though with a scattering of dateable location data into their 90s. And the right plot shows women with dateable residence data for only their later lives having appeared in our records since, in some cases, their teens.

## Hummocks and Bummocks

In [our wikibase](https://beyond-notability.wikibase.cloud/) then, the women who shine brightly are those with one or a few dateable instances of [resided at](https://beyond-notability.wikibase.cloud/wiki/Property:P29) statements towards the beginning or end of the average life expentancy. The datable and locatable activities relating to these women are closely bonded to points in time at which we know their place of residence. This opens up questions that go beyond the plot, beyond taking women in aggregate. In the fields of archaeology, history, and heritage, how closely connected are the appearance of residences in archival records and the notability of the resident? Does that differ for men and women? And how does that map to other fields? How useful are the locations of activities women took part in as proxies for the continued 'truthiness' of a previous residence statement? And can [our wikibase](https://beyond-notability.wikibase.cloud/) be used to measure how the truthiness of residence data degraded over time? Finally, thinking of our last plot, what imaginations of the lifecourse - [education](https://beyond-notability.github.io/beyond-notability-observable-essays/education.html), [motherhood](https://beyond-notability.github.io/beyond-notability-observable-essays/mothers.html), old age - does this work with data invoke, and how far do they distract us from the real experience of the lifecourse, of places, and of 'work' as experienced by the women in [our wikibase](https://beyond-notability.wikibase.cloud/)?

## References

- [Observable Plot dot mark](https://observablehq.com/plot/marks/dot)
- [Observable Plot stack transform](https://observablehq.com/plot/transforms/stack)





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
