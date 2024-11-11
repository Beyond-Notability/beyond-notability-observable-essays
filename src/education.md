---
theme: dashboard
title: Education
toc: false
---

# Timelines of higher education

Whilst Univeristy of London awarded degress to women from 1878, Oxford did not award women degress until 1920 and Cambridge until 1948. This did not stop women attending Oxbridge, only formerly graduating. So we gathered that data: from registers at UoL, and Camb/Ox women's colleagues, and mentions in records like Blue Papers, we sought to assemble information on women's education. But, like other statements, had to figure out how best to model their education experiences, especially given the degree awarding situation at Oxbridge.

## Modelling education

Modelling is an exercise in trying to approximate social reality in data. No easy over long period of project: ancient system inherited in the late-C19 starting to emerge as a modern university system by mid-C20, HE as part of post-war planning, led into 1963 Robbins Report that expanded HE [FIXME see Mandler].

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
