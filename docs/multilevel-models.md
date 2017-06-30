---
title: 'Multilevel models'
output:
  bookdown::tufte_html2
---





```r
disschecks <- statcheck::checkdir('~/Downloads/dissertations/')
## Importing PDF files...
## 
## Extracting statistics...
## 
## Warning in sqrt((1 - r^2)/df): NaNs produced
## 
## 
##  Check the significance level. 
##  
##  Some of the p value incongruencies are decision errors if the significance level is .1 or .01 instead of the conventional .05. It is recommended to check the actual significance level in the paper or text. Check if the reported p values are a decision error at a different significance level by running statcheck again with 'alpha' set to .1 and/or .01. 
## 
## 
##  Check for one tailed tests. 
##  
##  Some of the p value incongruencies might in fact be one tailed tests. It is recommended to check this in the actual paper or text. Check if the p values would also be incongruent if the test is indeed one sided by running statcheck again with 'OneTailedTests' set to TRUE. To see which Sources probably contain a one tailed test, try unique(x$Source[x$OneTail]) (where x is the statcheck output). 
## 
## Warning in sqrt((1 - r^2)/df): NaNs produced

## Warning in sqrt((1 - r^2)/df): NaNs produced

disschecks %>% 
  group_by(Statistic) %>% 
  reshape2::dcast(Statistic~Error)
## Using APAfactor as value column: use value.var to override.
## Aggregation function missing: defaulting to length
##   Statistic FALSE TRUE NA
## 1      Chi2    72    9  0
## 2         F   885  142  0
## 3         r   128   18  1
## 4         t   454  121  0
## 5         Z     6    4  0

disschecks %>% 
  group_by(Statistic) %>% 
  reshape2::dcast(Statistic~DecisionError)
## Using APAfactor as value column: use value.var to override.
## Aggregation function missing: defaulting to length
##   Statistic FALSE TRUE NA
## 1      Chi2    78    3  0
## 2         F  1008   19  0
## 3         r   146    0  1
## 4         t   555   20  0
## 5         Z     9    1  0
```

<!-- XXX TODO 

http://lme4.r-forge.r-project.org/lMMwR/lrgprt.pdf 

http://www.stata.com/meeting/germany13/abstracts/materials/de13_jann.pdf

-->


# Multilevel models


This chapter assumes:

- You know what a multilevel model is
- ...





## The `sleepstudy` data and traditional RM Anova

XXX As noted in the [Anova cookbook section](anova-cookbook.html), repeated measures anova can be approximated using linear mixed models.

For example, using the same `sleepstudy` example, this model approximates a repeat measures anova in which multiple measurments of `Reaction` time are taken on multiple `Days` for each `Subject`:

<!-- 
This post by the author of afex confirms these models are equivalent to RM anova:
http://singmann.org/mixed-models-for-anova-designs-with-one-observation-per-unit-of-observation-and-cell-of-the-design/ 
-->


```r
sleep.model <- lmer(Reaction ~ factor(Days) + (1|Subject), data=lme4::sleepstudy)
lmerTest::anova(sleep.model)
## Analysis of Variance Table of type III  with  Satterthwaite 
## approximation for degrees of freedom
##              Sum Sq Mean Sq NumDF DenDF F.value    Pr(>F)    
## factor(Days) 166235   18471     9   153  18.703 < 2.2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```


If you really wanted to fit traditional RM Anova, this is the 'real thing':


```r
afex::aov_car(Reaction ~ Days + Error(Subject/(Days)), data=lme4::sleepstudy)
## Anova Table (Type 3 tests)
## 
## Response: Reaction
##   Effect          df     MSE         F ges p.value
## 1   Days 3.32, 56.46 2676.18 18.70 *** .29  <.0001
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '+' 0.1 ' ' 1
## 
## Sphericity correction method: GG
```


XXX ADD THESE EXAMPLES
But see the [multilevel models section](multilevel-models.html) for details of more interesting models which:

### Fit a simple slope for `Days`


```r
lme4::sleepstudy %>% 
  ggplot(aes(Days, Reaction)) + 
  geom_point() + geom_jitter() +
  geom_smooth() 
## `geom_smooth()` using method = 'loess'
```

<img src="multilevel-models_files/figure-html/unnamed-chunk-5-1.png" width="672" />


