---
theme: dashboard
title: Networks
---


# Women's networks

*this is a work-in-progress data essay*

[still bits of work to do; see list below. but mostly done now.]

Creating linked data implies analysing networks, and analysing networks when DH researchers are involved implies making network graphs. Despite this, BN has made remarkably few attempts at analysing networks using network analysis - including network visualisation - techniques. Why? Because we had other proxies for networks: co-habitation, co-education, signatories on letters of nomination, local connections, work together on excavations. But as we started experimenting with ways to visualise data in our wikibase, one area that seemed particularly amenable to visualisation were networks relating to event participation and committee membership.

## Wrangling the data

- 'Event participation' bucket https://beyond-notability.github.io/bn_notes/posts/events-2024-02-26/ : most 'spoke at' and 'exhibited at', but includes event attendance and organistion.
- 'Committee': this is 'served on'. 

Making these into networks required slightly different criteria for association for the two networks - reflects different nature of activity but might make comparability questionable

- to make a link for events: requires attendance at the same event (same date)
- to make a link for committees: same organisation in the same year (note concept of a "service year"). making two assumptions: a) service can be more ongoing than attending an event, and b) implies a stronger engagement with the organisation and other members. (but for large organisations (like SAL or RAI) this could be a riskier assumption.). not sub-committee.

## Visualising the network 

About the graph options, measures, etc

- Nodes are coloured according to whether a node was in both networks, events only, or committees only
- "Link weight" is the number of connections between a pair of nodes. Default 2.
- Node size reflects the number of connections a node has ("degree") (but see note below)
- "Appearances" (in tooltips) measures the number of events/committees appeared in (the relationship between degree and appearances can vary considerably depending on the size of an event/committee or duration of service)

Completely isolated nodes were removed from the network. 

