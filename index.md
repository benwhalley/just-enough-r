
---
title: 'Just Enough R'
site: bookdown::bookdown_site
---

# Introduction {-}

![](media/keepcalm.png){.cup}

<!-- https://www.keepcalm-o-matic.co.uk/product/mug/keep-calm-and-learn-just-enough-r/ -->

R makes it easy to work with and learn from data.

It also happens to be a programmming language, but if you're reading this, that
might not be of interest. That's OK — the goal here is not to teach
programming^[This is a lie, but hopefully it won't be obvious until it's too
late.]. The goal is to teach you _just enough R_ to be confident to explore your
data.

This book uses R like any other statistics software: To work-with and visualise
data, run statistical analyses, and share our results with others. To do that
you don't need more than the _absolute basics_ of the R language itself. The
first chapters walk you through what you need to know to be productive.

#### Things to know Before you start {-}

This guide is fairly opinionated, but for good reason.

There are lots of ways to use R, and this has been a barrier for beginners. In
particular base-R functions can be oddly-named, or lack a regular or predictable
interface. For this reason we:

-   Recommend (strongly) that you install and use 'packages' that extend some of
    R's basic functionality. These packages are powerful tools in their own
    right, but also hide some of the complexities of R in a
    [clear and consistent way](https://www.youtube.com/watch?v=K-ss_ag2k9E). It
    might seem restrictive but, to begin with, learning _only_ these packages
    will help you form a more consistent mental model and make rapid progress.
    You can learn the crufty old bits (which still have their uses) later on.

-   Assume you are using the [RStudio editor](#rstudio) and working in an
    [RMarkdown document](#rmarkdown) (see the next section). If you don't have
    access to RStudio yet, see the [installation guide](installation.html).

#### License {-}

These documents are licensed under the
[CC BY-SA licence](https://creativecommons.org/licenses/by-sa/4.0/).
