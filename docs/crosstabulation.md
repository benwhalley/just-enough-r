---
title: 'Crosstabulation'
output: 
  bookdown::tufte_html2
---







## Crosstabulations and chi.^2^ {- #crosstabs}


We saw in a previous section [how to create a frequency table of one or more variables](#frequency-tables). Using that previous example, assume  we already have a crosstabulation of `age` and `prefers`




```r
lego.table
##          prefers
## age       duplo lego
##   4 years    38   20
##   6 years    12   30
```

We can easily run the inferential chi^2^ test on this table:


```r
lego.test <- chisq.test(lego.table)
lego.test
## 
## 	Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  lego.table
## X-squared = 11.864, df = 1, p-value = 0.0005724
```


Note that we can access each number in this output individually because the `chisq.test` function returns [a list](#lists). We do this by using the `$` syntax:



```r
# access the chi2 value alone
lego.test$statistic
## X-squared 
##  11.86371
```

Even nicer,  you can use R to write up your results for you in APA format!


```r
apa::apa(lego.test, print_n=T)
## [1] "$\\chi^2$(1, n = 100) = 11.86, *p* < .001"
```

[See more on automatically displaying statistics in APA format](#apa-output)



### Three-way tables

You can also use `table()` to get 3-way tables of frequencies. For example, using the `mtcars` dataset we create a 3-way table, and then convert the result to a dataframe so we can print the table nicely in RMarkdown using the `pandoc.table()` function.


```r
with(mtcars, table(am, cyl, gear)) %>%
  as.data.frame() %>% 
  head() %>% 
  pandoc.table()
## 
## ------------------------
##  am   cyl   gear   Freq 
## ---- ----- ------ ------
##  0     4     3      1   
## 
##  1     4     3      0   
## 
##  0     6     3      2   
## 
##  1     6     3      0   
## 
##  0     8     3      12  
## 
##  1     8     3      0   
## ------------------------
```



