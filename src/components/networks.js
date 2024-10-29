import * as Plot from "npm:@observablehq/plot";
import * as d3 from "npm:d3";


// not working...

export function eventsNetworkChart(data) {


const height = 900;
const width = 800;
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




}

