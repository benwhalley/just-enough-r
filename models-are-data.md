
---
title: 'Models are data too'
---



# Models are data {#models-are-data-too}

<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/WPc-VEqBPHI?rel=0&amp;showinfo=0" frameborder="0" allowfullscreen></iframe>

You might remember the episode of the Simpsons where Homer designs a car for
'the average man'. It doesn't end well. Traditional statistics packages are a
bit like Homer's car. They try to work for everyone, but in the process become
bloated and difficult to use.

This is particularly true of the _output_ of software like SPSS, which by
default produces multiple pages of 'results' for even relatively simple
statistical models. However, the problem is not just that SPSS is incredibly
verbose.

The real issue is that SPSS views the results of a model as the _end_ of a
process, rather than the beginning. The model SPSS has is something like:

1. Collect data
2. Choose analysis from GUI
3. Select relevant figures from pages of output and publish.

This is a problem because in real life it just doesn't work that way. In reality
you will want to do things like:

-   Run the same model for different outcomes
-   Re-run similar models as part of a sensitivity analysis
-   Compare different models and produce summaries of results from multiple
    models

All of this requires an _iterative process_, in which you may want to compare
and visualise the results of multiple models. In a traditional GUI, this quickly
becomes overwhelming.

However, if we treat modelling as a process which _both consumes and produces
data_, R provides many helpful tools.

This is an important insight: in R, the results of analyses are not the end
point — instead _model results are themselves data_, to be processed,
visualised, and compared.

### Storing models in variables {-}

This may seem obvious (and we have seen many examples in the sections above),
but because R variables can contain anything, we can use them to store the
results of our models.

This is important, because it means we can keep track of different versions of
the models we run, and compare them.

### Extracting results from models {- #extract-results-from-models}

One of the nice things about R is that the `summary()` function will almost
always provide a concise output of whatever model you send it, showing the key
features of an model you have run.

However, this text output isn't suitable for publication, and can even be too
verbose for communicating with colleagues. Often, when communicating with
others, you want to focus in on the important details from analyses and to do
this you need to extract results from your models.

