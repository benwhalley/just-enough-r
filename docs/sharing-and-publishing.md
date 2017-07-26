---
title: 'Sharing and publishing analyses'
output:
  bookdown::tufte_html2
---




# (PART) Sharing {-}

# Sharing and publishing your work {#sharing-and-publication}

Have you ever manually copied hundres of numbers from SPSS tables to a MS Word document? If so, rejoice that you'll never have to again!

R and RMarkdown provide many useful features when formatting results for publication. The key steps in the process are to:

1. [Extract](#extract-results-from-models) results from models (normally into a dataframe)
2. Select/filter/summarise/combine or otherwise [process your results](#process-model-results)
3. Output to a [plot](#graphics), [table](#output-tables), or [inline in your text](#apa-output) (or save for later)



## Extracting results from models {- #extract-results-from-models}


One of the nice things about R is that the `summary()` function will almost always provide a concise output, showing the key features of an model you have run.

However, this text output isn't suitable for publication, and can even be too verbose for communicating with colleagues. Often, when communicating with others, you want to focus in on the important details from analyses and to do this you need to extract results from your models.

Thankfully, there is almost always a method to extract results to a [`dataframe`]( #datasets-dataframes). For example, if we run a linear model:



```r
model.fit <- lm(mpg~wt+disp, data=mtcars)
summary(model.fit)
## 
## Call:
## lm(formula = mpg ~ wt + disp, data = mtcars)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -3.4087 -2.3243 -0.7683  1.7721  6.3484 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 34.96055    2.16454  16.151 4.91e-16 ***
## wt          -3.35082    1.16413  -2.878  0.00743 ** 
## disp        -0.01773    0.00919  -1.929  0.06362 .  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2.917 on 29 degrees of freedom
## Multiple R-squared:  0.7809,	Adjusted R-squared:  0.7658 
## F-statistic: 51.69 on 2 and 29 DF,  p-value: 2.744e-10
```



We can extract the parameter table from this model by saving the `summary()` of it, and then using the `$` operator to access the `coefficients` table (actually a matrix), which is stored within the summary object. In the example below, we also convert this to a dataframe:



```r
model.fit.summary <- summary(model.fit)
as_data_frame(model.fit.summary$coefficients)
## # A tibble: 3 x 4
##      Estimate `Std. Error` `t value`   `Pr(>|t|)`
##         <dbl>        <dbl>     <dbl>        <dbl>
## 1 34.96055404  2.164539504 16.151497 4.910746e-16
## 2 -3.35082533  1.164128079 -2.878399 7.430725e-03
## 3 -0.01772474  0.009190429 -1.928609 6.361981e-02
```


It's actually a useful trick to learn how to 'poke around' inside R objects using the `$` and `@` operators (if you want the gory details of how these operators work, [start with this guide](http://adv-r.had.co.nz/OO-essentials.html) to object systems in R).

In the video below, I use RStudio's autocomplete feature to find results buried within a `lm` object:


<iframe src="https://player.vimeo.com/video/225529842" width="862" height="892" frameborder="0"></iframe>



For example, we could write the follwing to extract a table of coefficients, test statistics and *p* values from an `lm()` object (this is shown in the video:


```r
model.fit.summary <- summary(model.fit)
model.fit.summary$coefficients %>% 
  as_data_frame()
## # A tibble: 3 x 4
##      Estimate `Std. Error` `t value`   `Pr(>|t|)`
##         <dbl>        <dbl>     <dbl>        <dbl>
## 1 34.96055404  2.164539504 16.151497 4.910746e-16
## 2 -3.35082533  1.164128079 -2.878399 7.430725e-03
## 3 -0.01772474  0.009190429 -1.928609 6.361981e-02
```
























```r
model.fit %>% broom::tidy()
##          term    estimate   std.error statistic      p.value
## 1 (Intercept) 34.96055404 2.164539504 16.151497 4.910746e-16
## 2          wt -3.35082533 1.164128079 -2.878399 7.430725e-03
## 3        disp -0.01772474 0.009190429 -1.928609 6.361981e-02
```


- Use `broom`



- Hint at the other things hidden in R objects (e.g. the formula and rsquared value in the `lm` object). Using @ and $ to autocomplete and find things





## Process your results {- #process-model-results}

- Calculate VPC/ICC from an lmer models using `model %>% summary %>% as_data_frame()$varcor`




## Printing tables {- #output-tables}



## APA formatting for free {- #apa-output}


A neat trick to avoid [fat finger errors](https://en.wikipedia.org/wiki/Fat-finger_error) is to use functions to automatically display results in APA format. Unfortunately, there isn't a single package which works with all types of model, but it's not too hard switch  between them.



### Chi^2^ {-}

For basic stats the `apa::` package is simple to use. Below we use the `apa::chisq_apa()` function to properly format the results of our chi^2^ test ([see the full chi^2^ example]#crosstabs)):





```r
lego.test <- chisq.test(lego.table)
lego.test
## 
## 	Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  lego.table
## X-squared = 11.864, df = 1, p-value = 0.0005724
```


And we can format in APA like so:


```r
apa::apa(lego.test, print_n=T)
## [1] "$\\chi^2$(1, n = 100) = 11.86, *p* < .001"
```


or using `apastats::` we also get Cramer's V, a measure of effect size:


```r
apastats::describe.chi(lego.table, addN=T)
## [1] "$\\chi^2$(1, _N_ = 100) = 11.86, _p_ < .001, _V_ = .34"
```


#### Inserting results into your text {#inline-apa-format}

If you are using RMarkdown, you can drop formatted results into your text without copying and pasting. Just type the following and the chi^2^ test result is automatically inserted inline in your text:

![Example of inline call to R functions within the text. This is shown as an image, because it would otherwise be hidden in this output (because the function is evaluated when we knit the document)](media/inline-r-example.png)

[Age (4 vs 6 years) was significantly associated with preference for duplo v.s. lego, $\chi^2$(1, _N_ = 100) = 11.86, _p_ < .001, _V_ = .34]{.apa-example}





### T-test {-}


```r
# run the t test
cars.test <- t.test(wt~am,data=mtcars, var.equal=T)
cars.test
## 
## 	Two Sample t-test
## 
## data:  wt by am
## t = 5.2576, df = 30, p-value = 1.125e-05
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  0.8304317 1.8853577
## sample estimates:
## mean in group 0 mean in group 1 
##        3.768895        2.411000
```

And then we can format as APA

```r
apa::apa(cars.test)
## [1] "*t*(30) = 5.26, *p* < .001, *d* = 1.86"
```

[American cars were significantly heavier than foreign cars, 
mean difference=1358lbs; 
*t*(30) = 5.26, *p* < .001, *d* = 1.86]{.apa-example}



### Anova {-}


```r
mpg.anova <- car::Anova(lm(mpg~am*cyl, data=mtcars))

library(apastats)
# extract and format main effect
describe.Anova(mpg.anova, term="am")
## [1] "_F_(1, 28) = 4.28, _p_ = .048"

# and the interaction
describe.Anova(mpg.anova, term="am:cyl")
## [1] "_F_(1, 28) = 3.41, _p_ = .076"
```

[There was no interaction between location of manufacture and number of cylinders, _F_(1, 28) = 3.41, _p_ = .076, but there was a main effect of location of manufacture, _F_(1, 28) = 3.41, _p_ = .076, such that US-made cars had significantly higher fuel consumption than European or Japanese brands (see [Figure X or Table X])]{.apa-example}


<!-- 
TODO add formatting of effect size estimates here

 -->



### Multilevel models {-}


If you have loaded the `lmerTest` package `apastats` can output either coefficients for single parameters, or F tests:


```r
sleep.model <- lmer(Reaction~factor(Days)+(1|Subject), data=lme4::sleepstudy)

#a single coefficient (this is a contrast from the reference category)
describe.glm(sleep.model, term="factor(Days)1")
## [1] "_t_ =  0.75, _p_ = .455"

# or describe the F test for the overall effect of Days
describe.lmtaov(anova(sleep.model), term='factor(Days)')
## [1] "_F_(9, 153.0) = 18.70, _p_ < .001"
```


[There were significant differences in reaction times across the 10 days of the study, _F_(9, 153.0) = 18.70, _p_ < .001 such that reaction latencies tended to increase in duration (see [Figure X]).]{.apa-example}
















### Publication { #publication}


- Save graphics to .pdf format. 

- Use RMarkdown documents to create supplementary online files or appendices for published papers. 

- Wait until you're an expert to [try writing the whole paper in RMarkdown (e.g. with citeproc)](https://kieranhealy.org/blog/archives/2014/01/23/plain-text/).











