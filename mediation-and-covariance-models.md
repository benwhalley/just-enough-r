
---
title: 'Analysing mediation'
---


```r
library(tidyverse)
Registered S3 methods overwritten by 'ggplot2':
  method         from 
  [.quosures     rlang
  c.quosures     rlang
  print.quosures rlang
Registered S3 method overwritten by 'rvest':
  method            from
  read_xml.response xml2
-- Attaching packages ---------------------------------- tidyverse 1.2.1 --
v ggplot2 3.1.1     v purrr   0.3.2
v tibble  2.1.1     v dplyr   0.8.1
v tidyr   0.8.3     v stringr 1.4.0
v readr   1.3.1     v forcats 0.4.0
-- Conflicts ------------------------------------- tidyverse_conflicts() --
x dplyr::filter() masks stats::filter()
x dplyr::lag()    masks stats::lag()
library(broom)
library(pander)
source('diagram.R')
```

# Mediation and covariance modelling

## Mediation {- #mediation}

Mediation is a complex topic, and the key message to take on — before starting
to analyse your data — is that mediation analayses make many strong assumptions
abou the data. These assumptions can often be pretty unreasonable, when spelled
out, so be cautious in the interpretation of you data.

Put differently, mediation is a correlational technique aiming to provide a
causal interpretation of data; caveat emptor.

### Mediation with multiple regression {-}

One common (if outdated) way to analyse mediation is via the 3 steps described
by Baron and Kenny -@baron1986moderator (also see @zhao_reconsidering_2010).

Let's say we have a hypothesised situation such as this:


```r
knit_gv("
Lateness -> Crashes
Lateness -> Speeding
Speeding -> Crashes
")
```

![](assets/5422591.pdf)<!-- --> 

Baron and Kenny propose 3 steps to establishing mediation. These steps
correspond to three separate regression models:

### Mediation Steps {-}

#### Step 1 (check distal variable predicts mediator) {-}

That is, show Lateness predicts Crashes

#### Step 2 (check distal variable predict mediator) {-}

That is, show Lateness predicts Speeding

#### Step 3 (check for mediation) {-}

That is, show Speeding predicts Crashes, controlling for Lateness

An additional step, which allows us to test whether the effect is _completely_
mediated, also uses the final regression model:

#### Step 4 (check for total mediation) {-}

That is, check if Lateness still predicts crashes, controlling for Lateness   


### Mediation example after Baron and Kenny {-}

Using simulated data, we can work through the steps.




```r
smash %>% glimpse
Observations: 200
Variables: 4
$ person   <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16...
$ lateness <int> 11, 12, 9, 8, 11, 4, 11, 7, 8, 11, 9, 10, 9, 11, 13, ...
$ speed    <dbl> 48.88524, 43.07030, 33.72812, 44.17897, 51.22378, 40....
$ crashes  <int> 15, 9, 12, 20, 25, 13, 22, 14, 22, 18, 11, 16, 19, 15...
```

Step 1: does lateness predict crashes?


```r
step1 <- lm(crashes ~ lateness, data=smash)
tidy(step1) %>% pander()
```


------------------------------------------------------------
    term       estimate   std.error   statistic    p.value  
------------- ---------- ----------- ----------- -----------
 (Intercept)    12.15       1.204       10.09     1.365e-19 

  lateness      0.4448     0.1125       3.953     0.0001074 
------------------------------------------------------------

Step 2: Does lateness predict speed?


```r
step2 <- lm(speed ~ lateness, data=smash)
tidy(step2, conf.int = T) %>% pander()
```


-----------------------------------------------------------------------------------
    term       estimate   std.error   statistic    p.value    conf.low   conf.high 
------------- ---------- ----------- ----------- ----------- ---------- -----------
 (Intercept)    33.42       2.275       14.69     1.563e-33    28.93       37.9    

  lateness      0.515      0.2126       2.422      0.01633    0.09573     0.9343   
