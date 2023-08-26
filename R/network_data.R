#' @title Network data from WGCNA tan module top-200 dataframe.
#' @description Network data from WGCNA tan module top-200 dataframe.
#' @author benben-miao
#'
#' @docType data
#' @format Dataframe: Network data from WGCNA tan module top-200 dataframe (1st-col: Source, 2nd-col: Target).
#' @usage data(network_data)
#'
#' @keywords datasets
#'
#' @references https://github.com/BioSciTools/BioSciToolsDatasets/tree/main/NetworkPlot/
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Load example data
#' data(network_data)
#'
#' # 3. View example data
#' network_data
#'
"network_data"

# data <- read.table(file = "data-tables/network_data.txt",
# 									 header = TRUE,
# 									 sep = "\t",
# 									 stringsAsFactors = F)
# network_data <- data
# usethis::use_data(network_data)
