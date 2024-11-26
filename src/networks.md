---
theme: dashboard
title: Networks
---


# Women's networks

VERY PROVISIONAL. lots of work to do.

including:

- improve colours and add a legend
- adjust initial zoom setting
- slightly slower/smoother transitions
- adjust collision
- link weight = width of lines, varies with network viewed
- link weight filter (and other things) varies with network being viewed
- toggle node size between degree and betweenness centrality (maybe)
- add all the credits


```js
//adjustment with flatmap seems to work here...
//start with both selected 

const pickGroup = view(
		Inputs.radio(
				["both"].concat(data.nodes.flatMap((d) => d.groups)),
				{
				label: "network", 
				value: "both", // default is both.
				sort: true, 
				unique: true
				}
		)
)
```



```js 
//slider - link weights. *after picking a group*. (although atm won't make any difference to min and max). when you switch networks it always resets to 1.

// get min and max for slider range
const minWeight = d3.min(groupData.links.map(d => d.weight));
const maxWeight = d3.max(groupData.links.map(d => d.weight))

const weightConnections = view(
	Inputs.range(
		[minWeight, maxWeight], {
  		label: "Minimum link weight",
  		step: 1,
  		value: 1 // default to min 1
		}
	)
)
```




<div class="card">
    ${resize((width) => chartHighlight(weightData, {width}))}
</div>



About the graph options, measures, etc

- Nodes are coloured according to whether a node was in both networks, events only, or committees only
- "Link weight" is the number of connections made between a pair of nodes
- Node size reflects the number of nodes a node is connected to ("degree") (but see note below)
- "Appearances" (in tooltips) measures the number of events/committees appeared in (the relationship between degree and appearances can vary considerably depending on the size of an event/committee or duration of service)


Completely isolated nodes were removed from the network. 

NB re node size: these are rescaled so that nodes with a *very* large number of connections are reduced a bit and modes with very few are a minimum size (otherwise they'd be barely visible). 


```js
// can't use <div class="grid grid-cols-1"> as usual, overflows instead of cropping; find out how to fix problem... though it seems ok without it?
```

About the network(s)

created from
- events data as analysed at [BN Notes events analysis](https://beyond-notability.github.io/bn_notes/posts/events-2024-02-26/)
- committees analysis - TODO add BN Notes link.

slightly different criteria for association for the two networks - reflects different nature of activity but might make comparability questionable

- to make a link for events: requires attendance at the same event (same date)
- to make a link for committees: same organisation in the same year (note concept of a "service year"). making two assumptions: a) service can be more ongoing than attending an event, and b) implies a stronger engagement with the organisation and other members. (but for large organisations (like SAL or RAI) this could be a riskier assumption.)



*association networks* 

