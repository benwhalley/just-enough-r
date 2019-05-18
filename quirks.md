
---
title: 'Quirks'
---



# Dealing with quirks of R {#quirks}

## Rownames are evil {- #rownames}

Historically 'row names' were used on R to label individual rows in a dataframe.
It turned out that this is generally a bad idea, because sorting and some
summary functions would get very confused and mix up row names and the data
itself.

It's now considered best practice to avoid row names for this reason.
Consequently, the functions in the `dplyr` library remove row names when
processing dataframes. For example here we see the row names in the `mtcars`
data:


```r
mtcars %>%
  head(3)
               mpg cyl disp  hp drat    wt  qsec vs am gear carb
Mazda RX4     21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
Mazda RX4 Wag 21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
Datsun 710    22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
```

But here we don't because `arrange` has stripped them:


```r
mtcars %>%
  arrange(mpg) %>%
  head(3)
   mpg cyl disp  hp drat    wt  qsec vs am gear carb
1 10.4   8  472 205 2.93 5.250 17.98  0  0    3    4
2 10.4   8  460 215 3.00 5.424 17.82  0  0    3    4
3 13.3   8  350 245 3.73 3.840 15.41  0  0    3    4
```

Converting the results of `psych::describe()` also returns rownames, which can
get lots if we sort the data.

We see row names here:


```r
psych::describe(mtcars) %>%
	as_data_frame() %>%
  head(3)
Warning: `as_data_frame()` is deprecated, use `as_tibble()` (but mind the new semantics).
This warning is displayed once per session.
# A tibble: 3 x 13
   vars     n   mean     sd median trimmed    mad   min   max range   skew
  <int> <dbl>  <dbl>  <dbl>  <dbl>   <dbl>  <dbl> <dbl> <dbl> <dbl>  <dbl>
1     1    32  20.1    6.03   19.2   19.7    5.41  10.4  33.9  23.5  0.611
2     2    32   6.19   1.79    6      6.23   2.97   4     8     4   -0.175
3     3    32 231.   124.    196.   223.   140.    71.1 472   401.   0.382
# … with 2 more variables: kurtosis <dbl>, se <dbl>
```

But not here (just numbers in their place):


```r
psych::describe(mtcars) %>%
	as_data_frame() %>%
  arrange(mean) %>%
  head(3)
# A tibble: 3 x 13
   vars     n  mean    sd median trimmed   mad   min   max range  skew
  <int> <dbl> <dbl> <dbl>  <dbl>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
1     9    32 0.406 0.499      0   0.385  0        0     1     1 0.364
2     8    32 0.438 0.504      0   0.423  0        0     1     1 0.240
3    11    32 2.81  1.62       2   2.65   1.48     1     8     7 1.05 
# … with 2 more variables: kurtosis <dbl>, se <dbl>
```

##### Preserving row names {-}

If you want to preserve row names, it's best to convert the names to an extra
colum in the data. So, the example below does what we probably want:


```r
# the var='car.name' argument is optional, but can be useful
mtcars %>%
  rownames_to_column(var="car.name") %>%
  arrange(mpg) %>%
  head(3)
             car.name  mpg cyl disp  hp drat    wt  qsec vs am gear carb
1  Cadillac Fleetwood 10.4   8  472 205 2.93 5.250 17.98  0  0    3    4
2 Lincoln Continental 10.4   8  460 215 3.00 5.424 17.82  0  0    3    4
3          Camaro Z28 13.3   8  350 245 3.73 3.840 15.41  0  0    3    4
```

<!-- TODO ADD THIS BACK WHEN THIS BUG FIXED: https://github.com/tidyverse/broom/issues/231 -->

<!-- Another good way of preserving row names when converting R objects to dataframes is to use the `broom` library. Its `tidy()` function often does something sensible to convert an object to a dataframe, and has other benefits too, like extracting the relevant parts of the output, and naming columns consistently. -->

<!-- Some example of `broom` in action: -->

<!-- ```{r} -->
<!-- psych::describe(mtcars, fast=T) %>% as_data_frame() -->
<!--   broom::tidy() %>%  -->
<!--   pander -->

<!--   select(column, mean, sd, n) %>%  -->
<!--   head(3) %>%  -->
<!--   pander -->

<!-- ``` -->


```r
lm(mpg~wt, data=mtcars) %>%
  broom::tidy() %>%
  pander
```


------------------------------------------------------------
    term       estimate   std.error   statistic    p.value  
------------- ---------- ----------- ----------- -----------
 (Intercept)    37.29       1.878       19.86     8.242e-19 

     wt         -5.344     0.5591      -9.559     1.294e-10 
------------------------------------------------------------
