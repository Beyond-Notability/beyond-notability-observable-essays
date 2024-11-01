---
theme: dashboard
title: Events networks
---


# Women's events networks

- zoom and drag the whole graph to focus on parts of the network
- drag individual nodes to get a better view of their links.
- only women with at least 3 event attendances have a visible name label, but you can see all the other names on hovering. 



<div class="card">
    ${resize((width) => chart(json, {width}))}
</div>



```js
// can't use <div class="grid grid-cols-1"> as usual, overflows instead of cropping; find out how to fix problem... though it seems ok without it?
```

About the network 

- created from events data as analysed at [BN Notes events analysis](https://beyond-notability.github.io/bn_notes/posts/events-2024-02-26/).
- it's an *association network* 
	- this type of network is created by connecting nodes that belong to a "group", rather than from direct *interactions* (like senders and recipients of letters)
	- this involves some potentially risky assumptions; just because two people went to the same conference doesn't necessarily mean they knew each other, although it does imply related interests
	- [there is interesting stuff about this from research on [animal networks](https://dshizuka.github.io/networkanalysis/networktypes_socialnetworks.html#constructing-networks-from-associations)]
- here the links have been created on the basis of attendance *at the same event instance* (fuller explanation of "instances" at the BN Notes post, but it's either a one-off event like a named conference or a single dated occurrence of a recurring event like an annual meeting)

About the graph
- [d3 force-directed graph for disconnected graphs](https://observablehq.com/@asgersp/force-directed-graph-disjoint) (designed to "prevent detached subgraphs from escaping the viewport")
- todo: filters...
- Size of nodes reflects a person's overall number of attendances. [or is it number of links? *check code*] 
- Width of connecting lines reflects the number of connections between a pair. (NB few people here have more than one or two connections)
- Completely isolated nodes were removed from the network. 
- Node colours represent groups detected by R. [maybe do toggle between algorithms, if I can] *check which algorithm is being used* I'm still experimenting a bit but most of the algorithms available seem to give very similar results. (It's worth looking out for people who have links to more than one group even if they don't have many links, eg Alice Edleston.)




```js
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
// helper function for drag interaction

function drag(simulation) {

  function dragstarted(event) {
    if (!event.active) simulation.alphaTarget(0.3).restart();
    event.subject.fx = event.subject.x;
    event.subject.fy = event.subject.y;
  }

  function dragged(event) {
    event.subject.fx = event.x;
    event.subject.fy = event.y;
  }

  function dragended(event) {
    if (!event.active) simulation.alphaTarget(0);
    event.subject.fx = null;
    event.subject.fy = null;
  }

  return d3.drag()
      .on("start", dragstarted)
      .on("drag", dragged)
      .on("end", dragended);
}

```



```js

function getRadius(useCasesCount){
		//var	m=useCasesCount/1.5
		//var d=3/useCasesCount
  if(useCasesCount>=6){   
  	//var radius = m+d  
    //return radius
    return useCasesCount
  }
  return 5
}
```




```js
// editables

//const plotTitle = "The ages at which BN women had children, sorted by mothers' dates of birth";

//const plotHeight = 1500;
```

```js
// Import components. can't get this working.
//import {eventsNetworkChart} from "./components/networks.js";
```



```js

// events data. group col is grp2, grp3, grp4 otherwise should match mis examples.
const json = FileAttachment("data/l_networks_events/bn-events.json").json();
```



