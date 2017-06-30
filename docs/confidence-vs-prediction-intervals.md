---
title: 'Confidence, credible and prediction intervals'
output:
  bookdown::tufte_html2
bibliography: bibliography.bib
---


```r
library(tidyverse)
```

```
## Loading tidyverse: ggplot2
## Loading tidyverse: tibble
## Loading tidyverse: tidyr
## Loading tidyverse: readr
## Loading tidyverse: purrr
## Loading tidyverse: dplyr
```

```
## Conflicts with tidy packages ----------------------------------------------
```

```
## filter(): dplyr, stats
## lag():    dplyr, stats
```


# Confidence, credible and prediction intervals


TODO: EXPAND ON THESE DEFINITIONS AND USE GRAPHICS AND PLOTS TO ILLUSTRATE

*Confidence interval*: The range within which we would expect the true value to fall, 95% of the time, if we replicated the study. 

*Prediction interval*: the range within which we expect 95% of new observations to fall. If we're considering the prediction interval for a specific point prediction (i.e. where we set predictors to specific values), then this interval woud be for new observations *with the same predictor values*.


## The problem with confidence intervals

Confidence intervals are helpful when we want to think about how *precise our estimate* is. For example, in an RCT we will want to estimate the difference between treatment groups, and it's conceivable be reasonable to want to know, for example, the range within which the true effect would fall 95% of the time if we replicated our study many times.

If we run a study with small N, intuitively we know that we have less information about the difference between our RCT treatments, and so we'd like the CI to expand accordingly.

*So — all things being equal — the confidence interval reduces as our sample size increases.*


The problem with confidence intervals come because many researchers and clinicians read them incorrectly. Typically, they either:

- Forget that the CI represents the *precision of the estimate*
- Misinterpret the CI as the range in which we are 95% sure the true value lies.


## Forgetting that the CI depends on sample size.

By forgetting that the CI contracts as the sample size increases, researchers can become overconfident about their ability to predict new observations. Imagine that we sample data from two populations with the same mean, but different variability:


```r
set.seed(1234)
df <- expand.grid(v=c(1,3,3,3), i=1:1000) %>% 
  as.data.frame %>%
  mutate(y = rnorm(length(.$i), 100, v)) %>% 
  mutate(samp = factor(v, labels=c("Low variability", "High variability")))
```



```r
df %>% 
  ggplot(aes(y)) + 
  geom_histogram() + 
  facet_grid(~samp) +
  scale_color_discrete("")
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

<img src="confidence-vs-prediction-intervals_files/figure-html/unnamed-chunk-2-1.png" width="672" />


- If we sample 100 individuals from each population the confidence interval around the sample mean would be wider in the high variability group. 

If we increase our sample size we would become more confident about the location of the mean, and this confidence interval would shrink.

But imagine taking a single *new sample* from either population. These samples would be new grey squares, which we place on the histograms above. It does not matter how much extra data we have collected in group B or how sure what the mean of the group is: *We would always be less certain making predictions for new observations in the high variability group*.

The important insight here is that *if our data are noisy and highly variable we can never make firm predictions for new individuals, even if we collect so much data that we are very certain about the location of the mean*.




## What does this mean for my work on [insert speciality here]?







