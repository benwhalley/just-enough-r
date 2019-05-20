
---
title: 'Covariance modelling'
---



## Covariance modelling {- #covariance-modelling}

<!--
Differences CFA EFA
https://jonathantemplin.com/files/multivariate/mv11icpsr/mv11icpsr_lecture12.pdf

Writing up CFA: http://www.understandingdata.net/2017/03/22/cfa-in-lavaan/#writeup


Nice reference guide: https://www.scribd.com/document/238478414/Beaujean-Latent-Variable-Modeling-Using-r

-->

> The CFA examples here were adapted from a guide originally produced by Jon May

This section covers path analysis (path models), confirmatory factor analysis
(CFA) and structural equation modelling (SEM). You are encouraged to work
through the path models and CFA sections, and especially the material on
assessing model fit, before tacking SEM.

Before you start this either section make sure you have the `lavaan` package
installed (see [installing packages](#packages)).


```r
install.packages(lavaan)
```

And load the package to
[make all the functions available with minimal typing](#package-namespacing):


```r
library(lavaan)
```

## Path models {- #path-models}

Path models are an extension of linear regression, but where multiple observed
variables can be considered as 'outcomes'.

Because the terminology of outcomes v.s. predictors breaks down when variables
can be both outcomes and predictors at the same time, it's normal to distinguish
instead between:

-   _Exogenous_ variables: those which are not predicted by any other

-   _Endogenous_ variables: variables which do have predictors, and may or may
    not predict other variales

### Defining a model {-}



To define a path model, `lavaan` requires that you specify the relationships
between variables in a text format. A full
[guide to this lavaan model syntax](http://lavaan.ugent.be/tutorial/syntax1.html)
is available on the project website.

For path models the format is very simple, and resembles a series of linear
models, written over several lines, but in text rather than as a
[model formula](#formulae):


```r
# define the model over multiple lines for clarity
mediation.model <- "
  y ~ x + m
  m ~ x
"
```

In this case the `~` symbols just means 'regressed on' or 'is predicted by'. The
model in the example above defines that our outcome `y` is predicted by both `x`
and `m`, and that `x` also predicts `m`. You might recognise this as a
[mediation model](#mediation).

[Make sure you include the closing quote symbol, and also be careful when
running the code which defines the model. RStdudio can sometimes get confused
and only run some of the lines, leading to errors. The simplest solution is to
select the entire block explicitly and run that.]{.tip}

To fit the model we pass the model specification and the data to the `sem()`
function:


```r
mediation.fit <- sem(mediation.model, data=mediation.df)
```

As we did for [linear regression models](#linear-models-simple), we have saved
the model fit object into a variable, here named `mediation.fit`.

To display the model results we can use `summary()`. The key section of the
output to check is the table listed 'Regressions', which lists the regression
parameters for the predictors for each of the endogenous variables.


```r
summary(mediation.fit)
lavaan 0.6-3 ended normally after 12 iterations

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
  y ~                                                 
    x                 0.166    0.075    2.198    0.028
    m                 0.190    0.070    2.721    0.007
  m ~                                                 
    x                 0.530    0.067    7.958    0.000

Variances:
                   Estimate  Std.Err  z-value  P(>|z|)
   .y                 0.967    0.097   10.000    0.000
   .m                 0.993    0.099   10.000    0.000
```

From this table we can see that both `x` and `m` are significant predictors of
`y`, and that `x` also predicts `m`. This implie that mediation is taking place,
but [see the mediation chapter](#mediation) for details of testing indirect
effects in `lavaan`.

#### Where's the intercept? {-}

Path analysis is part of the set of techniques often termed 'covariance
modelling'. As the name implies the primary focus here is the relationships
between variables, and less so the mean-structure of the variables. In fact, by
default the software first creates the covariance matrix of all the variables in
the model, and the fit is based only on these values, plus the sample sizes (in
early SEM software you typically had to provide the covariance matrix directly,
rather than working with the raw data).

Nonetheless, because path analysis is an extension of regression techniques it
is possible to request that intercepts are included in the model, and means
estimated, by adding `meanstructure=TRUE` to the `sem()` function
([see the `lavaan` manual for details](http://lavaan.ugent.be/tutorial/means.html)).

In the output below we now also see a table labelled 'Intercepts' which gives
the mean values of each variable _when it's predictors are zero_ (just like in
linear regression):


```r
mediation.fit.means <- sem(mediation.model,
                           meanstructure=T,
                           data=mediation.df)

summary(mediation.fit.means)
lavaan 0.6-3 ended normally after 16 iterations

  Optimization method                           NLMINB
  Number of free parameters                          7

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
  y ~                                                 
    x                 0.166    0.075    2.198    0.028
    m                 0.190    0.070    2.721    0.007
  m ~                                                 
    x                 0.530    0.067    7.958    0.000

Intercepts:
                   Estimate  Std.Err  z-value  P(>|z|)
   .y                10.629    0.362   29.323    0.000
   .m                 5.097    0.070   72.298    0.000

Variances:
                   Estimate  Std.Err  z-value  P(>|z|)
   .y                 0.967    0.097   10.000    0.000
   .m                 0.993    0.099   10.000    0.000
```

#### Tables of model coefficients {-}

If you want to present results from these models in table format, the
`parameterEstimates()` function is useful to extract the relevant numbers as a
dataframe. We can then manipulate and present this table as we would any other
dataframe.

In the example below we extract the parameter estimates, select only the
regression parameters (`~`) and remove some of the columns to make the final
output easier to read:


```r
parameterEstimates(mediation.fit.means) %>%
  as_tibble() %>%
  filter(op=="~") %>%
  mutate(Term=paste(lhs, op, rhs)) %>%
  rename(estimate=est,
         p=pvalue) %>%
  select(Term, estimate, z, p) %>%
  pander::pander(caption="Regression parameters from `mediation.fit`")
```


--------------------------------------
 Term    estimate     z         p     
------- ---------- ------- -----------
 y ~ x    0.1657    2.198    0.02797  

 y ~ m    0.1899    2.721   0.006515  

 m ~ x    0.5298    7.958   1.776e-15 
--------------------------------------

Table: Regression parameters from `mediation.fit`

#### Diagrams {-}

Because describing path, CFA and SEM models in words can be tedious and
difficult for readers to follow it is conventional to include a diagram of (at
least) your final model, and perhaps also initial or alternative models.

The `semPlot::` package makes this relatively easy: passing a fitted `lavaan`
model to the `semPaths()` function produces a line drawing, and gives the option
to overlap raw or standardised coefficients over this drawing:


```r
# unfortunately semPaths plots very small by default, so we set
# some extra parameters to increase the size to make it readable
semPlot::semPaths(mediation.fit, "par",
             sizeMan = 15, sizeInt = 15, sizeLat = 15,
             edge.label.cex=1.5,
             fade=FALSE)
```

![](cfa-sem_files/figure-latex/unnamed-chunk-11-1.pdf)<!-- --> 

## Confirmatory factor analysis (CFA) {- #cfa}

In psychology we make observations, but we're often interested in _hypothetical
constructs_, e.g. Anxiety, working memory. We can't measure these directly, but
we assume that our observations are related to these constructs in some way.

Regression and related techniques (e.g. Anova) require us to assume that our
outcome variables are good indices of these underlying constructs, and that our
predictor variables are measured without any error.

When outcomes are straightforward observed variables like plant yield or weight
reduction, and where predictors are experimentally manipulated, then these
assumptions are reasonable. However in many applied fields these are not
reasonable assumptions to make: For example, to assume that depression or
working memory are indexed in a straightforward way by responses to a depression
questionnaire or performance on a laboratory task is naive. Likewise, we should
not assume that a construct like working memory is measured without error when
we use it to predict some other outcome (e.g. exam success).

Confirmatory factor analysis (CFA), structural equation models (SEM) and related
techniques are designed to help researchers deal with these _imperfections in
our observations_, and can help to explore the correspondence between our
measures and the underlying constructs of interest.

### Latent variables {- #latent-variables}

CFA and SEM introduce the concept of a _latent variable_ which is either the
cause of, or formed by, the observations we make. Latent variables aren't quite
the same thing as hypothetical constructs, but they are similar many in some
ways. The original distinction between hypothetical constructs and intervening
variables is quite interesting in this context, see Maccorquodale and Meehl
(1948).

To achieve this, CFA requires that researchers to make predictions about the
patterns of correlations they will observe in their observations, based on the
process they think is generating the data. CFA provides a mechanism to test and
compare different hypotheses about these patterns, which correspond to different
models of the underlying process which generates the data.

It is conventional within CFA and SEM to extend the graphical models used to
describe path models (see above). In these diagrams, square edged boxes
represent observed variables, and rounded or oval boxes represent latent
variables, sometimes called factors:


```r
knit_gv('
Factor -> a
Factor -> b
Factor -> c
Factor -> d
a[shape=rectangle]
b[shape=rectangle]
c[shape=rectangle]
d[shape=rectangle]
')
```

![(\#fig:unnamed-chunk-12)Example of a CFA model, including one latent variable or factor, and 4 observed variables.](assets/9345411.pdf) 

CFA models can also include multiple latent variables, and estimate the
covariance between them:


```r
knit_gv('
        Affective -> a
Affective -> b
Affective -> c
Cognitive -> d
Cognitive -> e
Cognitive -> f
Affective -> Cognitive:nw [dir=both]

a [shape=box]
b [shape=box]
c [shape=box]
d [shape=box]
e [shape=box]
f [shape=box]

')
```

![](assets/4653102.pdf)<!-- --> 

SEM models extend this by allowing regression paths between latent variables and
observed or other latent variables:


```r
knit_gv('
        Affective -> a
Affective -> b
Affective -> c
Cognitive -> d
Cognitive -> e
Cognitive -> f
Affective -> Cognitive:nw [dir=both]

a [shape=box]
b [shape=box]
c [shape=box]
d [shape=box]
e [shape=box]
f [shape=box]


Stress -> g
Stress -> h
Stress -> i
g [shape=box]
h [shape=box]
i [shape=box]

Affective -> Stress

        ')
```

![](assets/4462595.pdf)<!-- --> 

For now though, we will focus on building a CFA model. Later we'll show how a
_well fitting_ measurement model can be used to test hypotheses related to the
structural relations between latent variables.

### Defining a CFA model {-}

First, open some data and check that all looks well. This is a classic CFA
example — see the help file for more info.


```r
hz <- lavaan::HolzingerSwineford1939
hz %>% glimpse()
Observations: 301
Variables: 15
$ id     <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 13, 14, 15, 16, 17, ...
$ sex    <int> 1, 2, 2, 1, 2, 2, 1, 2, 2, 2, 1, 1, 2, 2, 1, 2, 2, 1, 2...
$ ageyr  <int> 13, 13, 13, 13, 12, 14, 12, 12, 13, 12, 12, 12, 12, 12,...
$ agemo  <int> 1, 7, 1, 2, 2, 1, 1, 2, 0, 5, 2, 11, 7, 8, 6, 1, 11, 5,...
$ school <fct> Pasteur, Pasteur, Pasteur, Pasteur, Pasteur, Pasteur, P...
$ grade  <int> 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7...
$ x1     <dbl> 3.333333, 5.333333, 4.500000, 5.333333, 4.833333, 5.333...
$ x2     <dbl> 7.75, 5.25, 5.25, 7.75, 4.75, 5.00, 6.00, 6.25, 5.75, 5...
$ x3     <dbl> 0.375, 2.125, 1.875, 3.000, 0.875, 2.250, 1.000, 1.875,...
$ x4     <dbl> 2.333333, 1.666667, 1.000000, 2.666667, 2.666667, 1.000...
$ x5     <dbl> 5.75, 3.00, 1.75, 4.50, 4.00, 3.00, 6.00, 4.25, 5.75, 5...
$ x6     <dbl> 1.2857143, 1.2857143, 0.4285714, 2.4285714, 2.5714286, ...
$ x7     <dbl> 3.391304, 3.782609, 3.260870, 3.000000, 3.695652, 4.347...
$ x8     <dbl> 5.75, 6.25, 3.90, 5.30, 6.30, 6.65, 6.20, 5.15, 4.65, 4...
$ x9     <dbl> 6.361111, 7.916667, 4.416667, 4.861111, 5.916667, 7.500...
```

As noted above, to define models in `lavaan` you must specify the relationships
between variables in a text format. A full
[guide to this lavaan model syntax is available on the project website](http://lavaan.ugent.be/tutorial/syntax1.html).

For CFA models, like path models, the format is fairly simple, and resembles a
series of linear models, written over several lines.

In the model below there are three latent variables, `visual`, `writing` and
`maths`. The latent variable names are followed by =~ which means 'is manifested
by', and then the observed variables, our measures for the latent variable, are
listed, separated by the `+` symbol.


```r
hz.model <- '
visual =~ x1 + x2 + x3
writing =~ x4 + x5 + x6
maths =~ x7 + x8 + x9'
```

Note that we have saved our model specification/syntax in a variable named
`hz.model`.

The other special symbols in the `lavaan` syntax which can be used for CFA
models are:

-   `a ~~ b`, which represents a _covariance_.

-   `a ~~ a`, which is a _variance_ (you can think of this as the covariance of
    a variable with itself)

To run the analysis we again pass the model specification and the data to the
`cfa()` function:


```r
hz.fit <- cfa(hz.model, data=hz)
summary(hz.fit, standardized=TRUE)
lavaan 0.6-3 ended normally after 35 iterations

  Optimization method                           NLMINB
  Number of free parameters                         21

  Number of observations                           301

  Estimator                                         ML
  Model Fit Test Statistic                      85.306
  Degrees of freedom                                24
  P-value (Chi-square)                           0.000

Parameter Estimates:

  Information                                 Expected
  Information saturated (h1) model          Structured
  Standard Errors                             Standard

Latent Variables:
                   Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
  visual =~                                                             
    x1                1.000                               0.900    0.772
    x2                0.554    0.100    5.554    0.000    0.498    0.424
    x3                0.729    0.109    6.685    0.000    0.656    0.581
  writing =~                                                            
    x4                1.000                               0.990    0.852
    x5                1.113    0.065   17.014    0.000    1.102    0.855
    x6                0.926    0.055   16.703    0.000    0.917    0.838
  maths =~                                                              
    x7                1.000                               0.619    0.570
    x8                1.180    0.165    7.152    0.000    0.731    0.723
    x9                1.082    0.151    7.155    0.000    0.670    0.665

Covariances:
                   Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
  visual ~~                                                             
    writing           0.408    0.074    5.552    0.000    0.459    0.459
    maths             0.262    0.056    4.660    0.000    0.471    0.471
  writing ~~                                                            
    maths             0.173    0.049    3.518    0.000    0.283    0.283

Variances:
                   Estimate  Std.Err  z-value  P(>|z|)   Std.lv  Std.all
   .x1                0.549    0.114    4.833    0.000    0.549    0.404
   .x2                1.134    0.102   11.146    0.000    1.134    0.821
   .x3                0.844    0.091    9.317    0.000    0.844    0.662
   .x4                0.371    0.048    7.779    0.000    0.371    0.275
   .x5                0.446    0.058    7.642    0.000    0.446    0.269
   .x6                0.356    0.043    8.277    0.000    0.356    0.298
   .x7                0.799    0.081    9.823    0.000    0.799    0.676
   .x8                0.488    0.074    6.573    0.000    0.488    0.477
   .x9                0.566    0.071    8.003    0.000    0.566    0.558
    visual            0.809    0.145    5.564    0.000    1.000    1.000
    writing           0.979    0.112    8.737    0.000    1.000    1.000
    maths             0.384    0.086    4.451    0.000    1.000    1.000
```

#### `lavaan` CFA Model output {-}

The output has three parts:

1. Parameter estimates. The values in the first column are the standardised
   weights from the observed variables to the latent factors.

2. Factor covariances. The values in the first column are the covariances
   between the latent factors.

3. Error variances. The values in the first column are the estimates of each
   observed variable’s error variance.

#### Plotting models {-}

As before, we can use the `semPaths()` function to visualise the model. This is
an important step because it helps explain the model to others, and also gives
you an opportunity to check you have specified your model correctly.


```r
semPlot::semPaths(hz.fit)
```

![](cfa-sem_files/figure-latex/unnamed-chunk-18-1.pdf)<!-- --> 

And for 'final' models we might want to overplot model parameter estimates (in
this case, standardised):


```r
# std refers to standardised estimates. "par" would plot
# the unstandardised estimates
semPlot::semPaths(hz.fit, "std")
```

![](cfa-sem_files/figure-latex/unnamed-chunk-19-1.pdf)<!-- --> 

## CFA model fit {- #model-fit}

To examine the model fit we use `fitmeasures()` and pass a list of the names of
the fit indices we would like calculated:


```r
library(lavaan)
fitmeasures(hz.fit, c('cfi', 'rmsea', 'rmsea.ci.upper', 'bic'))
           cfi          rmsea rmsea.ci.upper            bic 
         0.931          0.092          0.114       7595.339 
```

This looks OK, but the fit indices indicate the model could be improved. In
particular the RMSEA figure is above 0.05. See the
[notes on goodness of fit statistics](#gof) for more detail.

## Modification indices {-}

Modification indices help us answer 'what if?' questions about whether freeing
parameter constraints or adding paths to our models would help improve it. The
modification index is the $\chi^2$ value, with 1 degree of freedom, by which
model fit would improve if a particular path was added or constraint freed.
Values bigger than 3.84 indicate that the model would be
'improved', and the p value for the added parameter would be < .05, and values
larger 10.83 than indicte the parameter would have a p
vaue < .001. _This does not mean that all parameters which appear in the MI
table should be added_, but it can be an aid to improving the model, in
combination with domain or theoretical knowledge. The rule of thumb is to add
parameters only when they 'make sense' substantively. See the notes on
[model improvements](#model-improvement) for more guidance.

To examine the modification indices we type:


```r
modificationindices(hz.fit)
```

But because this function produces a very long table of output, it can be
helpful to sort and filter the rows to show only those model modifications which
might be of interest to us.

The command below converts the output of `modificationindices()` to a dataframe.
It then:

-   Sorts the rows by the `mi` column, which represents the change in model
    $\chi^2$ we see if the path was included (see [sorting](#sorting))
-   Filters the results to show only those with $\chi^2$ change > 10
-   Selects only the `lhs`, `op`, `rhs`, `mi`, and `epc` columns.


```r
modificationindices(hz.fit) %>%
  as_data_frame() %>%
  arrange(-mi) %>%
  filter(mi > 11) %>%
  select(lhs, op, rhs, mi, epc) %>%
  pander(caption="Largest MI values for hz.fit")
```


-------------------------------------
  lhs     op   rhs    mi       epc   
-------- ---- ----- ------- ---------
 visual   =~   x9    36.41    0.577  

   x7     ~~   x8    34.15   0.5364  

 visual   =~   x7    18.63   -0.4219 

   x8     ~~   x9    14.95   -0.4231 
-------------------------------------

Table: Largest MI values for hz.fit

The `lhs` (left hand side, or outcome), `rhs` (right hand side, or predictor)
and `op` (operation) columns specify what modification should be made.

Paths linking latent variables to the observed variables which index them have
`=~` in the 'op' column.

Error covariances for observed variables have `~~` as the op. These symbols
match the symbols used to describe a path in the lavaan model syntax.

If we add the largest MI path to our model it will look like this:


```r
# same model, but with x9 now loading on visual
hz.model.2 <- "
visual =~ x1 + x2 + x3 + x9
writing =~ x4 + x5 + x6
maths =~ x7 + x8 + x9"

hz.fit.2 <- cfa(hz.model.2, data=hz)
fitmeasures(hz.fit.2, c('cfi', 'rmsea', 'rmsea.ci.upper', 'bic'))
           cfi          rmsea rmsea.ci.upper            bic 
         0.967          0.065          0.089       7568.123 
```

RMSEA has improved somewhat, but we'd probably want to investigate this model
further, and make additional improvements to it (although see the notes on
[model improvements](#model-improvement))

## Model modification and improvement {- #model-improvement}

Modification indices are a way of improving your model by identifying parameters
which, if included, would improve model fit (or constraints removed). However,
remember that:

-   Use of modification indices should be informed by theory
-   MI may suggest paths which don't make substantive sense

[It's very important to avoid adding paths in a completely data-driven way
because this is almost certain to lead to [over-fitting](#over-fitting).]{.tip}

It's also important to work one step at a time, because the table of
modification indices may change as you add additional paths. For example, the
second largest MI value may change once you add the path with the largest MI to
the model.

The basic steps to follow are:

1.  Run a simple, theoretically-derived model
2.  Notice it fits badly
3.  Add any additional paths which make theoretical sense
4.  Check GOF; If it still fits badly then,
5.  Run MI and identify the largest value
6.  If this parameter makes theoretical sense, relax the constraint
7.  Re-run the model and return to step 4

## Structural eqution modelling (SEM) {- #sem}

Combining Path models and CFA to create structural equation models (SEM) allows
researchers to combine allow for measurment imperfection whilst also (attempting
to) infer information about causation.

SEM involves adding paths to CFA models which are, like predictors in standard
regression models, are assumed to be causal in nature; i.e. rather than
variables $x$ and $y$ simply covarying with one another, we are prepared to make
the assumption that $x$ causes $y$.

It's worth pointing out though, right from the offset, that _causal
relationships drawn from SEM models always dependent on assumptions we are
prepared to make when setting up our model_. There is nothing magical in the
technique that makes allows us to infer causality from non-experimental data
(although note SEM can be used for some experimental analyses).

It is only be our substantive knowledge of the domain that makes any kind of
causal inference reasonable, and when using SEM the onus is always _on us_ to
check our assumptions, provide sensitivity analyses which test alternative
causal models, and interpret observational data cautiously.

[Note, there are techniques which use SEM as a means to make stronger kinds of
causal statements, for example
[instrumental variable analysis](https://en.wikipedia.org/wiki/Instrumental_variable),
but even here, inferring causality still requires that we make strong
assumptions about the process which generated our data.

Nonetheless, with these caveats in mind, SEM can be a useful technique to
quantify relationships been observed variables where we have measurement error,
and especially where we have a theoretical model linking these observations.

#### Steps to running an SEM {-}

1. Identify and test the fit of a _measurement model_. This is a CFA model which
   includes all of your observed variables, arranged in relation to the latent
   variables you think generated the data, and where covariances between all
   these latent variables are included. This step many include
   [many rounds of model fitting and modification](#model-improvement).

2. Ensure your measurement model [fits the data adequately](#gof) before
   continuing. Test alternative or simplified measurements models and report
   where these perform well (e.g. are close in fit to your desired model). SEM
   models that are based on a poorly fitting measurment model will produce
   parameter estimates that are imprecise, unstable or both, and you should not
   proceed unless an adequately fitting measrement model is founds
   ([see this nice discussion, which includes relevant references](https://stats.stackexchange.com/a/143465/)).

3. Convert your measurement model by removing covariances between latent
   variables where necessary and including new structural paths. Test model fit,
   and interpret the paths of interest. Avoid making changes to the measurement
   part of the model at this stage. Where the model is complex consider
   adjusting _p_ values to allow for multuple comparisons (if using NHST).

4. Test alternative models (e.g. with paths removed or reversed). Report where
   alternatives also fit the data.

5. In writing up, provide sufficient detail for other researchers to replicate
   your analyses, and to follow the logic of the ammendments you make. Ideally
   share your raw data, but at a minimum share the covariance matrix. Report GOF
   statistics, and follow published reporting guidelines for SEM
   [@schreiber_reporting_2006]. Always include a diagram of your final model (at
   the very least).

#### A worked example: Building from a measurement model to SEM {-}



Imagine we have some data from a study that aimed to test the theory of planned
behaviour. Researcher measured exercise and intentions, along with multiple
measures of attitudes, social norms and percieved behavioural control.


```r
tpb.df %>% psych::describe(fast=T)
```

```{=latex}
 
  \providecommand{\huxb}[2]{\arrayrulecolor[RGB]{#1}\global\arrayrulewidth=#2pt}
  \providecommand{\huxvb}[2]{\color[RGB]{#1}\vrule width #2pt}
  \providecommand{\huxtpad}[1]{\rule{0pt}{\baselineskip+#1}}
  \providecommand{\huxbpad}[1]{\rule[-#1]{0pt}{#1}}

\begin{table}[h]
\begin{raggedright}
\begin{threeparttable}
\begin{tabularx}{1\textwidth}{p{0.125\textwidth} p{0.125\textwidth} p{0.125\textwidth} p{0.125\textwidth} p{0.125\textwidth} p{0.125\textwidth} p{0.125\textwidth} p{0.125\textwidth}}


\hhline{>{\huxb{0, 0, 0}{0.4}}->{\huxb{0, 0, 0}{0.4}}->{\huxb{0, 0, 0}{0.4}}->{\huxb{0, 0, 0}{0.4}}->{\huxb{0, 0, 0}{0.4}}->{\huxb{0, 0, 0}{0.4}}->{\huxb{0, 0, 0}{0.4}}->{\huxb{0, 0, 0}{0.4}}-}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0.4}}r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{4pt}\raggedleft \textbf{vars}\huxbpad{4pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{4pt}\raggedleft \textbf{n}\huxbpad{4pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{4pt}\raggedleft \textbf{mean}\huxbpad{4pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{4pt}\raggedleft \textbf{sd}\huxbpad{4pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{4pt}\raggedleft \textbf{min}\huxbpad{4pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{4pt}\raggedleft \textbf{max}\huxbpad{4pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{4pt}\raggedleft \textbf{range}\huxbpad{4pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0.4}}}{\huxtpad{4pt}\raggedleft \textbf{se}\huxbpad{4pt}} \tabularnewline[-0.5pt]


\hhline{>{\huxb{0, 0, 0}{0.4}}->{\huxb{0, 0, 0}{0.4}}->{\huxb{0, 0, 0}{0.4}}->{\huxb{0, 0, 0}{0.4}}->{\huxb{0, 0, 0}{0.4}}->{\huxb{0, 0, 0}{0.4}}->{\huxb{0, 0, 0}{0.4}}->{\huxb{0, 0, 0}{0.4}}-}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0.4}}r!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\huxtpad{4pt}\raggedleft 1\huxbpad{4pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\huxtpad{4pt}\raggedleft 469\huxbpad{4pt}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft -0.00539\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 1.61\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft -5.99\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 4.78\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 10.8~\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0.4}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 0.0745\huxbpad{4pt}}} \tabularnewline[-0.5pt]


\hhline{>{\huxb{0, 0, 0}{0.4}}|>{\huxb{0, 0, 0}{0.4}}|}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0.4}}r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{4pt}\raggedleft 2\huxbpad{4pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{4pt}\raggedleft 459\huxbpad{4pt}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 0.117~~\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 1.22\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft -3.17\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 4.18\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 7.35\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0.4}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 0.057~\huxbpad{4pt}}} \tabularnewline[-0.5pt]


\hhline{>{\huxb{0, 0, 0}{0.4}}|>{\huxb{0, 0, 0}{0.4}}|}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0.4}}r!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\huxtpad{4pt}\raggedleft 3\huxbpad{4pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\huxtpad{4pt}\raggedleft 487\huxbpad{4pt}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft -0.001~~\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 1.08\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft -3.22\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 3.13\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 6.35\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0.4}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 0.0487\huxbpad{4pt}}} \tabularnewline[-0.5pt]


\hhline{>{\huxb{0, 0, 0}{0.4}}|>{\huxb{0, 0, 0}{0.4}}|}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0.4}}r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{4pt}\raggedleft 4\huxbpad{4pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{4pt}\raggedleft 487\huxbpad{4pt}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 0.078~~\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 1.53\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft -5.04\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 5.43\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 10.5~\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0.4}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 0.0695\huxbpad{4pt}}} \tabularnewline[-0.5pt]


\hhline{>{\huxb{0, 0, 0}{0.4}}|>{\huxb{0, 0, 0}{0.4}}|}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0.4}}r!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\huxtpad{4pt}\raggedleft 5\huxbpad{4pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\huxtpad{4pt}\raggedleft 487\huxbpad{4pt}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 0.0376~\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 1.22\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft -3.76\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 3.61\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 7.37\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0.4}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 0.0551\huxbpad{4pt}}} \tabularnewline[-0.5pt]


\hhline{>{\huxb{0, 0, 0}{0.4}}|>{\huxb{0, 0, 0}{0.4}}|}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0.4}}r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{4pt}\raggedleft 6\huxbpad{4pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{4pt}\raggedleft 487\huxbpad{4pt}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 0.00863\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 1.11\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft -3.21\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 3.11\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 6.33\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0.4}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 0.0501\huxbpad{4pt}}} \tabularnewline[-0.5pt]


\hhline{>{\huxb{0, 0, 0}{0.4}}|>{\huxb{0, 0, 0}{0.4}}|}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0.4}}r!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\huxtpad{4pt}\raggedleft 7\huxbpad{4pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\huxtpad{4pt}\raggedleft 471\huxbpad{4pt}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 0.0261~\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 1.1~\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft -2.94\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 3.14\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 6.08\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0.4}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 0.0506\huxbpad{4pt}}} \tabularnewline[-0.5pt]


\hhline{>{\huxb{0, 0, 0}{0.4}}|>{\huxb{0, 0, 0}{0.4}}|}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0.4}}r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{4pt}\raggedleft 8\huxbpad{4pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{4pt}\raggedleft 487\huxbpad{4pt}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft -0.00329\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 1.35\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft -4.13\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 4.03\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 8.16\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0.4}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 0.061~\huxbpad{4pt}}} \tabularnewline[-0.5pt]


\hhline{>{\huxb{0, 0, 0}{0.4}}|>{\huxb{0, 0, 0}{0.4}}|}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0.4}}r!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\huxtpad{4pt}\raggedleft 9\huxbpad{4pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\huxtpad{4pt}\raggedleft 487\huxbpad{4pt}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft -0.0865~\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 1.31\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft -4.86\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 4.08\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 8.94\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0.4}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 0.0593\huxbpad{4pt}}} \tabularnewline[-0.5pt]


\hhline{>{\huxb{0, 0, 0}{0.4}}|>{\huxb{0, 0, 0}{0.4}}|}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0.4}}r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{4pt}\raggedleft 10\huxbpad{4pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{4pt}\raggedleft 487\huxbpad{4pt}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft -0.00563\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 1.19\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft -3.12\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 3.34\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 6.46\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0.4}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 0.0537\huxbpad{4pt}}} \tabularnewline[-0.5pt]


\hhline{>{\huxb{0, 0, 0}{0.4}}|>{\huxb{0, 0, 0}{0.4}}|}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0.4}}r!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\huxtpad{4pt}\raggedleft 11\huxbpad{4pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\huxtpad{4pt}\raggedleft 487\huxbpad{4pt}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft -0.0863~\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 1.06\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft -3.23\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 3.34\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 6.57\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0.4}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 0.0481\huxbpad{4pt}}} \tabularnewline[-0.5pt]


\hhline{>{\huxb{0, 0, 0}{0.4}}|>{\huxb{0, 0, 0}{0.4}}|}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0.4}}r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{4pt}\raggedleft 12\huxbpad{4pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{4pt}\raggedleft 487\huxbpad{4pt}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft -0.0663~\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 1.16\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft -4.11\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 3.5~\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 7.61\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0.4}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 0.0525\huxbpad{4pt}}} \tabularnewline[-0.5pt]


\hhline{>{\huxb{0, 0, 0}{0.4}}|>{\huxb{0, 0, 0}{0.4}}|}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0.4}}r!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\huxtpad{4pt}\raggedleft 13\huxbpad{4pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\huxtpad{4pt}\raggedleft 469\huxbpad{4pt}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 10.1~~~~\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 2.55\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 1.83\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 16.7~\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 14.9~\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0.4}}}{\cellcolor[RGB]{242, 242, 242}\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 0.118~\huxbpad{4pt}}} \tabularnewline[-0.5pt]


\hhline{>{\huxb{0, 0, 0}{0.4}}|>{\huxb{0, 0, 0}{0.4}}|}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0.4}}r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{4pt}\raggedleft 14\huxbpad{4pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{4pt}\raggedleft 487\huxbpad{4pt}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 80.2~~~~\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 18.8~\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 15~~~\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 138~~~\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 123~~~\huxbpad{4pt}}} &
\multicolumn{1}{p{0.125\textwidth}!{\huxvb{0, 0, 0}{0.4}}}{\parbox[b]{0.125\textwidth-4pt-4pt}{\huxtpad{4pt}\raggedleft 0.851~\huxbpad{4pt}}} \tabularnewline[-0.5pt]


\hhline{>{\huxb{0, 0, 0}{0.4}}->{\huxb{0, 0, 0}{0.4}}->{\huxb{0, 0, 0}{0.4}}->{\huxb{0, 0, 0}{0.4}}->{\huxb{0, 0, 0}{0.4}}->{\huxb{0, 0, 0}{0.4}}->{\huxb{0, 0, 0}{0.4}}->{\huxb{0, 0, 0}{0.4}}-}
\arrayrulecolor{black}
\end{tabularx}\end{threeparttable}
\par\end{raggedright}

\end{table}
 
```

There were some missing data, but nothing to suggest a systematic pattern. For
the moment we continue with standard methods:


```r
mice::md.pattern(tpb.df)
```

![](cfa-sem_files/figure-latex/unnamed-chunk-26-1.pdf)<!-- --> 

```
    a3 sn1 sn2 sn3 pc1 pc2 pc3 pc4 pc5 exercise sn4 a1 intention a2   
416  1   1   1   1   1   1   1   1   1        1   1  1         1  1  0
23   1   1   1   1   1   1   1   1   1        1   1  1         1  0  1
13   1   1   1   1   1   1   1   1   1        1   1  1         0  1  1
2    1   1   1   1   1   1   1   1   1        1   1  1         0  0  2
16   1   1   1   1   1   1   1   1   1        1   1  0         1  1  1
1    1   1   1   1   1   1   1   1   1        1   1  0         0  1  2
11   1   1   1   1   1   1   1   1   1        1   0  1         1  1  1
2    1   1   1   1   1   1   1   1   1        1   0  1         1  0  2
1    1   1   1   1   1   1   1   1   1        1   0  1         0  1  2
1    1   1   1   1   1   1   1   1   1        1   0  1         0  0  3
1    1   1   1   1   1   1   1   1   1        1   0  0         1  1  2
     0   0   0   0   0   0   0   0   0        0  16 18        18 28 80
```

We start by fitting a measurement model. The model sytax includes lines with

-   `=~` separatatig left and right hand side (to define the latent variables)
-   `~~` to specify latent covariances

We are not including `exercise` and `intention` yet because these are observed
variables only (we don't have multiple measurements for them) and so they don't
need to be in the measurement model:


```r
mes.mod <- '
  # the "measurement" part, defining the latent variables
  AT =~ a1 + a2 + a3 + sn1
  SN =~ sn1 + sn2 + sn3 + sn4
  PBC =~ pc1 + pc2 + pc3 + pc4 + pc5

  # note that lavaan automatically includes latent covariances
  # but we can add here anyway to be explicit
  AT ~~ SN
  SN ~~ PBC
  AT ~~ PBC
'
```

We can fit this model to the data like so:


```r
mes.mod.fit <- cfa(mes.mod, data=tpb.df)
summary(mes.mod.fit)
lavaan 0.6-3 ended normally after 52 iterations

  Optimization method                           NLMINB
  Number of free parameters                         28

                                                  Used       Total
  Number of observations                           429         487

  Estimator                                         ML
  Model Fit Test Statistic                      50.290
  Degrees of freedom                                50
  P-value (Chi-square)                           0.462

Parameter Estimates:

  Information                                 Expected
  Information saturated (h1) model          Structured
  Standard Errors                             Standard

Latent Variables:
                   Estimate  Std.Err  z-value  P(>|z|)
  AT =~                                               
    a1                1.000                           
    a2                0.471    0.056    8.466    0.000
    a3                0.239    0.042    5.654    0.000
    sn1              -0.145    0.223   -0.651    0.515
  SN =~                                               
    sn1               1.000                           
    sn2               0.529    0.153    3.456    0.001
    sn3               0.294    0.089    3.300    0.001
    sn4               0.335    0.099    3.383    0.001
  PBC =~                                              
    pc1               1.000                           
    pc2               0.860    0.098    8.813    0.000
    pc3               0.647    0.081    7.978    0.000
    pc4               0.425    0.069    6.133    0.000
    pc5               0.643    0.081    7.964    0.000

Covariances:
                   Estimate  Std.Err  z-value  P(>|z|)
  AT ~~                                               
    SN                1.488    0.460    3.233    0.001
  SN ~~                                               
    PBC               0.045    0.085    0.525    0.600
  AT ~~                                               
    PBC               0.010    0.086    0.116    0.908

Variances:
                   Estimate  Std.Err  z-value  P(>|z|)
   .a1                0.586    0.195    2.997    0.003
   .a2                1.068    0.086   12.494    0.000
   .a3                1.018    0.072   14.222    0.000
   .sn1               0.870    0.239    3.640    0.000
   .sn2               0.940    0.090   10.404    0.000
   .sn3               1.071    0.077   13.887    0.000
   .sn4               1.028    0.076   13.544    0.000
   .pc1               0.871    0.104    8.401    0.000
   .pc2               1.084    0.100   10.842    0.000
   .pc3               1.018    0.082   12.431    0.000
   .pc4               0.992    0.072   13.690    0.000
   .pc5               1.014    0.081   12.447    0.000
    AT                2.035    0.259    7.859    0.000
    SN                1.873    0.882    2.124    0.034
    PBC               0.888    0.135    6.600    0.000
```

And we can assess model fit using `fitmeasures`. Here we select a subset of the
possible fit indices to keep the output manageable.


```r
useful.fit.measures <- c('chisq', 'rmsea', 'cfi', 'aic')
fitmeasures(mes.mod.fit, useful.fit.measures)
    chisq     rmsea       cfi       aic 
   50.290     0.004     1.000 16045.276 
```

This model looks pretty good (see the
[guide to fit indices](#common-fit-indices)), but still check
[modification indices to identify improvements](#model-improvement). If they
made theoretical sense we might choose to add paths:


```r
modificationindices(mes.mod.fit) %>%
  as_data_frame() %>%
  filter(mi>4) %>%
  arrange(-mi) %>%
  pander(caption="Modification indices for the measurement model")
```


------------------------------------------------------------------
 lhs   op   rhs    mi       epc     sepc.lv   sepc.all   sepc.nox 
----- ---- ----- ------- --------- --------- ---------- ----------
 AT    =~   sn2   20.39   0.5284    0.7536     0.6226     0.6226  

 sn1   ~~   sn2   15.04   -0.4689   -0.4689   -0.5184    -0.5184  

 AT    =~   sn4   12.49   -0.3035   -0.4329   -0.3891    -0.3891  

 a1    ~~   sn2   8.476   0.2457    0.2457     0.331      0.331   

 sn1   ~~   sn4   6.54     0.216     0.216     0.2285     0.2285  

 a2    ~~   pc5   4.098   -0.1118   -0.1118   -0.1074    -0.1074  
------------------------------------------------------------------

Table: Modification indices for the measurement model

However, in this case unless we had substantive reasons to add the paths, it
would probably be reasonable to continue with the original model.

##### The measurement model fits, so proceed to SEM {-}

Our SEM model adapts the CFA (measurement model), including additional observed
variables (e.g. intention and exercise) and any relevant structural paths:


```r
sem.mod <- '
  # this section identical to measurement model
  AT =~ a1 + a2 + a3 + sn1
  SN =~ sn1 + sn2 + sn3 + sn4
  PBC =~ pc1 + pc2 + pc3 + pc4 + pc5

  # additional structural paths
  intention ~ AT + SN + PBC
  exercise ~ intention
'
```

We can fit it as before, but now using the `sem()` function rather than the
`cfa()` function:


```r
sem.mod.fit <- sem(sem.mod, data=tpb.df)
```

The first thing we do is check the model fit:


```r
fitmeasures(sem.mod.fit, useful.fit.measures)
    chisq     rmsea       cfi       aic 
  171.065     0.058     0.929 20638.124 
```

RMSEA is slightly higher than we like, so we can check the modification indices:


```r
sem.mi <- modificationindices(sem.mod.fit) %>%
  as_data_frame() %>%
  arrange(-mi)

sem.mi %>%
  head(6) %>%
  pander(caption="Top 6 modification indices for the SEM model")
```


-----------------------------------------------------------------------------
    lhs      op     rhs       mi       epc     sepc.lv   sepc.all   sepc.nox 
----------- ---- ---------- ------- --------- --------- ---------- ----------
 exercise    ~      PBC      90.14    7.601     7.049     0.3695     0.3695  

    PBC      ~    exercise   89.49   0.04938   0.05325    1.016      1.016   

 intention   ~    exercise   47.03   -0.1233   -0.1233   -0.9106    -0.9106  

 intention   ~~   exercise   47.03   -16.18    -16.18    -0.6779    -0.6779  

    AT       =~     sn2      16.14   0.5093    0.7043     0.5855     0.5855  

    pc1      ~~   exercise   15.08    2.405     2.405     0.2205     0.2205  
-----------------------------------------------------------------------------

Table: Top 6 modification indices for the SEM model

Interestingly, this model suggests two additional paths involving `exercise` and
the `PBC` latent:


```r
sem.mi %>%
  filter(lhs %in% c('exercise', 'PBC') & rhs %in% c('exercise', 'PBC')) %>%
  pander()
```


----------------------------------------------------------------------------
   lhs      op     rhs       mi       epc     sepc.lv   sepc.all   sepc.nox 
---------- ---- ---------- ------- --------- --------- ---------- ----------
 exercise   ~      PBC      90.14    7.601     7.049     0.3695     0.3695  

   PBC      ~    exercise   89.49   0.04938   0.05325    1.016      1.016   
----------------------------------------------------------------------------

Of these suggested paths, the largest MI is for the one which says PBC is
predicted by exercise. However, the model would also be improved by allowing PBC
to predict exercise. Which should we add?

**_The answer will depend on both previous theory and knowledge of the data._**

If it were the case that exercise was measured at a later time point than PBC.
In this case the decision is reasonably clear, because the temporal sequencing
of observations would determine the most likely path. These data were collected
contemporaneously, however, and so we can't use our _design_ to differentiate
the causal possibilities.

Another consideration would be that, by adding a path from exercise to PBC we
would make the [model non-recursive](#identification-recursion), and likely
[non-identified](#identification).

A theorist might also argue that because previous studies, and the theory of
planned behaviour itself, predict that PBC may exert a direct influence on
behaviour, we should add the path with the smaller MI (so allow PBC to predict
exercise).

In this case, the best course of action would probably be to report the
theoretically implied model, but also test alternative models in which causal
relations between the variables are reversed or otherwise altered (along with
measures of fit and key parameter estimates). The discussion of your paper would
then make the case for your preferred account, but make clear that the data were
(most likely) unable to provide a persuasive case either way, and that
alternative explanations cannot be ruled out.

##### Interpreting and presenting key parameters {-}

One of the best ways to present estimates from your final model is in a diagram,
because this is intutive and provides a simple way for readers to comprehend the
paths implied by your model.

We can automatically generate a plot from a fitted model using `semPaths()`.
Here, the `what='std'` is requesting standardised parameter estimates be shown.
Adding `residuals=F` hides variances of observed and latent variables, which are
not of interest here. The line thicknesses are scaled to represent the size
parameter itself:


```r
semPlot::semPaths(sem.mod.fit, what='std', residuals=F)
```

![](cfa-sem_files/figure-latex/unnamed-chunk-36-1.pdf)<!-- --> 

For more information on reporting SEM however, see @schreiber2006reporting.

## 'Identification' in CFA and SEM {- #identification}

Identification refers to the idea that a model is 'estimable', or more
specifically whether there is a single best solution for the parameters
specified in the model. An analogy would be the 'line of best fit' in
regression - if we could draw two lines that fit the data equally well then our
method doesn't enable us to choose between these possibilities, and is
essentially meaningless (or uninterpretable, anyway).

This is a complex topic, but David Kenny has an excellent page here which covers
identification in lots of detail: <http://davidakenny.net/cm/identify.htm>. Some
of the key ideas to takeaway are:

#### {- #identification-recursion}

-   Feedback loops and other non-recursive models are likely to cause problems
    without special attention.

-   Latent variables need a scale. To do this either fix their variance, or fix
    a factor loading to 1.

-   You need 'enough data'. Normally this will be at least 3 measured variables
    per latent. Sometimes 2 is enough, provided the errors of these variables
    are uncorrelated, but you may struggle to fit models because of 'empirical
    under-identification'^[Note, indicators themselves should be correlated with
    one another in a bivariate correlation matrix. It's only the errors which
    should be uncorrelated.]

-   If a model is non-identified, it may either i) fail to run or, worse, ii)
    produce spurious results.

##### Rule B {-}

For structural models, 'Rule B' also applies when deciding when a model is
identified: No more than one of the following statements should be true about
variables or latents in your model:

-   X directly causes Y
-   Y directly causes X
-   X and Y have a correlated disturbance
-   X and Y are correlated exogenous variables

But see <http://davidakenny.net/cm/identify_formal.htm#RuleB> for a proper
explanation.

<!-- TODO improve with notes from 557 -->

## Missing data {- #cfa-sem-missing-data}

If you have missing data you can use the `missing = "ML"` argument to ask lavaan
to estimate the 'full information maximum likelihood' (see
<http://lavaan.ugent.be/tutorial/est.html>).


```r
# fit ML model including mean structure to make comparable with FIML fit below
# (means are always included with FIML model fits)
sem.mod.fit <- sem(sem.mod, data=tpb.df, meanstructure=TRUE)

# fit again including missing data also
sem.mod.fit.fiml <- sem(sem.mod, data=tpb.df, missing="ML")
```

It doesn't look like the parameter estimates change much. To compare them
explicitly we can extract the relevant coefficients from each (they don't look
all that different):


```r
bind_cols(parameterestimates(sem.mod.fit) %>%
    select(lhs, op, rhs, est, pvalue) %>%
    rename(ml=est, ml.p = pvalue),
  parameterestimates(sem.mod.fit.fiml) %>%
    transmute(fiml=est, fiml.p = pvalue)) %>%
  # select only the regression paths
  filter(op=="~") %>%
  as_huxtable() %>%
  set_caption("Comparison of ML and MLM parameter estimates.") %>%
  print_md()
-------------------------------------------------------
 intention ~   AT        0.379   0.0513 0.306   0.0608 
---------- --- --------- ----- -------- ----- ---------
 intention ~   SN        0.472   0.0234 0.479  0.00381 
                                                       
 intention ~   PBC        1.09 3.51e-12  1.05 2.01e-13 
                                                       
 exercise  ~   intention  5.91        0   5.9        0 
-------------------------------------------------------

Table: Comparison of ML and MLM parameter estimates.
```

## Goodness of fit statistics in CFA {- #gof}

It's worth noting that many 'goodness of fit' statistics are misnamed and are in
fact indexing 'badness of fit'. This applies to RMSEA, $\chi^2$, BIC, AIC and
others.

However all of these indices are trying to solve similar problems in subtly
different ways. The problem is that we would like a model which:

-   Fits the data we have _and also_
-   Predicts new data

You might think that these goals would be aligned and that a model which fits
the data we have would also be good ad predicting new data, but this isn't the
case. In fact, if we [overfit](#over-fitting) our current data we won't be able
to predict new observations very accurately.

#### How fit indices work {-}

There is a tradeoff involved to avoid over-fitting the data, and most fit
indices attempt to:

-   Quantify how well the model fits the current data but
-   Penalise models which use many parameters (i.e. those in danger of
    overfitting)

Each formula for a goodness of fit statistic represents a different tradeoff
between these goals.

#### {- .tip }

Model fit statistics are useful but can be misleading and misused. See David
Kenny's page on model fit for more details: <http://davidakenny.net/cm/fit.htm>

#### {- #common-fit-indices}

Below are some of the most useful and commonly reported GOF statistics for CFA
and SEM models:

#### Root Mean Square Error of Approximation (RMSEA) {-}

MacCallum, Browne and Sugawara (1996) have used 0.01, 0.05, and 0.08 to indicate
excellent, good, and mediocre fit, respectively.

RMSEA &lt; .05 often used as a cutoff for a reasonably fitting model, athough
others suggest .1.

RMSEA is also used to calculate the 'probability of a close fit' or pclose
statistic — this is the probability that the RMSEA is under 0.05.

#### Comparative fit index (CFI) {-}

CFI (and the related TLI) assesses the relative improvement in fit of your model
compared with the baseline model.

CFI ranges between 0 and 1.

The conventional (rule of thumb) threshold for a good fitting model is for CFI
to be > .9

#### Akaike Information Criterion (AIC) and Bayesian Information Criterion (BIC) {-}

The AIC and BIC are measures of comparative fit, so can be used when models are
non-nested (and therefore otherwise not easily comparable).

AIC is particularly attractive because it corresponds to a measure of
_predictive_ accuracy. That is, selecting the model with the smallest AIC is one
way of asking: "which model is most likely to accurately predict new data?"

#### Factors which can influence fit statistics {-}

All of the following can influence or bias fit statistics:

-   Number of variables (although note RMSEA trends to reduce with more
    parameters included, but other fit statistics will increase).
-   Model complexity (different statistics reward parsimony to different
    degrees).
-   Sample size (varies by statistic: some increase and others decrease with
    sample size).
-   Non-normality of outcome data will (tend to) worsen fit.

#### Which statistics should you report? {-}

When reporting absolute model fit, RMSEA and CFI are the most widely reported,
and are probably sufficient.

However, you should almost never just report a single model, and so:

-   When comparing nested models you should report the $\chi^2$ `lrtest`.
-   When comparing non-nested models you should also report differences in BIC
    and AIC.

#### Further reading {-}

This set of slides on model fit provides all fo the formulae and an explanation
for many different fit indices:
<http://www.psych.umass.edu/uploads/people/79/Fit_Indices.pdf>
