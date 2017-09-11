---
title: 'Real data'
output:
  bookdown::tufte_html2
---



# (PART) Data {- #data}


# 'Real' data {#real-data}

*Note: If you already lucky enough to have nicely formatted data, ready for use in R, then you could skip this section and revisit it later,* save for the section on [factors and other variable types](#factors-and-numerics).

Most tutorials and textbooks use neatly formatted example datasets to illustrate particular techniques. However in the real-world our data can be:

- In the wrong format
- Spread across multiple files
- Badly coded, or with errors
- Incomplete, with values missing for many different reasons


This chapter will give you techniques to address each of these problems.



## Types of variable {- #factors-and-numerics}

When working with data in Excel or other packages like SPSS you've probably become aware that different types of data get treated differently. For example, in Excel you can't set up a formula like `=SUM(...)` on cells which include letters (rather than just numbers). It does't make sense. However, Excel and many other programmes will sometimes make guesses about what to do if you combine different types of data. 

For example, if you add `28` to `1 Feb 2017` the result is `1 March 2017`. This is sometimes what you want, but can often lead to [unexpected results and errors in data analyses](http://www.sciencemag.org/news/sifter/one-five-genetics-papers-contains-errors-thanks-microsoft-excel).

R is much more strict about not mixing types of data. Vectors (or columns in dataframes) can only contain one type of thing. In general, there are probably 4 types of data you will encounter in data analysis problems:

- Numeric variables
- Character variables
- Factors
- Dates





The file `data/lakers.RDS` contains a dataset adapted from the `lubridate::lakers` dataset.

It contains four variables to illustrate the common variable types. From the original dataset which provides scores and other information from each Los Angeles Lakers basketball game in the 2008-2009 season we have the `date`, `opponent`, `team`, and  `points` variables.


```r
lakers <- readRDS("data/lakers.RDS")
lakers %>% 
  glimpse
## Observations: 34,624
## Variables: 4
## $ date     <date> 2008-10-28, 2008-10-28, 2008-10-28, 2008-10-28, 2008...
## $ opponent <chr> "POR", "POR", "POR", "POR", "POR", "POR", "POR", "POR...
## $ team     <fctr> OFF, LAL, LAL, LAL, LAL, LAL, POR, LAL, LAL, POR, LA...
## $ points   <int> 0, 0, 0, 0, 0, 2, 0, 1, 0, 2, 2, 0, 0, 2, 2, 0, 0, 2,...
```


One thing to note here is that the `glimpse()` command tells us the *type* of each variable. So we have 

- `points`: type `int`, short for integer (i.e. whole numbers). 
- `date`: type `date`
- `opponent`: type `chr`, short for 'character', or alaphanumeric data
- `team`: type `fctr`, short for factor and



### Differences in *quantity*: numeric variables {-}

We've already seem numeric variables in the section on [vectors and lists](#vectors). These behave pretty much as you'd expect, and we won't expand on them here. 


#### {- .tip}

There are different types of numeric variable, (e.g. integers, stored as `int`  v.s. types like `dbl` which can store numbers with a decimal place) but for most purposes the differences won't matter.



### Differences in *quality or kind* {- #character-and-factor}

In many cases variables will be used to identify values which are *qualitatively different*. For example, different groups or measurement occasions in an experimental study, or perhaps different genders or countries in survey data.


In practice, these qualitative differences get stored in a range of different variable types, including:

- Numeric variables (e.g. `time = 1`, or `time = 2`...)
- Character variables (e.g. `time = "time 1"`, `time = "time 2"`...)
- Boolean or logical variables (e.g. `time1 == TRUE` or `time1 == FALSE`)
- 'Factors'



Storing categories as numeric variables can produce [confusing results when running regression models](#factors-vs-linear-inputs).  

For this reason, it's normally best to store your categorical variables as descriptive strings of letters and numbers (e.g. "Treatment", "Control") and avoid simple numbers (e.g. 1, 2, 3). Or as a factor.

Factors are R's answer to the problem of storing categorical data.
Factors assign one number for each unique value in a variable, and optionally allow you to attach a label to it.


For example:


```r
1:10
##  [1]  1  2  3  4  5  6  7  8  9 10

group.factor <- factor(1:10)
group.factor
##  [1] 1  2  3  4  5  6  7  8  9  10
## Levels: 1 2 3 4 5 6 7 8 9 10

group.labelled <- factor(1:10, labels = paste("Group", 1:10))
group.labelled
##  [1] Group 1  Group 2  Group 3  Group 4  Group 5  Group 6  Group 7 
##  [8] Group 8  Group 9  Group 10
## 10 Levels: Group 1 Group 2 Group 3 Group 4 Group 5 Group 6 ... Group 10
```

We can see this 'underlying' number which represents each category by using `as.numeric`:


```r
# note, there is no guarantee that "Group 1" == 1 (although it is here)
as.numeric(group.labelled)
##  [1]  1  2  3  4  5  6  7  8  9 10
```



For simple analyses it's often best to store everything as the `character` type (letters and numbers), but factors can still be useful for making tables or graphs where the list of categories is known and needs to be in a particular order. For more about factors, and lots of useful functions for working with them, see the `forcats::` package: <https://github.com/tidyverse/forcats>



### Dates {-}

Internally, R stores dates as the number of days since January 1, 1970. This means that we can work with dates just like other numbers, and it makes sense to have the `min()`, or `max()` of a series of dates:



```r
# the first few dates in the sequence
head(lakers$date)
## [1] "2008-10-28" "2008-10-28" "2008-10-28" "2008-10-28" "2008-10-28"
## [6] "2008-10-28"

# first and last dates
min(lakers$date)
## [1] "2008-10-28"
max(lakers$date)
## [1] "2009-04-14"
```

Because dates are numbers we can also do arithmetic with them, and R will give us a difference (in this case, in days):


```r
max(lakers$date) - min(lakers$date)
## Time difference of 168 days
```

However, R does treat dates slightly differently from other numbers, and will format plot axes appropriately, which is helpful (see more on this in the [graphics section](#graphics)):


```r
hist(lakers$date, breaks=7)
```

<img src="real-data_files/figure-html/unnamed-chunk-8-1.png" width="672" />


### Missing values {-}

Missing values aren't a data type as such, but are an important concept in R; the way different functions handle missing values can be both helpful and frustrating in equal measure. [The next section covers the handling of missing data in more detail](#missing).


## Missing values {- #missing}

Missing values aren't a data type as such, but are an important concept in R; the way different functions handle missing values can be both helpful and frustrating in equal measure.

Missing values in a vector are denoted by the letters `NA`, but notice that these letters are unquoted. That is to say `NA` is not the same as `"NA"`!

To check for missing values in a vector (or dataframe column) we use the `is.na()` function:


```r
nums.with.missing <- c(1, 2, NA)
nums.with.missing
## [1]  1  2 NA

is.na(nums.with.missing)
## [1] FALSE FALSE  TRUE
```


Here the `is.na()` function has tested whether each item in our vector called `nums.with.missing` is missing. It returns a new vector with the results of each test: either `TRUE` or `FALSE`.

We can also use the negation operator, the `!` symbol to reverse the meaning of `is.na`. So we can read `!is.na(nums)` as "test whether the values in `nums` are NOT missing":


```r
# test if missing
is.na(nums.with.missing)
## [1] FALSE FALSE  TRUE

# test if NOT missing
!is.na(nums.with.missing)
## [1]  TRUE  TRUE FALSE
```


We can use the `is.na()` function as part of dplyr filters:


```r
airquality %>% 
  filter(is.na(Solar.R)) %>% 
  head(3) %>% 
  pander
```


---------------------------------------------
 Ozone   Solar.R   Wind   Temp   Month   Day 
------- --------- ------ ------ ------- -----
  NA       NA      14.3    56      5      5  

  28       NA      14.9    66      5      6  

   7       NA      6.9     74      5     11  
---------------------------------------------


Or to select only cases without missing values for a particular variable:


```r
airquality %>% 
  filter(!is.na(Solar.R)) %>% 
  head(3) %>% 
  pander
```


---------------------------------------------
 Ozone   Solar.R   Wind   Temp   Month   Day 
------- --------- ------ ------ ------- -----
  41       190     7.4     67      5      1  

  36       118      8      72      5      2  

  12       149     12.6    74      5      3  
---------------------------------------------

#### Complete cases {- #complete-cases}


Sometimes we want to select only rows which have no missing values --- i.e. *complete cases*. 

The `complete.cases` function accepts a dataframe (or matrix) and tests whether each *row* is complete. It returns a vector with a `TRUE/FALSE` result for each row:


```r
complete.cases(airquality) %>% 
  head
## [1]  TRUE  TRUE  TRUE  TRUE FALSE FALSE
```

This can also be useful in dplyr filters. Here we show all the rows which are *not* complete (note the exclamation mark):


```r
airquality %>% 
  filter(!complete.cases(airquality))
##    Ozone Solar.R Wind Temp Month Day
## 1     NA      NA 14.3   56     5   5
## 2     28      NA 14.9   66     5   6
## 3     NA     194  8.6   69     5  10
## 4      7      NA  6.9   74     5  11
## 5     NA      66 16.6   57     5  25
## 6     NA     266 14.9   58     5  26
## 7     NA      NA  8.0   57     5  27
## 8     NA     286  8.6   78     6   1
## 9     NA     287  9.7   74     6   2
## 10    NA     242 16.1   67     6   3
## 11    NA     186  9.2   84     6   4
## 12    NA     220  8.6   85     6   5
## 13    NA     264 14.3   79     6   6
## 14    NA     273  6.9   87     6   8
## 15    NA     259 10.9   93     6  11
## 16    NA     250  9.2   92     6  12
## 17    NA     332 13.8   80     6  14
## 18    NA     322 11.5   79     6  15
## 19    NA     150  6.3   77     6  21
## 20    NA      59  1.7   76     6  22
## 21    NA      91  4.6   76     6  23
## 22    NA     250  6.3   76     6  24
## 23    NA     135  8.0   75     6  25
## 24    NA     127  8.0   78     6  26
## 25    NA      47 10.3   73     6  27
## 26    NA      98 11.5   80     6  28
## 27    NA      31 14.9   77     6  29
## 28    NA     138  8.0   83     6  30
## 29    NA     101 10.9   84     7   4
## 30    NA     139  8.6   82     7  11
## 31    NA     291 14.9   91     7  14
## 32    NA     258  9.7   81     7  22
## 33    NA     295 11.5   82     7  23
## 34    78      NA  6.9   86     8   4
## 35    35      NA  7.4   85     8   5
## 36    66      NA  4.6   87     8   6
## 37    NA     222  8.6   92     8  10
## 38    NA     137 11.5   86     8  11
## 39    NA      64 11.5   79     8  15
## 40    NA     255 12.6   75     8  23
## 41    NA     153  5.7   88     8  27
## 42    NA     145 13.2   77     9  27
```



#### {- .tip}

Sometimes it's convenient to use the `.` (period) to represent the output from the previous pipe command. For example, we could rewrite the previous example as:


```r
airquality %>% 
  filter(!complete.cases(.))  # note the . (period) here in place of `airmiles`
##    Ozone Solar.R Wind Temp Month Day
## 1     NA      NA 14.3   56     5   5
## 2     28      NA 14.9   66     5   6
## 3     NA     194  8.6   69     5  10
## 4      7      NA  6.9   74     5  11
## 5     NA      66 16.6   57     5  25
## 6     NA     266 14.9   58     5  26
## 7     NA      NA  8.0   57     5  27
## 8     NA     286  8.6   78     6   1
## 9     NA     287  9.7   74     6   2
## 10    NA     242 16.1   67     6   3
## 11    NA     186  9.2   84     6   4
## 12    NA     220  8.6   85     6   5
## 13    NA     264 14.3   79     6   6
## 14    NA     273  6.9   87     6   8
## 15    NA     259 10.9   93     6  11
## 16    NA     250  9.2   92     6  12
## 17    NA     332 13.8   80     6  14
## 18    NA     322 11.5   79     6  15
## 19    NA     150  6.3   77     6  21
## 20    NA      59  1.7   76     6  22
## 21    NA      91  4.6   76     6  23
## 22    NA     250  6.3   76     6  24
## 23    NA     135  8.0   75     6  25
## 24    NA     127  8.0   78     6  26
## 25    NA      47 10.3   73     6  27
## 26    NA      98 11.5   80     6  28
## 27    NA      31 14.9   77     6  29
## 28    NA     138  8.0   83     6  30
## 29    NA     101 10.9   84     7   4
## 30    NA     139  8.6   82     7  11
## 31    NA     291 14.9   91     7  14
## 32    NA     258  9.7   81     7  22
## 33    NA     295 11.5   82     7  23
## 34    78      NA  6.9   86     8   4
## 35    35      NA  7.4   85     8   5
## 36    66      NA  4.6   87     8   6
## 37    NA     222  8.6   92     8  10
## 38    NA     137 11.5   86     8  11
## 39    NA      64 11.5   79     8  15
## 40    NA     255 12.6   75     8  23
## 41    NA     153  5.7   88     8  27
## 42    NA     145 13.2   77     9  27
```


This is nice because we can apply the `complete.cases` function to the output of the previous pipe. For example, if we wanted to select complete cases for a subset of the variables we could write:


```r
airquality %>% 
  select(Ozone, Solar.R) %>% 
  filter(!complete.cases(.))
##    Ozone Solar.R
## 1     NA      NA
## 2     28      NA
## 3     NA     194
## 4      7      NA
## 5     NA      66
## 6     NA     266
## 7     NA      NA
## 8     NA     286
## 9     NA     287
## 10    NA     242
## 11    NA     186
## 12    NA     220
## 13    NA     264
## 14    NA     273
## 15    NA     259
## 16    NA     250
## 17    NA     332
## 18    NA     322
## 19    NA     150
## 20    NA      59
## 21    NA      91
## 22    NA     250
## 23    NA     135
## 24    NA     127
## 25    NA      47
## 26    NA      98
## 27    NA      31
## 28    NA     138
## 29    NA     101
## 30    NA     139
## 31    NA     291
## 32    NA     258
## 33    NA     295
## 34    78      NA
## 35    35      NA
## 36    66      NA
## 37    NA     222
## 38    NA     137
## 39    NA      64
## 40    NA     255
## 41    NA     153
## 42    NA     145
```

Or alternatively:


```r
rows.to.keep <- !complete.cases(select(airquality, Ozone, Solar.R))
airquality %>% 
  filter(rows.to.keep) %>% 
  head(3) %>% 
  pander
```


---------------------------------------------
 Ozone   Solar.R   Wind   Temp   Month   Day 
------- --------- ------ ------ ------- -----
  NA       NA      14.3    56      5      5  

  28       NA      14.9    66      5      6  

  NA       194     8.6     69      5     10  
---------------------------------------------



#### Missing data and R functions {- #na.rm}

It's normally good practice to pre-process your data and select the rows you want to analyse *before* passing dataframes to R functions.

The reason for this is that different functions behave differently with missing data. 

For example:


```r
mean(airquality$Solar.R)
## [1] NA
```

Here the default for `mean()` is to return NA if any of the values are missing. We can explicitly tell R to ignore missing values by setting `na.rm=TRUE`


```r
mean(airquality$Solar.R, na.rm=TRUE)
## [1] 185.9315
```


In contrast some other functions, for example the `lm()` which runs a linear regression will ignore missing values by default. If we run `summary` on the call to `lm` then we can see the line near the bottom of the output which reads: "(7 observations deleted due to missingness)"


```r
lm(Solar.R ~ Temp, data=airquality) %>% 
  summary
## 
## Call:
## lm(formula = Solar.R ~ Temp, data = airquality)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -169.697  -59.315    6.224   67.685  186.083 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  -24.431     61.508  -0.397 0.691809    
## Temp           2.693      0.782   3.444 0.000752 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 86.86 on 144 degrees of freedom
##   (7 observations deleted due to missingness)
## Multiple R-squared:  0.07609,	Adjusted R-squared:  0.06967 
## F-statistic: 11.86 on 1 and 144 DF,  p-value: 0.0007518
```


[Normally R will do the 'sensible thing' when there are missing values, but it's always worth checking whether you do have any missing data, and addressing this explicitly in your code]{.tip}




#### Patterns of missingness {-}

The `mice` package has some nice functions to describe patterns of missingness in the data. These can be useful both at the exploratory stage, when you are checking and validating your data, but can also be used to create tables of missingness for publication:


```r
mice::md.pattern(airquality) 
##     Wind Temp Month Day Solar.R Ozone   
## 111    1    1     1   1       1     1  0
##  35    1    1     1   1       1     0  1
##   5    1    1     1   1       0     1  1
##   2    1    1     1   1       0     0  2
##        0    0     0   0       7    37 44
```


In this table, `md.pattern` list the number of cases with particular patterns of missing data.
- Each row describes a misisng data 'pattern'
- The first column indicates the number of cases
- The central columns indicate whether a particular variable is missing for the pattern (0=missing)
- The last column counts the number of values missing for the pattern
- The final row counts the number of missing values for each variable.



##### Visualising missingness

Graphics can also be useful to explore patterns in missingness.  

`rct.data` contains data from an RCT of functional imagery training (FIT) for weight loss, which measured outcome (weight in kg) at baseline and two followups (`kg1`, `kg2`, `kg3`). The trial also measured global quality of life (`gqol`).

As is common, there were some missing data at the follouwp:


```r
fit.data <- readRDS("data/fit-weight.RDS") %>% 
  select(kg1, kg2, kg3, age, gqol1)

mice::md.pattern(fit.data)
##     kg1 age gqol1 kg2 kg3   
## 112   1   1     1   1   1  0
##   2   1   1     1   1   0  1
##   7   1   1     1   0   0  2
##   8   0   0     0   0   0  5
##       8   8     8  15  17 56
```


We might be interested to explore patterns in which observations were missing. Here we use colour to identify missing observations as a function of the data recorded at baseline:


```r
fit.data %>% 
  mutate(missing.followup = is.na(kg2)) %>% 
  ggplot(aes(kg1, age, color=missing.followup)) +
  geom_point()
```

<img src="real-data_files/figure-html/unnamed-chunk-23-1.png" width="672" />

There's a clear trend here for lighter patients (at baseline) to have more missing data at followup. There's also a suggestion that younger patients are more likely to have been lost to followup.

If needed, we could perform formal statistical tests for these differences:


```r
t.test(kg1 ~ is.na(kg2), data=fit.data)
## 
## 	Welch Two Sample t-test
## 
## data:  kg1 by is.na(kg2)
## t = 4.7153, df = 11.132, p-value = 0.000614
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##   7.005116 19.236238
## sample estimates:
## mean in group FALSE  mean in group TRUE 
##            90.59211            77.47143
t.test(age ~ is.na(kg2), data=fit.data)
## 
## 	Welch Two Sample t-test
## 
## data:  age by is.na(kg2)
## t = 1.2418, df = 6.5246, p-value = 0.2571
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -7.39455 23.25169
## sample estimates:
## mean in group FALSE  mean in group TRUE 
##            43.50000            35.57143
```


However, given the small number of missing values and the post-hoc nature of these analyses these tests are rather underpowered and we might prefer to report and comment on the plot and alone.


For some nice missing data visualisation techniques, including those for repeated measures data, see @zhang2015missing.





## Tidying data {-}


'Tidying' data means converting it into the format that is most useful for data analyses, and so we have already covered many of the key techniques: selecting and filtering data, reshaping and summarising.

However the ideas behind 'tidying' draw together other related concepts which link together the way we enter, store and process data: for example the idea of '[relational data]()' and techniques to join together related datasets.


#### A philosophy of tidy data {-}

The chapter on tidying in 'R for data science' is well worth reading for it's thoughtful explanation of why we want tidy data, and the core techniques to clean up untidy data:  <http://r4ds.had.co.nz/tidy-data.html>


#### Broom {- #broom}

The [`broom::` library](http://varianceexplained.org/r/broom-intro/) is also worth learning. It takes a slightly different approach, by providing methods to 'clean up' the output of many older R functions.

For example, the `lm()` or `car::Anova` functions display results in the console, but don't make it easy to extract results as a dataframe.

`broom::` provides a consistent way of extracting the key numbers from most R objects. Let's say we have a regression model:



```r
(model.1 <- lm(mpg ~ factor(cyl) + wt + disp, data=mtcars))
## 
## Call:
## lm(formula = mpg ~ factor(cyl) + wt + disp, data = mtcars)
## 
## Coefficients:
##  (Intercept)  factor(cyl)6  factor(cyl)8            wt          disp  
##    34.041673     -4.305559     -6.322786     -3.306751      0.001715
```


We can extract model fit statistics as a dataframe with `glance`:


```r
glance(model.1)
##   r.squared adj.r.squared    sigma statistic      p.value df    logLik
## 1 0.8375299     0.8134602 2.603054   34.7961 2.726351e-10  5 -73.30158
##        AIC      BIC deviance df.residual
## 1 158.6032 167.3976  182.949          27
```

Coefficients with `tidy`:

```r
tidy(model.1)
##           term     estimate  std.error  statistic      p.value
## 1  (Intercept) 34.041672760 1.96303906 17.3413120 3.661629e-16
## 2 factor(cyl)6 -4.305559465 1.46475954 -2.9394309 6.661872e-03
## 3 factor(cyl)8 -6.322785631 2.59841631 -2.4333228 2.186022e-02
## 4           wt -3.306751078 1.10508285 -2.9923106 5.855001e-03
## 5         disp  0.001714866 0.01348116  0.1272046 8.997211e-01
```

Which can then be plotted easily (adding the `conf.int=T` includes 95% confidence intervals for each parameter):


```r
tidy(model.1, conf.int = T) %>% 
  ggplot(aes(term, estimate, ymin=conf.low, ymax=conf.high)) + 
  geom_pointrange() +
  geom_hline(yintercept = 0)
```

<img src="real-data_files/figure-html/unnamed-chunk-28-1.png" width="672" />

Finally, we can get fitted and residual values, plus common diagnostic metrics like Cooks distances, using the `augment` function:


```r
augment(model.1) %>% head
##           .rownames  mpg factor.cyl.    wt disp  .fitted   .se.fit
## 1         Mazda RX4 21.0           6 2.620  160 21.34680 1.0583597
## 2     Mazda RX4 Wag 21.0           6 2.875  160 20.50358 1.0086391
## 3        Datsun 710 22.8           4 2.320  108 26.55522 0.7853730
## 4    Hornet 4 Drive 21.4           6 3.215  258 19.54734 1.3552679
## 5 Hornet Sportabout 18.7           8 3.440  360 16.96102 0.9783961
## 6           Valiant 18.1           6 3.460  225 18.68060 1.0587563
##       .resid       .hat   .sigma      .cooksd .std.resid
## 1 -0.3468040 0.16531044 2.651595 0.0008423297 -0.1458272
## 2  0.4964176 0.15014309 2.650537 0.0015120693  0.2068669
## 3 -3.7552157 0.09103024 2.537679 0.0458585462 -1.5131327
## 4  1.8526561 0.27107161 2.618281 0.0516853704  0.8336221
## 5  1.7389850 0.14127428 2.626986 0.0171005288  0.7209173
## 6 -0.5805993 0.16543438 2.649710 0.0023633145 -0.2441536
```


Again these can be plotted:


```r
augment(model.1) %>% 
  ggplot(aes(x=.fitted, y=.resid)) + 
  geom_point() + 
  geom_smooth()
```

<img src="real-data_files/figure-html/unnamed-chunk-30-1.png" width="672" />



Because `broom` always returns a dataframe with a consistent set of column names we can also combine model results into tables for comparison. In this plot we see what happens to the regression coefficients in model 1 when we add `disp`, `carb` and `drat` in model 2. We plot the coefficients side by side for ease of comparison, and can see that the estimates for cyl1 and wt both shrink slightly with the addition of these variables:



```r
# run a new model with more predictors
(model.2 <- lm(mpg ~ factor(cyl) + wt + disp + carb + drat, data=mtcars))
## 
## Call:
## lm(formula = mpg ~ factor(cyl) + wt + disp + carb + drat, data = mtcars)
## 
## Coefficients:
##  (Intercept)  factor(cyl)6  factor(cyl)8            wt          disp  
##    29.849209     -2.796142     -4.116561     -2.748229     -0.002826  
##         carb          drat  
##    -0.587422      1.056532

# make a single dataframe from both models
# addin a new `model` column with mutate to 
# identify which coefficient came from which model
combined.results <- bind_rows(
  tidy(model.1, conf.int = T) %>% mutate(model="1"), 
  tidy(model.2, conf.int = T) %>%  mutate(model="2")) 
```


```r
combined.results %>% 
  # remove the intercept to make plot scale more sane
  filter(term != "(Intercept)") %>% 
  ggplot(aes(term, estimate, ymin=conf.low, ymax=conf.high, color=model)) +
    geom_pointrange(position=position_dodge(width=.1)) + 
  geom_hline(yintercept = 0)
```

<img src="real-data_files/figure-html/unnamed-chunk-32-1.png" width="672" />



## Saving things {- #storing-data}


#### Use CSV files {- #use-csv}

Comma-separated-values files are a plain text format which are idea for storing and sharing your data. They are:

- Understood by almost every piece of software, ever
- Will be readable in future
- Perfect for storing 2D data (like dataframes)
- Readable by humans (just open them in Notepad)


Commercial formats like Excel, SPSS (.sav) and Stata (.dta) don't have these properties.

Although CSV has some disadvantages, they are all easily overcome if you [save the steps of your data processing and analysis in your R code](#save-intermediate-steps), see below.



#### Save processes, not outcomes {- #save-intermediate-steps}

Many students (and academics) make errors in their analyses because they process data by hand (e.g. editing files in Excel) or use GUI tools to run analyses.

In both cases these errors are hard to identify or rectify because only the outputs of the analysis can be saved, and *no record has been made of how these outputs were produced*. 

In contrast, if you do your data processing and analysis in R/RMarkdown you benefit from a concrete, repeatable series of steps  which can be checked/verified by others. This can also save lots of time if you need to processing additional data later on (e.g. if you run more participants).


Some principles to follow when working:

- Save your raw data in the simplest possible format, in CSV

- Always include column names in the file

- Use descriptive names, but with a regular strucuture.

- Never include spaces or special characters in the column names. Use underscores (`_`) if you want to make things more readable.

- Make names <20 characters in length if possible





#### RDS files can be useful to preserve R objects {- #rds-files}

If you have R objects which you'd like to save, for example because they took a long time to compute, the the RDS format is the best way of preserving them.

To save something:


```r
# create a huge df of random numbers... 
massive.df <- data_frame(nums = rnorm(1:1e6))
saveRDS(massive.df, file="massive.RDS")
```

Then later on you can load it like this:


```r
restored.massive.df <-  readRDS('massive.RDS')
```

[If you do this in RMarkdown, by default the RDS files will be saved in the same directory as your .Rmd file.]{.tip}








## Dealing with multiple files {- #multiple-raw-data-files}

Oftentimes you will have multiple data files files (hopefully .csv format) to import and process - for example, those produced by experimental software like [PsychoPy](http://www.psychopy.org). This is one of the few times when you might have to do something resembling 'real programming', but it's still fairly straightforward.

In the [repeated measures Anova example later on in this guide](#trad-rm-anova) we encounter some data from an experiment where reaction times were recorded in 25 trials (`Trial`) before and after (`Time`) one of 4 experimental manipulations (`Condition` = {1,2,3,4}). There were 48  participants in total:





Let's say all the files are in a single directory, and numbered sequentially. Using the `list.files()` function we can list the contents of a directory on the hard drive:


```r
list.files('data/multiple-file-example/')
##  [1] "person1.csv"  "person10.csv" "person11.csv" "person12.csv"
##  [5] "person13.csv" "person14.csv" "person15.csv" "person16.csv"
##  [9] "person17.csv" "person18.csv" "person19.csv" "person2.csv" 
## [13] "person20.csv" "person21.csv" "person22.csv" "person23.csv"
## [17] "person24.csv" "person25.csv" "person26.csv" "person27.csv"
## [21] "person28.csv" "person29.csv" "person3.csv"  "person30.csv"
## [25] "person31.csv" "person32.csv" "person33.csv" "person34.csv"
## [29] "person35.csv" "person36.csv" "person37.csv" "person38.csv"
## [33] "person39.csv" "person4.csv"  "person40.csv" "person41.csv"
## [37] "person42.csv" "person43.csv" "person44.csv" "person45.csv"
## [41] "person46.csv" "person47.csv" "person48.csv" "person5.csv" 
## [45] "person6.csv"  "person7.csv"  "person8.csv"  "person9.csv"
```


Helpfully, `list.files()` creates a [vector](#vectors) of the filenames in the directory. 

At this point, there are many, many ways of importing the contents of these files, but below we use a technique which is concise, reliable, and less error-prone than many others. It also continues to use the `dplyr` library.

This approach has 3 steps:

1. Put all the names of the .csv files into a dataframe.
2. For each row in the dataframe, run a function which imports the file as a dataframe.
3. Combine all these dataframes together.



###### Putting the filenames into a dataframe {-}

Because `list.files` produces a vector, we can make them a column in a new dataframe:


```r
raw.files <- data_frame(filename = list.files('data/multiple-file-example/'))
```


And we can make a new column with the complete path (i.e. including the directory holding the files), using the [`paste0`](#paste) which combines strings of text. We wouldn't have to do this if the raw files were in the same directory as our RMarkdown file, but that would get messy.


```r
raw.file.paths <- raw.files  %>% 
  mutate(filepath = paste0("data/multiple-file-example/", filename))

raw.file.paths %>% 
  head(3)
## # A tibble: 3 x 2
##       filename                                filepath
##          <chr>                                   <chr>
## 1  person1.csv  data/multiple-file-example/person1.csv
## 2 person10.csv data/multiple-file-example/person10.csv
## 3 person11.csv data/multiple-file-example/person11.csv
```



###### Using `do()` {- #dplyr-do}

We can then use the `do()` function in `dplyr::` to import the data for each file and combine the results in a single dataframe.

The `do()` function allows us to run any R function for each group or row in a dataframe. 

The means that our original dataframe is broken up into chunks (either groups of rows, if we use `group_by()`, or individual rows if we use `rowwise()`) and each chunk is fed to the function we specify. This function must do it's work and return a new dataframe, and these are then combined into a single larger dataframe.

So in this example, we break our dataframe of filenames up into individual rows using `rowwise` and then specify the `read_csv` function which takes the name of a csv file, and returns the content as a dataframe ([see the importing data section](#importing-data)).

For example:


```r
raw.data <- raw.file.paths %>%
  # 'do' the function for each row in turn
  rowwise() %>% 
  do(., read_csv(file=.$filepath))
```


We can check these data look OK by sampling 10 rows at random:


```r
raw.data %>% 
  sample_n(10) %>% 
  pander()
```


-------------------------------------------
 Condition   trial   time   person    RT   
----------- ------- ------ -------- -------
     2         7      2       15     346.6 

     3         5      2       30     321.5 

     4         7      2       41     256.1 

     3        18      1       27     247.5 

     2        24      1       19     172.6 

     1        21      1       4      198.5 

     1         2      1       5      345.1 

     4         9      1       43     227.9 

     3        13      1       36     354.1 

     3         5      1       32      225  
-------------------------------------------



##### Using custom functions with `do()` {-}

In this example, each of the raw data files included the participant number (the `person` variable). However, this isn't always the case.

This isn't a problem though, if we create our own [helper function](#helper-functions) to import the data. Writing small functions in R is very easy, and the example below wraps the `read.csv()` function and adds a new colum, `filename` to the imported data frame which would enable us to keep track of where each row in the final combined dataset came from.

This is the helper function: 


```r
read.csv.and.add.filename <- function(filepath){
  read_csv(filepath) %>% 
    mutate(filepath=filepath)
}
```

In English, you should read this as: 

> "Create a new R function called `read.csv.and.add.filename` which expects to be passed a path to a csv file as an input. This function reads the csv file at the path (converting it to a dataframe), and adds a new column containing the original file path it read from. It then returns this dataframe."


We can use our helper function with `do()` in place of the bare `read_csv` function we used before:



```r
raw.data.with.paths <- raw.file.paths %>%
  rowwise() %>% 
  do(., read.csv.and.add.filename(.$filepath))

raw.data.with.paths %>% 
  sample_n(10) %>%
  pander()
```


-------------------------------------------
 Condition   trial   time   person    RT   
----------- ------- ------ -------- -------
     2         2      1       16     231.3 

     4        22      1       38     302.7 

     4         8      1       40     181.5 

     2        17      1       21     192.5 

     4        15      2       38     121.5 

     3        22      1       34     271.8 

     1        22      1       1       177  

     3        13      1       36     354.1 

     4        23      1       38     161.1 

     4         9      1       44     217.5 
-------------------------------------------

Table: Table continues below

 
-----------------------------------------
                filepath                 
-----------------------------------------
 data/multiple-file-example/person16.csv 

 data/multiple-file-example/person38.csv 

 data/multiple-file-example/person40.csv 

 data/multiple-file-example/person21.csv 

 data/multiple-file-example/person38.csv 

 data/multiple-file-example/person34.csv 

 data/multiple-file-example/person1.csv  

 data/multiple-file-example/person36.csv 

 data/multiple-file-example/person38.csv 

 data/multiple-file-example/person44.csv 
-----------------------------------------


At this point you might need to [use the `extract()` or `separate()` functions](#extract-to-split-column-names) to post-process the filename and re-create the `person` variable from this (although in this case that's already been done for us).





<!-- TODO1 -->
<!-- - File handling and import -->
<!-- - Writing a function for `do()` which returns a dataframe -->
<!-- - Joins and merges -->



<!-- ##  Error checking {-} -->

<!-- - `999`, `666` and `*`: the marks of the beast! -->




