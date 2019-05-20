
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
     1         1      1       1      219.8 

     1         2      1       1      194.4 

     1         3      1       1      394.1 

     1         1      2       1       272  

     1         2      2       1      180.1 

     1         3      2       1       277  
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
   1      269.4    243  

   2      259.2   219.8 

   3      211.3   323.1 

   4      255.5   249.2 

   5      264.1    307  

   6      274.5    291  
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
   1      108.7   54.56 

   2      53.07   79.45 

   3      38.84   28.52 

   4      43.3    52.74 

   5      45.72   45.02 

   6      38.74   94.47 
------------------------