-----------------------------------------------------------------------------------

The coefficient for `lateness` is statistically significant, so we would say
yes.

Step 3: Does speed predict crashes, controlling for lateness?


```r
step3 <- lm(crashes ~ lateness+speed, data=smash)
tidy(step3) %>% pander()
```


------------------------------------------------------------
    term       estimate   std.error   statistic    p.value  
------------- ---------- ----------- ----------- -----------
 (Intercept)    2.542       1.465       1.735      0.08427  

  lateness      0.2967     0.09611      3.088     0.002309  

    speed       0.2875     0.03166      9.083     1.122e-16 
------------------------------------------------------------

The coefficient for speed is statistically significant, so we can say mediation
does occur.

Step 4: In the same model, does lateness predict crashes, controlling for speed?
That is to say, is the mediation via speed _total_?

Here, the coefficient is still statistically significant. According to the Baron
and Kenny steps, this would indicate the mediation is _partial_, although the
fact the p value falls one side or another of .05 is not necessarily the best
way to express this (see below for ways to calculate the proportion of the
effect which is mediated).

We should alse be concerned here with the degree to which predictor and mediator
are measured with error — if they are noisy measures, then the proportion of the
effect which appears to be mediated will be reduced artificially (see the SEM
chapter for more on this).

## Testing the indirect effect {-}

Baron and Kenny also introduced conventions for labelling some of the
coefficients from the regressions described above.

Specifically, the described `a` as the path from the predictor to the mediator,
`b` as the path from the mediator to the outcome, and `c'` (`c` prime) as the
path from predictor to outcome, controlling for the mediator. As shown here:


```r
knit_gv("
Lateness -> Crashes[label='c`']
Lateness -> Speeding[label=a]
Speeding -> Crashes[label=b]
")
```

![](assets/5703525.pdf)<!-- --> 

Subsequent authors wished to provide a test for whether the path through `a` and
`b` --- the indirect effect --- was statistically significant.
@preacher_spss_2004 published SPSS macros for computing this indirect effect and
providing a non-parametric (bootstrapped) test of this term. The same approach
is now implemented in a number of R packages.

The `mediation::mediate` function accepts the 2nd and 3rd regression models from
the 'Baron and Kenny' steps, along with arguments which identify which variables
are the predictor and the mediator. From this, the function calculates the
indirect effect, and the proportion of the total effect mediated. This is
accompanied by a bootstrapped standard-error, and asociated p value.

For example, using the models we ran above, we can say:


```r
set.seed(1234)
crashes.mediation <- mediation::mediate(step2, step3, treat = "lateness", mediator = "speed")
summary(crashes.mediation)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

               Estimate 95% CI Lower 95% CI Upper p-value    
ACME             0.1477       0.0237         0.28   0.018 *  
ADE              0.2998       0.1166         0.50  <2e-16 ***
Total Effect     0.4475       0.2293         0.66  <2e-16 ***
Prop. Mediated   0.3295       0.0741         0.60   0.018 *  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Sample Size Used: 200 


Simulations: 1000 
```

From this output, we can see that the indirect effect is statistically
significant, and that around hald of the total effect is mediated via speed.
Because lateness in iteself is not a plausable cause of a crash, this suggest
that other factors (perhaps distraction, inattention) might be important in
mediating this residual direct effect.

## Mediation using Path models

An even more flexible approach to mediation can be taken using path models, a
type of [structural equation model](#covariance-modelling) which are covered in
more detail in the next section.

Using the `lavaan` package, path/SEM models can specify multiple variables to be
outcomes, and fit these models simultaneously. For example, we can fit both step
2 and step 3 in a single model, as in the example below:


```r
library(lavaan)
This is lavaan 0.6-3
lavaan is BETA software! Please report any bugs.

smash.model <- '
  crashes ~ speed + lateness
  speed ~ lateness
'

