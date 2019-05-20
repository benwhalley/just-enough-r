
---
title: 'Making "Table 1"'
---



## "Table 1" {- #table1}

Table 1 in reports of clinical trials and many psychological studies reports
characteristics of the sample. Typically, you will want to present information
collected at baseline, split by experimental groups, including:

-   Means, standard deviations or other descriptive statistics for continuous
    variables
-   Frequencies of particular responses for categorical variables
-   Some kind of inferential test for a zero-difference between the groups; this
    could be a t-test, an F-statistic where there are more than 2 groups, or a
    chi-squared test for categorical variables.

<!-- Make reference to this? https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3379950/ -->

Producing this table is a pain because it requires collating multiple
statistics, calculated from different functions. Many researchers resort to
performing all the analyses required for each part of the table, and then
copying-and-pasting results into Word.

It can be automated though! This example combines and extends many of the
techniques we have learned using the split-apply-combine method.

To begin, let's simulate some data from a fairly standard 2-arm clinical trial
or psychological experiment:



Check our data:


```r
boring.study %>% glimpse
Observations: 280
Variables: 8
$ person    <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 1...
$ time      <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1...
$ condition <fct> Control, Control, Control, Control, Control, Control...
$ yob       <dbl> 1969, 1978, 1969, 1989, 1975, 1975, 1989, 1983, 1978...
$ WM        <dbl> 103, 103, 94, 96, 109, 98, 102, 93, 78, 102, 98, 91,...
$ education <chr> "Graduate", "Secondary", "Postgraduate", "Primary", ...
$ ethnicity <chr> "Asian / Asian British", "White British", "White Bri...
$ Attitude  <dbl> 12, 5, 8, 6, 4, 9, 14, 12, 10, 9, 12, 14, 8, 11, 8, ...
```

Start by making a long-form table for the categorical variables:


```r
boring.study.categorical.melted <-
  table1.categorical.Ns <- boring.study %>%
  select(condition, education, ethnicity) %>%
  melt(id.var='condition')
```

Then calculate the N's for each response/variable in each group:


```r
(table1.categorical.Ns <-
  boring.study.categorical.melted %>%
  group_by(condition, variable, value) %>%
  summarise(N=n()) %>%
  dcast(variable+value~condition, value.var="N"))
   variable                                       value Control
1 education                                    Graduate      39
2 education                                Postgraduate      25
3 education                                     Primary      21
4 education                                   Secondary      27
5 education                                        <NA>      28
6 ethnicity                       Asian / Asian British      32
7 ethnicity Black / African / Caribbean / Black British      42
8 ethnicity              Mixed / multiple ethnic groups      33
9 ethnicity                               White British      33
  Intervention
1           33
2           25
3           24
4           24
5           34
6           37
7           35
8           30
9           38
```

Then make a second table containing Chi2 test statistics for each variable:


```r
(table1.categorical.tests <-
  boring.study.categorical.melted %>%
  group_by(variable) %>%
  do(., chisq.test(.$value, .$condition) %>% tidy) %>%
  # this purely to facilitate matching rows up below
  mutate(firstrowforvar=T))
# A tibble: 2 x 6
# Groups:   variable [2]
  variable  statistic p.value parameter method               firstrowforvar
  <fct>         <dbl>   <dbl>     <int> <chr>                <lgl>         
1 education     0.712   0.870         3 Pearson's Chi-squar~ TRUE          
2 ethnicity     1.49    0.684         3 Pearson's Chi-squar~ TRUE          
```

Combine these together:


```r
(table1.categorical.both <- table1.categorical.Ns %>%
  group_by(variable) %>%
  # we join on firstrowforvar to make sure we don't duplicate the tests
  mutate(firstrowforvar=row_number()==1) %>%
  left_join(., table1.categorical.tests, by=c("variable", "firstrowforvar")) %>%
  # this is gross, but we don't want to repeat the variable names in our table
  ungroup() %>%
  mutate(variable = ifelse(firstrowforvar==T, as.character(variable), NA)) %>%
  select(variable, value, Control, Intervention, statistic, parameter, p.value))
# A tibble: 9 x 7
  variable  value          Control Intervention statistic parameter p.value
  <chr>     <chr>            <int>        <int>     <dbl>     <int>   <dbl>
1 education Graduate            39           33     0.712         3   0.870
2 <NA>      Postgraduate        25           25    NA            NA  NA    
3 <NA>      Primary             21           24    NA            NA  NA    
4 <NA>      Secondary           27           24    NA            NA  NA    
5 <NA>      <NA>                28           34    NA            NA  NA    
6 ethnicity Asian / Asian~      32           37     1.49          3   0.684
7 <NA>      Black / Afric~      42           35    NA            NA  NA    
8 <NA>      Mixed / multi~      33           30    NA            NA  NA    
9 <NA>      White British       33           38    NA            NA  NA    
```

Now we deal with the continuous variables. First we make a 'long' version of the
continuous data


```r
continuous_variables <- c("yob", "WM")
boring.continuous.melted <-
  boring.study %>%
  select(condition, continuous_variables) %>%
  melt() %>%
  group_by(variable)
Using condition as id variables

boring.continuous.melted %>% head
# A tibble: 6 x 3
# Groups:   variable [1]
  condition variable value
  <fct>     <fct>    <dbl>
1 Control   yob       1969
2 Control   yob       1978
3 Control   yob       1969
4 Control   yob       1989
5 Control   yob       1975
6 Control   yob       1975
```

Then calculate separate tables of t-tests and means/SD's:


