# Safe data preprocessing

Preprocess data frame/matrix with NA handling and validation

## Usage

``` r
safe_preprocess_data(data, min_cols = 1, remove_na = TRUE)
```

## Arguments

- data:

  Data.frame or Matrix: input data

- min_cols:

  Integer: minimum number of columns required. Default: 1

- remove_na:

  Logical: remove rows with NA in first column. Default: TRUE

## Value

Processed data.frame
