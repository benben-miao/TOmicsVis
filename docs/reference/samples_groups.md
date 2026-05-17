# Samples and groups for gene expression.

Samples and groups for gene expression.

## Usage

``` r
data(samples_groups)
```

## Format

Dataframe: Samples and groups for gene expression (1st-col: Samples,
2nd-col: Groups).

## References

https://github.com/BioSciTools/BioSciToolsDatasets/tree/main/PCAplot/

## Author

benben-miao

## Examples

``` r
# 1. Library TOmicsVis package
library(TOmicsVis)

# 2. Load example dataset samples_groups
data(samples_groups)

# 3. View samples_groups
samples_groups
#>     Samples Groups
#> 1      CT_1     CT
#> 2      CT_2     CT
#> 3      CT_3     CT
#> 4    LT20_1   LT20
#> 5    LT20_2   LT20
#> 6    LT20_3   LT20
#> 7    LT15_1   LT15
#> 8    LT15_2   LT15
#> 9    LT15_3   LT15
#> 10   LT12_1   LT12
#> 11   LT12_2   LT12
#> 12   LT12_3   LT12
#> 13 LT12_6_1 LT12_6
#> 14 LT12_6_2 LT12_6
#> 15 LT12_6_3 LT12_6
```
