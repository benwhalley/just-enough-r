---
title: '''Just enough'' R'
output: tufte::tufte_html
site: bookdown::bookdown_site
bibliography: [bibliography.bib]
biblio-style: apalike
link-citations: yes
---



# {-} 

# (PART) Getting started {-} 


![](media/keepcalm.png)

<!-- 

https://www.keepcalm-o-matic.co.uk/product/mug/keep-calm-and-learn-just-enough-r/

-->




# Introduction

R is software which makes it easy to work with and learn from data. 

It also happens to be a complete programmming language, but if you're reading this guide then that might not be of interest to you. That's OK — the goal here is *not* to teach you how to program in R^[This is actually a lie, but I'm hoping you won't notice until it's too late.].  The goal is to teach you *just enough R* to be confident to explore your data.

We are going to use R the same way we use any other statistics software: To check and visualise data, run statistical analyses, and share our results with others.  To do that it's worth learning the *absolute basics* of the R language. The next few chapters walk you through those basics: what you need to know to be productive in R and RStudio. By analogy, imagine going on holiday and learning enough French to introduce yourself, count from one to ten, and order a baguette. You won't be fluent - but you won't starve, and your trip will be more fun.



#### Part 1: 'Must read' {-}

Part 1 is meant to be read from beginning to end by those starting from scratch.


1. [Getting started](#start_here) 
2. [Datasets and dataframes](#datasets-dataframes)
2. [Manipulating dataframes](#working-with-dataframes) (select and filter)
3. [Summarising data](#summarising-data) (split, apply, combine)
4. [Visualising data](#graphics) (layering graphics with `ggplot2`)



#### Part 2: Nice to know {-}

Part 2 can be read sequentially, but the chapters are also designed to work as standalone guides for specific techniques. 


- [Working with real data](#real-data)
- [Correlations](#correlations)
- [t-tests](#t-tests)

- [Regression and linear models](#linear-models-simple)
- [Anova in R](#anova)
- [Anova cookbook](#anova-cookbook)
- [Understanding (and visualising) interactions](#understanding-interactions) (visualising interactions in raw data)
- [Predictions and marginal effects](#predictions-and-margins)


- [General linear models](#general-linear-models)
- [Linear mixed models (multilevel models)](#multilevel-models)

- [Mediation](#mediation)
- [Meta analysis](#meta-analysis)
<!-- - Scale construction -->
<!-- - 'Reliability' analyses (inter rater reliability etc.) -->
- [Confirmatory factor analysis](#cfa) 
- [Structural Equation Modelling](#sem)
- [Power analysis](#power-analysis)
- [Bayes factors (aka what to do when your experiment doesn't work)](#bayes-factors)
- [Bayesian model fitting with MCMC](#bayes-mcmc)

<!-- - Multiple imputation (e.g. with MICE)
- Simulation
 -->

#### Part 3: Statistical explanations {-}

The main guide (mostly) assumes you understand the statistical principles which underpin the models you are running. These sections clarify some important or often-confused points.

- [Confidence intervals vs. prediction intervals](#intervals)
- [Multiple comparisons and *p* values](#multiple-comparisons)
- [Clustered data](#clustering)
- [The distinction between fixed and random effects](#fixed-or-random)
- [Model comparison and selection](#comparison-and-selection)



#### Part 4: Loose ends {-}

Part 4 should be used interactively to answer questions that arise along the way.  

Some of the content here is not specific to R, but may be useful in interpreting the output of some of the techniques taught in sections 1 and 2.



#### Part 5: Sharing and publishing analyses {-}

Practical guidance and examples of extracting model results and formatting for APA journals.






#### A warning {-}

This guide is extremely opinionated. 

There are many ways to get things done with R, but trying to learn them all at once causes unhappiness. In particular, lots of the base R functions are old, quirky, inconstently named, and hard to remember. This guide recommends that you use several new 'packages' that replicate and extend some of R's basic functionality. 

Using this new set of packages, which are very thoughtfully designed and work together nicely, will help you form a more consistent mental model and workflow in R. You can learn the crufty old bits (which do still have their uses) later on.

The guide also assumes you are using the [RStudio editor](#rstudio) and working in an [RMarkdown document](#rmarkdown) (see the next section). This is important because this guide itself is written in RMarkdown, and editing it will be an important part of the learning process. If you don't have access to RStudio yet, see the [installation guide](installation.html).




#### License {-}

These documents are licensed under the [CC BY-SA licence](https://creativecommons.org/licenses/by-sa/4.0/).