Thankfully, there is almost always a method to extract results to a
[`dataframe`](#datasets-dataframes). For example, if we run a linear model:


```r
model.fit <- lm(mpg ~ wt + disp, data=mtcars)
summary(model.fit)

Call:
lm(formula = mpg ~ wt + disp, data = mtcars)

Residuals:
    Min      1Q  Median      3Q     Max 
-3.4087 -2.3243 -0.7683  1.7721  6.3484 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept) 34.96055    2.16454  16.151 4.91e-16 ***
wt          -3.35082    1.16413  -2.878  0.00743 ** 
disp        -0.01773    0.00919  -1.929  0.06362 .  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 2.917 on 29 degrees of freedom
Multiple R-squared:  0.7809,	Adjusted R-squared:  0.7658 
F-statistic: 51.69 on 2 and 29 DF,  p-value: 2.744e-10
```

We can extract the parameter table from this model by saving the `summary()` of
it, and then using the `$` operator to access the `coefficients` table (actually
a matrix), which is stored within the summary object.


```r
model.fit.summary <- summary(model.fit)
model.fit.summary$coefficients
               Estimate  Std. Error   t value     Pr(>|t|)
(Intercept) 34.96055404 2.164539504 16.151497 4.910746e-16
wt          -3.35082533 1.164128079 -2.878399 7.430725e-03
disp        -0.01772474 0.009190429 -1.928609 6.361981e-02
```

### 'Poking around' with `$` and `@` {-}

It's a useful trick to learn how to 'poke around' inside R objects using the `$`
and `@` operators (if you want the gory details
[see this guide](http://adv-r.had.co.nz/OO-essentials.html)).

In the video below, I use RStudio's autocomplete feature to find results buried
within a `lm` object:

<iframe src="https://player.vimeo.com/video/225529842" width="862" height="892" frameborder="0"></iframe>

For example, we could write the follwing to extract a table of coefficients,
test statistics and _p_ values from an `lm()` object (this is shown in the
video:


```r
model.fit.summary <- summary(model.fit)
model.fit.summary$coefficients %>%
  as_data_frame()
Warning: `as_data_frame()` is deprecated, use `as_tibble()` (but mind the new semantics).
This warning is displayed once per session.
# A tibble: 3 x 4
  Estimate `Std. Error` `t value` `Pr(>|t|)`
     <dbl>        <dbl>     <dbl>      <dbl>
1  35.0         2.16        16.2    4.91e-16
2  -3.35        1.16        -2.88   7.43e- 3
3  -0.0177      0.00919     -1.93   6.36e- 2
```

### Save time: use a `broom` {- #broom}

The [`broom::` library](http://varianceexplained.org/r/broom-intro/) is worth
learning because it makes it really easy to turn model results into dataframes,
which is almost always what we want when working with data.

It takes a slightly different approach than simply poking around with \$ and @,
because it providing general methods to 'clean up' the output of many older R
functions.

For example, the `lm()` or `car::Anova` functions display results in the
console, but don't make it easy to extract results as a dataframe. `broom::`
provides a consistent way of extracting the key numbers from most R objects.

Let's say we have a regression model:


```r
(model.1 <- lm(mpg ~ factor(cyl) + wt + disp, data=mtcars))

Call:
lm(formula = mpg ~ factor(cyl) + wt + disp, data = mtcars)

Coefficients:
 (Intercept)  factor(cyl)6  factor(cyl)8            wt          disp  
   34.041673     -4.305559     -6.322786     -3.306751      0.001715  
```

We can extract model fit statistics --- that is, attributes of the model as a
whole --- with `glance()`. This produces a dataframe:


```r
glance(model.1)
# A tibble: 1 x 11
  r.squared adj.r.squared sigma statistic  p.value    df logLik   AIC   BIC
      <dbl>         <dbl> <dbl>     <dbl>    <dbl> <int>  <dbl> <dbl> <dbl>
1     0.838         0.813  2.60      34.8 2.73e-10     5  -73.3  159.  167.
# ... with 2 more variables: deviance <dbl>, df.residual <int>
```

If we want to extract information about the model coefficients we can use
`tidy`:


```r
tidy(model.1, conf.int = T) %>%
  pander
```


------------------------------------------------------------------------------------
     term       estimate   std.error   statistic    p.value    conf.low   conf.high 
-------------- ---------- ----------- ----------- ----------- ---------- -----------
 (Intercept)     34.04       1.963       17.34     3.662e-16    30.01       38.07   

 factor(cyl)6    -4.306      1.465      -2.939     0.006662     -7.311      -1.3    

 factor(cyl)8    -6.323      2.598      -2.433      0.02186     -11.65     -0.9913  

      wt         -3.307      1.105      -2.992     0.005855     -5.574     -1.039   

     disp       0.001715    0.01348     0.1272      0.8997     -0.02595    0.02938  
------------------------------------------------------------------------------------

Which can then be plotted easily (adding the `conf.int=T` includes 95%
confidence intervals for each parameter, which we can pass to `ggplot`):


```r
tidy(model.1, conf.int = T) %>%
  ggplot(aes(term, estimate, ymin=conf.low, ymax=conf.high)) +
  geom_pointrange() +
  geom_hline(yintercept = 0)
```

![](models-are-data_files/figure-latex/unnamed-chunk-9-1.pdf)<!-- --> 

Finally, we can use the `augment` function to get information on individual rows
in the modelled data: namely the fitted and residual values, plus common
diagnostic metrics like Cooks distances:


```r
augment(model.1) %>%
  head() %>%
  pander(split.tables=Inf)
```


---------------------------------------------------------------------------------------------------------------------------------
     .rownames       mpg    factor.cyl.    wt     disp   .fitted   .se.fit   .resid     .hat     .sigma    .cooksd    .std.resid 
------------------- ------ ------------- ------- ------ --------- --------- --------- --------- -------- ----------- ------------
     Mazda RX4        21         6        2.62    160     21.35     1.058    -0.3468   0.1653    2.652    0.0008423    -0.1458   

   Mazda RX4 Wag      21         6        2.875   160     20.5      1.009    0.4964    0.1501    2.651    0.001512      0.2069   

    Datsun 710       22.8        4        2.32    108     26.56    0.7854    -3.755    0.09103   2.538     0.04586      -1.513   

  Hornet 4 Drive     21.4        6        3.215   258     19.55     1.355     1.853    0.2711    2.618     0.05169      0.8336   

 Hornet Sportabout   18.7        8        3.44    360     16.96    0.9784     1.739    0.1413    2.627     0.0171       0.7209   

      Valiant        18.1        6        3.46    225     18.68     1.059    -0.5806   0.1654     2.65    0.002363     -0.2442   
---------------------------------------------------------------------------------------------------------------------------------

Again these can be plotted:


```r
augment(model.1) %>%
  ggplot(aes(x=.fitted, y=.resid)) +
  geom_point() +
  geom_smooth()
`geom_smooth()` using method = 'loess' and formula 'y ~ x'
```

![](models-are-data_files/figure-latex/unnamed-chunk-11-1.pdf)<!-- --> 

Because `broom` always returns a dataframe with a consistent set of column names
we can also combine model results into tables for comparison. In this plot we
see what happens to the regression coefficients in model 1 when we add `disp`,
`carb` and `drat` in model 2. We plot the coefficients side by side for ease of
comparison, and can see that the estimates for cyl1 and wt both shrink slightly
with the addition of these variables:


```r
# run a new model with more predictors
(model.2 <- lm(mpg ~ factor(cyl) + wt + disp + carb + drat, data=mtcars))

Call:
lm(formula = mpg ~ factor(cyl) + wt + disp + carb + drat, data = mtcars)

Coefficients:
 (Intercept)  factor(cyl)6  factor(cyl)8            wt          disp  
   29.849209     -2.796142     -4.116561     -2.748229     -0.002826  
        carb          drat  
   -0.587422      1.056532  

# make a single dataframe from both models
# addin a new `model` column with mutate to
# identify which coefficient came from which model
combined.results <- bind_rows(
  tidy(model.1, conf.int = T) %>% mutate(model="1"),
  tidy(model.2, conf.int = T) %>%  mutate(model="2"))
```


```r
combined.results %>%
  # remove the intercept to make plot scale more sane
  filter(term != "(Intercept)") %>%
  ggplot(aes(term, estimate, ymin=conf.low, ymax=conf.high, color=model)) +
    geom_pointrange(position=position_dodge(width=.1)) +
  geom_hline(yintercept = 0)
```

![](models-are-data_files/figure-latex/unnamed-chunk-13-1.pdf)<!-- --> 

## 'Processing' results {- #process-model-results}

XXX TODO e.g.:

-   Calculate VPC/ICC from an lmer models using
    `model %>% summary %>% as_data_frame()$varcor`

## Printing tables {- #output-tables}

XXX TODO

-   Pander and pandoc
-   Dealing with rounding and string formatting issues
-   Missing values/unequal length columns
-   Point out that arbitrarily complex tables often not worth the candle, longer
    easier than wider etc.

## APA formatting for free {- #apa-output}

A neat trick to avoid
[fat finger errors](https://en.wikipedia.org/wiki/Fat-finger_error) is to use
functions to automatically display results in APA format. Unfortunately, there
isn't a single package which works with all types of model, but it's not too
hard switch between them.

### Chi^2^ {-}

For basic stats the `apa::` package is simple to use. Below we use the
`apa::chisq_apa()` function to properly format the results of our chi^2^ test
([see the full chi^2^ example]#crosstabs)):




```r
lego.test <- chisq.test(lego.table)
lego.test

	Pearson's Chi-squared test with Yates' continuity correction

data:  lego.table
X-squared = 11.864, df = 1, p-value = 0.0005724
```

And we can format in APA like so:


```r
apa::apa(lego.test, print_n=T)
[1] "$\\chi^2$(1, n = 100) = 11.86, *p* < .001"
```

or using `apastats::` we also get Cramer's V, a measure of effect size:


```r
apastats::describe.chi(lego.table, addN=T)
[1] "$\\chi^2$(1, _N_ = 100) = 11.86, _p_ < .001, _V_ = .34"
```

#### Inserting results into your text {#inline-apa-format}

If you are using RMarkdown, you can drop formatted results into your text
without copying and pasting. Just type the following and the chi^2^ test result
is automatically inserted inline in your text:

![Example of inline call to R functions within the text. This is shown as an image, because it would otherwise be hidden in this output (because the function is evaluated when we knit the document)](media/inline-r-example.png)

[Age (4 vs 6 years) was significantly associated with preference for duplo v.s.
lego, $\chi^2$(1, _N_ = 100) = 11.86, _p_ < .001, _V_ = .34]{.apa-example}

### T-test {-}


```r
# run the t test
cars.test <- t.test(wt~am,data=mtcars, var.equal=T)
cars.test

	Two Sample t-test

data:  wt by am
t = 5.2576, df = 30, p-value = 1.125e-05
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 0.8304317 1.8853577
sample estimates:
mean in group 0 mean in group 1 
       3.768895        2.411000 
```

And then we can format as APA


```r
apa::apa(cars.test)
[1] "*t*(30) = 5.26, *p* < .001, *d* = 1.86"
```

[American cars were significantly heavier than foreign cars, mean
difference=1358lbs;
*t*(30) = 5.26, *p* < .001, *d* = 1.86]{.apa-example}

### Anova {-}


```r
mpg.anova <- car::Anova(lm(mpg~am*cyl, data=mtcars))
Registered S3 methods overwritten by 'car':
  method                          from
  influence.merMod                lme4
  cooks.distance.influence.merMod lme4
  dfbeta.influence.merMod         lme4
  dfbetas.influence.merMod        lme4

# extract and format main effect
apastats::describe.Anova(mpg.anova, term="am")
[1] "_F_(1, 28) = 4.28, _p_ = .048"

# and the interaction
apastats::describe.Anova(mpg.anova, term="am:cyl")
[1] "_F_(1, 28) = 3.41, _p_ = .076"
```

[There was no interaction between location of manufacture and number of
cylinders, _F_(1, 28) = 3.41, _p_ = .076, but there was
a main effect of location of manufacture,
_F_(1, 28) = 3.41, _p_ = .076, such that US-made cars
had significantly higher fuel consumption than European or Japanese brands (see
[Figure X or Table X])]{.apa-example}

<!--
TODO add formatting of effect size estimates here

 -->

### Multilevel models {-}

If you have loaded the `lmerTest` package `apastats` can output either
coefficients for single parameters, or F tests:


```r
sleep.model <- lmer(Reaction~factor(Days)+(1|Subject), data=lme4::sleepstudy)

#a single coefficient (this is a contrast from the reference category)
apastats::describe.glm(sleep.model, term="factor(Days)1")
Loading required namespace: Hmisc
[1] "_t_ =  0.75, _p_ = .455"

# or describe the F test for the overall effect of Days
apastats::describe.lmtaov(anova(sleep.model), term='factor(Days)')
[1] "_F_(9, 153.0) = 18.70, _p_ < .001"
```



[There were significant differences in reaction times across the 10 days of the
study, _F_(9, 153.0) = 18.70, _p_ < .001 such that reaction latencies tended to increase in duration
(see [Figure X]).]{.apa-example}
