---
title: 'Just Enough R'
output: tufte::tufte_html
site: bookdown::bookdown_site
bibliography: [bibliography.bib]
biblio-style: apalike
link-citations: yes
---



# {-} 

# (PART) Getting started {-} 


![](media/keepcalm.png){.cup}

<!-- https://www.keepcalm-o-matic.co.uk/product/mug/keep-calm-and-learn-just-enough-r/ -->



#### Introduction

R makes it easy to work with and learn from data. 

It also happens to be a complete programmming language, but if you're reading this guide then that might not be of interest to you. That's OK — the goal here is *not* to teach you how to program in R^[This is actually a lie, but I'm hoping you won't notice until it's too late.].  The goal is to teach you *just enough R* to be confident to explore your data.


In this guide, we use R in the same way we use any other statistics software: To check and visualise data, run statistical analyses, and share our results with others.   To do that it's worth learning the *absolute basics* of the R language. The next few chapters walk you through those basics: what you need to know to be productive in R and RStudio. 

By analogy, imagine going on holiday and learning enough French to introduce yourself, count from one to ten, and order a baguette. You won't be fluent - but you won't starve, and your trip will be more fun.




#### A warning {-}

This guide is extremely opinionated. 

There are many ways to get things done with R, but trying to learn them all at once causes unhappiness. In particular, lots of the base R functions are old, quirky, inconstently named, and hard to remember. This guide recommends that you use several new 'packages' that replicate and extend some of R's basic functionality. 

Using this new set of packages, which are very thoughtfully designed and work together nicely, will help you form a more consistent mental model and workflow in R. You can learn the crufty old bits (which do still have their uses) later on.

The guide also assumes you are using the [RStudio editor](#rstudio) and working in an [RMarkdown document](#rmarkdown) (see the next section). This is important because this guide itself is written in RMarkdown, and editing it will be an important part of the learning process. If you don't have access to RStudio yet, see the [installation guide](installation.html).




#### License {-}

These documents are licensed under the [CC BY-SA licence](https://creativecommons.org/licenses/by-sa/4.0/).


