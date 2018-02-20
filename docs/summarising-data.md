
--
title: 'Summarising data'
---



# Summaries {#summarising-data}





Before you begin this section, make sure you have fully understood the section on [datasets and dataframes](datasets.html), and in particular that you are happy using the `%>%` symbol to [describe a flow of data](#pipes).

The chapter outlines several different approaches to obtaining summary statistics, and covers:

- Useful 'utility' functions
- Creating tables
- Using `dplyr` as a generalisable tool to make any kind of summary


In particular, we emphasise functions that *return dataframes*. 

If a function returns a dataframe (rather than just printing output to the screen) then we can continue to process and present these results in useful ways.


<!-- VIDEO COVERING THIS MATERIAL -->




## "Quick and dirty" {-}


##### Using utility functions built into R {-}


### Frequency tables {- #frequency-tables}


Let's say we ask 4 year olds and 6 year olds whether they prefer lego or duplo. 

We can use the `table()` command to get a cross tabulation of these `age` categories and what the child `prefers`. We wrap `table(...)` in the `with()` function to tell it which dataframe to use:




```r
lego.table <- with(lego.duplo.df, table(age, prefers))
lego.table
         prefers
age       duplo lego
  4 years    38   20
  6 years    12   30
```


#### `xtab` {-}

`table` is a simple way of calculating frequencies, but you can also use the `xtabs` function to make more complex sumamries.

`xtabs` uses a formula type syntax to describe the table ([formulas for linear models are explained here](#formulae)).

In the simplest case, we just write a tilde symbol (`~`) and the the names of the variables we want to tablulate, separated with `+` symbols:


```r
xtabs(~age+prefers, lego.duplo.df)
         prefers
age       duplo lego
  4 years    38   20
  6 years    12   30
```

The order of the variables changes the orientation of the table:


```r
xtabs(~prefers+age, lego.duplo.df)
       age
prefers 4 years 6 years
  duplo      38      12
  lego       20      30
```


Tables like this are useful in their own right, but can also be passed to inferential tests, like [Chi squred](#crosstabs)





### Summary statistics {-}


In this guide so far you might have noticed functions which provide summaries of an entire dataframe. For example:


```r
summary(angry.moods)
     Gender          Sports        Anger.Out        Anger.In    
 Min.   :1.000   Min.   :1.000   Min.   : 9.00   Min.   :10.00  
 1st Qu.:1.000   1st Qu.:1.000   1st Qu.:13.00   1st Qu.:15.00  
 Median :2.000   Median :2.000   Median :16.00   Median :18.50  
 Mean   :1.615   Mean   :1.679   Mean   :16.08   Mean   :18.58  
 3rd Qu.:2.000   3rd Qu.:2.000   3rd Qu.:18.00   3rd Qu.:22.00  
 Max.   :2.000   Max.   :2.000   Max.   :27.00   Max.   :31.00  
  Control.Out      Control.In    Anger.Expression
 Min.   :14.00   Min.   :11.00   Min.   : 7.00   
 1st Qu.:21.00   1st Qu.:18.25   1st Qu.:27.00   
 Median :24.00   Median :22.00   Median :36.00   
 Mean   :23.69   Mean   :21.96   Mean   :37.00   
 3rd Qu.:27.00   3rd Qu.:24.75   3rd Qu.:44.75   
 Max.   :32.00   Max.   :32.00   Max.   :68.00   
```

Or:


```r
psych::describe(angry.moods, skew=FALSE)
                 vars  n  mean    sd min max range   se
Gender              1 78  1.62  0.49   1   2     1 0.06
Sports              2 78  1.68  0.47   1   2     1 0.05
Anger.Out           3 78 16.08  4.22   9  27    18 0.48
Anger.In            4 78 18.58  4.70  10  31    21 0.53
Control.Out         5 78 23.69  4.69  14  32    18 0.53
Control.In          6 78 21.96  4.95  11  32    21 0.56
Anger.Expression    7 78 37.00 12.94   7  68    61 1.47
```



Although useful, these functions miss two important elements:

1. We have to operate on the whole dataframe at once
2. The output is just printed to screen. We might prefer to get back a dataframe so that we can process the results further.



### Creating a data frame of summary statistics {-}

Thanksfully, many summary functions allow us to pass their results to the `as_data_frame()` function, which converts the output into a table which we can use like any other dataset.

In this example, we create summary statistics with the `psych::describe()` function, then convert to a dataframe and format as a table in RMarkdown:



```r
psych::describe(angry.moods, skew=FALSE) %>% 
  as_data_frame %>% 
  pander()
```


---------------------------------------------------------------------------------
        &nbsp;          vars   n    mean      sd     min   max   range     se    
---------------------- ------ ---- ------- -------- ----- ----- ------- ---------
      **Gender**         1     78   1.615   0.4897    1     2      1     0.05544 

      **Sports**         2     78   1.679   0.4697    1     2      1     0.05318 

    **Anger.Out**        3     78   16.08   4.217     9    27     18     0.4775  

     **Anger.In**        4     78   18.58   4.697    10    31     21     0.5319  

   **Control.Out**       5     78   23.69   4.688    14    32     18     0.5309  

    **Control.In**       6     78   21.96   4.945    11    32     21     0.5599  

 **Anger.Expression**    7     78    37     12.94     7    68     61      1.465  
---------------------------------------------------------------------------------


This summary table can be processed like any other dataframe. For instance, we can select columns and rows from it using `dplyr`:


```r
psych::describe(angry.moods, skew=FALSE) %>% 
  # rownames_to_column converts to a df but saves the 
  # row names in a new column for us, which can be useful
  rownames_to_column(var="variable") %>% 
  select(variable, mean, sd) %>% 
  filter(mean > 20) %>% 
  pander
```


----------------------------------
     variable       mean     sd   
------------------ ------- -------
   Control.Out      23.69   4.688 

    Control.In      21.96   4.945 

 Anger.Expression    37     12.94 
----------------------------------


We can do the same with the output of [`table` or `xtabs`](#frequency-tables) too:



```r
xtabs(~prefers+age, lego.duplo.df) %>%
  as_data_frame %>%
  pander(caption="Using `xtabs` to make a frequency table; converting to a dataframe for presentation using `pander`.")
```


------------------------
 prefers     age     n  
--------- --------- ----
  duplo    4 years   38 

  lego     4 years   20 

  duplo    6 years   12 

  lego     6 years   30 
------------------------

Table: Using `xtabs` to make a frequency table; converting to a dataframe for presentation using `pander`.





##### Rownames are evil {- .explainer}

Historically 'row names' were used on R to label individual rows in a dataframe. It turned out that this is generally a bad idea, because sorting and some summary functions would get very confused and mix up row names and the data itself.

It's generally considered best practice to avoid row names, and store everything as columns of data.

If you find that rownames in your data have disappeared, [see this guide for turning them into an extra column of data using `tibble::rownames_to_column()`](#rownames).





### Computing statistics by-groups {-}



```r
psych::describeBy(mtcars, 'cyl')

 Descriptive statistics by group 
group: 4
     vars  n   mean    sd median trimmed   mad   min    max range  skew
mpg     1 11  26.66  4.51  26.00   26.44  6.52 21.40  33.90 12.50  0.26
cyl     2 11   4.00  0.00   4.00    4.00  0.00  4.00   4.00  0.00   NaN
disp    3 11 105.14 26.87 108.00  104.30 43.00 71.10 146.70 75.60  0.12
hp      4 11  82.64 20.93  91.00   82.67 32.62 52.00 113.00 61.00  0.01
drat    5 11   4.07  0.37   4.08    4.02  0.34  3.69   4.93  1.24  1.00
wt      6 11   2.29  0.57   2.20    2.27  0.54  1.51   3.19  1.68  0.30
qsec    7 11  19.14  1.68  18.90   18.99  1.48 16.70  22.90  6.20  0.55
vs      8 11   0.91  0.30   1.00    1.00  0.00  0.00   1.00  1.00 -2.47
am      9 11   0.73  0.47   1.00    0.78  0.00  0.00   1.00  1.00 -0.88
gear   10 11   4.09  0.54   4.00    4.11  0.00  3.00   5.00  2.00  0.11
carb   11 11   1.55  0.52   2.00    1.56  0.00  1.00   2.00  1.00 -0.16
     kurtosis   se
mpg     -1.65 1.36
cyl       NaN 0.00
disp    -1.64 8.10
hp      -1.71 6.31
drat     0.12 0.11
wt      -1.36 0.17
qsec    -0.02 0.51
vs       4.52 0.09
am      -1.31 0.14
gear    -0.01 0.16
carb    -2.15 0.16
-------------------------------------------------------- 
group: 6
     vars n   mean    sd median trimmed   mad    min    max  range  skew
mpg     1 7  19.74  1.45  19.70   19.74  1.93  17.80  21.40   3.60 -0.16
cyl     2 7   6.00  0.00   6.00    6.00  0.00   6.00   6.00   0.00   NaN
disp    3 7 183.31 41.56 167.60  183.31 11.27 145.00 258.00 113.00  0.80
hp      4 7 122.29 24.26 110.00  122.29  7.41 105.00 175.00  70.00  1.36
drat    5 7   3.59  0.48   3.90    3.59  0.03   2.76   3.92   1.16 -0.74
wt      6 7   3.12  0.36   3.21    3.12  0.36   2.62   3.46   0.84 -0.22
qsec    7 7  17.98  1.71  18.30   17.98  1.90  15.50  20.22   4.72 -0.12
vs      8 7   0.57  0.53   1.00    0.57  0.00   0.00   1.00   1.00 -0.23
am      9 7   0.43  0.53   0.00    0.43  0.00   0.00   1.00   1.00  0.23
gear   10 7   3.86  0.69   4.00    3.86  0.00   3.00   5.00   2.00  0.11
carb   11 7   3.43  1.81   4.00    3.43  0.00   1.00   6.00   5.00 -0.26
     kurtosis    se
mpg     -1.91  0.55
cyl       NaN  0.00
disp    -1.23 15.71
hp       0.25  9.17
drat    -1.40  0.18
wt      -1.98  0.13
qsec    -1.75  0.65
vs      -2.20  0.20
am      -2.20  0.20
gear    -1.24  0.26
carb    -1.50  0.69
-------------------------------------------------------- 
group: 8
     vars  n   mean    sd median trimmed   mad    min    max  range  skew
mpg     1 14  15.10  2.56  15.20   15.15  1.56  10.40  19.20   8.80 -0.36
cyl     2 14   8.00  0.00   8.00    8.00  0.00   8.00   8.00   0.00   NaN
disp    3 14 353.10 67.77 350.50  349.63 73.39 275.80 472.00 196.20  0.45
hp      4 14 209.21 50.98 192.50  203.67 44.48 150.00 335.00 185.00  0.91
drat    5 14   3.23  0.37   3.12    3.19  0.16   2.76   4.22   1.46  1.34
wt      6 14   4.00  0.76   3.75    3.95  0.41   3.17   5.42   2.25  0.99
qsec    7 14  16.77  1.20  17.18   16.86  0.79  14.50  18.00   3.50 -0.80
vs      8 14   0.00  0.00   0.00    0.00  0.00   0.00   0.00   0.00   NaN
am      9 14   0.14  0.36   0.00    0.08  0.00   0.00   1.00   1.00  1.83
gear   10 14   3.29  0.73   3.00    3.17  0.00   3.00   5.00   2.00  1.83
carb   11 14   3.50  1.56   3.50    3.25  0.74   2.00   8.00   6.00  1.48
     kurtosis    se
mpg     -0.57  0.68
cyl       NaN  0.00
disp    -1.26 18.11
hp       0.09 13.62
drat     1.08  0.10
wt      -0.71  0.20
qsec    -0.92  0.32
vs        NaN  0.00
am       1.45  0.10
gear     1.45  0.19
carb     2.24  0.42
```

This is helpful, but there's no simple way to convert the result to a dataframe, which we will want if we are creating tables for publication.

`describeBy` actually returns a list of tables, one for each level of the `cyl` variable, so it is is possible to convert each table in turn:


```r
summary.tables <- psych::describeBy(mtcars, 'cyl')
summary.tables[[1]] %>% 
  as_data_frame() %>% 
  head(3)
# A tibble: 3 x 13
   vars     n      mean        sd median   trimmed      mad   min   max
  <int> <dbl>     <dbl>     <dbl>  <dbl>     <dbl>    <dbl> <dbl> <dbl>
1     1    11  26.66364  4.509828     26  26.44444  6.52344  21.4  33.9
2     2    11   4.00000  0.000000      4   4.00000  0.00000   4.0   4.0
3     3    11 105.13636 26.871594    108 104.30000 42.99540  71.1 146.7
# ... with 4 more variables: range <dbl>, skew <dbl>, kurtosis <dbl>,
#   se <dbl>
```

But this is pretty yucky. Not only are the column names all mangled up, but we also have to think about extracting each levell in turn, and need to check how many levels in `cyl` there are. What happens if an extra level gets added? Our code will likely break.

Thankfully there is much nicer and more consistent way to compute exactly the summaries we want, sometimes termed the 'split, apply, combine' method.



## A generalised approach {-}


#### The 'split, apply, combine' model {- #split-apply-combine}

The `dplyr::` package, and especially the `summarise()` function provides a generalised way to create dataframes of frequencies and other summary statistics, grouped and sorted however we like.

For example, let's say we want the mean of some of our variables across the whole dataframe:


```r
angry.moods %>% 
  summarise(
    mean.anger.out=mean(Anger.Out), 
    sd.anger.out=sd(Anger.Out)
  )
# A tibble: 1 x 2
  mean.anger.out sd.anger.out
           <dbl>        <dbl>
1       16.07692      4.21737
```

The `summarise` function has returned a dataframe containing the statistics we need, although in this instance the dataframe only has one row. 

What if we want the numbers for men and women separately?

Utility functions like `describeBy` have options to do this (you would specify grouping variables in that). But there's a more general pattern at work --- we want to:

- *Split* our data (into men and women, or some other categorisation)
- *Apply* some function to them (e.g. calculate the mean) and then
- *Combine* it into a single table again (for more processing or analysis)


It's helpful to think of this *split $\rightarrow$ apply $\rightarrow$ combine* pattern whenever we are processing data because it *makes explicit what we want to do*.



#### Split: breaking the data into groups {-}

The first task is to organise our dataframe into the relevant groups. To do this we use `group_by()`:


```r
angry.moods %>% 
  group_by(Gender) %>% 
  head
# A tibble: 6 x 7
# Groups:   Gender [2]
  Gender Sports Anger.Out Anger.In Control.Out Control.In Anger.Expression
   <int>  <int>     <int>    <int>       <int>      <int>            <int>
1      2      1        18       13          23         20               36
2      2      1        14       17          25         24               30
3      2      1        13       14          28         28               19
4      2      1        17       24          23         23               43
5      1      1        16       17          26         28               27
6      1      1        16       22          25         23               38
```

Weirdly, this doesn't seem to have done anything. The data aren't sorted by `Gender`, and there is no visible sign of the grouping, but stick with it...


#### Apply and combine {-}
 
Continuing the example above, once we have grouped our data we can then *apply* a function to it — for exmaple, summarise:


```r
angry.moods %>% 
  group_by(Gender) %>% 
  summarise(
    mean.anger.out=mean(Anger.Out)
  )
# A tibble: 2 x 2
  Gender mean.anger.out
   <int>          <dbl>
1      1       16.56667
2      2       15.77083
```

And R and `dplyr` have done as we asked:

- *split* the data by `Gender`, using `group_by()`
- *apply* the `summarise()` function
- *combine* the results into a new data frame



#### A 'real' example {-}

In the previous section on datasets, we saw some found some raw data from a study which had measured depression with the PHQ-9. Patients were measured on numerous occasions (`month` is recorded) and were split into treatment and control groups:



```r
phq9.df <- readr::read_csv("phq.csv")
Parsed with column specification:
cols(
  patient = col_integer(),
  phq9_01 = col_integer(),
  phq9_02 = col_integer(),
  phq9_03 = col_integer(),
  phq9_04 = col_integer(),
  phq9_05 = col_integer(),
  phq9_06 = col_integer(),
  phq9_07 = col_integer(),
  phq9_08 = col_integer(),
  phq9_09 = col_integer(),
  month = col_integer(),
  group = col_integer()
)
glimpse(phq9.df)
Observations: 2,429
Variables: 12
$ patient <int> 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, ...
$ phq9_01 <int> 3, 1, 1, 2, 2, 2, 3, 2, 3, 3, 1, 3, 2, 1, 2, 3, 3, 3, ...
$ phq9_02 <int> 3, 2, 2, 2, 3, 3, 3, 2, 3, 3, 1, 3, 2, 1, 3, 3, 3, 3, ...
$ phq9_03 <int> 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 3, 2, 3, 3, ...
$ phq9_04 <int> 3, 3, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 3, 3, 3, 3, ...
$ phq9_05 <int> 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 3, 2, 1, 2, ...
$ phq9_06 <int> 3, 2, 2, 2, 3, 3, 2, 1, 2, 3, 3, 3, 2, 1, 3, 3, 3, 3, ...
$ phq9_07 <int> 3, 3, 1, 1, 2, 1, 2, 2, 1, 3, 2, 2, 2, 2, 3, 2, 1, 1, ...
$ phq9_08 <int> 0, 2, 2, 1, 1, 1, 1, 2, 1, 3, 1, 2, 1, 0, 2, 1, 0, 1, ...
$ phq9_09 <int> 2, 2, 1, 1, 2, 2, 2, 1, 1, 3, 1, 2, 1, 1, 3, 3, 3, 3, ...
$ month   <int> 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 18, 0, 1,...
$ group   <int> 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, ...
```


If this were our data we might want to:

- Calculate the sum of the PHQ-9 variables (the PHQ-9 *score*)
- Calculate the average PHQ-9 score at each month, and in each group
- Show these means by group for months 0, 7 and 12

Using only the commands above[^sneaked]  we can write:

[^sneaked]: You might have noticed I sneaked something new in here: the call to `pander()`. This is from the `pander::` package, which contains is a useful set of functions function for when writing RMarkdown documents. They convert many R objects into more readable output: here it makes a nice table for us in the compiled document.  We cover more tips and tricks for formatting RMarkdown documents in the chapter on [sharing and publishing your data](#sharing-and-publication). You might also want to check [this page on missing values](#missing) to explain the filter which uses `!is.na()`, but you could equally leave this for later.



```r
phq9.summary.df <- phq9.df %>% 
  mutate(phq9 = phq9_01 + phq9_02 + phq9_03 + 
                    phq9_04 + phq9_05 + phq9_06 + 
                    phq9_07 + phq9_08 + phq9_09) %>% 

  select(patient, group, month, phq9) %>% 
  # remove rows with missing values
  filter(!is.na(phq9)) %>% 
  # split
  group_by(month, group) %>% 
  # apply and combine
  summarise(phq.mean = mean(phq9))


phq9.summary.df %>% 
  filter(month %in% c(0, 7, 12)) %>% 
  pander::pandoc.table()

--------------------------
 month   group   phq.mean 
------- ------- ----------
   0       0      19.76   

   0       1      18.97   

   7       0      16.62   

   7       1      13.42   

  12       0      16.15   

  12       1      12.54   
--------------------------
```



###### A 'neater way' {- #mutate-with-rowmeans}

You might have thought that typing out each variable in the above example (`phq9_01 + phq9_02...`) seemed a bit repetitive.

In general, if you find yourself typing something repetitive in R then there *will* a better way of doing it, and this is true here.

Stepping back, what we want is *the row mean of all the variables starting with `phq9_0`*. We can write this more concisely like so:


```r
phq9.df %>% 
  mutate(phq9 = rowMeans(
    select(phq9.df, starts_with("phq9_0"))
  )
)
# A tibble: 2,429 x 13
   patient phq9_01 phq9_02 phq9_03 phq9_04 phq9_05 phq9_06 phq9_07 phq9_08
     <int>   <int>   <int>   <int>   <int>   <int>   <int>   <int>   <int>
 1       1       3       3       3       3       3       3       3       0
 2       2       1       2       3       3       3       2       3       2
 3       2       1       2       3       2       3       2       1       2
 4       2       2       2       3       3       3       2       1       1
 5       2       2       3       3       3       3       3       2       1
 6       2       2       3       3       3       3       3       1       1
 7       2       3       3       3       3       3       2       2       1
 8       2       2       2       3       3       3       1       2       2
 9       2       3       3       3       3       3       2       1       1
10       2       3       3       3       3       3       3       3       3
# ... with 2,419 more rows, and 4 more variables: phq9_09 <int>,
#   month <int>, group <int>, phq9 <dbl>
```


I've broken the code into multiple lines to make it clearer to read. In English, this code means:

1. Take the the dataframe `phq9.df`
2. Add (using `mutate()`) a new variable called `phq` by
3. Calculating the rowmeans of selected columns in `phq9.df` which
4. Start with the letters: `phq9_0


[Ignore this if you are found the last section confusing, but if you find pipes useful then note that I explicitly passed the `phq9.df` directly to the `select()` function. There are other tricks with pipes where you can pass the intermediate result of a series of pipes to a function by putting a `.` (a full stop or period) as the argument to the function. This can be very useful, so see the [package documentation for details](https://github.com/tidyverse/magrittr).]{.explainer}








