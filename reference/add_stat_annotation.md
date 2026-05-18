# Add statistical annotation to plot

Add formatted statistical test results to plots

## Usage

``` r
add_stat_annotation(
  p,
  label,
  x = Inf,
  y = -Inf,
  hjust = 0,
  vjust = 0,
  size = 5
)
```

## Arguments

- p:

  ggplot object: target plot

- label:

  Character: text label to add

- x:

  Numeric: x position. Default: Inf

- y:

  Numeric: y position. Default: -Inf

- hjust:

  Horizontal justification. Default: 0

- vjust:

  Vertical justification. Default: 0

- size:

  Text size. Default: 5

## Value

Enhanced ggplot object
