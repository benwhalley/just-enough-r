
-- title: 'Summarising data'

---

# Summaries {#summarising-data}



Before you begin this section, make sure you have fully understood the section
on [datasets and dataframes](datasets.html), and in particular that you are
happy using the `%>%` symbol to [describe a flow of data](#pipes).

Although R contains many functions like `table`, or `xtabs`, `describe` or
`summarise` which you might see used elsewhere to tabulate or summarise data,
for beginners these base-R functions can be confusing; their names and input
names are not always consistent, and they don't always work together nicely.

Instead we recommend using `dplyr` and other parts of the tidyverse because they
provide a general set of tools to make any kind of table or summary.

They also encourage more coherent thinking about _what summary is really
needed_, rather than accepting or fighting with default options.

## A generalised approach {- #dplyr-general}

#### The 'split, apply, combine' model {- #split-apply-combine}

The `dplyr::` package, and especially the `summarise()` function provides a
generalised way to create dataframes of frequencies and other summary
statistics, grouped and sorted however we like.

**Each of the `dplyr` 'verbs' acts on a dataframe in some way, and returns a
dataframe as it's result. This is convenient because we can chain together the
different verbs to describe exactly the table we want.**

For example, let's say we want the mean of some of our variables across the
whole dataframe:


```r
angry.moods %>%
  summarise(
    mean.anger.out=mean(Anger.Out),
    sd.anger.out=sd(Anger.Out)
  )
# A tibble: 1 x 2
  mean.anger.out sd.anger.out
           <dbl>        <dbl>
1           16.1         4.22
```

:::{.explainer}

Here the `summarise` function accepts the `angry.moods` dataframe as an input,
and has returned a dataframe containing the statistics we need. In this instance
the result dataframe only has one row.

:::

What if we want the numbers for men and women separately?

The key is to think about what we want to achieve, and work out how to describe
it. However, in general, we will often want to follow this pattern:

-   _Split_ our data (into men and women, or some other categorisation)
-   _Apply_ some operation (function) to each group individually (e.g. calculate
    the mean)
-   _Combine_ it into a single table again

It's helpful to think of this _split $\rightarrow$ apply $\rightarrow$ combine_
pattern whenever we are processing data because it _makes explicit what we want
to do_.

#### Split: breaking the data into groups {-}

The first task is to organise our dataframe into the relevant groups. To do this
we use `group_by()`:


```r
angry.moods %>%
  group_by(Gender) %>%
  glimpse
Observations: 78
Variables: 7
Groups: Gender [2]
$ Gender           <dbl> 2, 2, 2, 2, 1, 1, 1, 2, 2, 2, 1, 1, 1, 1, 2, ...
$ Sports           <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, ...
$ Anger.Out        <dbl> 18, 14, 13, 17, 16, 16, 12, 13, 16, 12, 12, 1...
$ Anger.In         <dbl> 13, 17, 14, 24, 17, 22, 12, 16, 16, 16, 13, 2...
$ Control.Out      <dbl> 23, 25, 28, 23, 26, 25, 31, 22, 22, 29, 24, 2...
$ Control.In       <dbl> 20, 24, 28, 23, 28, 23, 27, 31, 24, 29, 25, 2...
$ Anger.Expression <dbl> 36, 30, 19, 43, 27, 38, 14, 24, 34, 18, 24, 4...
```

Weirdly, this doesn't seem to have done anything. The data aren't sorted by
`Gender`, and there is no visible sign of the grouping, but stick with it... the
grouping is there and the effect will be clearer in a moment.

#### Apply and combine {-}

Continuing the example above, once we have grouped our data we can then _apply_
a function to it — for example, we can summarise each group by taking the mean
of the `Anger.Out` variable:


```r
angry.moods %>%
  group_by(Gender) %>%
  summarise(
    mean.anger.out=mean(Anger.Out)
  )
# A tibble: 2 x 2
  Gender mean.anger.out
   <dbl>          <dbl>
1      1           16.6
2      2           15.8
```

The **combine** step happens automatically for us: `dplyr` has combined the
summaries of each gender into a single dataframe for us.

In summary, we:

-   _split_ the data by `Gender`, using `group_by()`
-   _apply_ the `summarise()` function
-   _combine_ the results into a new data frame (happens automatically)

#### A 'real' example {-}

Imagine we have raw data from a study which had measured depression with the
PHQ-9 scale.

Each `patient` was measured on numerous occasions (the `month` of observation is
recorded), and were split into treatment `group` (0=control, 1=treatment). The
`phq9` variable is calculated as the sum of all their questionnaire responses.




```r
phq9.df %>% glimpse
Observations: 2,429
Variables: 4
$ patient <dbl> 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, ...
$ group   <dbl> 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, ...
$ month   <dbl> 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 18, 0, 1,...
$ phq9    <dbl> 2.56, 2.33, 1.89, 2.00, 2.44, 2.33, 2.44, 2.11, 2.22, ...
```

If this were our data we might want to:

-   Calculate the average PHQ-9 score at each month, and in each group
-   Show these means by group for months 0, 7 and 12

We can do this using `group_by` and `summarise`:


```r
phq9.df %>%
  group_by(group) %>%
  summarise(average_phq9 = mean(phq9))
# A tibble: 2 x 2
  group average_phq9
  <dbl>        <dbl>
1     0         1.87
2     1         1.60
```

:::{.exercise}

You can load the PHQ9 data above by typing:


```r
# remeber to load the tidyverse package first
phq9 <- read_csv('data/phq-summary.csv')
Parsed with column specification:
cols(
  patient = col_double(),
  group = col_double(),
  month = col_double(),
  phq9 = col_double()
)
```

Try to edit the code above to:

-   Create summary table with the mean at each month
-   The mean at each month, in each group
-   The mean and SD by month and group

:::
