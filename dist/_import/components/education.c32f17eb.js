import * as Plot from "../../_npm/@observablehq/plot@0.6.15/_esm.js";
import * as d3 from "../../_npm/d3@7.9.0/_esm.js";

	
// share as much as possible between the two versions of the chart

const color_time = Plot.scale({
		color: {
			range: ["#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "lightgray"], 
			domain: ["point in time", "start time", "end time", "latest date", "filled"]
		}
	});

// TODO not working as intended; legend disappears.
const symbol_time = Plot.scale({ 	
    symbol: {legend:true, 
    				range: ["triangle", "diamond2", "diamond2", "star", "square"], 
						domain: ["point in time", "start time", "end time", "latest date", "filled"]
		}
	});
	
const plotHeight = 6000;
const plotMarginTop = 10;
const plotMarginLeft = 180;

    	//TODO a bit more space between top X axis labels and first rule?
    	//TODO year of event label at both top and bottom?
    	//TODO custom shapes?
    

const plotTitle = "Higher education [TODO (dates|ages)] "

const eventLabel = {label: "year of event"}
    	   	
 
// BY DATE   	
    	
export function educatedYearsChart(data, {width}) {

  return Plot.plot({
  
    title: plotTitle, //"higher education chronology (ordered by date of birth)",
    
    width,
    height: plotHeight,
    marginTop: plotMarginTop,
    marginLeft: plotMarginLeft,

    	
    x: {
    	grid: true, 
    	//label: "year of event", 
    	tickFormat: d3.format('d'),
    	//axis: "both" // "both" top and bottom of graph. null for nothing. when this = "both" the label only shows at the bottom, but when set to "top" the label is at the top...  seems you have to do Plot.axis to get it the way you want.
    	}, 
    	
    y: {label: null}, // this affects tooltip label too  
    
    //symbol: symbol_time, // not showing legend...    
    symbol: {legend:true, 
    				range: ["triangle", "diamond2", "diamond2", "star", "square"], 
						domain: ["point in time", "start time", "end time", "latest date", "filled"]
		} ,
    color: color_time,
    
    marks: [
     
     // NEAR REPETITION
      Plot.axisX({anchor: "top", 
      						label: "year of event", 
      						tickFormat: d3.format('d')}
      						),
      Plot.axisX({anchor: "bottom", 
      						label: "year of event", 
      						tickFormat: d3.format('d')}
      						),
      
      
    	// GUIDE LINES
      
    	// turn into separate rule for education? needs separate year_last as well
    	
    	// TODO split rule so that first segment between 1830 and birth is de-emphasised but still acts as a guide. just thinner atm but will look at other possible styling.
    	
      Plot.ruleY(data, { 
      	x1:1830, // TODO variable not hard coding? in case anything earlier gets added to the database... or just filter the data.
      	x2:"bn_dob_yr", 
      	y: "person_label", 
      	//dy:-6, // if separate
      	stroke: "lightgray" , 
      	strokeWidth: 1,
      channels: {yob: 'bn_dob_yr', "year":"year"}, sort: {y: 'yob'} // only need to do this once
      }),
      
      Plot.ruleY(data, {
      	x1:"bn_dob_yr", 
      	x2:"year_last", 
      	y: "person_label", 
      	//dy:-6, // if separate
      	stroke: "lightgray" , 
      	strokeWidth: 2,
      
      }),
      
    
    //  VERTICAL RULES
    
    	// this should be *after* left-most Y rule 
      Plot.ruleX([1830]), // makes X start at 1830. TODO earliest_year rather than hard coded? but needs to be 0 (or 5). leave it for the moment.
      
    // notable degree dates (1920 etc) highlight? hmm.
    // TODO tip/label of some sort.
     // Plot.ruleX([1878], {stroke:"pink"}), // UoL degrees. 
      Plot.ruleX([1920], {stroke: "lightgreen"}), // oxford
    //  Plot.ruleX([1948], {stroke: "lightblue"}), // cambridge
      
      
      // DOTS
      
 			// educated at fill years for start/end pairs. draw BEFORE single points.
 			// Q is there any way to do this so the fill looks like joined up lines rather than dots? esp. as spacing is different in the two views
 			
      Plot.dot(
      	data, {
      	x: "year", 
      	y: "person_label" , 
      	filter: (d) => d.year_type=="filled",
      	dy:-6,
      	symbol: "year_type",
      	fill:"year_type",
      	r:4,
      	tip:false, // don't want tooltips for these!
       }
      ),
    	
			// educated at single points (point in time, start/end, latest)
      Plot.dot(
      	data, {
      	x: "year", 
      	y: "person_label" , 
      	fill: "year_type",
      	symbol: "year_type",
      	filter: (d) =>  d.year_type !="filled"  &	d.src=="educated", 
      	dy:-6, // vertical offset. negative=above line.
      	// tips moved to Plot.tip
    	}), // /dot
 
      // degrees
      Plot.dot(
      	data, {
      	x: "year", 
      	y: "person_label" , 
      	fill: "year_type",
      	symbol: "year_type",
      	filter: (d) =>	d.src!="educated" , 
      	dy:6, // vertical offset. negative=above line.

      // tooltip stuff moved

    	}), // /plot.dot
    	
    	// year of birth dot (by years chart only)
    	Plot.dot(
      	data, {
      	x: "bn_dob_yr", 
      	y: "person_label" , 
      	//dx: 6, // oops putting this here moves the dot not the tip!
      	channels: {
      		"year of birth":"bn_dob_yr", 
      		} , 
      // tooltip
  			tip: {
    			format: {
    				x: false, // added channel for label.
      			y: false, // now need to exclude this explicitly
    				"year of birth": (d) => `${d}`,
    			},
  				anchor: "right", 
  				dx: -3,
  		  }
    	}), // /dot

      
      // TOOLTIPS
      
      // tip degrees
    	Plot.tip(data, Plot.pointer({
    			x: "year", 
    			y: "person_label", // can you really not give this a label?
      	  filter: (d) =>  d.year_type !="filled"  &	d.src=="degrees", 
    			anchor:"top-left",
    			//frameAnchor:"right",
    			dx:6,
    			dy:6,
    			channels: {
      		//woman: "person_label",
    			"event type":"src",
    			"event year": "year",
      		"year of birth":"bn_dob_yr", 
      		"age at event":"age",
      		where:"by_label",
      		qualification:"degree_label", 
      		} , 
      		format: {
      			x:false, 
      			y:false,
      			//woman: true,
      			// make these go first, do formatting
      			"event type":true,
      			"event year": (d) => `${d}`, 
      			"year of birth": (d) => `${d}`,
      			}
    			}
    		)	
    	), // /tip
      
      // tip education negative offset
    	Plot.tip(data, Plot.pointer({
    			x: "year", 
    			y: "person_label", // can you really not give this a label?
      	  filter: (d) =>  d.year_type !="filled"  &	d.src=="educated",  // no tips on filled years!
    			anchor:"top-right",
    			dx:-6,
    			dy:-6,
    			channels: {
      		//woman: "person_label",
    			"event type":"src",
    			"event year": "year",
      		"year of birth":"bn_dob_yr", 
      		"age at event":"age",
      		where:"by_label",
      		qualification:"degree_label", 
      		} , 
      		format: {
      			x:false, 
      			y:false,
      			//woman: true,
      			// make these go first, do formatting
      			"event type":true,
      			"event year": (d) => `${d}`, 
      			"year of birth": (d) => `${d}`,
      			}
    			}
    		)	
    	), // /tip
    ]  // /marks
  });
};



// BY AGE


export function educatedAgesChart(data, {width}) {

  return Plot.plot({
    title: plotTitle, // "higher education and age (ordered by date of birth)",
    width,
    height: plotHeight,
    marginTop: plotMarginTop,
    marginLeft: plotMarginLeft,
    
    
    x: {
    	grid: true, 
    	//padding:20, // does nothing
    	//label: "age at event", // using Plot.axis instead 
    	//axis: "both" // "both" top and bottom of graph. null for nothing.
    	}, 
    y: {label: null}, // this affects tooltip label too  
    //symbol: symbol_time,
    symbol: {legend:true, 
    				range: ["triangle", "diamond2", "diamond2", "star", "square"], 
						domain: ["point in time", "start time", "end time", "latest date", "filled"]
		},
    color: color_time,
    marks: [
    	
    	// NEAR REPETITION
    	Plot.axisX({anchor: "top", 
      						label: "age at event", 
      						tickFormat: d3.format('d')}
      						),
      Plot.axisX({anchor: "bottom", 
      						label: "age at event", 
      						tickFormat: d3.format('d')}
      						),
       
      Plot.ruleY(data, {
      	x1:10, 
      	x2:"age_last", 
      	y: "person_label", 
      	stroke: "lightgray" , 
      	strokeWidth: 2,
      channels: {yob: 'bn_dob_yr', "year":"year"}, sort: {y: 'yob'}
      }),
      
      // this should be after (on top of) leftmost ruleY
      Plot.ruleX([10]), // makes X start at 0.
 
 			// educated at fill years, no tips. draw before single points.
      Plot.dot(
      	data, {
      	x: "age", 
      	y: "person_label" , 
      	//filter: (d) => d.date_pairs=="2 both", //keeps start and end as well
      	filter: (d) => d.year_type=="filled",
      	dy:-6,
      	symbol: "year_type",
      	fill:"year_type",
      	r:4,
      	tip:false,
       }
      ),
      
			// educated at single points
      Plot.dot(
      	data, {
      	x: "age", 
      	y: "person_label" , 
      	fill: "year_type",
      	symbol: "year_type",
      	filter: (d) =>  d.year_type !="filled"  & d.src=="educated", 
      	dy:-6, // vertical offset. negative=above line.
    	}), // /dot
    	
      // degrees
      Plot.dot(
      	data, {
      	x: "age", 
      	y: "person_label" , 
      	fill: "year_type",
      	symbol: "year_type",
      	filter: (d) =>	d.src!="educated" , 
      	dy:6, // vertical offset. negative=above line.
      // tooltip -> Tip

    	}), // /dot
    	
    	      // TOOLTIPS
      
      // tip degrees
    	Plot.tip(data, Plot.pointer({
    			x: "age", 
    			y: "person_label", // can you really not give this a label?
      	  filter: (d) =>  d.year_type !="filled"  &	d.src=="degrees", 
    			anchor:"top-left",
    			dx:6,
    			dy:6,
    			channels: {
      		//woman: "person_label",
    			"event type":"src",
    			"event year": "year",
      		"year of birth":"bn_dob_yr", 
      		"age at event":"age",
      		where:"by_label",
      		qualification:"degree_label", 
      		} , 
      		format: {
      			x:false, 
      			y:false,
      			//woman: true,
      			// make these go first, do formatting
      			"event type":true,
      			"event year": (d) => `${d}`, 
      			"year of birth": (d) => `${d}`,
      			}
    			}
    		)	
    	), // /tip
      
      // tip education negative offset
    	Plot.tip(data, Plot.pointer({
    			x: "age", 
    			y: "person_label", // can you really not give this a label?
      	  filter: (d) =>  d.year_type !="filled"  &	d.src=="educated", // no tips on filled years!
    			anchor:"top-right",
    			dx:-6,
    			dy:-6,
    			channels: {
      		//woman: "person_label",
    			"event type":"src",
    			"event year": "year",
      		"year of birth":"bn_dob_yr", 
      		"age at event":"age",
      		where:"by_label",
      		qualification:"degree_label", 
      		} , 
      		format: {
      			x:false, 
      			y:false,
      			//woman: true,
      			// make these go first, do formatting
      			"event type":true,
      			"event year": (d) => `${d}`, 
      			"year of birth": (d) => `${d}`,
      			}
    			}
    		)	
    	), // /tip
    		
    ] // /marks
  });
}



// channels to reference more data variables; can be called anything
// seems clunky to make y label empty then define same variable as a channel for tooltip then exclude y again! 


