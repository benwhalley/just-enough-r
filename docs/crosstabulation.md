---
title: 'Crosstabulation'
---







## Crosstabulations and $\chi^2$ {- #crosstabs}


We saw in a previous section [how to create a frequency table of one or more variables](#frequency-tables). Using that previous example, assume  we already have a crosstabulation of `age` and `prefers`




```r
lego.table
##          prefers
## age       duplo lego
##   4 years    38   20
##   6 years    12   30
```

We can easily run the inferential $\chi^2$ (sometimes spelled "chi", but pronounced "kai"-squared) test on this table:



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

Even nicer,  you can use an R package to write up your results for you in APA format!



```r
library(apa)
apa(lego.test, print_n=T)
## [1] "$\\chi^2$(1, n = 100) = 11.86, *p* < .001"
```

[See more on automatically displaying statistics in APA format](#apa-output)



### Three-way tables {-}

You can also use `table()` or `xtabs()` to get 3-way tables of frequencies (`xtabs` is probably better for this than `table`). 

For example, using the `mtcars` dataset we create a 3-way table, and then convert the result to a dataframe. This means we can print the table nicely in RMarkdown using the `pander.table()` function, or process it further (e.g. by [sorting](#sorting) or [reshaping](#reshaping) it).


```r
xtabs(~am+gear+cyl, mtcars) %>%
  as_data_frame() %>% 
  pander()
```


----------------------
 am   gear   cyl   n  
---- ------ ----- ----
 0     3      4    1  

 1     3      4    0  

 0     4      4    2  

 1     4      4    6  

 0     5      4    0  

 1     5      4    2  

 0     3      6    2  

 1     3      6    0  

 0     4      6    2  

 1     4      6    2  

 0     5      6    0  

 1     5      6    1  

 0     3      8    12 

 1     3      8    0  

 0     4      8    0  

 1     4      8    0  

 0     5      8    0  

 1     5      8    2  
----------------------



Often, you will want to present a table in a wider format than this, to aid comparisons between categories. For example, we might want our table to make it easy to compare between US and non-US cars for each different number of cylinders:



```r
xtabs(~am+gear+cyl, mtcars) %>%
  as_data_frame() %>% 
  reshape2::dcast(am+gear~paste(cyl, "Cylinders")) %>% 
  pander()
## Using n as value column: use value.var to override.
```


-----------------------------------------------------
 am   gear   4 Cylinders   6 Cylinders   8 Cylinders 
---- ------ ------------- ------------- -------------
 0     3          1             2            12      

 0     4          2             2             0      

 0     5          0             0             0      

 1     3          0             0             0      

 1     4          6             2             0      

 1     5          2             1             2      
-----------------------------------------------------



Or our primary question might be related to the effect of `am`, in which case we might prefer to incude separate columns for US and non-US cars:


```r
xtabs(~am+gear+cyl, mtcars) %>%
  as_data_frame() %>% 
  reshape2::dcast(gear+cyl~paste0("US=", am)) %>% 
  pander()
## Using n as value column: use value.var to override.
```


--------------------------
 gear   cyl   US=0   US=1 
------ ----- ------ ------
  3      4     1      0   

  3      6     2      0   

  3      8     12     0   

  4      4     2      6   

  4      6     2      2   

  4      8     0      0   

  5      4     0      2   

  5      6     0      1   

  5      8     0      2   
--------------------------







