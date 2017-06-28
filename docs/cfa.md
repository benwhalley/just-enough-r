---
title: 'Confirmatory factor analysis'
output:
  bookdown::tufte_html2
---





# Confirmatory factor analysis

*This section adapted from a guide originally produced by Jon May*


First make sure the `lavaan` package is installed^[see: [installing packages](packages.html)]; it stands for Latent Variable Analysis and is the most popular package for CFA in R.


```r
install.packages(lavaan)
```



```r
library(lavaan)
## This is lavaan 0.5-23.1097
## lavaan is BETA software! Please report any bugs.
```


Open your data and check that all looks well:


```r
hz <- lavaan::HolzingerSwineford1939
hz %>% glimpse()
## Observations: 301
## Variables: 15
## $ id     <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 13, 14, 15, 16, 17, ...
## $ sex    <int> 1, 2, 2, 1, 2, 2, 1, 2, 2, 2, 1, 1, 2, 2, 1, 2, 2, 1, 2...
## $ ageyr  <int> 13, 13, 13, 13, 12, 14, 12, 12, 13, 12, 12, 12, 12, 12,...
## $ agemo  <int> 1, 7, 1, 2, 2, 1, 1, 2, 0, 5, 2, 11, 7, 8, 6, 1, 11, 5,...
## $ school <fctr> Pasteur, Pasteur, Pasteur, Pasteur, Pasteur, Pasteur, ...
## $ grade  <int> 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7...
## $ x1     <dbl> 3.333333, 5.333333, 4.500000, 5.333333, 4.833333, 5.333...
## $ x2     <dbl> 7.75, 5.25, 5.25, 7.75, 4.75, 5.00, 6.00, 6.25, 5.75, 5...
## $ x3     <dbl> 0.375, 2.125, 1.875, 3.000, 0.875, 2.250, 1.000, 1.875,...
## $ x4     <dbl> 2.333333, 1.666667, 1.000000, 2.666667, 2.666667, 1.000...
## $ x5     <dbl> 5.75, 3.00, 1.75, 4.50, 4.00, 3.00, 6.00, 4.25, 5.75, 5...
## $ x6     <dbl> 1.2857143, 1.2857143, 0.4285714, 2.4285714, 2.5714286, ...
## $ x7     <dbl> 3.391304, 3.782609, 3.260870, 3.000000, 3.695652, 4.347...
## $ x8     <dbl> 5.75, 6.25, 3.90, 5.30, 6.30, 6.65, 6.20, 5.15, 4.65, 4...
## $ x9     <dbl> 6.361111, 7.916667, 4.416667, 4.861111, 5.916667, 7.500...
```


## Defining the model

