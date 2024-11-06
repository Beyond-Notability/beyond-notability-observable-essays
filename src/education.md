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

Talk through data. Talk through what it 'shows'. Toggle changes narrative?


```js
// toggle baby! 8-)
const makeToggleView = view(makeToggle);
```

<div class="grid grid-cols-1">
  <div class="card">
    ${makeChart(makeToggleView) }
  </div>
</div>



## Towards research questions

What was the nature, scale and distribution of women's work in these fields?
What do the records reveal about the extent and character of women's intellectual networks and how these facilitated or constrained their activities?

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
