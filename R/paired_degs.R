#' @title Paired comparisons differentially expressed genes (degs) among groups.
#' @description Paired comparisons differentially expressed genes (degs) among groups.
#' @author benben-miao
#'
#' @docType data
#' @format Dataframe: Paired comparisons differentially expressed genes (degs) among groups (1st-col~: degs of paired comparisons).
#' @usage data(paired_degs)
#'
#' @keywords datasets
#'
#' @references https://github.com/BioSciTools/BioSciToolsDatasets/tree/main/VennPlot/
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Load example data
#' data(paired_degs)
#'
#' # 3. View example data
#' paired_degs
#'
"paired_degs"

# data <- read.table(file = "data-tables/paired_degs.txt",
# 									 header = TRUE,
# 									 sep = "\t",
# 									 stringsAsFactors = F)
# paired_degs <- data
# usethis::use_data(paired_degs)
