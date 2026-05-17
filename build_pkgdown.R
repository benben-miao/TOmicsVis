#!/usr/bin/env Rscript
# =============================================================================
# build_pkgdown.R - Build TOmicsVis pkgdown documentation website
# =============================================================================
# This script builds the complete pkgdown website for TOmicsVis package
# Version: 2.7.1
# Last Updated: 2026-05-17
# =============================================================================

cat("=============================================================================\n")
cat("TOmicsVis Pkgdown Website Builder v2.7.1\n")
cat("=============================================================================\n\n")

# Check if pkgdown is installed
if (!requireNamespace("pkgdown", quietly = TRUE)) {
  stop("pkgdown package is required. Install it with: install.packages('pkgdown')")
}

library(pkgdown)

cat("✓ Package loaded successfully\n\n")

# Build steps
steps <- list(
  "1. Cleaning previous build" = function() {
    cat("→ Step 1/4: Cleaning previous build...\n")
    if (dir.exists("docs")) {
      unlink("docs", recursive = TRUE)
      cat("  ✓ Removed old docs directory\n")
    }
  },
  
  "2. Generating Rd documentation" = function() {
    cat("\n→ Step 2/4: Generating Rd documentation...\n")
    tryCatch({
      roxygen2::roxygenise()
      cat("  ✓ Roxygen2 documentation generated\n")
    }, error = function(e) {
      warning(paste("  ⚠ Roxygen2 generation skipped:", e$message))
    })
  },
  
  "3. Building pkgdown site" = function() {
    cat("\n→ Step 3/4: Building pkgdown site...\n")
    
    # Build the site
    build_site(
      devel = FALSE,
      lazy = TRUE,
      examples = TRUE,
      document = "never",
      run_dont_run = FALSE,
      seed = 42,
      override = list(
        destination = "docs"
      )
    )
    
    cat("  ✓ Pkgdown site built successfully\n")
  },
  
  "4. Verifying build output" = function() {
    cat("\n→ Step 4/4: Verifying build output...\n")
    
    required_files <- c(
      "docs/index.html",
      "docs/reference/index.html",
      "docs/articles/Tutorials.html",
      "docs/pkgdown.yml"
    )
    
    all_exist <- all(file.exists(required_files))
    
    if (all_exist) {
      cat("  ✓ All required files generated:\n")
      for (f in required_files) {
        cat(sprintf("    - %s (%.1f KB)\n", f, file.info(f)$size / 1024))
      }
      
      # Count reference pages
      ref_pages <- length(list.files("docs/reference", pattern = "\\.html$", full.names = TRUE))
      cat(sprintf("\n  ✓ Total reference pages: %d\n", ref_pages))
      
      # Count articles
      articles <- length(list.files("docs/articles", pattern = "\\.html$", full.names = TRUE))
      cat("  ✓ Total articles:", articles, "\n")
      
    } else {
      missing <- required_files[!file.exists(required_files)]
      stop(paste("  ✗ Missing required files:", paste(missing, collapse = ", ")))
    }
  }
)

# Execute all steps
tryCatch({
  for (step_name in names(steps)) {
    steps[[step_name]]()
  }
  
  cat("\n=============================================================================\n")
  cat("🎉 BUILD SUCCESSFUL!\n")
  cat("=============================================================================\n\n")
  cat("Website location: docs/\n")
  cat("Open locally:     open docs/index.html\n")
  cat("Preview URL:      https://benben-miao.github.io/TOmicsVis/\n\n")
  
  cat("Next steps:\n")
  cat("  1. Review the site locally: open docs/index.html\n")
  cat("  2. Commit changes: git add docs/ && git commit -m 'Update pkgdown site'\n")
  cat("  3. Push to GitHub: git push origin main\n")
  cat("  4. GitHub Actions will deploy to: https://benben-miao.github.io/TOmicsVis/\n\n")
  
}, error = function(e) {
  cat("\n=============================================================================\n")
  cat("❌ BUILD FAILED!\n")
  cat("=============================================================================\n\n")
  cat("Error message:", e$message, "\n\n")
  
  cat("Troubleshooting:\n")
  cat("  1. Ensure all dependencies are installed: source('install_dependencies.R')\n")
  cat("  2. Check Rd files exist in man/ directory\n")
  cat("  3. Verify _pkgdown.yml syntax is correct\n")
  cat("  4. Run devtools::document() first to generate documentation\n\n")
  
  quit(status = 1)
})
