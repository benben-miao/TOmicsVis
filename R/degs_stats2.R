#' @title All DEGs of paired comparison CT-vs-LT12 stats2 dataframe.
#' @description All DEGs of paired comparison CT-vs-LT12 stats2 dataframe.
#' @author benben-miao
#'
#' @docType data
#' @format Dataframe: All DEGs of paired comparison CT-vs-LT12 stats2 dataframe (1st-col: Gene, 2nd-col: baseMean, 3rd-col: Log2FoldChange, 4th-col: FDR).
#' @usage data(degs_stats2)
#'
#' @keywords datasets
#'
#' @references https://github.com/BioSciTools/BioSciToolsDatasets/tree/main/MversusA/
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Load example data
#' data(degs_stats2)
#'
#' # 3. View example data
#' degs_stats2
#'
"degs_stats2"

# data <- read.table(file = "data-tables/degs_stats2.txt",
# 									 header = TRUE,
# 									 sep = "\t",
# 									 stringsAsFactors = F)
# degs_stats2 <- data
# usethis::use_data(degs_stats2, overwrite = T)
