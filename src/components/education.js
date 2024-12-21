import * as Plot from "npm:@observablehq/plot";
import * as d3 from "npm:d3";

	
// share as much as possible between the two versions of the chart

const colorTime = Plot.scale({
		color: {
			range: ["#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "lightgray"], 
			domain: ["point in time", "start time", "end time", "latest date", "filled"]
		}
	});

// not working as intended; legend disappears. idk why.
const symbolTime = Plot.scale({ 	
    symbol: {legend:true, 
    				range: ["triangle", "diamond2", "diamond2", "star", "square"], 
						domain: ["point in time", "start time", "end time", "latest date", "filled"]
		}
	});
	
const plotMarginTop = 20;
const plotMarginLeft = 180;


const eventLabel = {label: "year of event"}
    	   	
 
// BY DATE   	
    	
export function educatedYearsChart(data, {width}, titleYear, plotHeight) {

  return Plot.plot({
  
    title: titleYear, //"higher education chronology (ordered by date of birth)",
    
    width,
    height: plotHeight,
    marginTop: plotMarginTop,
    marginLeft: plotMarginLeft,
    	
    x: {
    	grid: true, 
    	//tickFormat: d3.format('d'), // overruled by plot.axis
    	//axis: "both" // "both" doesn't work; the label only shows at the bottom...  seems you have to do Plot.axis to get it the way you want.
    	}, 
    	
    y: {label: null}, // this affects tooltip label too  
    
    //symbol: symbolTime, // doesn't show legend...    
    symbol: {legend:true, 
    				range: ["triangle", "diamond2", "diamond2", "star", "square"], 
						domain: ["point in time", "start time", "end time", "latest date", "filled"]
		} ,
    color: colorTime,
    
    marks: [
     
     // NEAR REPETITION
      Plot.axisX({anchor: "top", 
      						label: "year of event", 
      						labelOffset: 35,
      						tickPadding: 8,
      						tickFormat: d3.format('d')}
      						),
      Plot.axisX({anchor: "bottom", 
      						label: "year of event", 
      						tickFormat: d3.format('d')}
      						),
      
      
    	// GUIDE LINES
    	
      Plot.ruleY(data, { 
      	x1:1830, // variable would have been better than hard coding, too late now.
      	x2:"bn_dob_yr", 
      	y: "person_label", 
      	//dy:-6, // if separate
      	stroke: "lightgray" , 
      	strokeWidth: 1,
      channels: {yob: 'bn_dob_yr', "year":"year"}, 
      sort: {y: 'yob'} // only need to do this once, apparently
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
    
    	// this should be *after* left-most Y rule so it sits on top.
      Plot.ruleX([1830]), // makes X start at 1830. 
      
    // notable degree dates highlighted
      Plot.ruleX([1878], {dy:-5, stroke:"#e97451", strokeOpacity: 0.4, strokeWidth:2}), // UoL degrees 1878. 
      Plot.tip([`London`],
      {
      	x: 1878, 
      	frameAnchor:"top", 
        dy: -3, dx:-3, 
      	anchor: "right",  
      	textPadding:2, 
      	fill: null, 
      	}
    ),
      
      Plot.ruleX([1920], {dy:-5, stroke: "#004488", strokeOpacity: 0.2, strokeWidth:2}), // oxford 1920
      Plot.tip([`Oxford`],
      {
      	x: 1920, 
      	frameAnchor:"top", 
        dy: -3, dx:3, 
      	anchor: "left", 
      	textPadding:2, 
      	fill: null, 
      	//stroke: null
      	}
    ),    
      Plot.ruleX([1948], {stroke: "#AA3377", strokeOpacity: 0.2, strokeWidth:2}), // cambridge 1948
      Plot.tip([`Cambridge`],
      {
      	x: 1948, 
      	frameAnchor:"top", 
        dy: -3, dx:3, 
      	anchor: "left", 
      	textPadding:2, 
      	fill: null, 
      	//stroke: null
      	}
    ),         
      
      // DOTS
      
 			// educated at fill years for start/end. draw BEFORE single points.
 			
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
      	dy:6, // vertical offset. positive=below line.

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
    			y: "person_label", 
      	  filter: (d) =>  d.year_type !="filled"  &	d.src=="degrees", 
    			anchor:"top-left",
    			dx:6,
    			dy:6,
    			channels: {
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
    			y: "person_label", 
      	  filter: (d) =>  d.year_type !="filled"  &	d.src=="educated",  // no tips on filled years!
    			anchor:"top-right",
    			dx:-6,
    			dy:-6,
    			channels: {
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


export function educatedAgesChart(data, {width}, titleAge, plotHeight) {

  return Plot.plot({
    title: titleAge, 
    width,
    height: plotHeight,
    marginTop: plotMarginTop,
    marginLeft: plotMarginLeft,
    
    
    x: {
    	grid: true, 
    	//padding:20, // does nothing
    	//label: "age at event", // using Plot.axis instead 
    	//axis: "both" //
    	}, 
    y: {label: null}, // this affects tooltip label too  
    //symbol: symbolTime,
    symbol: {legend:true, 
    				range: ["triangle", "diamond2", "diamond2", "star", "square"], 
						domain: ["point in time", "start time", "end time", "latest date", "filled"]
		},
    color: colorTime,
    marks: [
    	
    	// NEAR REPETITION
    	Plot.axisX({anchor: "top", 
      						label: "age at event", 
      						labelOffset: 35,
      						tickPadding: 8,      
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
    			y: "person_label", 
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
    			y: "person_label", 
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




