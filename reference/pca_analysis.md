# PCA dimensional reduction analysis for RNA-Seq.

PCA dimensional reduction analysis for RNA-Seq.

## Usage

``` r
pca_analysis(sample_gene, group_sample)
```

## Arguments

- sample_gene:

  Dataframe: All genes in all samples expression dataframe of RNA-Seq
  (1st-col: Genes, 2nd-col~: Samples).

- group_sample:

  Dataframe: Samples and groups for gene expression (1st-col: Samples,
  2nd-col: Groups).

## Value

Table: PCA dimensional reduction analysis for RNA-Seq.

## Author

benben-miao

## Examples

``` r
# 1. Library package TOmicsVis
library(TOmicsVis)

# 2. Load example datasets
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
res <- pca_analysis(gene_expression, samples_groups)
head(res)
#>               PC1         PC2         PC3        PC4         PC5       PC6
#> CT_1   -27010.536 -18328.2803   5955.2569 46547.7319  11394.1043 -7197.285
#> CT_2    16248.651  29132.9251   -824.1857 20747.9618 -18798.8755 21096.088
#> CT_3    22421.017 -26832.3964   6789.4490  5864.1171 -15375.3418 17424.861
#> LT20_1 -18587.073   -472.9036 -21638.7836  7765.9575    114.1225 -3943.968
#> LT20_2  33275.933  -9874.9959 -14991.3942 -7443.9250  -4600.8302 -8072.298
#> LT20_3  -1596.255  11683.5426 -10892.8493   381.0795  11080.3560 -8994.187
#>                PC7        PC8        PC9        PC10        PC11       PC12
#> CT_1     2150.6739   4850.320   4051.745   7666.9445  -3141.9327  -2487.939
#> CT_2   -12329.1138  -3353.734   4805.659   1503.8533  11184.0296  -4865.436
#> CT_3    12744.2255 -10037.516 -11468.842    202.4016 -11001.6260  -3847.291
#> LT20_1   8864.7482 -14171.127  -1968.082  -3562.1899   7446.2105  14831.486
#> LT20_2   -941.3943  -5072.401   5345.106   6494.1383  -3954.2153   9351.346
#> LT20_3   7263.9321  -7774.725  -1853.546 -21427.2641    -46.1503 -12507.011
#>              PC13       PC14          PC15
#> CT_1    -2704.613  2396.7383  4.266986e-11
#> CT_2    -2633.057 -1375.3352  1.484187e-11
#> CT_3     5193.978   188.5601  4.119713e-11
#> LT20_1   3937.457 -7871.8062  1.031765e-10
#> LT20_2 -12904.673  6071.6618 -8.107249e-11
#> LT20_3  -5369.380  2606.1762  5.619822e-11
```