```r
(table.continuous_variables.tests <-
    boring.continuous.melted %>%
    # note that we pass the result of t-test to tidy, which returns a dataframe
    do(., t.test(.$value~.$condition) %>% tidy) %>%
    select(variable, statistic, parameter, p.value))
# A tibble: 2 x 4
# Groups:   variable [2]
  variable statistic parameter p.value
  <fct>        <dbl>     <dbl>   <dbl>
1 yob          0.941      278.   0.348
2 WM          -0.695      278.   0.488

(table.continuous_variables.descriptives <-
    boring.continuous.melted %>%
    group_by(variable, condition) %>%
    # this is not needed here because we have no missing values, but if there
    # were missing value in this dataset then mean/sd functions would fail below,
    #  so best to remove rows without a response:
    filter(!is.na(value)) %>%
    # note, we might also want the median/IQR
    summarise(Mean=mean(value), SD=sd(value)) %>%
    group_by(variable, condition) %>%
    # we format the mean and SD into a single column using sprintf.
    # we don't have to do this, but it makes reshaping simpler and we probably want
    # to round the numbers at some point, and so may as well do this now.
    transmute(MSD = sprintf("%.2f (%.2f)", Mean, SD)) %>%
    dcast(variable~condition))
Using MSD as value column: use value.var to override.
  variable        Control   Intervention
1      yob 1979.51 (5.21) 1978.92 (5.21)
2       WM  100.08 (9.18)  100.86 (9.56)
```

And combine them:


```r
(table.continuous_variables.both <-
  left_join(table.continuous_variables.descriptives,
            table.continuous_variables.tests))
Joining, by = "variable"
  variable        Control   Intervention  statistic parameter   p.value
1      yob 1979.51 (5.21) 1978.92 (5.21)  0.9407657  277.9999 0.3476417
2       WM  100.08 (9.18)  100.86 (9.56) -0.6948592  277.5507 0.4877249
```

Finally put the whole thing together:


```r
(table1 <- table1.categorical.both %>%
  # make these variables into character format to be consistent with
  # the Mean (SD) column for continuus variables
  mutate_each(funs(format), Control, Intervention) %>%
  # note the '.' as the first argument, which is the input from the pipe
  bind_rows(.,
          table.continuous_variables.both) %>%
  # prettify a few things
  rename(df = parameter,
         p=p.value,
         `Control N/Mean (SD)`= Control,
         Variable=variable,
         Response=value,
         `t/χ2` = statistic))
Warning: funs() is soft deprecated as of dplyr 0.8.0
please use list() instead

  # Before:
  funs(name = f(.))

  # After: 
  list(name = ~ f(.))
This warning is displayed once per session.
Warning in bind_rows_(x, .id): binding character and factor vector,
coercing into character vector
# A tibble: 11 x 7
   Variable  Response     `Control N/Mean~ Intervention `t/χ2`    df      p
   <chr>     <chr>        <chr>            <chr>         <dbl> <dbl>  <dbl>
 1 education Graduate     39               33            0.712    3   0.870
 2 <NA>      Postgraduate 25               25           NA       NA  NA    
 3 <NA>      Primary      21               24           NA       NA  NA    
 4 <NA>      Secondary    27               24           NA       NA  NA    
 5 <NA>      <NA>         28               34           NA       NA  NA    
 6 ethnicity Asian / Asi~ 32               37            1.49     3   0.684
 7 <NA>      Black / Afr~ 42               35           NA       NA  NA    
 8 <NA>      Mixed / mul~ 33               30           NA       NA  NA    
 9 <NA>      White Briti~ 33               38           NA       NA  NA    
10 yob       <NA>         1979.51 (5.21)   1978.92 (5.~  0.941  278.  0.348
11 WM        <NA>         100.08 (9.18)    100.86 (9.5~ -0.695  278.  0.488
```

And we can print to markdown format for outputting. This is best done in a
separate chunk to avoid warnings/messages appearing in the final document.


```r
table1 %>%
  # split.tables argument needed to avoid the table wrapping
  pander(split.tables=Inf,
         missing="-",
         justify=c("left", "left", rep("center", 5)),
         caption='Table presenting baseline differences between conditions. Categorical variables tested with Pearson χ2, continuous variables with two-sample t-test.')
```


--------------------------------------------------------------------------------------------------------------
Variable    Response                          Control N/Mean (SD)    Intervention     t/χ2      df       p    
----------- -------------------------------- --------------------- ---------------- --------- ------- --------
education   Graduate                                  39                  33         0.7119      3     0.8704 

-           Postgraduate                              25                  25            -        -       -    

-           Primary                                   21                  24            -        -       -    

-           Secondary                                 27                  24            -        -       -    

-           -                                         28                  34            -        -       -    

ethnicity   Asian / Asian British                     32                  37          1.494      3     0.6837 

-           Black / African / Caribbean /             42                  35            -        -       -    
            Black British                                                                                     

-           Mixed / multiple ethnic groups            33                  30            -        -       -    

-           White British                             33                  38            -        -       -    

yob         -                                   1979.51 (5.21)      1978.92 (5.21)   0.9408     278    0.3476 

WM          -                                    100.08 (9.18)      100.86 (9.56)    -0.6949   277.6   0.4877 
--------------------------------------------------------------------------------------------------------------

Table: Table presenting baseline differences between conditions. Categorical variables tested with Pearson χ2, continuous variables with two-sample t-test.

Some exercises to work on/extensions to this code you might need:

-   Add a new continuous variable to the simulated dataset and include it in the
    final table
-   Create a third experimental group and amend the code to i) include 3 columns
    for the N/Mean and ii) report the F-test from a one-way Anova as the test
    statistic.
-   Add the within-group percentage for each response to a categorical variable.
