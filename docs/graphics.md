---
title: 'Graphics'
output: 
  bookdown::tufte_html2
---
  



# Graphics

THIS SECTION IS INCOMPLETE - YOU MIGHT WANT TO SKIP TO THE NEXT ONE


Sections to cover:


## Benefits of visualising data

Psychology and human factors of graphics + Tufte. Importance of graphs to communicate. Motivating examples from RCTs.


## Choosing a plot type

Describe 2 strategies when plotting in R:
  
  - Quick an dirty (helper functions like `pairs`, `Hmisc::hist.data.frame` or `ggplot2::qplot`)
- Doing it right (`ggplot` or careful use of `base` graphics)

When exploring a dataset, often useful to use built in functions or helpers from other libraries. These help you quickly visualise relationships, but aren't always *exactly* what you need and can be hard to customise.

The other approach is to build your plot from scratch using the layers approach in `ggplot` (you can also do this with base graphics, but it requires a detailed knowledge of R and can be fiddly). This enables you to construct a plot which exactly matches the aims of your communication, and can be tweaked to make it publication-ready.



## Layering graphics

ggplot - e.g. geom_point + geom_smooth


