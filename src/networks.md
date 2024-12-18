---
theme: dashboard
title: Networks
---


# Women's Networks

*this is a work-in-progress data essay*

Creating linked data implies analysing networks, and analysing networks when digital humanities researchers are involved implies making network graphs. Despite this, the [Beyond Notability project](https://beyondnotability.org/) has made remarkably few attempts at analysing networks using network analysis technique, including network visualisation. The reason is that we had other proxies for networks in our data: co-habitation, co-education, co-location, co-working on publications or excacations, co-signing letters of nomination. But as we started putting together these data essays, one area that seemed particularly amenable to network visualisation were data relating to event participation and committee membership.

## Making Networkable Data

These data, whilst related, had distinct origins. 'Event' data constitutes a series of statements relating to participation at events: this included people speaking, attending, organising, and exhibiting at events (see Sharon's [*PPA Events*](https://beyond-notability.github.io/bn_notes/posts/events-2024-02-26/) blog for more info). 'Committee' data is much more simple, represented only by those statements recording when people '[served on](https://beyond-notability.wikibase.cloud/wiki/Property:P102)' a committee or group.

Making the data into networks of people required slightly different apporoaches to what consituted an connetion between two individuals.

For 'Event' data, this required a qualifier indicating that two or more people were at the same event at the same time, whether as the same type of participant - say, as both [speakers](https://beyond-notability.wikibase.cloud/wiki/Property:P23) or both [attendees](https://beyond-notability.wikibase.cloud/wiki/Property:P24) - or different types of participation - say, one person was an [organiser](https://beyond-notability.wikibase.cloud/wiki/Property:P109) whilst another was an [exhibitor](https://beyond-notability.wikibase.cloud/wiki/Property:P13). This type of connection takes no account of how participants interacted, but rather takes co-location as a proxy for association (more on which later).

For 'Committee' data, we chose to create a networkable connection when two people served on a committee for the same association in the same year (thus creating the concept of a "service year"). This type of connection relies on two assumptions: first, that service is more likely to be an ongoing activity than participating in an event (which seems a reasonable assumption); and second, that committee membership involved engagement with other members (which for larger organisations like the [Society of Antiquaries of London](https://beyond-notability.wikibase.cloud/wiki/Item:Q8) or [Royal Archaeological Institute](https://beyond-notability.wikibase.cloud/wiki/Item:Q35) could be a risky assumption).

Conflations and assumptions notwithstanding this gave us something we could visualise as a network: the connections between people created by their participation at events and service on committees.

## Visualising a Networks 

Network visualisations (often referred to as network graphs) require a little explanation before we can dig into what they might well us. In this case we note the following features:

- Each 'node' (a round blob) represents an individual people. They are coloured according to whether the data - drawn from [our wikibase](https://beyond-notability.wikibase.cloud/wiki/Main_Page) - contains statements about individuals participating in events (yellow), serving on committees (red), or both (both).
- The size of each node reflects the number of connections between that node and another node (called "degree"). Note that in order to ensure legibility, node size is scaled: this reduces the relative size of very large nodes and increases the size of nodes with very few connection.
- Each node is connected to one or more other nodes by 'edges', and the width of each edge (called "link weight") is determined by number of connections between a pair of nodes. In our visualisation, the default minimum link weight is two, meaning that nodes that connect to only one other node are filtered out (more on which later). All isolated notes - that is, representing instances where an individual participated in an event or served on a committee without that activity connecting to another individual - are removed.
- Hovering over a node gives the number of 'appearances', a measure of the number of instances where an individual participated in an event or served on a committee. Note that this number may be smaller than the number of connections between that node and anothers node ("degree") depending on the size of an event/committee or the duration of service (e.g. a person could be in a single meeting that has multiple connections, therefore have an appearance of one with a high degree, therefore a large node).

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

## Reading a Network

The first thing to note about most network visualisation is that they are representations of both mathematical relationships between data and a visual organisation of those relationships designed to improve readability and legibility. In this case, we use [d3 force-directed graph for disconnected graphs](https://observablehq.com/@asgersp/force-directed-graph-disjoint), which is designed to "prevent detached subgraphs from escaping the viewport". As scholars such as [Ahnert and Ahnert](https://academic.oup.com/book/51646?login=false) demonstrate, we don't **need** network visualisations to analyse networks computationally. So when we do, it is vital to consider what we are actually doing: we are analysing a series of choices about the modelling of historical reality (see our [Education](https://beyond-notability.github.io/beyond-notability-observable-essays/education.html#modelling-education) data essay for more on modelling) through a series of mathematical choices deployed to organise that modelling as a network *and* a series of presentational choices about representing that modelling as a network.

Got that. Good. So what does this particular network visualisation seem to be telling us:

- First, networks of women in archaeology, history, and heritage circa 1870 - 1950 were dominated by those individuals recorded frequently in [our wikibase](https://beyond-notability.wikibase.cloud/) as both members of committees and participants in events. These individuals appear as a large and closely clustered network, with a second smaller sub-network that also centres on individuals who did both.
- Second, those individuals in [our wikibase](https://beyond-notability.wikibase.cloud/) only recorded as working on committees are closely connected to that primary network.
- Third, individuals in [our wikibase](https://beyond-notability.wikibase.cloud/) only recorded as having participated in events form the periphery of the network, often in isolated small sub-networks.
- Fourth, there are no obvious bridges between discrete networks: there is a centre, a periphery, and then isolated networks.
- But, fifth, if we toggle to the 'events' view and then to the 'committees' view, bridges dp emerge. [Margerie Venables Taylor](https://beyond-notability.wikibase.cloud/wiki/Item:Q133) seems to be a bridge between a large network centred on [Kathleen Kenyon](https://beyond-notability.wikibase.cloud/wiki/Item:Q709) and a small sub-group containing [Tessa Verney Wheeler](https://beyond-notability.wikibase.cloud/wiki/Item:Q145), [Rose Graham](https://beyond-notability.wikibase.cloud/wiki/Item:Q57), [Dorothy Liddell](https://beyond-notability.wikibase.cloud/wiki/Item:Q256) and [Winifred Lamb](https://beyond-notability.wikibase.cloud/wiki/Item:Q238).

We have then, a story that starts to emerge: a big interconnected network, some bridges, lots of looser connections. The thing is though, if we change the data presented by the network visualisation then different stories emerge. For example, if we stay on the 'events' view, set minimum link weight to one, and zoom out a little, we see a big ball, with large nodes close together on one side, smaller nodes on other, and a smattering of one-time connection event nodes around the core. Here the interactive nature of our viz enables interpretation of further bridges. For example, hover on [Margaret Alice Murray](https://beyond-notability.wikibase.cloud/wiki/Item:Q569) (centre right) and look at the her leftward connection to [Charlotte Sophia Burne](https://beyond-notability.wikibase.cloud/wiki/Item:Q662) and rightward connections to [Kathleen Kenyon](https://beyond-notability.wikibase.cloud/wiki/Item:Q709) and [Tessa Verney Wheeler](https://beyond-notability.wikibase.cloud/wiki/Item:Q145). In this view, Murray is at the heart of two separate - if unevenly composed - networks. And if we hover on [Burne](https://beyond-notability.wikibase.cloud/wiki/Item:Q662) we see that [Murray](https://beyond-notability.wikibase.cloud/wiki/Item:Q569) is Burne's only connection into the large network. Burne then seems an important bridge. Burne was principally a folklorist. Murray whilst a member and sometime President of the [Folklore Society](https://beyond-notability.wikibase.cloud/wiki/Item:Q292) had broader interests, specialising in Egyptology. In [our wikibase](https://beyond-notability.wikibase.cloud/) Burne and Murray co-occur at the 1913 Annual Meeting of the [British Association for the Advancement of Science](https://beyond-notability.wikibase.cloud/wiki/Item:Q644) in Birmingham. Murray spoke on 'Evidence for the custom of killing the king in Ancient Egypt', Burne on 'Souling, Clementing and Caturning: Three November Customs of the Western Midlands'. Two scholars with ample evidence of possible connections - Burne also served as President of the [Folklore Society](https://beyond-notability.wikibase.cloud/wiki/Item:Q292) - linked by a single event, an event at which they spoke on very different subjects, and may never have interacted. What does the Burne-Murray case mean for interpreting this network?

## A Network of Association 

To answer this, stay on the 'events' view and move to link weight eight. We now see two nodes: [Jessie MacGregor](https://beyond-notability.wikibase.cloud/wiki/Item:Q970) and [Rosa Wallis](https://beyond-notability.wikibase.cloud/wiki/Item:Q508) connected by a thick edge. This connection is explained by both appearing regularly at the [Royal Academy Summer Exhibition](https://beyond-notability.wikibase.cloud/wiki/Item:Q510): MacGregor on 28 occasions between 1872 and 1904, Wallis on eight occasions between 1881 and 1918, with their co-occurrences in the 1880s. What [our wikibase](https://beyond-notability.wikibase.cloud/) does not tell us is if they exhibited in close proximity, if they met, and if so what they discussed. Here then, as with the Burne-Murray case, we arrive at the conclusion that this network is a network of *association*. It is a network created by connecting nodes that belong to "groups", rather than from direct *interactions* such as senders and recipients of letters, [which historians will be more familiar with](https://tudornetworks.net/). This type of network visualisation then involves some potentially risky assumptions: for example, just because two people went to the same event does not necessarily mean they knew each other. We aren't of course the first people to ponder this. Network science often grapples with the purpose and utility of such weak networking (such as this research on [animal networks](https://dshizuka.github.io/networkanalysis/networktypes_socialnetworks.html#constructing-networks-from-associations)). And so whilst can build interpretations from the knowledge that this network takes proxies for association to build a network, this involves knowing our data and not being fouled by the fact the visualisation looks like other visualisations we may be familiar with. Which works against the use of visualisation as a simplifying explanatory tool. Proceed then, as they say, with caution.

## References

- [Force-Directed Graph, Disjoint](https://observablehq.com/@asgersp/force-directed-graph-disjoint)
- [Network Graph with d3.force grouping (for highlighting)](https://observablehq.com/@ravengao/force-directed-graph-with-cola-grouping )
- [D3 Force-Directed Graph with Input](https://observablehq.com/@asgersp/d3-force-directed-graph-with-input)
- [Drag Queens Netwerk Diagram](https://observablehq.com/d/f3941ff4743f26e3)
- [Agents Network Visualisation](https://observablehq.com/@jmiguelv/radical-translations-agents-network-visualisation)
- [Marvel Network](https://observablehq.com/@jrladd/marvel-network)
- [Plot: Legends](https://observablehq.com/d/a23f6e59f1380df0)


## To do!

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



