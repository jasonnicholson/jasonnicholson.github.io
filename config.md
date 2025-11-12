<!--
Add here global page variables to use throughout your website.
-->
+++
author = "Jason H. Nicholson"
mintoclevel = 2

# uncomment and adjust the following line if the expected base URL of your website is something like [www.thebase.com/yourproject/]
# please do read the docs on deployment to avoid common issues: https://franklinjl.org/workflow/deploy/#deploying_your_website
# prepath = "yourproject"

# Add here files or directories that should be ignored by Franklin, otherwise
# these files might be copied and, if markdown, processed by Franklin which
# you might not want. Indicate directories by ending the name with a `/`.
# Base files such as LICENSE.md and README.md are ignored by default.
ignore = ["node_modules/", "notes.md","TODO.md",".vscode/"]

# RSS (the website_{title, descr, url} must be defined to get RSS)
generate_rss = true
website_title = "Jason Nicholson Engineering and Life"
website_descr = "A place to share what I have learned"
website_url   = "https://www.jasonhnicholson.com/"
+++

<!--
Add here global latex commands to use throughout your pages.
-->
\newcommand{\R}{\mathbb R}
\newcommand{\scal}[1]{\langle #1 \rangle}

<!-- 
\figureHelper{the caption}{/assets/rndimg.jpg}{width:50%;border: 1px solid red;}

(1) the image caption 
(2) the image source path and 
(3) specific CSS styling for the image.

Modified from here: https://franklinjl.org/syntax/markdown/index.html#inserting_a_figure
-->
\newcommand{\figureHelper}[3]{
~~~
<figure style="text-align:center;">
<img src="!#2" style="padding:0;#3" alt="#1"/>
<figcaption>#1</figcaption>
</figure>
~~~
}