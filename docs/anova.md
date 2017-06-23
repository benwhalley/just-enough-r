---
title: 'Anova'
output: 
  bookdown::tufte_html2
---




# Anova
  



This intention of this section is to be a kind of cookbook for common types of Anova, and the chapter mostly consists of examples. However, there are some key principles when working with Anova in R that everyone should know:

- R can run any Anova model you wan but.
- R's default settings for Anova are different to those SPSS or Stata.
- You probably _do_ want to change the default settings, or use a package that does this for you.


```r
# options(contrasts = c("contr.helmert", "contr.poly"))
# m <- lm(mpg~factor(cyl)*wt, data=mtcars)
# car::Anova(m, type=3)
# 
# 
# options(contrasts = c("contr.sum", "contr.poly"))
# m <- lm(mpg~factor(cyl)*wt, data=mtcars)
# car::Anova(m, type=3)
# 
# 
# options(contrasts = c("contr.treatment", "contr.poly"))
# m <- lm(mpg~factor(cyl)*wt, data=mtcars)
# car::Anova(m, type=3)
# 
# contrasts(factor(mtcars$cyl))
# 
# library(lmerTest)
# 
# options(contrasts = c("contr.treatment", "contr.poly"))
# anova(lmer(hamd~factor(grp)*factor(month)+(1|patient), data=rf2main))
# 
# 
# options(contrasts = c("contr.helmert", "contr.poly"))
# m <- lmer(hamd~grp*month+(1|patient), data=rf2main)
# anova(lmer(hamd~factor(grp)*factor(month)+(1|patient), data=rf2main), type=2)
# anova(lmer(hamd~factor(grp)*factor(month)+(1|patient), data=rf2main), type=3)
# 
# 
# options(contrasts = c("contr.treatment", "contr.poly"))
# m <- lmer(hamd~grp*month+(1|patient), data=rf2main)
# anova(m)
# lsmeansLT(m)
# drop1(m, test="Chisq")
# options(contrasts = c("contr.sum", "contr.poly"))
# rf2main$grp
# 
# options(contrasts = c("contr.treatment", "contr.poly"))
# m <- lmer(hamd~hamd.b+grp*month+(1|patient), data=rf2main %>% filter(month!="0"))
# 
# lsmeansLT(m, "grp:month")
# library(multcomp)
# glht(m, linfct = c("month12 = 1", "grpTAU=0"))
# leveneTest
# mcp(grp="Tukey"))
# summary(m)
# anova(m, type=2)
# anova(m, type=3)
# lsmeansLT(m)

```



## Anova for between subjects designs

TODO


## Repeated measures 

TODO




