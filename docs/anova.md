---
title: 'Anova'
output: bookdown::tufte_html2
---


# Anova {#anova-in-r}


## Anova in R {- #anova}

  




This section attempts to cover in a high level way how to specify anova models in R and some of the issues in interpreting the model output. If you just want the 'answers' — i.e. the syntax to specify common Anova models -- you could skip to the next section: [Anova cookbook](#anova-cookbook)



There are 4 rules for doing Anova in R and not wanting to cry:

1. Keep your data in 'long' format.
2. Know the differences between character, factor and numeric variables
3. Do not use the `aov()` or `anova()` functions to get an Anova table unless you know what you are doing.
4. Learn about the types of sums of squares and always remember to specify `type=3`, unless you know better.


### Rule 1: Use long format data {-}

In R, data are almost always most useful a long format where:

- each row of the dataframe corresponds to a single measurement occasion
- each column corresponds to a variable which is measured





For example, in R we will have data like this:


```r
df %>% head %>% pandoc.table
## 
## -------------------------------------
##  person   time   predictor   outcome 
## -------- ------ ----------- ---------
##    1       1         0          7    
## 
##    1       2         0         12    
## 
##    1       3         0         11    
## 
##    2       1         3         13    
## 
##    2       2         3          5    
## 
##    2       3         3         11    
## -------------------------------------
```



Whereas in SPSS we might have the same data structured like this:



```r
df.wide %>% head %>% pandoc.table
## 
## -----------------------------------------------
##  person   predictor   Time 1   Time 2   Time 3 
## -------- ----------- -------- -------- --------
##    1          0         7        12       11   
## 
##    2          3         13       5        11   
## 
##    3          5         10       12       10   
## 
##    4          2         10       12       11   
## 
##    5          4         9        13       5    
## 
##    6          4         9        15       9    
## -----------------------------------------------
```




R always uses long form data when running an Anova, but one downside is that it therefore has no automatic to know which rows belong to which person (assuming individual people are the unit of error in your model). This means that for repeated measures designs you need to be careful to explicitly specify any repeated measures when specifying the model (see the section on repeated designs below).



### Rule 2: Know your variables {-}

See [the section on dataframes](#datasets-dataframes) and be sure you can distinguish:

- Numeric variables
- Factors
- Character strings.


In Anova, you need to enter:

- Numeric variables as your outcome
- Factors or (preferably) character strings as predictors
- (If you want to run Ancova models, you can also add numeric predictors.)



### Rule 3: Don't use `aov()` or `anova()` {-}

This is the most important rule of all.

The `aov` and `anova` functions have been around in R a long time. For various historical reasons the defaults for these functions won't do what you expect if you are used to SPSS, Stata, SAS and most other stats packages. These differences are important and will be confusing and give you misleading results unless you understand them.

The recommendation here is:

- If you have a factorial experiment define your model using `lm()` and then use `car::Anova()`.

- If you have repeated measures, your data are perfectly balanced, and you have no missing values then use `afex::car_aov()`. But be careful to specify the Error term in your model to allow for the repeats.

- If you think you might want a repeat measures Anova but your data are not balanced or you have missing data, use [linear mixed models](#multilevel-models) instead via the `lme4::` package.



### But what about [insert favourite R package for Anova]?

Lots of people like `ez::ezANOVA` and other similar packages. My problem with `ezANOVA` is that it doesn't use formulae to define the model and for this reason encourages people to think of Anova as something magical and separate from linear models and regression in general. 

This guide is called 'just enough R', so I've chosen to show only `car::Anova` because I find this the most transparent method to explain. By using formulae to specify the model in `lm()` first it reinforces a technique which is useful in many other contexts.

If you want effect sizes use: `lsr::etaSquared(model)` (install the `lsr` package first).




### Rule 4: Use type 3 sums of squares (and learn about why) {-}

You may be aware, but there are at least 3 different ways of calculating the sums of squares for each factor and interaction in an Anova. In short, 

- SPSS and most other packages use type 3 sums of squares.
- `aov` and `anova` use type 1.
- By default, `car::Anova` and `ez::ezANOVA` use type 2, but can use type 3 if you ask.


What you should do:

- Make sure you use type 3 sums of squares unless you have a reason not to.
- Always pass `type=3` as an argument when running an Anova.


A longer explanation of *why* you probably want type 3 sums of squares is given in this [online discussion on stats.stackechange.com]( https://stats.stackexchange.com/questions/60362/choice-between-type-i-type-ii-or-type-iii-anova) and practical implications are shown in [this worked example](http://dwoll.de/rexrepos/posts/anovaSStypes.html).

An even longer answer, including a much deeper exploration of the philosophical questions involved is given by @venables1998exegeses. 





### General recommendations {- #anova-recommendations}


1. Make sure to [Plot your raw data *first*](#graphics)

1. Where you have interactions, [be cautious in interpreting the main effects in your model, and always plot the model predictions](#understanding-interactions). 

1. If you find yourself aggregating (averaging) data before running your model, [think about using a mixed or multilevel model](#multilevel-models) instead.

1. If you are using repeated measures Anova, [check if you should should be using a mixed model](#multilevel-models) instead. If you have an unbalanced design or any missing data, you probably should use a mixed model.






