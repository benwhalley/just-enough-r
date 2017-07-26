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





## Selecting columns {- #selecting-columns}


###### Selecting a single column {-}

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




###### Selecting more than one column {-}

To select multiple columns the `select()` function from `dplyr` is the simplest solution. You give `select()` a dataframe plus the names of the columns you want, and it returns a new dataframe with just those columns, in the order you specified:



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


## Selecting rows {- #selecting-rows}

To select particular rows from a dataframe, `dplyr` provides the very useful `filter()` function. Let's say we just want the 6-cylindered cars from the `mtcars` dataframe:


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



## 'Operators' {- #operators}

<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/4TYv2PhG89A?rel=0" frameborder="0" allowfullscreen></iframe>


In the two examples above we used two equals signs `==` to compare values. There are other operators we can use though to create other filters. Rather than describe them, the examples below demonstrate what each of them do:



###### Equality and matching {-}

To compare a single value we use `==`


```r
2 == 2
## [1] TRUE
```

And in a filter:


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



###### {- .explainer}

You might have noted above that we write `==` rather than just `=` to define the criteria. This is because most programming languages, including R, use two `=` symbols to distinguish: *comparison* from *assignment*.

Here we are doing comparison, so we use `==`. In R it's normal to use `<-` to assign variables, which avoids any ambiguity.



To test if a value is in a vector of suitable matches we can use: `%in%`:


```r
0 %in% 1:10
## [1] FALSE
2 %in% 1:10
## [1] TRUE
```

And, perhaps less obviously, we can test whether each value in a vector is in a second vector. This returns a vector of `TRUE/FALSE` values as long as the first list:


```r
c(1, 2) %in% c(2, 3, 4)
## [1] FALSE  TRUE
```

And this is very useful in a dataframe filter:



```r
head(filter(mtcars, cyl %in% c(4, 6)))
##    mpg cyl  disp  hp drat    wt  qsec vs am gear carb
## 1 21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
## 2 21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
## 3 22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
## 4 21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
## 5 18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
## 6 24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
```




###### Greater/less than {-}

The `<` and `>` symbols work as you'd expect:


```r
head(filter(mtcars, cyl > 4))
head(filter(mtcars, cyl < 5))
```


You can also use `>=` and `<=`:


```r
filter(mtcars, cyl >= 6)
filter(mtcars, cyl <= 4)
```



###### Negation (opposite of) {-}

The `!` is very useful to tell R to reverse an expression; that is, take the opposite of the value. In the simplest example:



```r
!TRUE
## [1] FALSE
```

This is helpful because we can reverse the meaning of other expressions:


```r
is.na(NA)
## [1] TRUE
!is.na(NA)
## [1] FALSE
```

And we can use in filters. Here we select rows where `Ozone` is missing (`NA`):


```r
filter(airquality, is.na(Ozone))
```

And here we use `!` to reverse the expression and select rows which are not missing:


```r
filter(airquality, !is.na(Ozone))
```


[Try running these commands for yourself and experiment with changing the operators to make select different combinations of rows]{.exercise}




###### Other logical operators {-}


There are operators for 'and'/'or' which can combine other filters


```r
filter(mtcars, hp > 200 | wt > 4)
##    mpg cyl  disp  hp drat    wt  qsec vs am gear carb
## 1 14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
## 2 16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3
## 3 10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4
## 4 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4
## 5 14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4
## 6 13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4
## 7 15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
## 8 15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8
```

Using `&` (and) makes the filter more restrictive:


```r
filter(mtcars, hp > 200 & wt > 4)
##    mpg cyl disp  hp drat    wt  qsec vs am gear carb
## 1 10.4   8  472 205 2.93 5.250 17.98  0  0    3    4
## 2 10.4   8  460 215 3.00 5.424 17.82  0  0    3    4
## 3 14.7   8  440 230 3.23 5.345 17.42  0  0    3    4
```


Finally, you can set the order in which operators are applied by using parentheses. This means these expressions are subtly different:


```r
# first
filter(mtcars, (hp > 200 & wt > 4) | cyl==8)
##     mpg cyl  disp  hp drat    wt  qsec vs am gear carb
## 1  18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
## 2  14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
## 3  16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3
## 4  17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3
## 5  15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3
## 6  10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4
## 7  10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4
## 8  14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4
## 9  15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2
## 10 15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2
## 11 13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4
## 12 19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2
## 13 15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
## 14 15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8

# second reordered evaluation
filter(mtcars, hp > 200 & (wt > 4 | cyl==8))
##    mpg cyl disp  hp drat    wt  qsec vs am gear carb
## 1 14.3   8  360 245 3.21 3.570 15.84  0  0    3    4
## 2 10.4   8  472 205 2.93 5.250 17.98  0  0    3    4
## 3 10.4   8  460 215 3.00 5.424 17.82  0  0    3    4
## 4 14.7   8  440 230 3.23 5.345 17.42  0  0    3    4
## 5 13.3   8  350 245 3.73 3.840 15.41  0  0    3    4
## 6 15.8   8  351 264 4.22 3.170 14.50  0  1    5    4
## 7 15.0   8  301 335 3.54 3.570 14.60  0  1    5    8
```


