---
title: 'Multiple comparisons'
output: bookdown::tufte_html2
---




## Multiple comparisons {#multiple-comparisons}

XXX THIS JUST copied from previous anova section. Needs more on problem of multiple comparisons


### Post hoc (pairwise) tests {-}

As in the Anova cookbook, we use a dataset from Howell (REF), chapter 13 which recorded `Recall` among young v.s. older adults (`Age`) for each of 5 conditions:


```r
eysenck <- readRDS("data/eysenck.Rdata")
eysenck %>% 
  ggplot(aes(Condition, Recall, group=Age, color=Age)) + 
  stat_summary(geom="pointrange", fun.data = mean_cl_boot) +
  ylab("Recall (95% CI)") + xlab("")
```

<img src="multiple-comparisons_files/figure-html/unnamed-chunk-2-1.png" width="672" />


We might run an Anova on this dataset:


```r
eysenck.model <- lm(Recall~Age*Condition, data=eysenck)
car::Anova(eysenck.model, type=3)
## Anova Table (Type III tests)
## 
## Response: Recall
##               Sum Sq Df F value    Pr(>F)    
## (Intercept)   490.00  1 61.0550  9.85e-12 ***
## Age             1.25  1  0.1558 0.6940313    
## Condition     351.52  4 10.9500  2.80e-07 ***
## Age:Condition 190.30  4  5.9279 0.0002793 ***
## Residuals     722.30 90                      
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```


We can see there is a significant interaction for `Age:Condition`.  If we want to look at post-hoc pairwise tests we can use the the `lsmeans()` function from the `lsmeans::` package:


```r
lsmeans::lsmeans(eysenck.model, pairwise~Age:Condition)
## $lsmeans
##  Age   Condition lsmean        SE df  lower.CL  upper.CL
##  Young Counting     7.0 0.8958547 90  5.220228  8.779772
##  Older Counting     6.5 0.8958547 90  4.720228  8.279772
##  Young Rhyming      6.9 0.8958547 90  5.120228  8.679772
##  Older Rhyming      7.6 0.8958547 90  5.820228  9.379772
##  Young Adjective   11.0 0.8958547 90  9.220228 12.779772
##  Older Adjective   14.8 0.8958547 90 13.020228 16.579772
##  Young Imagery     13.4 0.8958547 90 11.620228 15.179772
##  Older Imagery     17.6 0.8958547 90 15.820228 19.379772
##  Young Intention   12.0 0.8958547 90 10.220228 13.779772
##  Older Intention   19.3 0.8958547 90 17.520228 21.079772
## 
## Confidence level used: 0.95 
## 
## $contrasts
##  contrast                          estimate      SE df t.ratio p.value
##  Young,Counting - Older,Counting        0.5 1.26693 90   0.395  1.0000
##  Young,Counting - Young,Rhyming         0.1 1.26693 90   0.079  1.0000
##  Young,Counting - Older,Rhyming        -0.6 1.26693 90  -0.474  1.0000
##  Young,Counting - Young,Adjective      -4.0 1.26693 90  -3.157  0.0633
##  Young,Counting - Older,Adjective      -7.8 1.26693 90  -6.157  <.0001
##  Young,Counting - Young,Imagery        -6.4 1.26693 90  -5.052  0.0001
##  Young,Counting - Older,Imagery       -10.6 1.26693 90  -8.367  <.0001
##  Young,Counting - Young,Intention      -5.0 1.26693 90  -3.947  0.0058
##  Young,Counting - Older,Intention     -12.3 1.26693 90  -9.709  <.0001
##  Older,Counting - Young,Rhyming        -0.4 1.26693 90  -0.316  1.0000
##  Older,Counting - Older,Rhyming        -1.1 1.26693 90  -0.868  0.9970
##  Older,Counting - Young,Adjective      -4.5 1.26693 90  -3.552  0.0205
##  Older,Counting - Older,Adjective      -8.3 1.26693 90  -6.551  <.0001
##  Older,Counting - Young,Imagery        -6.9 1.26693 90  -5.446  <.0001
##  Older,Counting - Older,Imagery       -11.1 1.26693 90  -8.761  <.0001
##  Older,Counting - Young,Intention      -5.5 1.26693 90  -4.341  0.0015
##  Older,Counting - Older,Intention     -12.8 1.26693 90 -10.103  <.0001
##  Young,Rhyming - Older,Rhyming         -0.7 1.26693 90  -0.553  0.9999
##  Young,Rhyming - Young,Adjective       -4.1 1.26693 90  -3.236  0.0511
##  Young,Rhyming - Older,Adjective       -7.9 1.26693 90  -6.236  <.0001
##  Young,Rhyming - Young,Imagery         -6.5 1.26693 90  -5.131  0.0001
##  Young,Rhyming - Older,Imagery        -10.7 1.26693 90  -8.446  <.0001
##  Young,Rhyming - Young,Intention       -5.1 1.26693 90  -4.025  0.0044
##  Young,Rhyming - Older,Intention      -12.4 1.26693 90  -9.787  <.0001
##  Older,Rhyming - Young,Adjective       -3.4 1.26693 90  -2.684  0.1963
##  Older,Rhyming - Older,Adjective       -7.2 1.26693 90  -5.683  <.0001
##  Older,Rhyming - Young,Imagery         -5.8 1.26693 90  -4.578  0.0006
##  Older,Rhyming - Older,Imagery        -10.0 1.26693 90  -7.893  <.0001
##  Older,Rhyming - Young,Intention       -4.4 1.26693 90  -3.473  0.0260
##  Older,Rhyming - Older,Intention      -11.7 1.26693 90  -9.235  <.0001
##  Young,Adjective - Older,Adjective     -3.8 1.26693 90  -2.999  0.0950
##  Young,Adjective - Young,Imagery       -2.4 1.26693 90  -1.894  0.6728
##  Young,Adjective - Older,Imagery       -6.6 1.26693 90  -5.209  0.0001
##  Young,Adjective - Young,Intention     -1.0 1.26693 90  -0.789  0.9986
##  Young,Adjective - Older,Intention     -8.3 1.26693 90  -6.551  <.0001
##  Older,Adjective - Young,Imagery        1.4 1.26693 90   1.105  0.9830
##  Older,Adjective - Older,Imagery       -2.8 1.26693 90  -2.210  0.4578
##  Older,Adjective - Young,Intention      2.8 1.26693 90   2.210  0.4578
##  Older,Adjective - Older,Intention     -4.5 1.26693 90  -3.552  0.0205
##  Young,Imagery - Older,Imagery         -4.2 1.26693 90  -3.315  0.0411
##  Young,Imagery - Young,Intention        1.4 1.26693 90   1.105  0.9830
##  Young,Imagery - Older,Intention       -5.9 1.26693 90  -4.657  0.0005
##  Older,Imagery - Young,Intention        5.6 1.26693 90   4.420  0.0011
##  Older,Imagery - Older,Intention       -1.7 1.26693 90  -1.342  0.9409
##  Young,Intention - Older,Intention     -7.3 1.26693 90  -5.762  <.0001
## 
## P value adjustment: tukey method for comparing a family of 10 estimates
```

