# Load TOmicsVis package without display warnings

Helper function to load TOmicsVis while suppressing harmless display
warnings from Mfuzz dependency

## Usage

``` r
load_TOmicsVis()
```

## Value

Invisible NULL. Loads TOmicsVis into the session namespace

## Examples

``` r
# Use this instead of library(TOmicsVis)
load_TOmicsVis()
#> [OK] TOmicsVis v0.99.0 loaded successfully!
#>   All functions ready to use.

# Then use all functions normally
data(gene_expression)
data(degs_stats)
volcano_plot(degs_stats)
#> Warning: The `size` argument of `element_rect()` is deprecated as of ggplot2 3.4.0.
#> ℹ Please use the `linewidth` argument instead.
#> ℹ The deprecated feature was likely used in the EnhancedVolcano package.
#>   Please report the issue to the authors.

```