Define the CFA model you want to run using 'lavaan model syntax'^[A full guide is here: <http://lavaan.ugent.be/tutorial/syntax1.html>]. For example:



```r
hz.model <- '
visual =~ x1 + x2 + x3
writing =~ x4 + x5 + x6
maths =~ x7 + x8 + x9
'
```

The model is defined in text, and can be broken over lines for clarity.  Here was save it in a variable named `hz.model`. 

The model is defined by naming latent variables, and then specifying which observed variables measure them. The latent variable names are followed by =~ which means 'is manifested by'.


To run the analysis:


```r
hz.fit <- cfa(hz.model, data=hz)
```
  

To display the results:


```r
hz.fit.summary <- summary(hz.fit, standardized=TRUE)
## lavaan (0.5-23.1097) converged normally after  35 iterations
## 
##   Number of observations                           301
## 
##   Estimator                                         ML
##   Minimum Function Test Statistic               85.306
##   Degrees of freedom                                24
##   P-value (Chi-square)                           0.000
## 
## Parameter Estimates:
## 
##   Information                                 Expected
##   Standard Errors                             Standard
## 
## Latent Variables:
##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
##   visual =~                                                             
##     x1                1.000                               0.900    0.772
##     x2                0.554    0.100    5.554    0.000    0.498    0.424
##     x3                0.729    0.109    6.685    0.000    0.656    0.581
##   writing =~                                                            
##     x4                1.000                               0.990    0.852
##     x5                1.113    0.065   17.014    0.000    1.102    0.855
##     x6                0.926    0.055   16.703    0.000    0.917    0.838
##   maths =~                                                              
##     x7                1.000                               0.619    0.570
##     x8                1.180    0.165    7.152    0.000    0.731    0.723
##     x9                1.082    0.151    7.155    0.000    0.670    0.665
## 
## Covariances:
##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
##   visual ~~                                                             
##     writing           0.408    0.074    5.552    0.000    0.459    0.459
##     maths             0.262    0.056    4.660    0.000    0.471    0.471
##   writing ~~                                                            
##     maths             0.173    0.049    3.518    0.000    0.283    0.283
## 
## Variances:
##                    Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
##    .x1                0.549    0.114    4.833    0.000    0.549    0.404
##    .x2                1.134    0.102   11.146    0.000    1.134    0.821
##    .x3                0.844    0.091    9.317    0.000    0.844    0.662
##    .x4                0.371    0.048    7.779    0.000    0.371    0.275
##    .x5                0.446    0.058    7.642    0.000    0.446    0.269
##    .x6                0.356    0.043    8.277    0.000    0.356    0.298
##    .x7                0.799    0.081    9.823    0.000    0.799    0.676
##    .x8                0.488    0.074    6.573    0.000    0.488    0.477
##    .x9                0.566    0.071    8.003    0.000    0.566    0.558
##     visual            0.809    0.145    5.564    0.000    1.000    1.000
##     writing           0.979    0.112    8.737    0.000    1.000    1.000
##     maths             0.384    0.086    4.451    0.000    1.000    1.000
hz.fit.summary
## NULL
```


The output has three parts:

1. Parameter estimates. The values in the first column are the standardised weights from the observed variables to the latent factors.

2. Factor covariances. The values in the first column are the covariances between the latent factors.

3. Error variances. The values in the first column are the estimates of each observed variable’s error variance.



## Model fit

To examine the model fit:


```r
fitmeasures(hz.fit, c('cfi', 'rmsea', 'rmsea.ci.upper', 'bic')) 
##            cfi          rmsea rmsea.ci.upper            bic 
##          0.931          0.092          0.114       7595.339
```


This looks OK, but could be improved. 


## Modification indices

To examine the modification indices (here sorted to see the largest first) we type:


```r
modificationindices(hz.fit) %>% 
  as.data.frame() %>% 
  arrange(-mi) %>% 
  filter(mi > 10) %>% 
  select(lhs, op, rhs, mi, epc) %>% 
  pander::pander()
```


-------------------------------
 lhs    op   rhs   mi     epc  
------ ---- ----- ----- -------
visual  =~   x9   36.41  0.577 

  x7    ~~   x8   34.15 0.5364 

visual  =~   x7   18.63 -0.4219

  x8    ~~   x9   14.95 -0.4231
-------------------------------


Latent factor to variable links have `=~` in the 'op' column. Error covariances for observed variables have `~~` as the op. These symbols match the symbols used to describe a path in the lavaan model syntax.


If we add the largest MI path to our model it will look like this:


```r
hz.model.2 <- "
visual =~ x1 + x2 + x3
writing =~ x4 + x5 + x6 + x9
maths =~ x7 + x8 + x9
"
hz.fit.2 <- cfa(hz.model.2, data=hz)
fitmeasures(hz.fit.2, c('cfi', 'rmsea', 'rmsea.ci.upper', 'bic')) 
##            cfi          rmsea rmsea.ci.upper            bic 
##          0.936          0.091          0.113       7595.660
```

RMSEA has improved marginally, but we'd probably want to investigate this model further, and make additional improvements to it.


## Missing data

If you have missing data, add the argument `estimator='MLM'` to the `cfa()` function to use a robust method. There are no missing data in this dataset, but it would look like this:


```r
hz.fit.2.mlm <- cfa(hz.model.2, data=hz, estimator="MLM")
hz.fit.2.mlm
## lavaan (0.5-23.1097) converged normally after  35 iterations
## 
##   Number of observations                           301
## 
##   Estimator                                         ML      Robust
##   Minimum Function Test Statistic               79.919      75.703
##   Degrees of freedom                                23          23
##   P-value (Chi-square)                           0.000       0.000
##   Scaling correction factor                                  1.056
##     for the Satorra-Bentler correction
```


