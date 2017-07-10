---
title: 'Real data'
output:
  bookdown::tufte_html2
---





# Working with 'real' data {#real-data}

*Note: If you already have nicely formatted data ready for use in R then you could skip this section and revisit it later,* save for the section on [factors and other variable types](#factors-and-numerics)

Most tutorials and textbooks use neatly formatted example datasets to illustrate particular techniques. However in the real-world our data can be:

- In the wrong format
- Spread across multiple files
- Badly coded, or with errors
- Incomplete, with values missing for many different reasons


This chapter shows you how to address each of these problems.



## Storing your data {- #storing-data}


### CSV files are your friend {- #use-csv}

Comma-sepatated-values files are a plain text format which are idea for storing your data. Some advantages include:

- Understood by almost every piece of software on the planet
- Will remain readbale in future
- Easy to store 2D data (like data frames)
- Human readable (just open in Notepad)


Commercial formats like Excel, SPSS (.sav) and Stata (.dta) don't have these properties.

Although CSV has some disadvantages, they are all easily overcome if you [save the steps of your data processing and analysis in your R code](#save-intermediate-steps), see below.





### Save your steps {- #save-intermediate-steps}

Many students (and academics) make errors in their analyses because they process data by hand (e.g. editing files in Excel) or use GUI tools to run analyses. In both cases these errors are hard to identify or rectify because *no record is made of what was done*.

In contrast, if you do your data processing and analysis in R/RMarkdown you:

- Have a concrete, repeatable series of steps  which can be checked/verified by others.
- Save a lot of time processing new data (e.g. if you run more participants).


Some principles to follow when working:

- Save data in the simplest possible format, in CSV
- Always include column names in the file
- Use descriptive names, but with a regular strucuture.
- Never include spaces or special characters in the column names. Use underscores (`_`) if you want to make things more readable.
- Make names <20 characters in length if possible










### RDS files can be useful to preserve R objects

If you have R objects which you'd like to save, for example because they took a long time to compute, the the RDS format is the best way of preserving them.

To save something:


```r
# create a huge df... 
# note this actually blows up my laptop because it's too big
massive.df <- data_frame(i = 1:1e10, sqrt_i = sqrt(i))
saveRDS(massive.df, file="bigdata.RDS")
```

Then later on you can load it like this:


```r
restored.massive.df  <-  readRDS('bigdata.RDS')
```

If you do this in RMarkdown, by default the RDS files will be saved in the same directory as your .Rmd file.







## Types of variable: factor, character and numeric {- #factors-and-numerics}

When working with data in Excel or other packages like SPSS you've probably become aware that different types of data get treated differently. For example, in Excel you can't set up a formula like `=SUM(...)` on cells which include letters (rather than just numbers). It does't make sense. However, Excel and many other programmes will sometimes make guesses about what to do if you combine different types of data. For example, if you add `28` to `1 Feb 2017` the result is `1 March 2017`. This is sometimes what you want, but can often lead to unexpected results and errors in data analyses.

R is much more strict about not mixing types of data. Vectord (and columns in dataframes) can only contain one type of thing. In general, there are probably 4 types of data you will encounter in data analysis problems:

- Numeric variables
- Character variables
- Factors
- Dates





The file `lakers.RDS` contains a dataset adapted from the `lubridate::lakers` dataset.

It contains four variables to illustrate the common variable types. From the original dataset which provides scores and other information from each Los Angeles Lakers basketball game in the 2008-2009 season we have the `date`, `opponent`, `team`, and  `points` variables.


```r
lakers <- readRDS("lakers.RDS")
lakers %>% 
  glimpse
## Observations: 34,624
## Variables: 4
## $ date     <date> 2008-10-28, 2008-10-28, 2008-10-28, 2008-10-28, 2008...
## $ opponent <chr> "POR", "POR", "POR", "POR", "POR", "POR", "POR", "POR...
## $ team     <fctr> OFF, LAL, LAL, LAL, LAL, LAL, POR, LAL, LAL, POR, LA...
## $ points   <int> 0, 0, 0, 0, 0, 2, 0, 1, 0, 2, 2, 0, 0, 2, 2, 0, 0, 2,...
```

One thing to note here is that the `glimpse()` command tells us the type of each variable. So we have 

- `points`: type `int`, short for integer (i.e. whole numbers). 
- `date`: type `date`
- `opponent`: type `chr`, short for 'character', or alaphanumeric data
- `team`: type `fctr`, short for factor and


[Other numeric variables might sometimes have type = `dbl`, which stands for 'double precision' floating point number (that is, a decimal fraction). But for most data analysis purposes we can treat all numeric variable types the same.]{.admonition}




### Numeric variables

We've already seem numeric variables in the section on [vectors and lists](#vectors). These behave pretty much as you'd expect, and we won't expand on them here. 

#### {- .explainer}

One small aside is that you should be aware that there are limits to the precision with which R (and computers in general) can store decimal values. This only tends to matter when working with very large or very small numbers — but this can crop up when estimating regression coefficients that are very small for example, and is one reason why [scaling inputs to regression models can improve performance and accuracy of results](#scaling-regression-inputs).









### Dates

Like  most computers, R stores dates as the number of days since January 1, 1970. This means that we can work with dates just like other numbers, and it makes sense to have the `min()`, or `max()` of a series of dates:



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











## Missing values {-}

- `is.na()` and `is.finite`
- `expand()`








## Tidying data {- #tidying-data}

- Melt, spread
- ...



## Deal with multiple files {-}

- File handling and import
- Writing a function for `do()` which returns a dataframe
- Joins and merges



##  Error checking {-}

- `999`, `666` and `*`: the marks of the beast!




