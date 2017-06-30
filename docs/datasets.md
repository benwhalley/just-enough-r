---
title: 'Datasets and dataframes'
output: 
  bookdown::tufte_html2
---
  




# Datasets and dataframes

A dataframe is an object which can store data as you might encounter it in SPSS, Stata or other statistics packages. It's much like a spreadsheet, but with some constraints applied 
'Constraints' sounds bad, but are helpful here: they make dataframes more structured and predictable to work with:

- Each column is a vector, and so can only store one type of data ^[Remember that in a [previous chapter](start_here.html) we created *vectors*, which are sequences that contain only one type of thing, and *lists* (which can contain a mix of different things.]

- Every column has to be the same length (although missing values are allowed).

- Each column should have a name.


Put another way, a dataframe behaves like a *list* of *vectors*, which means we can use a lot of the same rules to access elements within them (more on this below).


## Using 'built in' data 



The quickest way to see a dataframe in action is to use one that is built in[^builtin] to R. For example:

[^builtin]:
  To find a list of all the built in datasets you can type `help(datasets)`


```r
head(airquality)
##   Ozone Solar.R Wind Temp Month Day
## 1    41     190  7.4   67     5   1
## 2    36     118  8.0   72     5   2
## 3    12     149 12.6   74     5   3
## 4    18     313 11.5   62     5   4
## 5    NA      NA 14.3   56     5   5
## 6    28      NA 14.9   66     5   6
```

Or we can use `dplyr::glimpse()` function to take a different look at the first few rows of the `mtcars` data. This flips the dataframe so the variables are listed in the first column of the output:


```r
glimpse(mtcars)
## Observations: 32
## Variables: 11
## $ mpg  <dbl> 21.0, 21.0, 22.8, 21.4, 18.7, 18.1, 14.3, 24.4, 22.8, 19....
## $ cyl  <dbl> 6, 6, 4, 6, 8, 6, 8, 4, 4, 6, 6, 8, 8, 8, 8, 8, 8, 4, 4, ...
## $ disp <dbl> 160.0, 160.0, 108.0, 258.0, 360.0, 225.0, 360.0, 146.7, 1...
## $ hp   <dbl> 110, 110, 93, 110, 175, 105, 245, 62, 95, 123, 123, 180, ...
## $ drat <dbl> 3.90, 3.90, 3.85, 3.08, 3.15, 2.76, 3.21, 3.69, 3.92, 3.9...
## $ wt   <dbl> 2.620, 2.875, 2.320, 3.215, 3.440, 3.460, 3.570, 3.190, 3...
## $ qsec <dbl> 16.46, 17.02, 18.61, 19.44, 17.02, 20.22, 15.84, 20.00, 2...
## $ vs   <dbl> 0, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, ...
## $ am   <dbl> 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, ...
## $ gear <dbl> 4, 4, 4, 3, 3, 3, 3, 4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 4, 4, ...
## $ carb <dbl> 4, 4, 1, 1, 2, 1, 4, 2, 2, 4, 4, 3, 3, 3, 4, 4, 4, 1, 2, ...
```


In both these examples the datasets (`airquality` and `mtcars`) are already loaded and available to be used in the `head()` or `glimpse()` functions.


Other useful functions for looking at datasets include:


```r
summary(airquality)
##      Ozone           Solar.R           Wind             Temp      
##  Min.   :  1.00   Min.   :  7.0   Min.   : 1.700   Min.   :56.00  
##  1st Qu.: 18.00   1st Qu.:115.8   1st Qu.: 7.400   1st Qu.:72.00  
##  Median : 31.50   Median :205.0   Median : 9.700   Median :79.00  
##  Mean   : 42.13   Mean   :185.9   Mean   : 9.958   Mean   :77.88  
##  3rd Qu.: 63.25   3rd Qu.:258.8   3rd Qu.:11.500   3rd Qu.:85.00  
##  Max.   :168.00   Max.   :334.0   Max.   :20.700   Max.   :97.00  
##  NA's   :37       NA's   :7                                       
##      Month            Day      
##  Min.   :5.000   Min.   : 1.0  
##  1st Qu.:6.000   1st Qu.: 8.0  
##  Median :7.000   Median :16.0  
##  Mean   :6.993   Mean   :15.8  
##  3rd Qu.:8.000   3rd Qu.:23.0  
##  Max.   :9.000   Max.   :31.0  
## 
```


Or the more compact and useful output from `describe()` which is in the `pysch` package:


```r
psych::describe(airquality)
##         vars   n   mean    sd median trimmed   mad  min   max range  skew
## Ozone      1 116  42.13 32.99   31.5   37.80 25.95  1.0 168.0   167  1.21
## Solar.R    2 146 185.93 90.06  205.0  190.34 98.59  7.0 334.0   327 -0.42
## Wind       3 153   9.96  3.52    9.7    9.87  3.41  1.7  20.7    19  0.34
## Temp       4 153  77.88  9.47   79.0   78.28  8.90 56.0  97.0    41 -0.37
## Month      5 153   6.99  1.42    7.0    6.99  1.48  5.0   9.0     4  0.00
## Day        6 153  15.80  8.86   16.0   15.80 11.86  1.0  31.0    30  0.00
##         kurtosis   se
## Ozone       1.11 3.06
## Solar.R    -1.00 7.45
## Wind        0.03 0.28
## Temp       -0.46 0.77
## Month      -1.32 0.11
## Day        -1.22 0.72
```


There are also some helpful plotting functions which accept a dataframe:
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">These plots might not be worth including in a final write-up, but are very useful when exploring your data.</span>


```r
boxplot(airquality)
```

<img src="datasets_files/figure-html/unnamed-chunk-6-1.png" width="672" />

```r
psych::cor.plot(airquality)
```

<img src="datasets_files/figure-html/unnamed-chunk-6-2.png" width="672" />


## Importing and exporting data


If you have data outside of R, *the simplest way to import it is to first save it as a comma or tab-separated text file*, normally with the file extension `.csv` or `.txt`^[This is easy to achieve in Excel and most other stats packages using the `Save As...` menu item].

Let's say we have file called `angry_moods.csv` in the same directory as our `.Rmd` file. We can read this data using the `read_csv()` function from the `readr` package[^readr]:


[^readr]:
  There are also standard functions built into R, such as `read.csv()` or `read.table()` for importing data. These are fine if you can't install the `readr` package for some reason, but they are quite old and the default behaviour is sometimes counterintuitive. I recommend using the `readr` equivalents: `readr::read_csv()` or `readr::read_tsv()`.



```r
angry.moods <- readr::read_csv('data/angry_moods.csv')
## Parsed with column specification:
## cols(
##   Gender = col_integer(),
##   Sports = col_integer(),
##   Anger.Out = col_integer(),
##   Anger.In = col_integer(),
##   Control.Out = col_integer(),
##   Control.In = col_integer(),
##   Anger.Expression = col_integer()
## )
head(angry.moods)
## # A tibble: 6 × 7
##   Gender Sports Anger.Out Anger.In Control.Out Control.In Anger.Expression
##    <int>  <int>     <int>    <int>       <int>      <int>            <int>
## 1      2      1        18       13          23         20               36
## 2      2      1        14       17          25         24               30
## 3      2      1        13       14          28         28               19
## 4      2      1        17       24          23         23               43
## 5      1      1        16       17          26         28               27
## 6      1      1        16       22          25         23               38
```



As you can see, when loading the `.csv` file the `read_csv()` makes some assumptions about the *type*  of data the file contains. In this case, all the columns contain integer values. It's worth checking this message to make sure that stray cells in the file you are importing don't cause problems when importing. Excel won't complain about this sort of thing, but R is more strict and won't mix text and numbers in the same column.

A common error is for stray notes or text values in a spreadsheet to cause a column which should be numeric to be converted to the `character` type.




Once it's loaded, you can use this new dataset like any other:



```r
pairs(angry.moods)
```

<img src="datasets_files/figure-html/unnamed-chunk-8-1.png" width="672" />



## Importing data over the web

One neat feature of the `readr` package is that you can import data from the web, using a URL rather than a filename on your local computer. This can be really helpful when sharing data and code with colleagues. For example, we can load the `angry_moods.csv` file from a URL:



```r
angry.moods.from.url <- readr::read_csv(
  "https://raw.githubusercontent.com/benwhalley/just-enough-r/master/angry_moods.csv")
head(angry.moods.from.url)
```




## Importing from SPSS and other packages

This is often more trouble than it's worth (just use a csv file!) but if you really must see <https://www.datacamp.com/community/tutorials/r-data-import-tutorial>.
