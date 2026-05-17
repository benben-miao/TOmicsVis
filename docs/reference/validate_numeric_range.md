# Validate numeric range

Validate if numeric value is within specified range

## Usage

``` r
validate_numeric_range(x, param_name = "x", min_val = 0, max_val = NULL)
```

## Arguments

- x:

  Numeric: value to validate

- param_name:

  Character: parameter name for error message

- min_val:

  Numeric: minimum allowed value (inclusive). Default: 0

- max_val:

  Numeric: maximum allowed value (inclusive). Default: NULL (no max)

## Value

Logical: TRUE if within range (invisible)
