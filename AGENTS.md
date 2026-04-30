# AGENTS.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project type
- This repository is an R package (`DESCRIPTION`, `NAMESPACE`, `R/`, `man/`, `data/`) named `TOmicsVis`.
- It also ships a full Shiny app at `inst/shinyapp/app.R`, launched by `TOmicsVis::tomicsvis()`.

## Common commands
Run commands from the repository root.

### Install dependencies and package locally
- Install Bioconductor prerequisites used by this package:
  - `R -q -e 'install.packages("BiocManager"); BiocManager::install(c("ComplexHeatmap","EnhancedVolcano","clusterProfiler","enrichplot","impute","preprocessCore","Mfuzz"))'`
- Install package for local development:
  - `R -q -e 'install.packages("devtools"); devtools::install(".")'`

### Run the Shiny app
- Launch packaged app entrypoint:
  - `R -q -e 'TOmicsVis::tomicsvis()'`
- Run app source directly (binds to port 6767 inside `app.R`):
  - `R -q -e 'source("inst/shinyapp/app.R")'`

### Build, check, and docs
- Full package check (closest thing to CI in this repo):
  - `R -q -e 'devtools::check()'`
- Build source tarball:
  - `R CMD build .`
- Regenerate Rd docs/NAMESPACE from roxygen comments:
  - `R -q -e 'devtools::document()'`
- Rebuild pkgdown site:
  - `R -q -e 'pkgdown::build_site()'`

### Tests and focused validation
- There is currently no `tests/testthat` suite in this repository.
- For focused validation of one feature/function, run one example topic:
  - `R -q -e 'devtools::run_examples(topic = "quantile_plot")'`
- Run one function directly with bundled data:
  - `R -q -e 'library(TOmicsVis); data(weight_sex); quantile_plot(weight_sex)'`

## High-level architecture
### 1) Package API surface
- `NAMESPACE` exports many user-facing functions grouped into six analysis families:
  1. Samples statistics
  2. Traits analysis
  3. Differential expression analysis
  4. Advanced analysis
  5. GO/KEGG enrichment
  6. Table operations
- Each feature is typically implemented in one file under `R/` and documented via roxygen.

### 2) Data-flow pattern used by most `R/*.R` functions
- Input convention is column-position based (e.g., first column is gene/sample identifier, remaining columns are measurements/groups).
- Typical function structure:
  - coerce input to `data.frame`
  - reshape/filter data
  - compute statistics/enrichment/network/dimension reduction
  - return either a plot object/base plot side effect or a result table
- Many plotting functions map string options (theme, palette, shape) to `ggplot2`/`ggsci` settings via large `if/else` blocks.

### 3) Shiny app orchestration
- `R/tomicsvis.R` is a thin wrapper that locates `inst/shinyapp` and calls `shiny::runApp`.
- `inst/shinyapp/app.R` is a large monolithic UI+server script:
  - Sidebar tabs mirror exported function families.
  - Each tab typically has:
    - input table upload (`fileInput`)
    - parameter controls
    - `renderPlot` / `renderDT`
    - `downloadHandler` that re-runs the same underlying package function and saves output (often via `ggsave` or `write.table`).
  - Defaults usually load packaged example datasets (`data(...)`) when no file is uploaded.
- Most product behavior changes require edits in both places:
  - underlying function in `R/*.R`
  - corresponding UI/server wiring in `inst/shinyapp/app.R`

### 4) Generated and content directories
- `man/`: generated Rd docs from roxygen.
- `data/`: packaged example `.rda` datasets heavily used by README, vignettes, and Shiny defaults.
- `vignettes/Tutorials.Rmd`: long-form tutorial source.
- `docs/` + `_pkgdown.yml`: pkgdown website output/config.
- `.Rbuildignore` excludes website/project artifacts from package builds.

### 5) Practical editing guidance
- Keep function argument semantics aligned with README/vignette examples; examples are a key interface for users.
- When changing function signatures, update:
  - roxygen comments in `R/*.R`
  - generated docs (`devtools::document()`)
  - any matching Shiny controls in `inst/shinyapp/app.R`
  - tutorial snippets in `README.md` / `vignettes/Tutorials.Rmd` where relevant.
