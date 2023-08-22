#' @title Quantile data for quantile_plot example.
#' @description Quantile data for quantile_plot example.
#' @author benben-miao
#'
#' @docType data
#' @format Dataframe: Trait measurement of samples in multiple groups (1st-col: Values, 2nd-col: Groups).
#' @usage data(quantile_data)
#'
#' @keywords datasets
#'
#' @references https://github.com/BioSciTools/BioSciToolsDatasets/tree/main/QuantileQuantile/
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Load example data
#' data(quantile_data)
#'
#' # 3. View example data
#' quantile_data
#'
"quantile_data"

# data <- read.table(file = "data-tables/quantile_data.txt",
# 									 header = TRUE,
# 									 sep = "\t",
# 									 stringsAsFactors = F)
# quantile_data <- data
# usethis::use_data(quantile_data, overwrite = TRUE)