By default Tukey correction is applied for multiple comparisons which is a reasonable default. If you want to use other methods (e.g. to use false discovery rate adjustment, see the section on [multiple comparisons](multiple-comparisons.html)) you can use the `adjust` argument. 

In the code below we request FDR-adjusted p values, and then use the `broom::tidy()` function to convert the table into a dataframe, and then show only the first 6 rows as a table in RMarkdown: 


```r

# calculate pairwise contrasts
eysenck.fdr <- lsmeans::lsmeans(eysenck.model, pairwise~Age:Condition, adjust="fdr")

# show the first 6 rows from this long table
eysenck.fdr$contrasts %>% 
  broom::tidy() %>% 
  head(6) %>% 
  pandoc.table(caption="First 6 rows of the pairwise contrasts with FDR-adjusted p values")
## 
## --------------------------------------------------------------------------------
##     level1         level2       estimate   std.error   df   statistic   p.value 
## -------------- --------------- ---------- ----------- ---- ----------- ---------
## Young,Counting Older,Counting     0.5        1.267     90    0.3947     0.7263  
## 
## Young,Counting  Young,Rhyming     0.1        1.267     90    0.07893    0.9373  
## 
## Young,Counting  Older,Rhyming     -0.6       1.267     90    -0.4736    0.6824  
## 
## Young,Counting Young,Adjective     -4        1.267     90    -3.157    0.003251 
## 
## Young,Counting Older,Adjective    -7.8       1.267     90    -6.157    7.626e-08
## 
## Young,Counting  Young,Imagery     -6.4       1.267     90    -5.052    5.698e-06
## --------------------------------------------------------------------------------
## 
## Table: First 6 rows of the pairwise contrasts with FDR-adjusted p values
```


You should note that the FDR adjusted p values do not represent probabilities in the normal sense. Instead, the p value now indicates the *false discovery rate at which the p value should be considered statistically significant*. So, for example, if the adjusted p value  0.09, then this indicates the contrast *would* be significant if the acceptable false discovery rate is 10% (people often set their acceptable false discover rate to be 5% out of habit, but this is not always appropriate).


```r
# Set our acceptable false discovery rate to 10%
FDR <- .1
lsmeans::lsmeans(eysenck.model, pairwise~Age:Condition, adjust="none")$contrast %>%
  broom::tidy() %>%
  select(level1, level2, p.value) %>%
  arrange(p.value) %>%
  mutate(`q (10% FDR)` = (rank(p.value)/length(p.value))*FDR) %>%
  mutate(p.fdr.adjust=p.adjust(p.value, method="BH")) %>%
  mutate(significant = as.numeric(p.value < `q (10% FDR)`)) %>%
  # just show some of the results, at the break between sig and ns contrast
  filter(p.fdr.adjust > .01 & p.fdr.adjust < .4) %>%
  pandoc.table(caption="Subset of contrasts, showing the break between significant and ns results, as determined by an FDR of 10%.", split.tables=Inf)
## 
## ------------------------------------------------------------------------------------
##     level1          level2       p.value   q (10% FDR)   p.fdr.adjust   significant 
## --------------- --------------- --------- ------------- -------------- -------------
##  Older,Rhyming  Young,Adjective 0.008667     0.07111       0.01219           1      
## 
## Older,Adjective Young,Intention  0.02964     0.07333       0.03923           1      
## 
## Older,Adjective  Older,Imagery   0.02964     0.07556       0.03923           1      
## 
## Young,Adjective  Young,Imagery   0.06139     0.07778       0.07893           1      
## 
##  Older,Imagery  Older,Intention   0.183       0.08          0.2288           0      
## 
## Older,Adjective  Young,Imagery   0.2721      0.08222        0.3222           0      
## 
##  Young,Imagery  Young,Intention  0.2721      0.08444        0.3222           0      
## ------------------------------------------------------------------------------------
## 
## Table: Subset of contrasts, showing the break between significant and ns results, as determined by an FDR of 10%.
```

Note, that when you use `adjust='fdr'` then the p values returned are
The [Biostat Handbook](http://www.biostathandbook.com/multiplecomparisons.html) has a good




<!---TO ADD? https://rawgit.com/geneticsMiNIng/FactorMerger/master/materials/vignette.html--->