- this type of network is created by connecting nodes that belong to a "group", rather than from direct *interactions* (like senders and recipients of letters)
- this involves some potentially risky assumptions; eg just because two people went to the same conference doesn't necessarily mean they knew each other
	- [there is interesting stuff about this from research on [animal networks](https://dshizuka.github.io/networkanalysis/networktypes_socialnetworks.html#constructing-networks-from-associations)]



Credits
- [d3 force-directed graph for disconnected graphs](https://observablehq.com/@asgersp/force-directed-graph-disjoint) (designed to "prevent detached subgraphs from escaping the viewport")

more to add




```js

const groupNodes =
data.nodes
  .filter((d) =>  
  		pickGroup === "both" ||  	
  		d.groups.some((m) => pickGroup.includes(m)) // why m rather than d? no obvious difference. 
  		)
  .map((d) => ({...d})) //is this necessary?

  
// is this enough or do i need the extra step used in connectionsData?
// if not why not?

const groupLinks = data.links.filter(
    (l) =>
      groupNodes.some((n) => n.id === l.source) &&
      groupNodes.some((n) => n.id === l.target)
  );

const groupData = {nodes:groupNodes, links: groupLinks}
```




```js
// links and nodes data for slider.  output = weightData

const weightLinks = groupData.links.filter(l => l.weight >= weightConnections);
const weightNodes = groupData.nodes.filter((n) =>
    weightLinks.some((l) => l.source === n.id || l.target === n.id)
  );
const weightData = {nodes: weightNodes, links: weightLinks}

```



```js

function groupDegree(g) {
  if (pickGroup === "committees") {
    return d => d.committees_degree;
      } else if (pickGroup === "events") {
    return d => d.events_degree;
      } else {
		return d => d.both_degree;	
      }
  	}	


function degreeRadius(r) {
  if (pickGroup === "committees") {
    return d => getRadius(d.committees_degree);
      } else if (pickGroup === "events") {
    return d => getRadius(d.events_degree);
      } else {
		return d => getRadius(d.both_degree);	
      }
  	}	
  	
```


```js

function chartHighlight(chartData) {

const height = 600


  const links = chartData.links.map(d => Object.create(d));
  const nodes = chartData.nodes.map(d => Object.create(d));
  
    // Create the SVG container.

  
  const svg = d3.create("svg")
      .attr("width", width)
      .attr("height", height)
//      .attr("viewBox", [0, 0, width, height])
      .attr("viewBox", [-width / 2, -height / 2, width, height]) // positioning within the box
      .attr("style", "max-width: 100%; height: auto;");
  
  
  // create link reference
  let linkedByIndex = {};
  data.links.forEach(d => {
    linkedByIndex[`${d.source},${d.target}`] = true;
  });
  
  // nodes map
  let nodesById = {};
  data.nodes.forEach(d => {
    nodesById[d.id] = {...d};
  })

  const isConnectedAsSource = (a, b) => linkedByIndex[`${a},${b}`];
  const isConnectedAsTarget = (a, b) => linkedByIndex[`${b},${a}`];
  const isConnected = (a, b) => isConnectedAsTarget(a, b) || isConnectedAsSource(a, b) || a === b;
  const isEqual = (a, b) => a === b;
  // todo?
  //const nodeRadius = d => 15 * d.support;


/*
// https://stackoverflow.com/a/66673220/7281022
Let's say that you want your initial position and scale to be x, y, scale respectively.

const zoom = d3.zoom();

const svg = d3.select("#containerId")
    .append("svg")
    .attr("width", width)
    .attr("height", height)
    .call(zoom.transform, d3.zoomIdentity.translate(x, y).scale(scale)
    .call(zoom.on('zoom', (event) => {
        svg.attr('transform', event.transform);
     }))
    .append("g")
    .attr('transform', `translate(${x}, ${y})scale(${k})`);

.call(zoom.transform, d3.zoomIdentity.translate(x, y).scale(scale) makes sure that when the zoom event is fired, the event.transform variable takes into account the translation and the scale. The line right after it handles the zoom while the last one is used to apply the translation and the scale only once on "startup".


agents

  const root = svg.append("g").attr("id", "root");
  
  const transform = d3.zoomIdentity.translate(0, 0).scale(zoomLevel);
  
  root.attr("transform", transform);


*/


  const baseGroup = svg.append("g");
  
  function zoomed() {
    baseGroup.attr("transform", d3.zoomTransform(this));
  }

  const zoom = d3.zoom()
  	//.extent([[0,0],[500,300]]) // ?
    .scaleExtent([0.2, 8]) // limits how far in/out you can zoom.
    .on("zoom", zoomed);
  
  svg.call(zoom);
  
  let ifClicked = false;

  const simulation = d3.forceSimulation()
    .force("link", d3.forceLink().id( function(d) { return d.id; } ).strength(0.3)) 
		.force("charge", d3.forceManyBody().strength(-300) ) //
		.force("center", d3.forceCenter( 0,0 ))
		
		// avoid (or reduce) overlap. TODO work with degreeRadius... not sure how
		.force("collide", d3.forceCollide().radius(d => getRadius(d) + 30).iterations(2))  
     
      .force("x", d3.forceX())
      .force("y", d3.forceY())
      ;
      
		

  const link = baseGroup.append("g")
      .selectAll("line")
      .data(links)
      .join("line")
      //.classed('link', true) // aha now width works.
      .attr("stroke", "#bdbdbd") 
      .attr("stroke-opacity", 0.4) // is this working? works with attr instead of style
      .attr("stroke-width", d => d.value) ;
          
      
  

  const node = baseGroup.append("g")
      .selectAll("circle")
      .data(nodes)
      .join("circle")
      .classed('node', true)
      .attr("r", degreeRadius(d=>d))
      //.attr("r", d => getRadius(d.degree/2)) // can tweak.
      //.attr("fill", clustering(d => d)) 
      .attr("fill", d => color(d.group))  
      .style("fill-opacity", 0.6)  
      .call(drag(simulation)); // this is what was missing for drag...
       

    
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
// original chart
// https://richardbrath.wordpress.com/2018/11/24/using-font-attributes-with-d3-js/
 
function chart(data) {

const height = 900;
const color = d3.scaleOrdinal(d3.schemeCategory10);

  // The force simulation mutates links and nodes, so create a copy
  // so that re-evaluating this cell produces the same result.
  const links = data.links.map(d => ({...d}));
  const nodes = data.nodes.map(d => ({...d}));

  // Create a simulation with several forces.
  const simulation = d3.forceSimulation(nodes)
      .force("charge", d3.forceManyBody())
      .force("link", d3.forceLink(links).id(d => d.id))
      .force("charge", d3.forceManyBody().strength(-300)) // .distanceMin(10)
      .force("center", d3.forceCenter(0, 0))
      .force("x", d3.forceX())
      .force("y", d3.forceY());
      
      
     

  // Create the SVG container.
  const svg = d3.create("svg")
      //.attr("width", width)
      //.attr("height", height)
      //.attr("style", "max-width: 100%; height: auto;")
      .attr("viewBox", [-width / 2, -height / 2, width, height]) ;

  // Add a line for each link, and a circle for each node.
  const link = svg.append("g")
    .attr("stroke", "#999")
    .attr("stroke-opacity", 0.4)
    .selectAll("line")
    .data(links)
    .join("line")
    .attr("stroke-width", d => d.value); // width of lines
      //.attr("stroke-width", d => Math.sqrt(d.value))

	// circles
  const node = svg.append("g")
    .attr("stroke", "#fff")
    .attr("stroke-width", 1)
    .selectAll("circle")
    .data(nodes)
    .join("circle")
      .attr("r", d => getRadius(d.n_event))
      //.attr("r", d => d.n_event)
      .attr("fill", d => color(d.grp3))   
      .style("fill-opacity", 0.5)
      
     // change opacity on hovering. 
     .on("mouseover",function(){
      const target = d3.select(this)
      target.style("fill-opacity", 0.8)
      })
    .on("mouseout",function(){
      const target = d3.select(this) 
      target.style("fill-opacity", 0.5)
      })
      
      .call(drag(simulation));


	// labels
  const text = svg.append("g")
    .attr("class", "labels")
    .selectAll("text")
    .data(nodes)
    .enter().append("text")
    .attr("dx", d => d.x)
    .attr("dy", d => d.y)
    .attr("opacity", 0.8)
    .attr("font-family", "Arial")
    .style("font-size","13px")
    .text(function(d) { return d.name_label })
    .call(drag(simulation));

  
  
  // tooltips
  node.append("title")
      .text(d => d.id);
      
  
  // Set the position attributes of links and nodes each time the simulation ticks.

  simulation.on("tick", () => {
    link
        .attr("x1", d => d.source.x)
        .attr("y1", d => d.source.y)
        .attr("x2", d => d.target.x)
        .attr("y2", d => d.target.y);

    node
        .attr("cx", d => d.x)
        .attr("cy", d => d.y);
    
    text
        .attr("dx", d => d.x)
        .attr("dy", d => d.y);
  });

  invalidation.then(() => simulation.stop());

  svg.call(d3.zoom()
      .extent([[0, 0], [width, height]])
      .scaleExtent([0.2, 10])
      .on("zoom", zoomed));

// https://stackoverflow.com/a/71011116/7281022
// zoomTransform(this) rather than transform 
  function zoomed() {
  	//svg.attr("transform", d3.zoomTransform(this));
    node.attr("transform", d3.zoomTransform(this));
    link.attr("transform", d3.zoomTransform(this));
    text.attr("transform", d3.zoomTransform(this));
  }  
  
  //display(svg.node() );
  
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

function getRadius(useCasesCount){
		var	m=useCasesCount/3
		var d=3/useCasesCount
  if(useCasesCount>=6){   
  	var radius = m+d  
    return radius
  }
  return 6
}


const color = d3.scaleOrdinal(d3.schemeCategory10);
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
// editables if any

```


```js
// Import components. importing chart is complicated!
import {drag} from "./components/networks.js";
```



```js
const json = FileAttachment("./data/l_networks_two/bn-two-networks.json").json();

```




```js
// prepare data
// it feels like there ought to be a better way to add *_degree and suchlike to be usable, but this is the one I can work out how to do so.
const dataNodes =
json.nodes
  .map((d) => (
  	{...d, 
  		both_degree: d.all[0].degree ,
  		events_degree: (d.events[0] != undefined) ? d.events[0].degree : [] ,
  		committees_degree: (d.committees[0] != undefined ) ? d.committees[0].degree : []	 
  })) 


const dataLinks = json.links

const data = {nodes: dataNodes, links: dataLinks}
```