[Try writing in plain English the meaning of the two filter expressions above]{.exercise}




## Pipes {-}

We are often going to want to combine both `select` and `filter` to return a subset of our original data.

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








## Modifying and creating new columns {- #mutate}


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
## # A tibble: 6 x 4
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






## Sorting {- #sorting}

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











## Reshaping {- #reshaping}

<div style="width:100%;height:0;padding-bottom:75%;position:relative;"><iframe src="https://giphy.com/embed/J42u1BTrks9eU" width="100%" height="100%" style="position:absolute" frameBorder="0" class="giphy-embed" allowFullScreen></iframe></div><p><a href="https://giphy.com/gifs/funny-transformer-J42u1BTrks9eU">via GIPHY</a></p>


This section will probably require more attention than any other in the guide, but will likely be the most useful thing you learn in R.


As previously discussed, most things work best in R if you have data in *long format*. This means we prefer data that look like this:


---------------------------
 person    time    outcome 
-------- -------- ---------
   1      Time 1    22.22  

   2      Time 1    17.43  

   3      Time 1    20.06  

   1      Time 2    21.41  

   2      Time 2    21.52  

   3      Time 2    17.87  

   1      Time 3    19.6   

   2      Time 3    22.52  

   3      Time 3    15.4   

   1      Time 4    19.72  

   2      Time 4    17.81  

   3      Time 4    15.61  
---------------------------



And NOT like this:


--------------------------------------------
 person   Time 1   Time 2   Time 3   Time 4 
-------- -------- -------- -------- --------
   1      22.22    21.41     19.6    19.72  

   2      17.43    21.52    22.52    17.81  

   3      20.06    17.87     15.4    15.61  
--------------------------------------------



In long format data:

  - each row of the dataframe corresponds to a single measurement occasion
  - each column corresponds to a variable which is measured


Fortunately it's fairly easy to move between the two formats, provided your variables are named in a consistent way.








#### Wide to long format {- #wide-to-long}

This is the most common requirement. Often you will have several columns which actually measure the same thing, and you will need to convert these two two columns  - a 'key', and a value.

For example, let's say we measure patients on 10 days:




```r
sleep.wide %>% 
  head(4) %>% 
  pander(caption="Data for the first 4 subjects")
```


-----------------------------------------------------------------------------------------
 Subject   Day.0   Day.1   Day.2   Day.3   Day.4   Day.5   Day.6   Day.7   Day.8   Day.9 
--------- ------- ------- ------- ------- ------- ------- ------- ------- ------- -------
    1      249.6   258.7   250.8   321.4   356.9   414.7   382.2   290.1   430.6   466.4 

    2      222.7   205.3    203    204.7   207.7    216    213.6   217.7   224.3   237.3 

    3      199.1   194.3   234.3   232.8   229.3   220.5   235.4   255.8    261    247.5 

    4      321.5   300.4   283.9   285.1   285.8   297.6   280.2   318.3   305.3    354  
-----------------------------------------------------------------------------------------

Table: Data for the first 4 subjects



We want to convert RT measurements on each Day to a single variable, and create a new variable to keep track of what `Day` the measurement was taken:

The `melt()` function in the `reshape2::` package does this for us:


```r
library(reshape2)
## 
## Attaching package: 'reshape2'
## The following object is masked from 'package:tidyr':
## 
##     smiths
sleep.long <- sleep.wide %>% 
  melt(id.var="Subject") %>%
  arrange(Subject, variable)  

sleep.long %>% 
  head(12) %>% 
  pander
```


----------------------------
 Subject   variable   value 
--------- ---------- -------
    1       Day.0     249.6 

    1       Day.1     258.7 

    1       Day.2     250.8 

    1       Day.3     321.4 

    1       Day.4     356.9 

    1       Day.5     414.7 

    1       Day.6     382.2 

    1       Day.7     290.1 

    1       Day.8     430.6 

    1       Day.9     466.4 

    2       Day.0     222.7 

    2       Day.1     205.3 
----------------------------