smash.model.fit <- sem(smash.model, data=smash)
summary(smash.model.fit)
lavaan 0.6-3 ended normally after 19 iterations

  Optimization method                           NLMINB
  Number of free parameters                          5

  Number of observations                           200

  Estimator                                         ML
  Model Fit Test Statistic                       0.000
  Degrees of freedom                                 0
  Minimum Function Value               0.0000000000000

Parameter Estimates:

  Information                                 Expected
  Information saturated (h1) model          Structured
  Standard Errors                             Standard

Regressions:
                   Estimate  Std.Err  z-value  P(>|z|)
  crashes ~                                           
    speed             0.288    0.031    9.152    0.000
    lateness          0.297    0.095    3.111    0.002
  speed ~                                             
    lateness          0.515    0.212    2.434    0.015

Variances:
                   Estimate  Std.Err  z-value  P(>|z|)
   .crashes          18.190    1.819   10.000    0.000
   .speed            92.135    9.214   10.000    0.000
```

The summary output gives us coefficients which correspond to the regression
coefficients in the step 2 and step 3 models --- but this time, from a single
model.

We can also use `lavaan` to compute the indirect effects by labelling the
relevant parameters, using the `*` and `:=` operators. See the
[`lavaan` syntax guide for mediation](http://lavaan.ugent.be/tutorial/mediation.html)
for more detail.

Note that the `*` operator does not have the same meaning as in formulas for
linear models in R --- in `lavaan`, it means 'apply a constraint'.


```r
smash.model <- '
  crashes ~ B*speed + C*lateness
  speed ~ A*lateness

  # computed parameters, see http://lavaan.ugent.be/tutorial/mediation.html
  indirect := A*B
  total := C + (A*B)
  proportion := indirect/total
'

smash.model.fit <- sem(smash.model, data=smash)
summary(smash.model.fit)
lavaan 0.6-3 ended normally after 19 iterations

  Optimization method                           NLMINB
  Number of free parameters                          5

  Number of observations                           200

  Estimator                                         ML
  Model Fit Test Statistic                       0.000
  Degrees of freedom                                 0
  Minimum Function Value               0.0000000000000

Parameter Estimates:

  Information                                 Expected
  Information saturated (h1) model          Structured
  Standard Errors                             Standard

Regressions:
                   Estimate  Std.Err  z-value  P(>|z|)
  crashes ~                                           
    speed      (B)    0.288    0.031    9.152    0.000
    lateness   (C)    0.297    0.095    3.111    0.002
  speed ~                                             
    lateness   (A)    0.515    0.212    2.434    0.015

Variances:
                   Estimate  Std.Err  z-value  P(>|z|)
   .crashes          18.190    1.819   10.000    0.000
   .speed            92.135    9.214   10.000    0.000

Defined Parameters:
                   Estimate  Std.Err  z-value  P(>|z|)
    indirect          0.148    0.063    2.353    0.019
    total             0.445    0.112    3.973    0.000
    proportion        0.333    0.121    2.756    0.006
```

We can again get a bootstrap interval for the indirect effect, and print a table
of just these computed effects like so:


```r
set.seed(1234)
smash.model.fit <- sem(smash.model, data=smash, test="bootstrap", bootstrap=100)

parameterEstimates(smash.model.fit) %>%
  filter(op == ":=") %>%
  select(label, est, contains("ci")) %>%
  pander::pander()
```


-------------------------------------------
   label       est     ci.lower   ci.upper 
------------ -------- ---------- ----------
  indirect    0.1481   0.02472     0.2715  

   total      0.4448    0.2254     0.6643  

 proportion   0.3329   0.09614     0.5697  
-------------------------------------------

Comparing these results with the `mediation::mediate()` output, we get similar
results. In both cases, it's possible to increase the number of bootstrap
resamples if needed to increase the precision of the interval (the default is
1000, but 5000 might be a good target for publication).
