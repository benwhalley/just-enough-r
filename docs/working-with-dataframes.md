---
title: 'Working with dataframes'
output: 
  bookdown::tufte_html2
---


## Working with dataframes {- #working-with-dataframes}




### Introducing the `tidyverse` {- #tidyverse}

R includes hundreds of built-in ways to select individual elements, rows or columns from a dataframe.  This guide isn't going to teach you many of them.

The truth is that R can be overwhelming to new users, especially those new to programming. R is sometimes _too_ powerful and flexible: there are too many different to accomplish the same end, and this can lead to confusion.

Recently, a suite of packages has been developed for R which tries to provide a simple, consistent set of tools for working with data and graphics.

This suite of packages is called the *tidyverse*, and you can load all of these pacakges by calling:


```r
library(tidyverse)
```


In this guide we make much use of two components from the tidyverse:

- `dplyr`: to select, filter and summarise data
- `ggplot2`: to make plots

It's strongly recommended that you use these in your own code.





### Selecting columns from a dataframe {- #selecting-columns}


*Selecting a single column*:
  Because dataframes act like lists of vectors, we can access columns from them using the `$` symbol. For example, here we select the `Ozone` column, which returns a vector of the observations made:


```r
airquality$Ozone
##   [1]  41  36  12  18  NA  28  23  19   8  NA   7  16  11  14  18  14  34
##  [18]   6  30  11   1  11   4  32  NA  NA  NA  23  45 115  37  NA  NA  NA
##  [35]  NA  NA  NA  29  NA  71  39  NA  NA  23  NA  NA  21  37  20  12  13
##  [52]  NA  NA  NA  NA  NA  NA  NA  NA  NA  NA 135  49  32  NA  64  40  77
##  [69]  97  97  85  NA  10  27  NA   7  48  35  61  79  63  16  NA  NA  80
##  [86] 108  20  52  82  50  64  59  39   9  16  78  35  66 122  89 110  NA
## [103]  NA  44  28  65  NA  22  59  23  31  44  21   9  NA  45 168  73  NA
## [120]  76 118  84  85  96  78  73  91  47  32  20  23  21  24  44  21  28
## [137]   9  13  46  18  13  24  16  13  23  36   7  14  30  NA  14  18  20
```


And we can pass this vector to functions, for example `summary()`:


```r
summary(airquality$Ozone)
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##    1.00   18.00   31.50   42.13   63.25  168.00      37
```



*Selecting more than one column*:
  To select multiple columns the `select()` function from `dplyr` is the simplest solution. You give `select()` a dataframe and the names of the columns you want, and it returns a new dataframe with just those columns, in the order you specified:



```r
head(
  select(mtcars, cyl, hp)
)
##                   cyl  hp
## Mazda RX4           6 110
## Mazda RX4 Wag       6 110
## Datsun 710          4  93
## Hornet 4 Drive      6 110
## Hornet Sportabout   8 175
## Valiant             6 105
```


Because all the main `dplyr` functions tend to return a new dataframe, we can assign the results to a variable, and use that as normal:


```r
cylandweight <- select(mtcars, cyl, wt)
summary(cylandweight)
##       cyl              wt       
##  Min.   :4.000   Min.   :1.513  
##  1st Qu.:4.000   1st Qu.:2.581  
##  Median :6.000   Median :3.325  
##  Mean   :6.188   Mean   :3.217  
##  3rd Qu.:8.000   3rd Qu.:3.610  
##  Max.   :8.000   Max.   :5.424
```


You can also put a minus (`-`) sign in front of the column name to indicate which columns you don't want:



```r
head(
select(airquality, -Ozone, -Solar.R, -Wind)
)
##   Temp Month Day
## 1   67     5   1
## 2   72     5   2
## 3   74     5   3
## 4   62     5   4
## 5   56     5   5
## 6   66     5   6
```



You can use a patterns to match a subset of the columns you want. For example, here we select all the columns where the name contains the letter `d`:


```r
head(
select(mtcars, contains("d"))
)
##                   disp drat
## Mazda RX4          160 3.90
## Mazda RX4 Wag      160 3.90
## Datsun 710         108 3.85
## Hornet 4 Drive     258 3.08
## Hornet Sportabout  360 3.15
## Valiant            225 2.76
```