Here melt has created two new variable: `variable`, which keeps track of what was measured, and `value` which contains the score. This is the format we need when [plotting graphs](#graphics) and running [regression and Anova models](#linear-models-simple).



#### Long to wide format {- #long-to-wide}

To continue the example from above, these are long form data we just made:


```r
sleep.long %>% 
  head(3) %>% 
  pander(caption="First 3 rows in the long format dataset")
```


----------------------------
 Subject   variable   value 
--------- ---------- -------
    1       Day.0     249.6 

    1       Day.1     258.7 

    1       Day.2     250.8 
----------------------------

Table: First 3 rows in the long format dataset

We can convert these back to the original wide format using `dcast`, again in the `reshape2` package. The name of the `dcast` function indicates we can 'cast' a dataframe (the d prefix). So here, casting means the opposite of 'melting'.

Using `dcast` is a little more fiddly than `melt` because we have to say *how* we want the data spread wide. In this example we could either have:

- Columns for each day, with rows for each subject
- Columns for each subject, with rows for each day

Although it's obvious to us which we want, we have to be explicit. We do this using a [formula](#formulae), which we'll see again in the regression section. 

Each formula has two sides, left and right, separated by the tilde (`~`) symbol. On the left hand side we say which variable we want to keep in rows. On the right hand side we say which variables to conver to columns. So, for example:


```r
# rows per subject, columns per day
sleep.long %>%
	dcast(Subject~variable) %>% 
  head(3)
##   Subject    Day.0    Day.1    Day.2    Day.3    Day.4    Day.5    Day.6
## 1       1 249.5600 258.7047 250.8006 321.4398 356.8519 414.6901 382.2038
## 2       2 222.7339 205.2658 202.9778 204.7070 207.7161 215.9618 213.6303
## 3       3 199.0539 194.3322 234.3200 232.8416 229.3074 220.4579 235.4208
##      Day.7    Day.8    Day.9
## 1 290.1486 430.5853 466.3535
## 2 217.7272 224.2957 237.3142
## 3 255.7511 261.0125 247.5153
```


To compare, we can convert so each Subject has a column by reversing the formula:


```r
# note we select only the first 7 Subjects to 
# keep the table to a manageable size
sleep.long %>%
  filter(Subject < 8) %>% 
	dcast(variable~Subject)
##    variable        1        2        3        4        5        6        7
## 1     Day.0 249.5600 222.7339 199.0539 321.5426 287.6079 234.8606 283.8424
## 2     Day.1 258.7047 205.2658 194.3322 300.4002 285.0000 242.8118 289.5550
## 3     Day.2 250.8006 202.9778 234.3200 283.8565 301.8206 272.9613 276.7693
## 4     Day.3 321.4398 204.7070 232.8416 285.1330 320.1153 309.7688 299.8097
## 5     Day.4 356.8519 207.7161 229.3074 285.7973 316.2773 317.4629 297.1710
## 6     Day.5 414.6901 215.9618 220.4579 297.5855 293.3187 309.9976 338.1665
## 7     Day.6 382.2038 213.6303 235.4208 280.2396 290.0750 454.1619 332.0265
## 8     Day.7 290.1486 217.7272 255.7511 318.2613 334.8177 346.8311 348.8399
## 9     Day.8 430.5853 224.2957 261.0125 305.3495 293.7469 330.3003 333.3600
## 10    Day.9 466.3535 237.3142 247.5153 354.0487 371.5811 253.8644 362.0428
```



###### {- .tip}
One neat trick when casting is to use `paste` to  give your columns nicer names. So for example:


```r
sleep.long %>%
  filter(Subject < 8) %>% 
	dcast(variable~paste0("Participant.", Subject))
##    variable Participant.1 Participant.2 Participant.3 Participant.4
## 1     Day.0      249.5600      222.7339      199.0539      321.5426
## 2     Day.1      258.7047      205.2658      194.3322      300.4002
## 3     Day.2      250.8006      202.9778      234.3200      283.8565
## 4     Day.3      321.4398      204.7070      232.8416      285.1330
## 5     Day.4      356.8519      207.7161      229.3074      285.7973
## 6     Day.5      414.6901      215.9618      220.4579      297.5855
## 7     Day.6      382.2038      213.6303      235.4208      280.2396
## 8     Day.7      290.1486      217.7272      255.7511      318.2613
## 9     Day.8      430.5853      224.2957      261.0125      305.3495
## 10    Day.9      466.3535      237.3142      247.5153      354.0487
##    Participant.5 Participant.6 Participant.7
## 1       287.6079      234.8606      283.8424
## 2       285.0000      242.8118      289.5550
## 3       301.8206      272.9613      276.7693
## 4       320.1153      309.7688      299.8097
## 5       316.2773      317.4629      297.1710
## 6       293.3187      309.9976      338.1665
## 7       290.0750      454.1619      332.0265
## 8       334.8177      346.8311      348.8399
## 9       293.7469      330.3003      333.3600
## 10      371.5811      253.8644      362.0428
```

Notice we used `paste0` rather than `paste` to avoid spaces in variable names, which is allowed but can be a pain. [See more on working with character strings in a later section](#string-handling).




##### {-}

For a more detailed explanation and various other methods for reshaping data, see: http://r4ds.had.co.nz/tidy-data.html




### Summarising and reshaping {-}


One common trick when reshaping is to convert a datafile which has multiple rows and columns per person to one with only a single row. Although useful this isn't covered in this section, because it is combining two techniques:

- Reshaping (i.e. from long to wide or back)
- Aggregating or summarising (converting multiple rows to one)

In the next section we cover [summarising data](#summarising-data), and introduce the 'split-apply-combine' method for summarising. Once you have a good grasp of this, you could check out the ['fancy reshaping' section](#fancy-reshaping) which does provide examples.







