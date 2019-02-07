Data Analysis 3: Class 3
================
Alexey Bessudnov
31 January 2019

Plan for today:

1.  Test assignment.
2.  The **tidyverse** framework (<https://www.tidyverse.org/>).
3.  Reading in data with **readr**.
4.  Transforming data with **dplyr**.
5.  Statistical assignment 1: questions.
6.  Homework for next week.

Importing data: read ch.11 from R for Data Science (Data import): <https://r4ds.had.co.nz/data-import.html> and ch.2 from my website (Read data): <http://abessudnov.net/dataanalysis3/readdata.html>.

``` r
library(tidyverse)
Data <- read_tsv("data/UKDA-6614-tab/tab/ukhls_wx/xwavedat.tab")
```

This is a cross-wave data file with stable characteristics of individuals. See the codebook at <https://www.understandingsociety.ac.uk/documentation/mainstage/dataset-documentation/wave/xwave/datafile/xwavedat>.

See the dplyr cheetsheet: <https://github.com/rstudio/cheatsheets/blob/master/data-transformation.pdf>

Exercises.

1.  Select the variables for: sex (derived), date of bith (derived), ethnic group (racel\_dv). Also keep the cross-wave identifier (pidp) and the sample origin variable (memorig).

``` r
subset(Data, select = c("pidp", "memorig", "sex_dv", "doby_dv", "racel_dv"))
```

    ## # A tibble: 145,779 x 5
    ##     pidp memorig sex_dv doby_dv racel_dv
    ##    <dbl>   <dbl>  <dbl>   <dbl>    <dbl>
    ##  1   687       3    -20     -20        1
    ##  2  1367       3    -20     -20       15
    ##  3  2051       3    -20     -20       15
    ##  4  2727       3    -20     -20       97
    ##  5  3407       3    -20     -20        1
    ##  6  4091       3    -20     -20        1
    ##  7  4767       3    -20     -20        1
    ##  8  5451       3    -20     -20        1
    ##  9  6135       3    -20     -20        1
    ## 10  6807       3    -20     -20        1
    ## # … with 145,769 more rows

``` r
## method 1
```

``` r
select(Data, pidp, memorig, sex_dv, doby_dv, racel_dv)
```

    ## # A tibble: 145,779 x 5
    ##     pidp memorig sex_dv doby_dv racel_dv
    ##    <dbl>   <dbl>  <dbl>   <dbl>    <dbl>
    ##  1   687       3    -20     -20        1
    ##  2  1367       3    -20     -20       15
    ##  3  2051       3    -20     -20       15
    ##  4  2727       3    -20     -20       97
    ##  5  3407       3    -20     -20        1
    ##  6  4091       3    -20     -20        1
    ##  7  4767       3    -20     -20        1
    ##  8  5451       3    -20     -20        1
    ##  9  6135       3    -20     -20        1
    ## 10  6807       3    -20     -20        1
    ## # … with 145,769 more rows

``` r
## method 2, less faff
```

``` r
Data <- Data %>%
  select(pidp, memorig, sex_dv, doby_dv, racel_dv)
## method 3, using pipes, auto showing the names of variables from the dataset, thus less likely to make typos.
```

1.  Filter the data to keep (in new data frames): a) men only. b) people born before 1950 and after 1975. c) men of Pakistani origin born in 1958 or 1982.

``` r
new1 <- Data %>%
  filter(sex_dv == 1)

new2 <- Data %>%
  filter((doby_dv > 0 & doby_dv < 1950) | doby_dv > 1975) 

new3 <- Data %>%
  filter(sex_dv == 1 & racel_dv == 10 & (doby_dv == 1958 | doby_dv == 1982))
```

1.  people born within the range of 1950 and 1975

``` r
Data %>%
  filter(doby_dv %in% 1950:1975) %>%
  head(3)
```

    ## # A tibble: 3 x 5
    ##     pidp memorig sex_dv doby_dv racel_dv
    ##    <dbl>   <dbl>  <dbl>   <dbl>    <dbl>
    ## 1  15645       3      2    1956        1
    ## 2 223725       3      1    1975        1
    ## 3 496405       3      1    1975        1