And you can combine these techniques to make more complex selections:


```r
head(
select(mtcars, contains("d"), -drat)
)
##                   disp
## Mazda RX4          160
## Mazda RX4 Wag      160
## Datsun 710         108
## Hornet 4 Drive     258
## Hornet Sportabout  360
## Valiant            225
```



As a quick reference, you can use the following 'verbs' to select columns in different ways:


- `starts_with()`
- `ends_with()`
- `contains()`
- `everything()`



There are other commands too, but these are probably the most useful to begin with. See the help files for more information.


### Selecting rows of data {- #selecting-rows}

To select particular rows from a dataframe, `dplyr` provides the very useful `select()` function. Let's say we just want the 6-cylindered cars from the `mtcars` dataframe:


```r
filter(mtcars, cyl==6)
##    mpg cyl  disp  hp drat    wt  qsec vs am gear carb
## 1 21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
## 2 21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
## 3 21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
## 4 18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
## 5 19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
## 6 17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
## 7 19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
```

Here we used the `filter` function to select rows matching a particular criteria: in this case, that `cyl==6`. We can match two criteria at once if needed[^notesonoperators]:


```r
filter(mtcars, cyl==6 & gear==3)
##    mpg cyl disp  hp drat    wt  qsec vs am gear carb
## 1 21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
## 2 18.1   6  225 105 2.76 3.460 20.22  1  0    3    1
```



[^notesonoperators]:
  Some notes on `==` and `&`: You might have noted above that I wrote `==` rather than just `=` to define the criteria. This is because most programming languages, including R, use two `=` symbols to distinguish: *comparison* from *assignment*.
Here we are doing comparison, so we use `==`. In R it's normal to use `<-` to assign variables,  which avoids any ambiguity.
The `&` symbol does what you probably expect — it simply means 'AND'.






### Combining column selections and row filters {-}


As you might have noticed above, we can 'nest' function calls in R. For example, we might want to both select some columns and filter rows.

Taking the `mtcars` data, we might want to select the weights of only those cars with low `mpg`:


```r
gas.guzzlers <- select(filter(mtcars, mpg < 15), wt)
summary(gas.guzzlers)
##        wt       
##  Min.   :3.570  
##  1st Qu.:3.840  
##  Median :5.250  
##  Mean   :4.686  
##  3rd Qu.:5.345  
##  Max.   :5.424
```



This is OK, but can get quite confusing to read, and the more deeply functions are nested the easier it is to make a mistake.

### {- #pipes}

`dplyr` provides an alternative to nested function calls, called the pipe.

Imagine your dataframe as a big bucket containing data. From this bucket, you can 'pour' your data down through a series of tubes and filters, until at the bottom of your screen you have a smaller bucket containing just the data you want.


Think of your data 'flowing' down the screen.

To make data flow from one bucket to another, we use the 'pipe' operator: `%>%`


```r
big.bucket.of.data <- mtcars

big.bucket.of.data %>%
  filter(mpg <15) %>%
  select(wt) %>%
  summary
##        wt       
##  Min.   :3.570  
##  1st Qu.:3.840  
##  Median :5.250  
##  Mean   :4.686  
##  3rd Qu.:5.345  
##  Max.   :5.424
```


