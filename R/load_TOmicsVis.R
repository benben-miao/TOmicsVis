#' @title Load TOmicsVis package without display warnings
#' @description Helper function to load TOmicsVis while suppressing harmless 
#'              display warnings from Mfuzz dependency
#'
#' @return Invisible NULL. Loads TOmicsVis into the session namespace
#'
#' @examples
#' # Use this instead of library(TOmicsVis)
#' load_TOmicsVis()
#'
#' # Then use all functions normally
#' data(gene_expression)
#' data(degs_stats)
#' volcano_plot(degs_stats)
#'
#' @export

load_TOmicsVis <- function() {
  
  save_warn <- options()$warn
  
  on.exit({
    options(warn = save_warn)
  }, add = TRUE)
  
  options(warn = -1)
  
  suppressPackageStartupMessages(library(TOmicsVis))
  
  message("[OK] TOmicsVis v", utils::packageDescription("TOmicsVis", fields = "Version"), 
          " loaded successfully!")
  message("  All functions ready to use.")
  
  invisible()
}