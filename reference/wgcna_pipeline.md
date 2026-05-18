# WGCNA analysis pipeline for RNA-Seq.

WGCNA analysis pipeline for RNA-Seq.

## Usage

``` r
wgcna_pipeline(
  sample_gene,
  group_sample,
  R_cutofff = 0.85,
  max_block = 5000,
  min_module = 20,
  network_type = "unsigned",
  merge_cutoff = 0.15,
  cor_type = "pearson",
  na_color = "#cdcdcd",
  xlab_angle = 45,
  text_size = 0.7
)
```

## Arguments

- sample_gene:

  Dataframe: All genes in all samples expression dataframe of RNA-Seq
  (1st-col: Genes, 2nd-col~: Samples).

- group_sample:

  Dataframe: Samples and groups for gene expression (1st-col: Samples,
  2nd-col: Groups).

- R_cutofff:

  Numeric: Rsquare cutoff. Default: 0.85, min: 0.00, max: 1.00.

- max_block:

  Numeric: max block size. Default: 5000.

- min_module:

  Numeric: min module gene number. Default: 20.

- network_type:

  Character: network type. Default: "unsigned", options: "unsigned",
  "signed", "signed hybrid".

- merge_cutoff:

  Numeric: merge modules cutoff. Default: 0.15.

- cor_type:

  Character: correlation type. Default: "pearson", options: "pearson",
  "bicor".

- na_color:

  Character: NA value color (color name or hex value). Default:
  "#cdcdcd".

- xlab_angle:

  Numeric: X axis lable angle. Default: 45, min: 0, max: 360.

- text_size:

  Numeric: cell text size. Default: 0.7, min: 0, max: NULL.

## Value

WGCNA results in tempdir() directory of current session.

## Author

benben-miao

## Examples

``` r
# 1. Library TOmicsVis package
library(TOmicsVis)

# 2. Use example dataset
data(gene_expression)
head(gene_expression)
#>              Genes   CT_1   CT_2   CT_3 LT20_1 LT20_2 LT20_3 LT15_1 LT15_2
#> 1     transcript_0 655.78 631.08 669.89 654.21 402.56 447.09 510.08 442.22
#> 2     transcript_1  92.72 112.26 150.30  88.35  76.35  94.55 120.24  80.89
#> 3    transcript_10  21.74  31.11  22.58  15.09  13.67  13.24  12.48   7.53
#> 4   transcript_100   0.00   0.00   0.00   0.00   0.00   0.00   0.00   0.00
#> 5  transcript_1000   0.00  14.15  36.01   0.00   0.00 193.59 208.45   0.00
#> 6 transcript_10000  89.18 158.04  86.28  82.97 117.78 102.24 129.61 112.73
#>   LT15_3 LT12_1 LT12_2 LT12_3 LT12_6_1 LT12_6_2 LT12_6_3
#> 1 399.82 483.30 437.89 444.06   405.43   416.63   464.75
#> 2  73.94  96.25  82.62  85.48    65.12    61.94    73.44
#> 3  13.35  11.16  11.36   6.96     7.82     4.01    10.02
#> 4   0.00   0.00   0.00   0.00     0.00     0.00     0.00
#> 5 232.40 148.58   0.00 181.61     0.02    12.18     0.00
#> 6  85.70  80.89 124.11 115.25   113.87   107.69   119.83

data(samples_groups)
head(samples_groups)
#>   Samples Groups
#> 1    CT_1     CT
#> 2    CT_2     CT
#> 3    CT_3     CT
#> 4  LT20_1   LT20
#> 5  LT20_2   LT20
#> 6  LT20_3   LT20
```
