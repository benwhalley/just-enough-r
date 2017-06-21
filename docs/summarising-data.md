---
title: 'Summarising data'
output: 
  bookdown::tufte_html2
---



# Summarising data





Before you begin this section, make sure you have fully understood the section on [datasets and dataframes](datasets.html), and in particular that you are happy using the `%>%` symbol to describe a flow of data.


## Summaries of dataframes

So far you have seen a number of functions which provide summaries of a dataframe. For example:


```r
summary(angry.moods)
##      Gender          Sports        Anger.Out        Anger.In    
##  Min.   :1.000   Min.   :1.000   Min.   : 9.00   Min.   :10.00  
##  1st Qu.:1.000   1st Qu.:1.000   1st Qu.:13.00   1st Qu.:15.00  
##  Median :2.000   Median :2.000   Median :16.00   Median :18.50  
##  Mean   :1.615   Mean   :1.679   Mean   :16.08   Mean   :18.58  
##  3rd Qu.:2.000   3rd Qu.:2.000   3rd Qu.:18.00   3rd Qu.:22.00  
##  Max.   :2.000   Max.   :2.000   Max.   :27.00   Max.   :31.00  
##   Control.Out      Control.In    Anger.Expression
##  Min.   :14.00   Min.   :11.00   Min.   : 7.00   
##  1st Qu.:21.00   1st Qu.:18.25   1st Qu.:27.00   
##  Median :24.00   Median :22.00   Median :36.00   
##  Mean   :23.69   Mean   :21.96   Mean   :37.00   
##  3rd Qu.:27.00   3rd Qu.:24.75   3rd Qu.:44.75   
##  Max.   :32.00   Max.   :32.00   Max.   :68.00
```

Or 


```r
psych::describe(angry.moods, skew=FALSE)
##                  vars  n  mean    sd min max range   se
## Gender              1 78  1.62  0.49   1   2     1 0.06
## Sports              2 78  1.68  0.47   1   2     1 0.05
## Anger.Out           3 78 16.08  4.22   9  27    18 0.48
## Anger.In            4 78 18.58  4.70  10  31    21 0.53
## Control.Out         5 78 23.69  4.69  14  32    18 0.53
## Control.In          6 78 21.96  4.95  11  32    21 0.56
## Anger.Expression    7 78 37.00 12.94   7  68    61 1.47
```



However, these functions operate on the dataset as a whole. What if we want to get summaries grouped by one of our variables, for example `Gender`? Or perhaps we want to use our summary data in a further analysis: for example, we might want to compute average reaction times in each block of an experiment to run an Anova or regression model.


What we really want is a summary function *which gives us back a dataframe*. The  `dplyr::summarise()` does just that:



```r
angry.moods %>% 
  summarise(
    mean.anger.out=mean(Anger.Out), 
    sd.anger.out=sd(Anger.Out)
  )
## # A tibble: 1 × 2
##   mean.anger.out sd.anger.out
##            <dbl>        <dbl>
## 1       16.07692      4.21737
```


This has returned a dataframe, which we could store and use as before, although in this instance the dataframe only has one row. What if we want the numbers for men and women separately?



## Split, apply, combine

Let's think more about the case where we want to compute statistics on men and women separately.

Although many packages would have functions with options to do this (for example, perhaps you would specify grouping variables in a summary function), there's a more general pattern at work. We want to:

- *Split* our data (into men and women)
- *Apply* some function to them (e.g. calculate the mean) and then
- *Combine* it into a single table again (for more processing or analysis)


It's helpful to think of this *split $\rightarrow$ apply $\rightarrow$ combine* pattern whenever we are processing data because it makes explicit what it is that we want to do.



## Split: breaking the data into groups

The first task is to organise our dataframe into the relevant groups. To do this we use `group_by()`:


```r
angry.moods %>% 
  group_by(Gender) %>% 
  head
## Source: local data frame [6 x 7]
## Groups: Gender [2]
## 
##   Gender Sports Anger.Out Anger.In Control.Out Control.In Anger.Expression
##    <int>  <int>     <int>    <int>       <int>      <int>            <int>
## 1      2      1        18       13          23         20               36
## 2      2      1        14       17          25         24               30
## 3      2      1        13       14          28         28               19
## 4      2      1        17       24          23         23               43
## 5      1      1        16       17          26         28               27
## 6      1      1        16       22          25         23               38
```

Weirdly, this doesn't seem to have done anything. The data aren't sorted by `Gender`, and there is no visible sign of the grouping, but stick with it...


## Apply and combine

Continuing the example above, once we have grouped our data we can then *apply* a function to it — for exmaple, summarise:


```r
angry.moods %>% 
  group_by(Gender) %>% 
  summarise(
    mean.anger.out=mean(Anger.Out)
  )
## # A tibble: 2 × 2
##   Gender mean.anger.out
##    <int>          <dbl>
## 1      1       16.56667
## 2      2       15.77083
```

And R and `dplyr` have done as we asked:

- *split* the data by `Gender`, using `group_by()`
- *apply* the `summarise()` function
- *combine* the results into a new data frame





## A 'real' example

In the previous section on datasets, we saw some found some raw data from a study which had measured depression with the PHQ-9. Patients were measured on numerous occasions (`month` is recorded) and were split into treatment and control groups:



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



If this were our data we might want to:

- Calculate the sum of the PHQ-9 variables (the PHQ-9 *score*)
- Calculate the average PHQ-9 score at each month, and in each group
- Show these means by group for months 0, 7 and 12

Using only the commands above[^sneaked]  we can write:

[^sneaked]: You might have noticed I sneaked something new in here: the call to `pander()`. This is a weirdly named but useful function when writing RMarkdown documents. It converts any R object into more readable output: here it makes a nice table for us in the compiled document.  We cover more [tips and tricks for formatting RMarkdown documents here](rmarkdown-tricks.html). You might also want to check [this page on missing values](missing-values.html) to explain the filter which uses `!is.na()`, but you could leave it for later.



```r
phq9.summary.df <- phq9.df %>% 
  mutate(phq9 = phq9_01 + phq9_02 + phq9_03 + 
                    phq9_04 + phq9_05 + phq9_06 + 
                    phq9_07 + phq9_08 + phq9_09
  ) %>% 
  select(patient, group, month, phq9) %>% 
  # remove rows with missing values
  filter(!is.na(phq9)) %>% 
  # split
  group_by(month, group) %>% 
  # apply and combine
  summarise(phq.mean = mean(phq9))


phq9.summary.df %>% 
  filter(month %in% c(0, 7, 12)) %>% 
  pander::pander()
```


--------------------------
 month   group   phq.mean 
------- ------- ----------
   0       0     19.75904 

   0       1     18.97368 

   7       0     16.61818 

   7       1     13.42056 

  12       0     16.15385 

  12       1     12.54082 
--------------------------


## Sorting data

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



