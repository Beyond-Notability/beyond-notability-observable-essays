---
theme: dashboard
title: Education
toc: false
---

# Education, education, education

*This is a work-in-progress data essay*

The Beyond Notability project focused on women's work in archaeology, history and heritage between 1870 and 1950. For many women, but certainly not a majority, a precursor to working in these fields was receiving formal education. And in this period the landscape in which women were able to receive formal education, in particular at [tertiary education institutions](https://beyond-notability.wikibase.cloud/wiki/Item:Q2914) was undergoing significant chanage. In 1878, the Univeristy of London became the first UK universtiy to award degress to women. The University of Oxford did not award women degress until 1920. It took until 1948 for the University Cambridge to follow suit. But women could still receive an Oxbridge education without formerly graduating or being awarded a degree and so the educational prestige of Oxford and Cambridge institutions meant that women attended their women's colleges - Girton, Newnham, Somerville, St Hilda's, LAdy Margaret Hall - in significant numbers. And so with a view to contextualising the relationship between work and education we set about assembling information on women's education from admission registers, fee books, university gazettes, and mentions of education achievement in records like the [Society of Antiquaries of London Certificates of Candidates for Election](https://beyond-notability.wikibase.cloud/wiki/Item:Q315). But, as we found at many points during the project, modelling the historically specific reality these women experienced - in this case, their experience of education - was not a straightforward endeavour.

## Modelling education

Modelling is an exercise in using data structures as a means of attempting to approximate social reality. As citizens of modern bureaucracies we encounter data modelling on a regular basis, on every occasion we are asked to fill in a form about ourselves we are asked to deconstruct our identity into constituent parts: title, given and family names, gender, age, address, ethnic identity, and so on. As [infrastructure studies scholars have long argued](https://mitpress.mit.edu/9780262522953/sorting-things-out/), we tend only to see these categories as a series of choices when they do longer match our perceived reality, such as when the categories provided feel out of data, modelled on other people (e.g. a hegemonic social group), or overtly politicised. But modelling is always positionally inscribed, and that is underscored when historians - like us - attempt to use data structures to approaxminate social reality over a long period of time, such as the 80 or so years covered by Beyond Notability. Seen through the lens of hihger education, our period was one of gradual and significant change: from the ancient university system inherited in the late nineteenth century a 'modern' university system began to emerge by the middle of the twenteith century, in part driven by higher education forming part of post-war political planning, culminating with the 1963 Robbins Report that would catalyse a significant expansion in higher education provision in the UK (see Peter Mandler's *[The Crisis of the Meritocracy](https://global.oup.com/academic/product/the-crisis-of-the-meritocracy-9780198840145?cc=gb&lang=en&)* for an excellent elaboration of this process).

Coupling of education and award as found in modern imagination than made little sense. E.g. wikidata use of degree as qualifer of educated at [e.g. https://www.wikidata.org/wiki/Q567] Degree award and seperation distinct activities requiring distinct statements to represent - model - historical specificity. 'Educated at' - including dates and subject when known - for what people did, and 'Academic Degree' for PIT of award and who confered by.

Also - echoing RESIDENCE - types of date: award PIT or latest date; education ideally start and end but not always possible.

## The Plot

Talk through plot (education above the line, degrees below the line)


```js
// toggle baby! 8-)
const makeToggleView = view(makeToggle);
```

<div class="grid grid-cols-1">
  <div class="card">
    ${makeChart(makeToggleView) }
  </div>
</div>

Talk through what it 'shows'.

1. Women attended university before, in most cases, they were able to receive degrees.
2. The 'modern' university system of contiguous education followed by a degree award emerges from the plot. Good record keeping = good data.
3. Clear basis through which to think about networks of co-occurence, places of study as places of mutual experience and knowledge.
4. The 'modern' university system also emerges via women entering uni between 18 and 20, and being educated over a short period of time (toggle for 'age' to see this).
5. PG harder to see --- often in award rather than study

## Towards research questions

Draw us towards two BN research questions:

- What was the nature, scale and distribution of women's work in these fields?
- What do the records reveal about the extent and character of women's intellectual networks and how these facilitated or constrained their activities?

Here we take education as a form of 'work', endeavours that pre-figured some kind of career in arch, hist, heritage. Education data in our wikibase suggests formalisation in nature, increase in scale, and a distribution ever focused into ox/camb women's colleges.

Records reveal temptation to use co-occurance at a HEI as proxy for networks, even if other forms of networks more revealing --- e.g. papers/classes taken - especially at UoL - as tutorial related networks; period at places of advanced study/research such as BSA and the networks that enabled women to go.

They also - plotted - lead towards temptation to say that women were no constrained by ox/camb not giving degrees, but that would be naive reading of this data presented in isolation, need to take this data in richer context.

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