```r
slope.model <- lmer(Reaction ~ Days + (1|Subject),  data=lme4::sleepstudy)
lmerTest::anova(slope.model)
## Analysis of Variance Table of type III  with  Satterthwaite 
## approximation for degrees of freedom
##      Sum Sq Mean Sq NumDF DenDF F.value    Pr(>F)    
## Days 162703  162703     1   161   169.4 < 2.2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
slope.model.summary <- summary(slope.model)
slope.model.summary$coefficients
##              Estimate Std. Error       df  t value Pr(>|t|)
## (Intercept) 251.40510  9.7467163  22.8102 25.79383        0
## Days         10.46729  0.8042214 161.0036 13.01543        0
```



### Allow the effect of sleep deprivation to vary for different participants

It looks like sleep deprivation hits some participants worse than others:


```r
set.seed(1234)
lme4::sleepstudy %>% 
  filter(Subject %in% sample(levels(Subject), 10)) %>% 
  ggplot(aes(Days, Reaction, group=Subject, color=Subject)) +
  geom_smooth(method="lm", se=F) + 
  geom_jitter(size=1) +
  theme_minimal()
```

<img src="multilevel-models_files/figure-html/unnamed-chunk-7-1.png" width="672" />


If we wanted to test whether there was significant variation in the effects of sleep deprivation between subjects, we could add a *random slope* to the model. 

The random slope allows the effect of `Days` to vary between subjects. So we can think of an overall slope (i.e. RT goes up over the days), from which individuals deviate by some amount (e.g. a resiliant person will have a negative deviation or residual from the overall slope).

Adding the random slope doesn't change the F test for `Days` that much:


```r
random.slope.model <- lmer(Reaction ~ Days + (Days|Subject),  data=lme4::sleepstudy)
lmerTest::anova(random.slope.model)
## Analysis of Variance Table of type III  with  Satterthwaite 
## approximation for degrees of freedom
##      Sum Sq Mean Sq NumDF DenDF F.value    Pr(>F)    
## Days  30031   30031     1    17  45.853 3.264e-06 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

Nor the overall slope coefficient:


```r
random.slope.model.summary <- summary(random.slope.model)
slope.model.summary$coefficients
##              Estimate Std. Error       df  t value Pr(>|t|)
## (Intercept) 251.40510  9.7467163  22.8102 25.79383        0
## Days         10.46729  0.8042214 161.0036 13.01543        0
```

But we can use the `lmerTest::rand()` function to show that there is statistically significant variation in slopes between individuals, using the likelihood ratio test:


```r
lmerTest::rand(random.slope.model)
## Analysis of Random effects Table:
##              Chi.sq Chi.DF p.value    
## Days:Subject   42.8      2   5e-10 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```


Because the random slope for `Days` is statistically significant, we know it improves the model.
One way to see that improvement is to plot residuals (unexplained error for each datapoint) against predicted values. To extract residual and fitted values we use the `residuals()` and `predict()` functions. These are then combined in a data_frame, to enable us to use ggplot for the subsequent figures.


```r
# create data frames containing residuals and fitted
# values for each model we ran above
a <-  data_frame(
    model = "random.slope",
    fitted = predict(random.slope.model), 
    residual = residuals(random.slope.model))
b <- data_frame(
    model = "random.intercept",
    fitted = predict(slope.model), 
    residual = residuals(slope.model)) 

# join the two data frames together
residual.fitted.data <- bind_rows(a,b)
```


We can see that the residuals from the random slope model are much more evenly distributed across the range of fitted values, which suggests that the assumption of homogeneity of variance is met in the random slope model:


```r
# plots residuals against fitted values for each model
residual.fitted.data %>%
  ggplot(aes(fitted, residual)) +
  geom_point() + 
  geom_smooth(se=F) +
  facet_wrap(~model) 
## `geom_smooth()` using method = 'loess'
```

<img src="multilevel-models_files/figure-html/unnamed-chunk-12-1.png" width="672" />




We can plot both of the random effects from this model (intercept and slope) to see how much the model expects individuals to deviate from the overall (mean) slope.


