# Chord plot for visualizing the relationships of pathways and genes.

Chord plot is used to visualize complex relationships between samples
and genes, as well as between pathways and genes.

## Usage

``` r
chord_plot(
  data,
  multi_colors = "VividColors",
  color_alpha = 0.3,
  link_visible = TRUE,
  link_dir = -1,
  link_type = "diffHeight",
  sector_scale = "Origin",
  width_circle = 3,
  dist_name = 3,
  label_dir = "Vertical",
  dist_label = 0.3,
  label_scale = 0.8
)
```

## Arguments

- data:

  Dataframe: Shared DEGs of all paired comparisons in all samples
  expression dataframe of RNA-Seq. (1st-col: Genes, 2nd-col~: Samples).

- multi_colors:

  Character: color palette. Default: "VividColors", options:
  "VividColors", "RainbowColors".

- color_alpha:

  Numeric: color alpha. Default: 0.50, min: 0.00, max: 1.00.

- link_visible:

  Logical: links visible. Default: TRUE, options: TRUE, FALSE.

- link_dir:

  Numeric: links direction, use with link_type. Default: -1, options:
  -1, 0, 1, 2.

- link_type:

  Character: links type, use with link_dir. Default: "diffHeight",
  options: "diffHeight", "arrows".

- sector_scale:

  Character: sector scale method. Default: "Origin", options: "Origin",
  "Scale".

- width_circle:

  Numeric: outside circle width. Default: 3.0, min: 0.0, max: 10.0.

- dist_name:

  Numeric: the distance of name and circle. Default: 3.0, min: 0.0, max:
  10.0.

- label_dir:

  Character: label director. Default: "Vertical", options: "Horizontal",
  "Vertical".

- dist_label:

  Numeric: the distance of label and circle. Default: 0.3, min: 0.0.

- label_scale:

  Numeric: labels font size sclae. Default: 0.8, min: 0, max: NULL.

## Value

Plot: chord plot is used to visualize complex relationships between
samples and genes, as well as between pathways and genes.

## Author

benben-miao

## Examples

``` r
# 1. Library TOmicsVis package
library(TOmicsVis)

# 2. Use example dataset
data(gene_expression2)
head(gene_expression2)
#>   Genes  CT_1    CT_2  CT_3 LT20_1 LT20_2 LT20_3 LT15_1 LT15_2 LT15_3 LT12_1
#> 1 ACAA2 24.50   39.83 55.38 114.11 159.32  96.88 169.56 464.84 182.66 116.08
#> 2  ACAN 14.97   18.71 10.30  71.23 142.67 213.54 253.15 320.80 104.15 174.02
#> 3  ADH1  1.54    1.56  2.04  14.95  13.60  15.87  12.80  17.74   6.06  10.97
#> 4  AHSG  0.00 1911.99  0.00   0.00   0.00   0.00   0.00   0.00   0.00   0.00
#> 5 ALDH2  2.07    2.86  2.54   0.85   0.49   0.47   0.42   0.13   0.26   0.00
#> 6 AP1S3  6.62   14.59  9.30  24.90  33.94  23.19  24.00  36.08  27.40  24.06
#>   LT12_2 LT12_3 LT12_6_1 LT12_6_2 LT12_6_3
#> 1 497.29 464.48   471.43   693.62   229.77
#> 2 305.81 469.48  1291.90   991.90   966.77
#> 3  10.71  30.95     9.84    10.91     7.28
#> 4   0.00   0.00     0.00     0.00     0.00
#> 5   0.28   0.11     0.37     0.15     0.11
#> 6  38.74  34.54    62.72    41.36    28.75

# 3. Default parameters
chord_plot(gene_expression2[1:20,])

#>      rn   cn value1 value2 o1 o2      x1     x2       col
#> 1 ACAA2 CT_1  24.50  24.50 15 20 3779.75 302.44 #E248C9B2
#> 2  ACAN CT_1  14.97  14.97 15 19 5349.40 277.94 #E6A17DB2
#> 3  ADH1 CT_1   1.54   1.54 15 18  166.82 262.97 #DFE9E0B2
#> 4  AHSG CT_1   0.00   0.00 15 17 1911.99 261.43 #B7E2B9B2
#> 5 ALDH2 CT_1   2.07   2.07 15 16   11.11 261.43 #B7E681B2
#> 6 AP1S3 CT_1   6.62   6.62 15 15  430.19 259.36 #69AB9AB2
```
