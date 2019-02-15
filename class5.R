---
title: 'Data Analysis 3: Week 5'
author: "Alexey Bessudnov"
date: "14 February 2019"
output: github_document
---
  
  ```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
knitr::opts_chunk$set(message = FALSE)
knitr::opts_chunk$set(warning = FALSE)
knitr::opts_chunk$set(cache = TRUE)
```
Plan for today:
  
- Assignment 1: marks and feedback
- Assignment 2
- Tidy data and reshaping
- Homework for next week

## Exercises

1. Join individual-level substantive data for the first three waves of the Understabding Society (*indresp* files). Keep the balanced panel only (i.e. individuals who participated in all three waves). Keep only the following variables: pidp, derived sex and age, and total net personal income (*fimnnet_dv*).

```{r}
library(tidyverse)

w1 <- read_tsv("data/UKDA-6614-tab/tab/ukhls_w1/a_indresp.tab")
w1 <- w1 %>% 
  select(pidp, a_sex_dv, a_age_dv, a_fimnnet_dv)

w2 <- read_tsv("data/UKDA-6614-tab/tab/ukhls_w2/b_indresp.tab")
w2 <- w2 %>% 
  select(pidp, b_sex_dv, b_age_dv, b_fimnnet_dv)

w3 <- read_tsv("data/UKDA-6614-tab/tab/ukhls_w3/c_indresp.tab")
w3 <- w3 %>% 
  select(pidp, c_sex_dv, c_age_dv, c_fimnnet_dv)

joined <- w1 %>% 
  inner_join(w2, by = "pidp") %>% 
  inner_join(w3, by = "pidp")
```

2. Calculate the average difference in monthly income between waves 1 and 2, and waves 2 and 3.

```{r}
joined %>% 
  mutate(diff2_1 = b_fimnnet_dv - a_fimnnet_dv) %>% 
  mutate(diff3_2 = c_fimnnet_dv - b_fimnnet_dv) %>% 
  summarise(
    mean2_1 = mean(diff2_1, na.rm = TRUE),
    mean3_2 = mean(diff3_2, na.rm = TRUE),
    perc2_1 = mean2_1 / mean(a_fimnnet_dv, na.rm = TRUE) * 100,
    perc3_2 = mean3_2 / mean(b_fimnnet_dv, na.rm = TRUE) * 100)
```

3. Estimate and interpret a linear model showing how income is associated with age and sex, for wave 1. Can you do it for all three waves of UndSoc at the same time?

```{r}
# my version... looks wrong
summary(lm(a_fimnnet_dv ~ I(a_age_dv^2) + as.factor(a_sex_dv), joined))

joined %>% 
  mutate(a_sex_dv = ifelse(a_sex_dv == 2, "female",
                           ifelse(a_sex_dv == 1, "male", NA))) %>% 
  mutate(a_age_dv2 = a_age_dv ^ 2) %>% # so that it's non-lineear which more accurate
  do(broom::tidy(lm(a_fimnnet_dv ~ a_sex_dv + a_age_dv + a_age_dv2, .))) # this line to use lm() within a dataframe code chunk

```

4. Reshape the data from the wide to long format (check http://abessudnov.net/dataanalysis3/tidy-data.html).

```{r}
long <- joined %>% 
  gather(a_sex_dv:c_fimnnet_dv, key = "variables", value = "value") %>% 
  separate(variables, into = c("wave", "variable"), sep = "_", extra = "merge") %>% 
  spread(key = variable, value = value)
long

```

5. Estimate a model showing how income depends on age and sex for all three waves, adding dummy variables for wave. Remember that the association between income and age is often non-linear and account for this in your models.

```{r}
long %>% 
   mutate(sex_dv = ifelse(sex_dv == 2, "female",
                           ifelse(sex_dv == 1, "male", NA))) %>% 
  do(broom::tidy(lm(fimnnet_dv ~ sex_dv + age_dv + I(age_dv^2) + wave, .)))
```

6. In the long data set, create two variables showing income in the previous and subsequent wave. Use the *lead* and *lag* window functions from **dplyr**: https://cran.r-project.org/web/packages/dplyr/vignettes/window-functions.html . Summarise the differences in incomes between waves 1 and 2, and 2 and 3.

```{r}

```

7. Use the three original data tables for waves 1 to 3 and combine them in the long format. (check *bind_rows*). Now convert into the wide format. 