NB re node size: these are rescaled so that nodes with a *very* large number of connections are reduced a bit and modes with very few are a minimum size (otherwise they'd be barely visible). 

```js
//FILTERS CODE 
```
```js
//select network: start with both selected 
const pickGroup = view(
		Inputs.radio(
				["both"].concat(data.nodes.flatMap((d) => d.groups)),
				{
				label: "select network", 
				value: "both", // default is both.
				sort: true, 
				unique: true
				}
		)
)
```
```js 
//slider for min link weight. *after picking a group*. 
//when you switch networks it always resets to 1. idk if this can be chagned

// get min and max for slider range
const minWeight = d3.min(groupData.links.map(d => d.weight));
const maxWeight = d3.max(groupData.links.map(d => d.weight))

const weightConnections = view(
	Inputs.range(
		[minWeight, maxWeight], {
  		label: "minimum link weight",
  		step: 1,
  		value: 2 // default to min 2
		}
	)
)
```
```js
//legend (standalone)
//https://observablehq.com/d/a23f6e59f1380df0

Plot.legend({
  color: {
    domain: colourDomain, 
    range: colourRange ,
    alpha: 0.8
  },
 // legend: "swatches",
  //className: "alphabet",
  swatchSize: 15,

})

```
```js
// END OF FILTERS CODE.
```


<div class="card">
    ${resize((width) => chartHighlight(weightData, {width}))}
</div>

## Reading a network

This is maths + visual reorganisation to make it easier for us to see. Specifically, [d3 force-directed graph for disconnected graphs](https://observablehq.com/@asgersp/force-directed-graph-disjoint) (designed to "prevent detached subgraphs from escaping the viewport") As Ahnerts show, don't need network viz to analyse networks. So when we do, important to consider what we are actually doing: analysing a series of choices about modelling of historical reality (see [Education](https://beyond-notability.github.io/beyond-notability-observable-essays/education.html#modelling-education) post) through a series of mathemetical choices to organise that modelling as a network *and* a series of presentational choices re representing that modelling as a network. Got that. Good. Then we'll move on. So, what does it seem to be telling us:

- networks of women in arch/hist/heri dominated by those who were both in committees and went to events, with a sub-network centred on Gomme and Goodrich-Fyer
- those only on committees then closely connected to that network.
- those only recorded at events then form the periphery.
- no bridges between discrete networks: there is a centre, a periphery, and then isolated networks.
- toggle to 'events' and then 'committees' that becomes more obvious, though MVT emerges as a bridge between a big node link Kenyon and people like Wheeler, Graham, Liddle and Lamb --- intergenerational node (?)

Thing is, if you change the data on the graph then different stories emerge. For example, set min link weight to one and zoom out a little, you see a big ball, with large nodes on one side, smaller nodes on other, and a mass of one-time connection event nodes. Here the interactive nature of our viz enables interpretation of bridges. For example hover on 'Margaret Alice Murray', and look at the leftward connection to Charlotte Sophia Burne and rightward connection to Kathleen Mary Kenyon. Reaches to the heart of two separate networks. And if you hover on Charlotte Sophia Burne you see that Murray is her only connection into the "main" network. Burne then seems an important bridge.

(add something here on burne)

## Association 

But what does this networking mean? What holds it together in reality?

Switch to events network. Move to link weight 8. Jessie MacGregor https://beyond-notability.wikibase.cloud/wiki/Item:Q970 and Rosa Wallis https://beyond-notability.wikibase.cloud/wiki/Item:Q508 connected. Why? Royal Ac Summer Exhit. So this is an *association* network. This type of network is created by connecting nodes that belong to a "group", rather than from direct *interactions* (like senders and recipients of letters, which historians are used to). This involves some potentially risky assumptions; eg just because two people went to the same conference doesn't necessarily mean they knew each other (there is interesting stuff about this from research on [animal networks](https://dshizuka.github.io/networkanalysis/networktypes_socialnetworks.html#constructing-networks-from-associations)). Weak at best. Proxy for association.



Credits 
- [Force-Directed Graph, Disjoint](https://observablehq.com/@asgersp/force-directed-graph-disjoint)
- [Network Graph with d3.force grouping (for highlighting)](https://observablehq.com/@ravengao/force-directed-graph-with-cola-grouping )
- [D3 Force-Directed Graph with Input](https://observablehq.com/@asgersp/d3-force-directed-graph-with-input)
- [Drag Queens Netwerk Diagram](https://observablehq.com/d/f3941ff4743f26e3)
- [Agents Network Visualisation](https://observablehq.com/@jmiguelv/radical-translations-agents-network-visualisation)
- [Marvel Network](https://observablehq.com/@jrladd/marvel-network)
- [Plot: Legends](https://observablehq.com/d/a23f6e59f1380df0)


TODO

- more info in tooltips
- toggle node size between degree and betweenness centrality (maybe) (will need to use rankings rather than measures, might not work)
- adjust initial zoom setting (still a mystery)
- slightly slower/smoother transitions (ditto)
- minor niggle: how to put the filters/legend in the same div as the chart (or make them look as though they are)

done
- add all the credits
- as a sort of workaround for the zoom, changed default min link weight to 2, which gives better initial view 
- adjust collision - I *think* this is working better
- transitions are a bit better
- improve colours and add a legend
- fixed some filtering errors (may not actually affect appearance of chart)
	- really fixed them this time!
- link weight = width of lines, varies with network viewed
- link weight filter (and other things) varies with network being viewed






```js
// REST OF THE CODE STARTS HERE - don't edit anything after this point.
```


```js 
// set up colour for chart and legend

const  colourDomain = ["both", "committees", "events"];
const  colourRange = ['#77AADD', '#BB5566',  '#F1932D'];
```



```js
// make the chart

function chartHighlight(chartData) {

const height = 700


  const links = chartData.links.map(d => Object.create(d));
  const nodes = chartData.nodes.map(d => Object.create(d));
  
  
// Create the SVG container.

  const svg = d3.create("svg")
      .attr("width", width)
      .attr("height", height)
      .attr("viewBox", [-width / 2, -height / 2, width, height]) // positioning within the box
      .attr("style", "max-width: 100%; height: auto;");
  

// link connections

// need to use the right data here!!! honestly sharon.

  // create link reference
  let linkedByIndex = {};
  
  chartData.links.forEach(d => {
    linkedByIndex[`${d.source},${d.target}`] = true;
  });
  
  // nodes map
  let nodesById = {};
  chartData.nodes.forEach(d => {
    nodesById[d.id] = {...d};
  })

  const isConnectedAsSource = (a, b) => linkedByIndex[`${a},${b}`];
  const isConnectedAsTarget = (a, b) => linkedByIndex[`${b},${a}`];
  const isConnected = (a, b) => isConnectedAsTarget(a, b) || isConnectedAsSource(a, b) || a === b;
  const isEqual = (a, b) => a === b;


// start to draw stuff

  const baseGroup = svg.append("g");
 
// zoom function
 
  function zoomed() {
    baseGroup.attr("transform", d3.zoomTransform(this));
  }

  const zoom = d3.zoom()
    .scaleExtent([0.2, 8]) // limits how far in/out you can zoom.
    .on("zoom", zoomed);
  
  svg.call(zoom);
  
  let ifClicked = false;

// feel the force

  const simulation = d3.forceSimulation()
    .force("link", d3.forceLink().id( function(d) { return d.id; } ).strength(0.3)) 
		.force("charge", d3.forceManyBody().strength(-150) ) //
		.force("center", d3.forceCenter( 0,0 ))
		
		// avoid (or at least reduce) overlap.
		.force("collide", d3.forceCollide().radius(d => getRadius(d) + 30).iterations(2))  
     
      .force("x", d3.forceX(0.7))
      .force("y", d3.forceY(0.7))
      ;
      

// lines between nodes		

  const link = baseGroup.append("g")
      .selectAll("line")
      .data(links)
      .join("line")
      .attr("stroke", "#bdbdbd") 
      .attr("stroke-opacity", 0.4)
      .attr("stroke-width", d => d.weight) ;  // width of lines = link weight
          
      
// the circles  

  const node = baseGroup.append("g")
      .selectAll("circle")
      .data(nodes)
      .join("circle")
      .attr("r", d => getRadius(d.degree)) // check getRadius
      .attr("fill", d => colour(d.group))  
      //.style("fill-opacity", 0.7)  
      .attr("stroke", "black")
      .attr("stroke-width", 0.5)
      .call(drag(simulation)); 
       

    
// text labels 
  // stuff has to be added in several places after this to match node and link.
 
 	const text = baseGroup.append("g")
    //.attr("class", "labels")
    .selectAll("text")
    .data(nodes)
    .join("text")
    .attr("dx", d => d.x)
    .attr("dy", d => d.y)
    
    .attr("opacity", 0.8)
    .attr("font-family", "Arial")
    .style("font-size","13px")
    .text(function(d) { return d.name })
    .call(drag(simulation));
     
  
  function ticked() {
    link
        .attr("x1", function(d) { return d.source.x; })
        .attr("y1", function(d) { return d.source.y; })
        .attr("x2", function(d) { return d.target.x; })
        .attr("y2", function(d) { return d.target.y; });

    node
        .attr("cx", function(d) { return d.x; })
        .attr("cy", function(d) { return d.y; });    
    
    text 
        .attr("dx", d => d.x)
        .attr("dy", d => d.y);
        
  }


  simulation
      .nodes(nodes)
      .on("tick", ticked);

  simulation.force("link")
      .links(links);


// functions to highlight connected nodes  
  
  const mouseOverFunction = (event, d) => {
    tooltip.style("visibility", "visible")
    .html(() => {
        const content = `${d.name}<br/>${d.nn} appearances`;
        return content;
      });

    if (ifClicked) return;

    node
      .transition(500)
        .style('opacity', o => {
          const isConnectedValue = isConnected(o.id, d.id);
          if (isConnectedValue) {
            return 1.0;
          }
          return 0.1;
        });

    link
      .transition(500)
        .style('stroke-opacity', o => {
        console.log(o.source === d)
      return (o.source === d || o.target === d ? 1 : 0.1)})
        .transition(500)
        .attr('marker-end', o => (o.source === d || o.target === d ? 'url(#arrowhead)' : 'url()'));
        
    text
      .transition(500)
        .style('opacity', o => {
          const isConnectedValue = isConnected(o.id, d.id);
          if (isConnectedValue) {
            return 1.0;
          }
          return 0.1;
        });
        
  };

  const mouseOutFunction = (event, d) => {
  
    tooltip.style("visibility", "hidden");

    if (ifClicked) return;

    node
      .transition(500)
      .style('opacity', 1);

    link
      .transition(500)
      .style("stroke-opacity", o => {
        console.log(o.value)
      });

	 	text
      .transition(500)
      .style('opacity', 1);




  };
  
  
  const mouseClickFunction = (event, d) => {
  
    // we don't want the click event bubble up to svg
    event.stopPropagation();
    
    ifClicked = true;
    
    node
      .transition(500)
      .style('opacity', 1)

    link
      .transition(500);
      
    text
      .transition(500)
      .style('opacity', 1)
 
 
    node
      .transition(500)
        .style('opacity', o => {
          const isConnectedValue = isConnected(o.id, d.id);
          if (isConnectedValue) {
            return 1.0;
          }
          return 0.1
        })

    text
      .transition(500)
        .style('opacity', o => {
          const isConnectedValue = isConnected(o.id, d.id);
          if (isConnectedValue) {
            return 1.0;
          }
          return 0.1
        })


    link
      .transition(500)
        .style('stroke-opacity', o => (o.source === d || o.target === d ? 1 : 0.1))
        .transition(500)
        .attr('marker-end', o => (o.source === d || o.target === d ? 'url(#arrowhead)' : 'url()'));
        
  };
  
  
  node.on('mouseover', mouseOverFunction)
      .on('mouseout', mouseOutFunction)
      .on('click', mouseClickFunction)
      .on('mousemove', (event) => tooltip.style("top", (event.pageY-10)+"px").style("left",(event.pageX+10)+"px"));
  
  svg.on('click', () => {
    ifClicked = false;
    node
      .transition(500)
      .style('opacity', 1);

    link
      .transition(500)
      .style("stroke-opacity", 0.5)

    text
      .transition(500)
      .style('opacity', 1);
    
    
  });

  invalidation.then(() => simulation.stop());

  return svg.node();
}

```










```js
const tooltip = d3.select("body").append("div")
  .attr("class", "svg-tooltip")
    .style("position", "absolute")
    .style("visibility", "hidden")
    .text("I'm a circle!");
```



```js
// 
function getRadius(useCasesCount){
		var	m=useCasesCount/3
		var d=3/useCasesCount
  if(useCasesCount>=6){   
  	var radius = m+d  
    return radius
  }
  return 6
}


//changed
const colour = d3.scaleOrdinal(colourDomain, colourRange);

```




```js 
html
`<style>         
    .node {
        stroke: #f0f0f0;
        stroke-width: 0px;
    }

    .link {
        stroke: #999;
        stroke-opacity: .4;
        stroke-width: 0.5;
    }

    .group {
        stroke: #fff;
        stroke-width: 1.5px;
        fill: #fff;
        opacity: 0.05;
    }
    .svg-tooltip {
     // font-family: -apple-system, system-ui, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif, "Apple   Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol";
      background: rgba(69,77,93,.9);
      border-radius: .1rem;
      color: #fff;
      display: block;
      font-size: 12px;
      max-width: 320px;
      padding: .2rem .4rem;
      position: absolute;
      text-overflow: ellipsis;
      white-space: pre;
      z-index: 300;
      visibility: hidden;
    }

    svg {
       // background-color: #333;
    }
</style>`
```






```js
// Import components. importing chart is complicated!
import {drag} from "./components/networks.js";
```




```js
// DATA //
```



```js
// data from R processing
const json = FileAttachment("./data/l_networks_two/bn-two-networks.json").json();

```




```js
// prepare data for first filter
// it feels like there ought to be a better way to add *_degree and suchlike to be usable, but this is the one I can work out how to do so.

const dataNodes =
json.nodes
  .map((d) => (
  	{...d, 
  		both_degree: d.all[0].degree ,
  		events_degree: (d.events[0] != undefined) ? d.events[0].degree : [] ,
  		committees_degree: (d.committees[0] != undefined ) ? d.committees[0].degree : []	 
  })) 

// don't need to do anything to json.links at this stage

const data = {nodes: dataNodes, links: json.links}
```





```js
// choosing your network
const groupNodes =
data.nodes
  .filter((d) =>  
  		pickGroup === "both" ||  	
  		d.groups.some((m) => pickGroup.includes(m)) 
  		)
  		// select the right degree for the network.
  .map((d) => ({...d,
  		degree: // can rename this once you get rid of toplevel stuff
			(pickGroup==="committees") ? d.committees_degree :  
			(pickGroup=="events") ? d.events_degree :  
		  d.both_degree  
  })) 

const groupLinks = data.links.filter(
    (l) =>
      groupNodes.some((n) => n.id === l.source) &&
      groupNodes.some((n) => n.id === l.target) &&
      // this looks terrible but i think it works.
      (
      (pickGroup=="both" & (l.group =="both" || l.group=="events" | l.group=="committees") ) || 
      (pickGroup=="events" & (l.group=="both" || l.group=="events")) ||
      (pickGroup=="committees" & (l.group=="both" || l.group=="committees"))
      )
  )
  // select the right weight for the filter.
  .map((d) => ({...d,
  		weight: 
			(pickGroup==="committees") ? d.weight_committees :  
			(pickGroup=="events") ? d.weight_events :  
		  d.weight_both
  }))  ;

const groupData = {nodes:groupNodes, links: groupLinks}
```




```js
// link weights filtering

const weightLinks = groupData.links.filter(l => l.weight >= weightConnections);
const weightNodes = groupData.nodes.filter((n) =>
    weightLinks.some((l) => l.source === n.id || l.target === n.id)
  );
const weightData = {nodes: weightNodes, links: weightLinks}

```