Discuss: logical operators.

1.  Recode birth year into cohorts (a new variable): the G.I. Generation (born before 1924), Silent Generation (1925-42), Baby Boomers (1943-65), Generation X (1966-1980), Millenials (1981-99), Generation Z (2000-). (The years are approximate.)

``` r
Data <- Data %>%
  mutate(generation = case_when(
    between(doby_dv, 0, 1924) ~ "G.I. Generation",
    between(doby_dv, 1925, 1942) ~ "Silent Generation",
    between(doby_dv, 1943, 1965) ~ "Baby Boomers",
    between(doby_dv, 1966, 1980) ~ "Generation X",
    between(doby_dv, 1981, 1999) ~ "Millenials",
    doby_dv >= 2000 ~ "Generation Z"
  ))
Data %>% 
  pull(generation) %>% 
  class()
```

    ## [1] "character"

``` r
Data %>% 
  pull(generation) %>% 
  table()
```

    ## .
    ##      Baby Boomers   G.I. Generation      Generation X      Generation Z 
    ##             28263              1129             23643             22060 
    ##        Millenials Silent Generation 
    ##             33340             10162

1.  Recode ethnicity into the following groups: white British, Other White, Indian, Pakistani, other. (This classification doesn't make much sense, but we're doing this as an exercise).

Discuss: numeric and character vectors (strings), factors. Missing values in R.

1.  Count the number of people belonging to different ethnic groups (and produce percentages).

``` r
Data %>%
  count(racel_dv) %>%
  mutate(perc = n/ sum(n) * 100)
```

    ## # A tibble: 19 x 3
    ##    racel_dv     n    perc
    ##       <dbl> <int>   <dbl>
    ##  1       -9 47559 32.6   
    ##  2        1 75100 51.5   
    ##  3        2  2069  1.42  
    ##  4        3    27  0.0185
    ##  5        4  3302  2.27  
    ##  6        5   614  0.421 
    ##  7        6   260  0.178 
    ##  8        7   383  0.263 
    ##  9        8   353  0.242 
    ## 10        9  3574  2.45  
    ## 11       10  3125  2.14  
    ## 12       11  1957  1.34  
    ## 13       12   501  0.344 
    ## 14       13  1051  0.721 
    ## 15       14  1919  1.32  
    ## 16       15  2726  1.87  
    ## 17       16   197  0.135 
    ## 18       17   507  0.348 
    ## 19       97   555  0.381

1.  Summarise the proportion of white British by generation.

``` r
Data %>%
  filter(racel_dv != -9) %>%
  mutate(whiteBritish = if_else(racel_dv == 1, 1, 0)) %>%
  group_by(generation) %>%
  summarise(
    propWhiteBritish = mean(whiteBritish, na.rm = TRUE) * 100
  )
```

    ## # A tibble: 7 x 2
    ##   generation        propWhiteBritish
    ##   <chr>                        <dbl>
    ## 1 Baby Boomers                  80.7
    ## 2 G.I. Generation               92.5
    ## 3 Generation X                  64.7
    ## 4 Generation Z                  59.9
    ## 5 Millenials                    64.2
    ## 6 Silent Generation             87.0
    ## 7 <NA>                          93.0

1.  Summarise the proportion of women by birth year.

``` r
Data %>%
  mutate(women = if_else(sex_dv == 2, 1, 0)) %>% 
  group_by(doby_dv) %>% 
  summarise(
    propWomen = mean(women, na.rm = TRUE) * 100
  )
```

    ## # A tibble: 112 x 2
    ##    doby_dv propWomen
    ##      <dbl>     <dbl>
    ##  1     -20       0  
    ##  2      -9      43.2
    ##  3    1908     100  
    ##  4    1910     100  
    ##  5    1911      25  
    ##  6    1912      76.9
    ##  7    1913      72.2
    ##  8    1914      80  
    ##  9    1915      40.9
    ## 10    1916      73.8
    ## # … with 102 more rows
