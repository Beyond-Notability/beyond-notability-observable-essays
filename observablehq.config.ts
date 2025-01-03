import MarkdownItFootnote from "markdown-it-footnote";

// See https://observablehq.com/framework/config for documentation.
export default {
  // The project’s title; used in the sidebar and webpage titles.
  title: "Beyond Notability",
	cleanUrls: false,  

  // The pages and sections in the sidebar. If you don’t specify this option,
  // all pages will be listed in alphabetical order. Listing pages explicitly
  // lets you organize them into sections and have unlisted pages.
  // not essential if the cleanUrls setting works (not available in early versions)
  
  pages: [
    {
      name: "Pages",
      pages: [
        {name: "All the Dates", path: "/all-dates.html"},
        {name: "Education", path: "/education.html"},
        {name: "Motherhood", path: "/mothers.html"},
        {name: "Residence", path: "/residence.html"},
        {name: "Networks", path: "/networks.html"},
        {name: "Project Links", path: "/project-links.html"},
        {name: "Notes", path: "/notes.html"},
      ]
    }
  ],


  // Content to add to the head of the page, e.g. for a favicon:
  head: '<link rel="icon" href="./static/profile.jpg" type="image/jpg">',


  // Some additional configuration options and their defaults:
  // theme: "default", // try "light", "dark", "slate", etc.
  // header: "", // what to show in the header (HTML)
  // footer: "Built with Observable.", // what to show in the footer (HTML)
  // toc: true, // whether to show the table of contents
  // pager: true, // whether to show previous & next links in the footer
  
  root: "src", // path to the source root for preview
  output: "docs", // path to the output root for build
  
  // search: true, // activate search
  
  // Register a custom stylesheet.
  //style: "custom-style.css",

	// markdown extension
  markdownIt: (md) => md.use(MarkdownItFootnote)

};