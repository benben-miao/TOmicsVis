# Table filter used to filter row by column condition.

Table filter used to filter row by column condition.

## Usage

``` r
table_filter(data, ...)
```

## Arguments

- data:

  Dataframe: Length, Width, Weight, and Sex traits dataframe (1st-col:
  Value, 2nd-col: Traits, 3rd-col: Sex).

- ...:

  Expression: multiple expressions.

## Value

Table: table filter used to filter row by column condition.

## Author

benben-miao

## Examples

``` r
# 1. Library TOmicsVis package
library(TOmicsVis)

# 2. Use example dataset
data(traits_sex)
head(traits_sex)
#>   Value Traits    Sex
#> 1 36.74 Weight Female
#> 2 38.54 Weight Female
#> 3 44.91 Weight Female
#> 4 43.53 Weight Female
#> 5 39.03 Weight Female
#> 6 26.01 Weight Female

# 3. Set height > 100 & eye_color == "black"
res <- table_filter(traits_sex, Sex == "Male" & Traits == "Weight" & Value > 40)
head(res)
#>   Value Traits  Sex
#> 1 48.06 Weight Male
#> 2 42.74 Weight Male
#> 3 45.25 Weight Male
#> 4 44.95 Weight Male
#> 5 43.21 Weight Male
#> 6 40.02 Weight Male
```
