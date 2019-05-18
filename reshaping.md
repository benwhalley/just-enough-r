
---
title: Reshaping
---



## Reshaping {- #reshaping}

<!-- <div style="width:100%;height:0;padding-bottom:75%;position:relative;"><iframe src="https://giphy.com/embed/J42u1BTrks9eU" width="100%" height="100%" style="position:absolute" frameBorder="0" class="giphy-embed" allowFullScreen></iframe></div><p><a href="https://giphy.com/gifs/funny-transformer-J42u1BTrks9eU">via GIPHY</a></p>
 -->

This section will probably require more attention than any other in the guide,
but will likely be one of the most useful things you learn in R.

As previously discussed, most things work best in R if you have data in _long
format_. This means we prefer data that look like this:


---------------------------
 person    time    outcome 
-------- -------- ---------
   1      Time 1    21.29  

   2      Time 1    23.83  

   3      Time 1    26.46  

   1      Time 2    22.71  

   2      Time 2    17.31  

   3      Time 2    22.72  

   1      Time 3    21.46  

   2      Time 3    18.63  

   3      Time 3    18.82  

   1      Time 4    12.85  

   2      Time 4    18.43  

   3      Time 4    21.7   
---------------------------

And NOT like this:


--------------------------------------------
 person   Time 1   Time 2   Time 3   Time 4 
-------- -------- -------- -------- --------
   1      21.29    22.71    21.46    12.85  

   2      23.83    17.31    18.63    18.43  

   3      26.46    22.72    18.82     21.7  
--------------------------------------------

In long format data:

-   each row of the dataframe corresponds to a single measurement occasion
-   each column corresponds to a variable which is measured

Fortunately it's fairly easy to move between the two formats, provided your
variables are named in a consistent way.

#### Wide to long format {- #wide-to-long}

This is the most common requirement. Often you will have several columns which
actually measure the same thing, and you will need to convert these two two
columns - a 'key', and a value.

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

We want to convert RT measurements on each Day to a single variable, and create
a new variable to keep track of what `Day` the measurement was taken:

The `melt()` function in the `reshape2::` package does this for us:


```r
library(reshape2)
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



Here melt has created two new variable: `variable`, which keeps track of what
was measured, and `value` which contains the score. This is the format we need
when [plotting graphs](#graphics) and running
[regression and Anova models](#linear-models-simple).

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

We can convert these back to the original wide format using `dcast`, again in
the `reshape2` package. The name of the `dcast` function indicates we can 'cast'
a dataframe (the d prefix). So here, casting means the opposite of 'melting'.

Using `dcast` is a little more fiddly than `melt` because we have to say _how_
we want the data spread wide. In this example we could either have:

-   Columns for each day, with rows for each subject
-   Columns for each subject, with rows for each day

Although it's obvious to _us_ which format we want, we have to be explicit for R
to get it right.

We do this using a [formula](#formulae), which we'll see again in the regression
section.

Each formula has two sides, left and right, separated by the tilde (`~`) symbol.
On the left hand side we say which variable we want to keep in rows. On the
right hand side we say which variables to convert to columns. So, for example:


```r
# rows per subject, columns per day
sleep.long %>%
  dcast(Subject~variable) %>%
  head(3)
  Subject    Day.0    Day.1    Day.2    Day.3    Day.4    Day.5    Day.6
1       1 249.5600 258.7047 250.8006 321.4398 356.8519 414.6901 382.2038
2       2 222.7339 205.2658 202.9778 204.7070 207.7161 215.9618 213.6303
3       3 199.0539 194.3322 234.3200 232.8416 229.3074 220.4579 235.4208
     Day.7    Day.8    Day.9
1 290.1486 430.5853 466.3535
2 217.7272 224.2957 237.3142
3 255.7511 261.0125 247.5153
```

To compare, we can convert so each Subject has a column by reversing the
formula:


```r
# note we select only the first 7 Subjects to
# keep the table to a manageable size
sleep.long %>%
  filter(Subject < 8) %>%
  dcast(variable~Subject)
   variable        1        2        3        4        5        6        7
1     Day.0 249.5600 222.7339 199.0539 321.5426 287.6079 234.8606 283.8424
2     Day.1 258.7047 205.2658 194.3322 300.4002 285.0000 242.8118 289.5550
3     Day.2 250.8006 202.9778 234.3200 283.8565 301.8206 272.9613 276.7693
4     Day.3 321.4398 204.7070 232.8416 285.1330 320.1153 309.7688 299.8097
5     Day.4 356.8519 207.7161 229.3074 285.7973 316.2773 317.4629 297.1710
6     Day.5 414.6901 215.9618 220.4579 297.5855 293.3187 309.9976 338.1665
7     Day.6 382.2038 213.6303 235.4208 280.2396 290.0750 454.1619 332.0265
8     Day.7 290.1486 217.7272 255.7511 318.2613 334.8177 346.8311 348.8399
9     Day.8 430.5853 224.2957 261.0125 305.3495 293.7469 330.3003 333.3600
10    Day.9 466.3535 237.3142 247.5153 354.0487 371.5811 253.8644 362.0428
```

###### {- .tip}

One neat trick when casting is to use `paste` to give your columns nicer names.
So for example:


```r
sleep.long %>%
  filter(Subject < 4) %>%
  dcast(variable~paste0("Person.", Subject))
   variable Person.1 Person.2 Person.3
1     Day.0 249.5600 222.7339 199.0539
2     Day.1 258.7047 205.2658 194.3322
3     Day.2 250.8006 202.9778 234.3200
4     Day.3 321.4398 204.7070 232.8416
5     Day.4 356.8519 207.7161 229.3074
6     Day.5 414.6901 215.9618 220.4579
7     Day.6 382.2038 213.6303 235.4208
8     Day.7 290.1486 217.7272 255.7511
9     Day.8 430.5853 224.2957 261.0125
10    Day.9 466.3535 237.3142 247.5153
```

Notice we used `paste0` rather than `paste` to avoid spaces in variable names,
which is allowed but can be a pain.
[See more on working with character strings in a later section](#string-handling).

##### {-}

For a more detailed explanation and various other methods for reshaping data,
see: http://r4ds.had.co.nz/tidy-data.html

### Which package should you use to reshape data? {- #which-reshape-package}

There are three main options:

-   `tidyr::`, which comes as part of the `tidyverse`, using `gather` and
    `spread()`
-   `reshape2::` using `melt()` and `dcast()`
-   `data.table::` also using functions called `melt()` and `dcast()` (but which
    are slightly different from those in `reshape2`)

This post walks through some of the differences:
https://www.r-bloggers.com/how-to-reshape-data-in-r-tidyr-vs-reshape2/ but the
short answer is whichever you find simplest and easiest to remember (for me
that's `melt` and `dcast`).

`

### Aggregating and reshaping at the same time {-}

One common trick when reshaping is to convert a datafile which has multiple rows
and columns per person to one with only a single row per person. That is, we
aggregae by using a summary (perhaps the mean) and reshape at the same time.

Although useful this isn't covered in this section, because it is combining two
techniques:

-   Reshaping (i.e. from long to wide or back)
-   Aggregating or summarising (converting multiple rows to one)

In the next section we cover [summarising data](#summarising-data), and
introduce the 'split-apply-combine' method for summarising.

Once you have a good grasp of this, you could check out the
['fancy reshaping' section](#fancy-reshaping) which does provide examples of
aggregating and reshaping simultaneously.
