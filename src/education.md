---
theme: dashboard
title: Education
toc: false
---

# Education, education, education

*This is a work-in-progress data essay*

The Beyond Notability project focused on women's work in archaeology, history and heritage between 1870 and 1950. For many women, but certainly not a majority, a precursor to working in these fields was receiving formal education. And in this period the landscape in which women were able to receive formal education, in particular at [tertiary education institutions](https://beyond-notability.wikibase.cloud/wiki/Item:Q2914) was undergoing significant chanage. In 1878, the Univeristy of London became the first UK universtiy to award degress to women. The University of Oxford did not award women degress until 1920. It took until 1948 for the University Cambridge to follow suit. But women could still receive an Oxbridge education without formerly graduating or being awarded a degree and so the educational prestige of Oxford and Cambridge institutions meant that women attended their women's colleges - Girton, Newnham, Somerville, St Hilda's, Lady Margaret Hall - in significant numbers. And so with a view to contextualising the relationship between work and education we set about assembling information on women's education from admission registers, fee books, university gazettes, and mentions of education achievement in records like the [Society of Antiquaries of London Certificates of Candidates for Election](https://beyond-notability.wikibase.cloud/wiki/Item:Q315). But, as we found at many points during the project, modelling the historically specific reality these women experienced - in this case, their experience of education - was not a straightforward endeavour.

## Modelling education

Modelling is an exercise in using data structures as a means of attempting to approximate social reality. As citizens of modern bureaucracies we encounter data modelling on a regular basis, on every occasion we are asked to fill in a form about ourselves we are asked to deconstruct our identity into constituent parts: title, given and family names, gender, age, address, ethnic identity, and so on. As [infrastructure studies scholars have long argued](https://mitpress.mit.edu/9780262522953/sorting-things-out/), we tend only to see these categories as a series of choices when they do longer match our perceived reality, such as when the categories provided feel out of data, modelled on other people (e.g. a hegemonic social group), or overtly politicised. But modelling is always positionally inscribed, and that is underscored when historians - like us - attempt to use data structures to approximate social reality over a long period of time, such as the 80 or so years covered by Beyond Notability. Seen through the lens of hihger education, our period was one of gradual and significant change: from the ancient university system inherited in the late nineteenth century a 'modern' university system began to emerge by the middle of the twenteith century, in part driven by higher education forming part of post-war political planning, culminating with the 1963 Robbins Report that would catalyse a significant expansion in higher education provision in the UK (see Peter Mandler's *[The Crisis of the Meritocracy](https://global.oup.com/academic/product/the-crisis-of-the-meritocracy-9780198840145?cc=gb&lang=en&)* for an excellent elaboration of this process).

Part of that story was the distinction between getting an education and being awarded a degree. The modern imagination of the two being indivisible (with the exception being failing to achieve the standard required to be awarded a degree) made little sense in context. Wikidata, in which we based our biographical modelling, but diverged - often significantly in order to better represent the historical specificity we encountered in the archive ([we published an article on this](https://eprints.soton.ac.uk/495654/) if you are interested) - assumes this presentist coupling of education with award. There the data model uses '[educated at](https://www.wikidata.org/wiki/Property:P69)' statements to record the institutions at which people were educated, with qualifers by time, [subject](https://www.wikidata.org/wiki/Property:P812), and [degree](https://www.wikidata.org/wiki/Property:P512) used to record instances of education (to see how this works, the wikidata entry for [Angela Merkel](https://www.wikidata.org/wiki/Q567) is a good starting point). So we diverged again, creating '[educated at](https://beyond-notability.wikibase.cloud/wiki/Property:P94)' statements to record where women were educated, with qualifers by date and subject when known, and seperate  '[academic degree](https://beyond-notability.wikibase.cloud/wiki/Item:Q2315)' statements to capture when degree awards were made and who they were confered by. And, in an echo of our [residence data](https://beyond-notability.github.io/beyond-notability-observable-essays/residence.html#how-we-record-residence-data), the dating of both took on distinct forms due to variations in recording practices: '[educated at](https://beyond-notability.wikibase.cloud/wiki/Property:P94)' statements typically, but not always, included '[start times](https://beyond-notability.wikibase.cloud/wiki/Property:P27)' and '[end times](https://beyond-notability.wikibase.cloud/wiki/Property:P28)', whereas '[academic degree](https://beyond-notability.wikibase.cloud/wiki/Item:Q2315)' statements were given as '[points in time](https://beyond-notability.wikibase.cloud/wiki/Property:P1)' or '[latest dates](https://beyond-notability.wikibase.cloud/wiki/Property:P51)', the date by which - say - we knew [Veronica Inez Ruffer](https://beyond-notability.wikibase.cloud/wiki/Item:Q795) must have had a bachelor's degree, because - even though she was educated at Oxford from 1919 - the evidence we have for being awarded a degree comes from document prepared in 1944 that put her forward for election as a Fellow of the Society of Antiquaries of London.

## Education Plotted

To plot this data, we took a similar approach as we did for [motherhood](https://beyond-notability.github.io/beyond-notability-observable-essays/mothers.html). The plot shows each women for which we have '[educated at](https://beyond-notability.wikibase.cloud/wiki/Property:P94)' and/or '[academic degree](https://beyond-notability.wikibase.cloud/wiki/Item:Q2315)' statements. Each woman is represented by a single row. The rows are sorted by date of birth, with the earliest at the top and the latest at the bottom. The right hand end of the row represents the last piece of data on the graph (rather than a data of death). Each row then shows number of pieces of information:

- Year of birth, represented by a white ring on each row.
- Sitting on top of each row, any '[point in time](https://beyond-notability.wikibase.cloud/wiki/Property:P1)' (as a triangle), '[start time](https://beyond-notability.wikibase.cloud/wiki/Property:P27)' (as a yellow diamond), '[end time](https://beyond-notability.wikibase.cloud/wiki/Property:P28)' (as a green diamond), or '[latest date](https://beyond-notability.wikibase.cloud/wiki/Property:P51)' (as a star) data relating to '[educated at](https://beyond-notability.wikibase.cloud/wiki/Property:P94)' statements.
- Where there are statements with matching '[start times](https://beyond-notability.wikibase.cloud/wiki/Property:P27)' and '[end times](https://beyond-notability.wikibase.cloud/wiki/Property:P28)', a series of white cubes - merging into a white bar if we view the plot in a narrow browser window - represent continuous education.
- Hanging below each row, '[point in time](https://beyond-notability.wikibase.cloud/wiki/Property:P1)' (as a triangle), '[start time](https://beyond-notability.wikibase.cloud/wiki/Property:P27)' (as a yellow diamond), '[end time](https://beyond-notability.wikibase.cloud/wiki/Property:P28)' (as a green diamond), or '[latest date](https://beyond-notability.wikibase.cloud/wiki/Property:P51)' (as a star) data relating to '[academic degree](https://beyond-notability.wikibase.cloud/wiki/Item:Q2315)' statements.
- Intersecting lines representing the years in which the Universities of London (1878), Oxford (1920), and Cambridge (1948) began awarding degrees to women.
- A toggle to switch between a default view that presents the data using dates on the X-axis and a second view that presents the data using ages on the X-axis.


```js
// toggle baby! 8-)
const makeToggleView = view(makeToggle);
```

<div class="grid grid-cols-1">
  <div class="card">
    ${makeChart(makeToggleView) }
  </div>
</div>

So, what is shown if we focus on education data and plot it in this way:

- First, that women attended university before - in most cases - they were able to receive degrees.
- Second, that the 'modern' university system of contiguous education followed by a degree award emerges from the plot, meaning that as we scroll down the plot the purple triangles below the line (the point in time when someone was awarded a degree) closely correspond with green diamonds above the line (the end time for someone's time in tertiary education).
- Third, by focusing on the presence of more white bars as we scroll down the plot, that a rationale emerges for exploring networks of education co-occurence, to examine places of study as places of mutual experience and knowledge.
- Fourth, by toggling to the arrangement of the x-axis by age, that 'modern' university system also emerges as we scroll down the plot through the apparent normalisation of women entering university between the ages of 18 and 20, and being educated over a 3-4 year periods of time.
- Fifth, that if we hover over those period of continuous study, we note that postgraduate education is poorly represented, typically only captured in our data as an award some years after first entering tertiary education (e.g. a purple triangle below the line), rather than as a period of study (data points above the line).

## Towards research questions

Two of the research questions that [Beyond Notability]https://beyondnotability.org/) started out with are useful here for drilling into the plot. 

1. What was the nature, scale and distribution of women's work in these fields?
2. What do the records reveal about the extent and character of women's intellectual networks and how these facilitated or constrained their activities?

If we take education as a form of 'work', as endeavours that pre-figured some kind of career in archaeology, history, and heritage, this plot of the education data in [our wikibase](https://beyond-notability.wikibase.cloud/) suggests that between the late-nineteenth and mid-twentieth centuries education in these fields was formalised in nature, increased in scale, and was concentrated on women's colleges at Oxford and Cambridge (though, the latter point may well be because those colleges have the most accurate and accessible data on students enrollments). In terms of what plot 'reveals' about women's intellectual networks, it offers a tempting proxy for networks in the from of temporal educational co-occurence: if women were in the same place at the same time receiving education in the same college then *maybe* they can be considered part of a network. But as we know from our research (and Katherine and Amara will discuss in [their forthcoming book](https://beyondnotability.org/publications/)) other proxies for networks are likely more revealing: the tutors women chose to work with and the individual classes chose to attend, or the time spent at places of postgraduate study and research, such as the [British School at Athens](https://beyond-notability.wikibase.cloud/wiki/Item:Q917), as well as the networks that enabled women to attend such institutions. Our education data also, when plotted this way, leads us towards the temptation that women's work in archaeology, history, and heritage was not constrainted by Oxford and Cambridge not awarding women degrees. In some cases that was clearly true: many women did make important contributions to these fields without being able to receive degress from the UKs most prestiguous educational institutions. But to read the data that way would be a naive interpretation of a plot presenting education data in isolation. Education does not take place in a vacuum. In the UK it is and was, as Mandler shows, intimately connected with how the state imagines itself and its aspirations. This plot might tell *a* story of how those imaginations and aspirations were refracted through a particular group of women's access to tertiary education (that is, 1920 and 1948 aren't the years to focus on), but above all it - we think - teases out the value of modelling data in ways that is attentive to historical specificity, the avenues of enquiry that emerge when data - is this case, education data - is taken as found and modelling accordingly. 

```js
// editables

const plotHeight = 5000;

const titleAge = "Higher education timelines: lifecycle (ordered by date of birth)";
const titleYear = "Higher education timelines: chronological (ordered by date of birth)";

```



```js
// Import components

import {educatedAgesChart, educatedYearsChart} from "./components/education.js";
```



```js
// load data

const education = FileAttachment("data/l_dates_education/educated_degrees2.json").json({typed: true});
```







```js
// make the radio button for the toggle

const makeToggle =
		Inputs.radio(
			["dates", "ages"],  
			{
				label: "View by: ", 
				value:"dates", // preference
				}
			);
```


```js
// toggle function
//i'd like less repetition in here but i can live with it.

const makeChart = (selection) => {
  return selection === "dates" ?  
  resize((width) => educatedYearsChart(education, {width}, titleYear, plotHeight)) : 
  resize((width) => educatedAgesChart(education, {width}, titleAge, plotHeight)) 
}

```
