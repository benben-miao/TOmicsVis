# UMAP analysis for analyzing RNA-Seq data.

UMAP analysis for analyzing RNA-Seq data.

## Usage

``` r
umap_analysis(sample_gene, group_sample, seed = 1, method = "naive")
```

## Arguments

- sample_gene:

  Dataframe: gene expression dataframe (1st-col: Transcripts or Genes,
  2nd-col~: Samples).

- group_sample:

  Dataframe: Samples and groups for gene expression (1st-col: Samples,
  2nd-col: Groups).

- seed:

  Numeric: set seed for robust result. Default: 1.

- method:

  Character: 'naive' (an implementation written in pure R) and
  'umap-learn' (requires python package 'umap-learn').

## Value

Table: UMAP analysis for analyzing RNA-Seq data.

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

# 3. Default parameters
res <- umap_analysis(gene_expression, samples_groups)
head(res)
#>              UMAP1       UMAP2
#> CT_1    0.39894968  0.39023545
#> CT_2   -0.60445627 -0.40203491
#> CT_3    1.09099797 -0.10852843
#> LT20_1 -0.09000485  0.08849396
#> LT20_2  0.99760329 -0.84753825
#> LT20_3 -0.42657219 -1.20536760
```
