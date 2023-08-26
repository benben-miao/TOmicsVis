#' @title Paired comparisons differentially expressed genes (degs) among groups.
#' @description Paired comparisons differentially expressed genes (degs) among groups.
#' @author benben-miao
#'
#' @docType data
#' @format Dataframe: Paired comparisons differentially expressed genes (degs) among groups (1st-col~: degs of paired comparisons).
#' @usage data(degs_lists)
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
#' data(degs_lists)
#'
#' # 3. View example data
#' degs_lists
#'
"degs_lists"

# data <- read.table(file = "data-tables/degs_lists.txt",
# 									 header = TRUE,
# 									 sep = "\t",
# 									 stringsAsFactors = F)
# degs_lists <- data
# usethis::use_data(degs_lists)