```r
# extract the random effects from the model (intercept and slope)
ranef(random.slope.model)$Subject %>% 
  # implicitly convert them to a dataframe and add a column with the subject number
  rownames_to_column(var="Subject") %>% 
  # plot the intercept and slobe values with geom_abline()
  ggplot(aes()) + 
  geom_abline(aes(intercept=`(Intercept)`, slope=Days, color=Subject)) +
  # add axis label
  xlab("Day") + ylab("Residual RT") +
  # set the scale of the plot to something sensible
  scale_x_continuous(limits=c(0,10), expand=c(0,0)) + 
  scale_y_continuous(limits=c(-100, 100)) 
```

<img src="multilevel-models_files/figure-html/unnamed-chunk-13-1.png" width="672" />



Inspecting this plot, there doesn't seem to be any strong correlation between the RT value at which an individual starts (their intercept residual) and the slope describing how they change over the days compared with the average slope (their slope residual). 

That is, we can't say that knowing whether a person has fast or slow RTs at the start of the study gives us a clue about what will happen to them after they are sleep deprived: some people start slow and get faster; other start fast but suffer and get slower. 

However we can explicitly check this correlation (between individuals' intercept and slope residuals) using the `VarCorr()` function:


```r
VarCorr(random.slope.model)
##  Groups   Name        Std.Dev. Corr 
##  Subject  (Intercept) 24.7404       
##           Days         5.9221  0.066
##  Residual             25.5918
```


The correlation between the random intercept and slopes is only 0.066, and so very low. We might, therefore, want to try fitting a model without this correlation.  `lmer` includes the correlation by default, so we need to change the model formula to make it clear we don't want it:


```r
uncorrelated.reffs.model <- lmer(
  Reaction ~ Days + (1 | Subject) + (0 + Days|Subject),  
  data=lme4::sleepstudy)

VarCorr(uncorrelated.reffs.model)
##  Groups    Name        Std.Dev.
##  Subject   (Intercept) 25.0513 
##  Subject.1 Days         5.9882 
##  Residual              25.5653
```

The variance components don't change much when we constrain the *covariance* of intercepts and slopes to be zero, and we can explicitly compare these two models using the `anova()` function, which is somewhat confusingly named because in this instance it is performing a likelihood ratio test to compare the two models:


```r
anova(random.slope.model, uncorrelated.reffs.model)
## refitting model(s) with ML (instead of REML)
## Data: lme4::sleepstudy
## Models:
## ..1: Reaction ~ Days + (1 | Subject) + (0 + Days | Subject)
## object: Reaction ~ Days + (Days | Subject)
##        Df    AIC    BIC  logLik deviance  Chisq Chi Df Pr(>Chisq)
## ..1     5 1762.0 1778.0 -876.00   1752.0                         
## object  6 1763.9 1783.1 -875.97   1751.9 0.0639      1     0.8004
```

Model fit is not significantly worse with the constrained model, so for parsimony's sake we prefer it to the more complex model.



### Fitting a curve for the effect of `Days`

In theory, we could also fit additional parameters for the effect of `Days`, although a combined smoothed line plot/scatterplot indicates that a linear function fits the data reasonably well.



```r
lme4::sleepstudy %>% 
  ggplot(aes(Days, Reaction)) + 
  geom_point() + geom_jitter() + 
  geom_smooth() 
## `geom_smooth()` using method = 'loess'
```

<img src="multilevel-models_files/figure-html/unnamed-chunk-17-1.png" width="672" />


If we insisted on testing a curved (quadratic) function of `Days`, we could:


```r
quad.model <- lmer(Reaction ~ Days + I(Days^2) + (1|Subject),  data=lme4::sleepstudy)
quad.model.summary <- summary(quad.model)
quad.model.summary$coefficients
##                Estimate Std. Error        df   t value   Pr(>|t|)
## (Intercept) 255.4493728 10.4656310  30.04063 24.408406 0.00000000
## Days          7.4340850  2.9707978 160.00374  2.502387 0.01334034
## I(Days^2)     0.3370223  0.3177733 160.00374  1.060575 0.29048148
```



Here, the *p* value for `I(Days^2)` is not significant, suggesting (as does the plot) that a simple slope model is sufficient.












<!-- ## Arguments for bayesian model fitting -->

<!-- See  -->

<!-- https://arxiv.org/pdf/1701.04858.pdf -->