So we have achieved the same outcome, but the code reads as a series of operations which the data flows through, connected by our pipes (the `%>%`). At the end of the last pipe, our data gets dumped into the `summary()` function^[You might notice that when we write the `select` function we don't explicitly name the dataframe to be used. This is because R *implicitly* passes the output of the pipe to the first argument of the function. So here, the output of `filter(mpg<15)` is used as the dataframe in the `select` function.]

We could just has well have saved this smaller 'bucket' of data so we can use it later on:


```r
smaller.bucket <- big.bucket.of.data %>%
  filter(mpg <15) %>%
  select(wt)
```


This turns out to be an incredibly useful pattern when processing and working with data. We can pour data through a series of filters and other operations, saving intermediate states where necessary.


[You can insert the `%>%` symbol in RStdudio by typing `cmd-shift-M`, which saves a lot of typing.]{.explainer}








### Modifying and creating new columns {- #mutate}


Often when working with data we want to compute new values from columns we already have. Let's say we have some data on the PHQ-9, which measures depression:


```r
phq9.df <- readr::read_csv("phq.csv")
## Parsed with column specification:
## cols(
##   patient = col_integer(),
##   phq9_01 = col_integer(),
##   phq9_02 = col_integer(),
##   phq9_03 = col_integer(),
##   phq9_04 = col_integer(),
##   phq9_05 = col_integer(),
##   phq9_06 = col_integer(),
##   phq9_07 = col_integer(),
##   phq9_08 = col_integer(),
##   phq9_09 = col_integer(),
##   month = col_integer(),
##   group = col_integer()
## )
glimpse(phq9.df)
## Observations: 2,429
## Variables: 12
## $ patient <int> 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, ...
## $ phq9_01 <int> 3, 1, 1, 2, 2, 2, 3, 2, 3, 3, 1, 3, 2, 1, 2, 3, 3, 3, ...
## $ phq9_02 <int> 3, 2, 2, 2, 3, 3, 3, 2, 3, 3, 1, 3, 2, 1, 3, 3, 3, 3, ...
## $ phq9_03 <int> 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 3, 2, 3, 3, ...
## $ phq9_04 <int> 3, 3, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 3, 3, 3, 3, ...
## $ phq9_05 <int> 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 3, 2, 1, 2, ...
## $ phq9_06 <int> 3, 2, 2, 2, 3, 3, 2, 1, 2, 3, 3, 3, 2, 1, 3, 3, 3, 3, ...
## $ phq9_07 <int> 3, 3, 1, 1, 2, 1, 2, 2, 1, 3, 2, 2, 2, 2, 3, 2, 1, 1, ...
## $ phq9_08 <int> 0, 2, 2, 1, 1, 1, 1, 2, 1, 3, 1, 2, 1, 0, 2, 1, 0, 1, ...
## $ phq9_09 <int> 2, 2, 1, 1, 2, 2, 2, 1, 1, 3, 1, 2, 1, 1, 3, 3, 3, 3, ...
## $ month   <int> 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 18, 0, 1,...
## $ group   <int> 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, ...
```


We want to calculate the PHQ-9 score for each patient, at each month. This is easy with `dplyr::mutate()`:


```r
phq9.scored.df <- phq9.df %>%
mutate(phq9 = phq9_01 + phq9_02 + phq9_03 + phq9_04 +
         phq9_05 + phq9_06 + phq9_07 + phq9_08 + phq9_09)

phq9.scored.df %>%
  select(patient, group, month, phq9) %>%
  head
## # A tibble: 6 × 4
##   patient group month  phq9
##     <int> <int> <int> <int>
## 1       1     1     0    23
## 2       2     0     0    21
## 3       2     0     1    17
## 4       2     0     2    18
## 5       2     0     3    22
## 6       2     0     4    21
```

Notice that we first stored the computed scores in `phq9.scored.df` and then used `select()` to get rid of the raw data columns to display only what we needed.

See this section on [summarising and processing data](#split-apply-combine) for nice ways to create summary scores from questionnaires.






### Sorting data {- #sorting}

Sorting data is easy with `dplyr::arrange()`:


```r
airquality %>% 
  arrange(Ozone) %>% 
  head
##   Ozone Solar.R Wind Temp Month Day
## 1     1       8  9.7   59     5  21
## 2     4      25  9.7   61     5  23
## 3     6      78 18.4   57     5  18
## 4     7      NA  6.9   74     5  11
## 5     7      48 14.3   80     7  15
## 6     7      49 10.3   69     9  24
```


By default sorting is ascending, but you can use a minus sign to reverse this:


```r
airquality %>% 
  arrange(-Ozone) %>% 
  head
##   Ozone Solar.R Wind Temp Month Day
## 1   168     238  3.4   81     8  25
## 2   135     269  4.1   84     7   1
## 3   122     255  4.0   89     8   7
## 4   118     225  2.3   94     8  29
## 5   115     223  5.7   79     5  30
## 6   110     207  8.0   90     8   9
```


You can sort on multiple columns too:


```r
airquality %>% 
  select(Month, Ozone) %>% 
  arrange(Month, -Ozone) %>% 
  head
##   Month Ozone
## 1     5   115
## 2     5    45
## 3     5    41
## 4     5    37
## 5     5    36
## 6     5    34
```
