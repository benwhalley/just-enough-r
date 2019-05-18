
---
title: 'Fancy reshaping'
---



### Fancy reshaping {- #fancy-reshaping}

As noted above, it's common to combine the process of reshaping and aggregating
or summarising in the same step.

For example here we have multiple rows per person, 3 trial at time 1, and 3 more
trials at time 2:




```r
expt.data %>%
  arrange(person, time, trial) %>%
  head %>%
  pander
```


-------------------------------------------
 Condition   trial   time   person    RT   
----------- ------- ------ -------- -------
     1         1      1       1      284.5 

     1         2      1       1      309.3 

     1         3      1       1      346.7 

     1         1      2       1       368  

     1         2      2       1      263.7 

     1         3      2       1      220.4 
-------------------------------------------

We can reshape and aggregate this in a single step using `dcast`. Here we
request the mean for each person at each time, with observations for each time
split across two columns:


```r
library(reshape2)
expt.data %>%
	dcast(person~paste0('time',time),
	      fun.aggregate=mean) %>%
  head %>%
  pander
Using RT as value column: use value.var to override.
```


------------------------
 person   time1   time2 
-------- ------- -------
   1      313.5    284  

   2      252.2   263.3 

   3      263.1   290.4 

   4      271.2   249.4 

   5      274.3   329.9 

   6      280.3   231.7 
------------------------

Here `dcast` has correctly guessed that `RT` is the value we want to aggregate
(you can specify explicitly with the `value.var=` parameter).

`dcast` knows to aggregate using the mean because we set this with the
`agg.function` parameter; this just stands for 'aggregation function'.

We don't have to request the mean though: any function will do. Here we request
the SD instead:


```r
expt.data %>%
	dcast(person~time,
	      fun.aggregate=sd) %>%
  head %>%
  pander
Using RT as value column: use value.var to override.
```


------------------------
 person     1       2   
-------- ------- -------
   1      31.27   75.85 

   2      15.07   33.98 

   3      88.71    104  

   4      40.42   3.913 

   5      61.34   52.7  

   6      35.82   17.3  
------------------------
