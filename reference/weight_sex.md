# Weight and Sex traits dataframe.

Weight and Sex traits dataframe.

## Usage

``` r
data(weight_sex)
```

## Format

Dataframe: Weight and Sex traits dataframe (1st-col: Weight, 2nd-col:
Sex).

## References

https://github.com/BioSciTools/BioSciToolsDatasets/tree/main/QuantileQuantile/

## Author

benben-miao

## Examples

``` r
# 1. Library TOmicsVis package
library(TOmicsVis)

# 2. Load example data
data(weight_sex)

# 3. View example data
weight_sex
#>     Weight    Sex
#> 1    36.74 Female
#> 2    38.54 Female
#> 3    44.91 Female
#> 4    43.53 Female
#> 5    39.03 Female
#> 6    26.01 Female
#> 7    29.59 Female
#> 8    33.08 Female
#> 9    45.21 Female
#> 10   38.05 Female
#> 11   39.48 Female
#> 12   32.13 Female
#> 13   41.42 Female
#> 14   30.82 Female
#> 15   37.90 Female
#> 16   33.64 Female
#> 17   39.67 Female
#> 18   45.27 Female
#> 19   34.44 Female
#> 20   33.59 Female
#> 21   46.57 Female
#> 22   34.47 Female
#> 23   46.02 Female
#> 24   26.08 Female
#> 25   46.16 Female
#> 26   28.38 Female
#> 27   32.75 Female
#> 28   39.50 Female
#> 29   42.16 Female
#> 30   29.23 Female
#> 31   43.36 Female
#> 32   36.43 Female
#> 33   25.98 Female
#> 34   31.89 Female
#> 35   31.38 Female
#> 36   31.51 Female
#> 37   32.73 Female
#> 38   39.31 Female
#> 39   34.33 Female
#> 40   36.88 Female
#> 41   37.24 Female
#> 42   33.57 Female
#> 43   33.32 Female
#> 44   48.36 Female
#> 45   29.55 Female
#> 46   34.98 Female
#> 47   30.03 Female
#> 48   32.89 Female
#> 49   42.65 Female
#> 50   40.30 Female
#> 51   35.54 Female
#> 52   41.79 Female
#> 53   28.87 Female
#> 54   33.32 Female
#> 55   43.62 Female
#> 56   40.84 Female
#> 57   47.42 Female
#> 58   46.15 Female
#> 59   33.54 Female
#> 60   38.28 Female
#> 61   34.52 Female
#> 62   47.90 Female
#> 63   27.03 Female
#> 64   28.78 Female
#> 65   29.48 Female
#> 66   32.57 Female
#> 67   27.36 Female
#> 68   45.46 Female
#> 69   38.97 Female
#> 70   36.67 Female
#> 71   35.33 Female
#> 72   34.71 Female
#> 73   46.67 Female
#> 74   36.90 Female
#> 75   32.07 Female
#> 76   39.46 Female
#> 77   25.48 Female
#> 78   36.97 Female
#> 79   47.20 Female
#> 80   37.25 Female
#> 81   44.09 Female
#> 82   43.06 Female
#> 83   34.93 Female
#> 84   36.34 Female
#> 85   28.48 Female
#> 86   29.40 Female
#> 87   26.94 Female
#> 88   41.15 Female
#> 89   33.47 Female
#> 90   28.32 Female
#> 91   40.16 Female
#> 92   30.22 Female
#> 93   29.42 Female
#> 94   25.97 Female
#> 95   34.67 Female
#> 96   27.35 Female
#> 97   46.19 Female
#> 98   30.79 Female
#> 99   43.49 Female
#> 100  35.42 Female
#> 101  48.06   Male
#> 102  36.80   Male
#> 103  39.98   Male
#> 104  39.51   Male
#> 105  42.74   Male
#> 106  31.61   Male
#> 107  38.76   Male
#> 108  34.81   Male
#> 109  45.25   Male
#> 110  39.65   Male
#> 111  44.95   Male
#> 112  29.90   Male
#> 113  30.96   Male
#> 114  36.78   Male
#> 115  43.21   Male
#> 116  40.02   Male
#> 117  35.01   Male
#> 118  34.84   Male
#> 119  44.65   Male
#> 120  47.32   Male
#> 121  45.44   Male
#> 122  39.63   Male
#> 123  28.20   Male
#> 124  42.06   Male
#> 125  42.11   Male
#> 126  42.66   Male
#> 127  30.69   Male
#> 128  39.11   Male
#> 129  38.78   Male
#> 130  43.42   Male
#> 131  27.85   Male
#> 132  36.94   Male
#> 133  39.86   Male
#> 134  35.74   Male
#> 135  33.50   Male
#> 136  27.45   Male
#> 137  45.66   Male
#> 138  48.13   Male
#> 139  33.39   Male
#> 140  43.16   Male
#> 141  29.07   Male
#> 142  34.13   Male
#> 143  42.51   Male
#> 144  43.36   Male
#> 145  33.32   Male
#> 146  45.76   Male
#> 147  28.52   Male
#> 148  30.45   Male
#> 149  31.87   Male
#> 150  30.56   Male
#> 151  32.39   Male
#> 152  29.56   Male
#> 153  39.86   Male
#> 154  45.90   Male
#> 155  31.16   Male
#> 156  25.86   Male
#> 157  41.91   Male
#> 158  35.11   Male
#> 159  27.65   Male
#> 160  29.29   Male
#> 161  29.40   Male
#> 162  43.58   Male
#> 163  37.42   Male
#> 164  43.23   Male
#> 165  43.20   Male
#> 166  41.15   Male
#> 167  29.53   Male
#> 168  26.67   Male
#> 169  45.51   Male
#> 170  44.10   Male
#> 171  30.42   Male
#> 172  38.93   Male
#> 173  44.09   Male
#> 174  34.60   Male
#> 175  43.78   Male
#> 176  27.19   Male
#> 177  30.61   Male
#> 178  38.21   Male
#> 179  37.95   Male
#> 180  46.62   Male
#> 181  46.32   Male
#> 182  40.38   Male
#> 183  44.88   Male
#> 184  28.48   Male
#> 185  38.23   Male
#> 186  36.62   Male
#> 187  39.93   Male
#> 188  31.18   Male
#> 189  47.54   Male
#> 190  42.75   Male
#> 191  48.24   Male
#> 192  37.09   Male
#> 193  36.49   Male
#> 194  43.54   Male
#> 195  46.83   Male
#> 196  34.19   Male
#> 197  34.27   Male
#> 198  33.22   Male
#> 199  42.54   Male
#> 200  44.18   Male
```
