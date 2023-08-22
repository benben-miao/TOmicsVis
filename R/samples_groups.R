#' @title Samples and groups for gene expression.
#' @description Samples and groups for gene expression.
#' @author benben-miao
#'
#' @docType data
#' @format Dataframe: Samples and groups for gene expression (1st-col: Samples, 2nd-col: Groups).
#' @usage data(samples_groups)
#'
#' @keywords datasets
#'
#' @references https://github.com/BioSciTools/BioSciToolsDatasets/tree/main/PCAplot/
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Load example dataset samples_groups
#' data(samples_groups)
#'
#' # 3. View samples_groups
#' samples_groups
#'
"samples_groups"

# data <- read.table(file = "data-tables/samples_groups.txt",
# 									 header = TRUE,
# 									 sep = "\t",
# 									 stringsAsFactors = F)
# samples_groups <- data
# # usethis::use_data(samples_groups)
