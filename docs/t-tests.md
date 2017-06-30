---
title: 't-tests'
output:
  bookdown::tufte_html2
---





# t-tests

Before you run any tests it's worth plotting your data. 

Assuming you have a continuous outcome and categorical (binary) predictor (here we use a subset of the built in `chickwts` data), a boxplot can work well:


```r
chicks.eating.beans <- chickwts %>% 
  filter(feed %in% c("horsebean", "soybean"))

chicks.eating.beans %>% 
  ggplot(aes(feed, weight)) +
  geom_boxplot()
```

<div class="figure">
<img src="t-tests_files/figure-html/boxplot-1.png" alt="The box in a boxplot indictes the IQR; the whisker indicates the min/max values or 1.5 * the IQR, whichever is the smaller. If there are outliers beyond 1.5 * the IQR then they are shown as points." width="672" />
<p class="caption">(\#fig:boxplot)The box in a boxplot indictes the IQR; the whisker indicates the min/max values or 1.5 * the IQR, whichever is the smaller. If there are outliers beyond 1.5 * the IQR then they are shown as points.</p>
</div>

Or a violin or bottle plot, which shows the distributions within each group:


```r
chicks.eating.beans %>% 
  ggplot(aes(feed, weight)) +
  geom_violin()
```

<img src="t-tests_files/figure-html/unnamed-chunk-2-1.png" width="672" />


Layering boxes and bottles can work well too because it combines information about the distribution with key statistics like the median and IQR, and also because it scales reasonably well to multiple categories:



```r
chickwts %>% 
  ggplot(aes(feed, weight)) +
  geom_violin() +
  geom_boxplot(width=.1) + 
  xlab("")
```

<img src="t-tests_files/figure-html/unnamed-chunk-3-1.png" width="672" />


Bottleplots are just density plots, turned 90 degrees. Density plots might be more familiar to some, but it's hard to show more than 2 or 3 categories:


```r
chicks.eating.beans %>% 
  ggplot(aes(weight, fill=feed)) +
  geom_density(alpha=.5)
```

<img src="t-tests_files/figure-html/unnamed-chunk-4-1.png" width="672" />



And density plots are just smoothed histograms (which you might prefer if you're a fan of 80's computer games):


```r
chicks.eating.beans %>% 
  ggplot(aes(weight)) +
  geom_histogram(bins=7) + 
  facet_grid(feed ~ .)
```

<img src="t-tests_files/figure-html/unnamed-chunk-5-1.png" width="672" />



## Running t-tests

Assuming you really do still want to run a null hypothesis test on one or two means, the `t.test()` function performs most common variants, illustrated below.


## 2 independent groups:


```r
# the t.test function is a bit crufty and won't accept a data= parameter
# for all types of test. Instead we use the with(...) function to make
# the variables in the chicks.eating.beans datafram available to the
# t.test function.
with(chicks.eating.beans, t.test(weight ~ feed))
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  weight by feed
## t = -4.5543, df = 21.995, p-value = 0.0001559
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -125.49476  -46.96238
## sample estimates:
## mean in group horsebean   mean in group soybean 
##                160.2000                246.4286
```


Or equivalently, if your data are untidy and each group has it's own column:


```r
untidy.chicks <- chicks.eating.beans %>% 
  mutate(chick = row_number()) %>% 
  reshape2::dcast(chick~feed, value.var = 'weight')

with(untidy.chicks, t.test(horsebean, soybean))
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  horsebean and soybean
## t = -4.5543, df = 21.995, p-value = 0.0001559
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -125.49476  -46.96238
## sample estimates:
## mean of x mean of y 
##  160.2000  246.4286
```


## Unequal variances

By default R assumes your groups have unequal variances and applies an appropriate correction. If you don't want this you can add `var.equal = TRUE` and get a vanilla t-test:


```r
with(untidy.chicks, t.test(horsebean, soybean, var.equal=TRUE))
```

```
## 
## 	Two Sample t-test
## 
## data:  horsebean and soybean
## t = -4.3037, df = 22, p-value = 0.0002873
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -127.78018  -44.67696
## sample estimates:
## mean of x mean of y 
##  160.2000  246.4286
```


## Paired samples


```r
a <- rnorm(50, 2.5, 1)
b = a + rnorm(50, .5, 1)
t.test(a, b, paired=TRUE)
```

```
## 
## 	Paired t-test
## 
## data:  a and b
## t = -3.9526, df = 49, p-value = 0.0002481
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -0.7844081 -0.2556303
## sample estimates:
## mean of the differences 
##              -0.5200192
```


Note that we could also 'melt' the data into long  format and use the `paired=TRUE` argument with a formula:


```r
long.form.data <- data_frame(a=a, b=b) %>% 
  tidyr::gather()

with(long.form.data, t.test(value~key, paired=TRUE))
```

```
## 
## 	Paired t-test
## 
## data:  value by key
## t = -3.9526, df = 49, p-value = 0.0002481
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -0.7844081 -0.2556303
## sample estimates:
## mean of the differences 
##              -0.5200192
```



## One-sample test 

i.e. comparing sample mean with a specific value:


```r
# test if mean of `outcome` variable is different from 2
somedata <- rnorm(50, 2.5, 1)
t.test(somedata, mu=2)
```

```
## 
## 	One Sample t-test
## 
## data:  somedata
## t = 4.4114, df = 49, p-value = 5.623e-05
## alternative hypothesis: true mean is not equal to 2
## 95 percent confidence interval:
##  2.313335 2.837658
## sample estimates:
## mean of x 
##  2.575496
```

