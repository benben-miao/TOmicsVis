#' @title All DEGs of paired comparison CT-vs-LT12 stats dataframe.
#' @description All DEGs of paired comparison CT-vs-LT12 stats dataframe.
#' @author benben-miao
#'
#' @docType data
#' @format Dataframe: All DEGs of paired comparison CT-vs-LT12 stats dataframe (1st-col: Genes, 2nd-col: log2FoldChange, 3rd-col: Pvalue, 4th-col: FDR).
#' @usage data(degs_stats)
#'
#' @keywords datasets
#'
#' @references https://github.com/BioSciTools/BioSciToolsDatasets/tree/main/VolcanoPlot/
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Load example data
#' data(degs_stats)
#'
#' # 3. View example data
#' degs_stats
#'
"degs_stats"

# data <- read.table(file = "data-tables/degs_stats.txt",
# 									 header = TRUE,
# 									 sep = "\t",
# 									 stringsAsFactors = F)
# degs_stats <- data
# usethis::use_data(degs_stats, overwrite = T)
