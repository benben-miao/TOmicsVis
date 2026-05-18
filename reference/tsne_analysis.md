# TSNE analysis for analyzing and visualizing TSNE algorithm.

TSNE analysis for analyzing and visualizing TSNE algorithm.

## Usage

``` r
tsne_analysis(sample_gene, group_sample, tsne_dims = 2)
```

## Arguments

- sample_gene:

  Dataframe: All genes in all samples expression dataframe of RNA-Seq
  (1st-col: Genes, 2nd-col~: Samples).

- group_sample:

  Dataframe: Samples and groups for gene expression (1st-col: Samples,
  2nd-col: Groups).

- tsne_dims:

  Numeric: TSNE dimensionality number. Default: 2.

## Value

Table: TSNE analysis for analyzing and visualizing TSNE algorithm.

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
res <- tsne_analysis(gene_expression, samples_groups)
head(res)
#>         TSNE1       TSNE2
#> 1 -17.4821306    6.498886
#> 2 -12.0952975 -107.498099
#> 3 -50.4682222  133.666722
#> 4 -13.0580773  -23.643563
#> 5 -47.9560920  103.631983
#> 6  -0.7416114  -39.085967

# 4. Set tsne_dims = 3
res <- tsne_analysis(gene_expression, samples_groups, tsne_dims = 3)
head(res)
#>       TSNE1     TSNE2     TSNE3
#> 1 -72.27937 -21.90071  54.69879
#> 2  34.31063  21.17806  63.31632
#> 3  48.72947 140.07721 -70.57131
#> 4 -53.02895 -28.35836  21.52661
#> 5  42.88914  90.01099 -49.15126
#> 6 -26.35944 -25.89054  19.17322
```
