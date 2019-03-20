
---
title: 'Working with dataframes'
---


## Working with dataframes {- #working-with-dataframes}




### Introducing the `tidyverse` {- #tidyverse}


This guide deliberately ignores many common patterns for working with dataframes. 

There are plenty of other guides for working in these older ways, but for beginners, these techniques can be confusing. The approach shown here is based only on functions in [the `tidyverse`](#tidyverse). Although simple --- and easy to read ---  the approach is extremely flexible and covers almost all of the cases you will encounter when working with psychological data. 



Specifically, we make extensive use of two tidyverse packages:

- `dplyr`: to select, filter and summarise data
- `ggplot2`: to make plots


To load the tidyverse first write:


```r
library(tidyverse)
```

This can either be typed into the console or (better) included at the top of an markdown file.


<!---
XXX Add note for teachers here???
--->


## Selecting columns {- #selecting-columns}


To pick out single or multiple columns use the `select()` function. 

The `select()` function expects a dataframe as it's first input ('argument', in R language), followed by the names of the columns you want to extract with a comma between each name. 

It returns a *new* dataframe with just those columns, in the order you specified:



```r
head(
  select(mtcars, cyl, hp)
)
                  cyl  hp
Mazda RX4           6 110
Mazda RX4 Wag       6 110
Datsun 710          4  93
Hornet 4 Drive      6 110
Hornet Sportabout   8 175
Valiant             6 105
```


#### Saving a subset of the data {-}
Because `dplyr` functions return a *new* dataframe, we can assign the results to a variable:


```r
justcylandweight <- select(mtcars, cyl, wt)
summary(justcylandweight)
      cyl              wt       
 Min.   :4.000   Min.   :1.513  
 1st Qu.:4.000   1st Qu.:2.581  
 Median :6.000   Median :3.325  
 Mean   :6.188   Mean   :3.217  
 3rd Qu.:8.000   3rd Qu.:3.610  
 Max.   :8.000   Max.   :5.424  
```



#### Excluding columns {-}

If you want most of the columns --- perhaps you just want to get rid of one of them --- you can also put a minus (`-`) sign in front of the name. This then selects everything *except* the column you named:



```r
# Note we are just dropping the Ozone column
head(select(airquality, -Ozone))
  Solar.R Wind Temp Month Day
1     190  7.4   67     5   1
2     118  8.0   72     5   2
3     149 12.6   74     5   3
4     313 11.5   62     5   4
5      NA 14.3   56     5   5
6      NA 14.9   66     5   6
```



#### Matching specific columns {-}
You can use a patterns to match a subset of the columns you want. For example, here we select all the columns where the name contains the letter `d`:


```r
head(select(mtcars, contains("d")))
                  disp drat
Mazda RX4          160 3.90
Mazda RX4 Wag      160 3.90
Datsun 710         108 3.85
Hornet 4 Drive     258 3.08
Hornet Sportabout  360 3.15
Valiant            225 2.76
```


And you can combine these techniques to make more complex selections:


```r
head(select(mtcars, contains("d"), -drat))
                  disp
Mazda RX4          160
Mazda RX4 Wag      160
Datsun 710         108
Hornet 4 Drive     258
Hornet Sportabout  360
Valiant            225
```



#### Other methods of selection {-}

As a quick reference, you can use the following 'verbs' to select columns in different ways:

- `starts_with()`
- `ends_with()`
- `contains()`
- `everything()`

See the help files for more information (type `??dplyr::select` into the console).



## Selecting rows {- #selecting-rows}

To select rows from a dataframe use the `filter()` function (again from `dplyr`). 


If we only wanted to rows for 6-cylindered cars, we could write:


```r
filter(mtcars, cyl==6)
   mpg cyl  disp  hp drat    wt  qsec vs am gear carb
1 21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
2 21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
3 21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
4 18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
5 19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
6 17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
7 19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
```


## 'Operators' {- #operators}

<!-- <iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/4TYv2PhG89A?rel=0" frameborder="0" allowfullscreen></iframe>
 -->

When selecting rows in the [example above](#selecting-rows) we used two equals signs `==` to select rows where `cyl` was exactly `6`. 

As you might guess, there are other 'operators' we can use to create filters. 

Rather than describe them, the examples below demonstrate what each of them do.


###### Equality and matching {-}

As above, to compare a single value we use `==`


```r
2 == 2
[1] TRUE
```

And in a filter:


```r
filter(mtcars, cyl==6)
   mpg cyl  disp  hp drat    wt  qsec vs am gear carb
1 21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
2 21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
3 21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
4 18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
5 19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
6 17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
7 19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
```


:::{.explainer}

You might have noted above that we write `==` rather than just `=` to define the criteria. This is because most programming languages, including R, use two `=` symbols to distinguish: *comparison* from *assignment*.

:::



###### Presence/absence {-}


To test if a value is in a vector of suitable matches we can use: `%in%`:


```r
5 %in% 1:10
[1] TRUE
```

Or for an example which is not true:


```r
100 %in% 1:10
[1] FALSE
```

Perhaps less obviously, we can test whether each value in a vector is *in* a second vector. 

This returns a vector of `TRUE/FALSE` values as long as the first list:


```r
c(1, 2) %in% c(2, 3, 4)
[1] FALSE  TRUE
```

This is very useful in a dataframe filter:


```r
head(filter(mtcars, cyl %in% c(4, 6)))
   mpg cyl  disp  hp drat    wt  qsec vs am gear carb
1 21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
2 21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
3 22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
4 21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
5 18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
6 24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
```

:::{.explainer}

Here we selected all rows where `cyl` matched either `4` or `6`. That is, where the value of `cyl` was 'in' the vector `c(4,6)`.

:::


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
[1] FALSE
```

This is helpful because we can reverse the meaning of other expressions:


```r
is.na(NA)
[1] TRUE
!is.na(NA)
[1] FALSE
```

And we can use in dplyr filters. 

Here we select rows where `Ozone` is missing (`NA`):


```r
filter(airquality, is.na(Ozone))
```

And here we use `!` to reverse the expression and select rows which are not missing:


```r
filter(airquality, !is.na(Ozone))
```



:::{.exercise}

Try running these commands for yourself and experiment with changing the operators to make select different combinations of rows

:::



###### Other logical operators {-}


There are operators for 'and'/'or' which can combine other filters.

Using `&` (and) with two condtions makes the filter more restrictive:


```r
filter(mtcars, hp > 200 & wt > 4)
   mpg cyl disp  hp drat    wt  qsec vs am gear carb
1 10.4   8  472 205 2.93 5.250 17.98  0  0    3    4
2 10.4   8  460 215 3.00 5.424 17.82  0  0    3    4
3 14.7   8  440 230 3.23 5.345 17.42  0  0    3    4
```

In contrast, the pipe symbol, `|`, means 'or', so we match more rows:


```r
filter(mtcars, hp > 200 | wt > 4)
   mpg cyl  disp  hp drat    wt  qsec vs am gear carb
1 14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
2 16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3
3 10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4
4 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4
5 14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4
6 13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4
7 15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
8 15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8
```

Finally, you can set the order in which operators are applied by using parentheses. This means these expressions are subtly different:


```r
# first
filter(mtcars, (hp > 200 & wt > 4) | cyl==8)
    mpg cyl  disp  hp drat    wt  qsec vs am gear carb
1  18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
2  14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
3  16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3
4  17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3
5  15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3
6  10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4
7  10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4
8  14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4
9  15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2
10 15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2
11 13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4
12 19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2
13 15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
14 15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8

# second reordered evaluation
filter(mtcars, hp > 200 & (wt > 4 | cyl==8))
   mpg cyl disp  hp drat    wt  qsec vs am gear carb
1 14.3   8  360 245 3.21 3.570 15.84  0  0    3    4
2 10.4   8  472 205 2.93 5.250 17.98  0  0    3    4
3 10.4   8  460 215 3.00 5.424 17.82  0  0    3    4
4 14.7   8  440 230 3.23 5.345 17.42  0  0    3    4
5 13.3   8  350 245 3.73 3.840 15.41  0  0    3    4
6 15.8   8  351 264 4.22 3.170 14.50  0  1    5    4
7 15.0   8  301 335 3.54 3.570 14.60  0  1    5    8
```


:::{.exercise}

Try writing in plain English the meaning of the two filter expressions above

:::



## Sorting {- #sorting}

Sort dataframes using `arrange()` from `dplyr`:


```r
airquality %>% 
  arrange(Ozone) %>% 
  head
  Ozone Solar.R Wind Temp Month Day
1     1       8  9.7   59     5  21
2     4      25  9.7   61     5  23
3     6      78 18.4   57     5  18
4     7      NA  6.9   74     5  11
5     7      48 14.3   80     7  15
6     7      49 10.3   69     9  24
```

By default sorting is ascending, but you can use a minus sign to reverse this:


```r
airquality %>% 
  arrange(-Ozone) %>% 
  head
  Ozone Solar.R Wind Temp Month Day
1   168     238  3.4   81     8  25
2   135     269  4.1   84     7   1
3   122     255  4.0   89     8   7
4   118     225  2.3   94     8  29
5   115     223  5.7   79     5  30
6   110     207  8.0   90     8   9
```


You can sort on multiple columns too, but the order of the variables makes a difference. This:


```r
airquality %>% 
  select(Month, Ozone) %>% 
  arrange(Month, -Ozone) %>% 
  head
  Month Ozone
1     5   115
2     5    45
3     5    41
4     5    37
5     5    36
6     5    34
```

Is different to this:


```r
airquality %>% 
  select(Month, Ozone) %>% 
  arrange(-Ozone, Month) %>% 
  head
  Month Ozone
1     8   168
2     7   135
3     8   122
4     8   118
5     5   115
6     8   110
```




## Pipes {- #pipes}

We often want to combine `select` and `filter` (and other functions) to return a subset of our original data.

One way to achieve this is to 'nest' function calls. 

Taking the `mtcars` data, we can select the weights of cars with a poor `mpg`:


```r
gas.guzzlers <- select(filter(mtcars, mpg < 15), wt)
summary(gas.guzzlers)
       wt       
 Min.   :3.570  
 1st Qu.:3.840  
 Median :5.250  
 Mean   :4.686  
 3rd Qu.:5.345  
 Max.   :5.424  
```


This is OK, but can be confusing to read.  The more deeply nested we go, the easier it is to make a mistake.



#### `tidyverse` provides an alternative to nested function calls, called the 'pipe'. {-}


Imagine your dataframe as a big bucket, containing data. 

From this bucket, you can 'pour' your data down the screen, and it passes through a series of tubes and filters. 

At the bottom of your screen you have a smaller bucket, containing only the data you want.


![Think of your data 'flowing' down the screen.](media/tubes.jpg)


The 'pipe' operator, `%>%` makes our data 'flow' in this way:


```r
big.bucket.of.data <- mtcars

big.bucket.of.data %>%
  filter(mpg <15) %>%
  select(wt) %>%
  summary
       wt       
 Min.   :3.570  
 1st Qu.:3.840  
 Median :5.250  
 Mean   :4.686  
 3rd Qu.:5.345  
 Max.   :5.424  
```

:::{.explainer}

The `%>%` symbol makes the data flow onto the next step. Each function which follows the pipe takes the incoming data as it's first input.

:::


Pipes do the same thing as nesting functions, but the code stays more readable.

It's especially nice because the order in which the functions happen is the same as the order in which we read the code (the opposite is true for nested functions).

We can save intermediate 'buckets' for use later on:


```r
smaller.bucket <- big.bucket.of.data %>%
  filter(mpg <15) %>%
  select(wt)
```


This is an incredibly useful pattern for processing and working with data. 

We can 'pour' data through a series of filters and other operations, saving intermediate states where necessary.

:::{.tip}

You can insert the `%>%` symbol in RStdudio by typing `cmd-shift-M`, which saves a lot of typing.

:::






## Modifying and creating new columns {- #mutate}


We often want to compute new columns from data we already have. 

Imagine we had heights stored in cm, and weights stored in kg for 100 participants in a study on weight loss:


```r
set.seed(1234)

weightloss <- tibble(
	height_cm = rnorm(100, 150, 20),
	weight_kg = rnorm(100, 65, 10)
)
```


```r
weightloss %>% head
# A tibble: 6 x 2
  height_cm weight_kg
      <dbl>     <dbl>
1      126.      69.1
2      156.      60.3
3      172.      65.7
4      103.      60.0
5      159.      56.7
6      160.      66.7
```


If we want to compute each participants' Body Mass Index, we first need to convert their height into meters. We do this with mutate:


```r
weightloss %>% 
  mutate(height_meters = height_cm / 100) %>% 
  head
# A tibble: 6 x 3
  height_cm weight_kg height_meters
      <dbl>     <dbl>         <dbl>
1      126.      69.1          1.26
2      156.      60.3          1.56
3      172.      65.7          1.72
4      103.      60.0          1.03
5      159.      56.7          1.59
6      160.      66.7          1.60
```

We then want to calculate BMI:


```r
weightloss %>% 
  mutate(height_meters = height_cm / 100,
         bmi = weight_kg / height_meters ^ 2) %>% 
  head
# A tibble: 6 x 4
  height_cm weight_kg height_meters   bmi
      <dbl>     <dbl>         <dbl> <dbl>
1      126.      69.1          1.26  43.7
2      156.      60.3          1.56  24.9
3      172.      65.7          1.72  22.3
4      103.      60.0          1.03  56.4
5      159.      56.7          1.59  22.6
6      160.      66.7          1.60  26.0
```


:::{.tip}

You could skip the intermediate step of converting to meters and write: `bmi = weight_kg / (height_cm/100) ^ 2`. But it's often best to be explicit and simplify each operation.

:::


