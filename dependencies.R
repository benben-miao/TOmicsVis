options(BioC_mirror = "https://bioconductor.org")
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager", repos = "https://cloud.r-project.org")
}
library(BiocManager)

cran_packages <- c(
  "ggplot2", "dplyr", "tidyr", "shiny", "pheatmap", "Rtsne", "umap",
  "survival", "igraph", "circlize", "ggsci", "ggforce", "stringr",
  "vegan", "ggrepel", "ggnewscale", "knitr", "rmarkdown", "bs4Dash",
  "DT", "colourpicker", "shinyWidgets", "survminer", "GGally",
  "factoextra", "venn", "UpSetR", "randomcoloR", "plotrix",
  "ggpubr", "ggcorrplot", "ggpolypath"
)

bioc_packages <- c(
  "Biostrings", "WGCNA", "Biobase", "ComplexHeatmap", "EnhancedVolcano",
  "clusterProfiler", "enrichplot", "Mfuzz"
)

for (pkg in cran_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    message(sprintf("Installing CRAN: %s", pkg))
    install.packages(pkg, repos = "https://cloud.r-project.org", quiet = TRUE, force = TRUE)
  }
}

for (pkg in bioc_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    message(sprintf("Installing Bioc: %s", pkg))
    BiocManager::install(pkg, update = FALSE, ask = FALSE, quiet = TRUE, force = TRUE)
  }
}

all_deps <- c(cran_packages, bioc_packages)
success <- sum(sapply(all_deps, requireNamespace, quietly = TRUE))
message(sprintf("\nComplete: %d/%d packages installed", success, length(all_deps)))

if (success == length(all_deps)) {
  message("\nAll dependencies installed! Now install TOmicsVis.")
}
