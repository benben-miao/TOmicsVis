#' @title Survival data as example data for survival_plot function.
#' @description Survival data as example data for survival_plot function.
#' @author benben-miao
#'
#' @docType data
#' @format Dataframe: survival record data (1st-col: Time, 2nd-col: Status, 3rd-col: Group).
#' @usage data(survival_data)
#'
#' @keywords datasets
#'
#' @references https://github.com/BioSciTools/BioSciToolsDatasets/tree/main/SurvivalAnalysis/
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Load example data
#' data(survival_data)
#'
#' # 3. View example data
#' survival_data
#'
"survival_data"

# data <- read.table(file = "data-tables/survival_data.txt",
# 									 header = TRUE,
# 									 sep = "\t",
# 									 stringsAsFactors = F)
# survival_data <- data
# usethis::use_data(survival_data, overwrite = T)
