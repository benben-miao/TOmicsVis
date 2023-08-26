#' @title Shared DEGs of all paired comparisons in all groups expression dataframe of RNA-Seq.
#' @description Shared DEGs of all paired comparisons in all groups expression dataframe of RNA-Seq.
#' @author benben-miao
#'
#' @docType data
#' @format Dataframe: Shared DEGs of all paired comparisons in all groups expression dataframe of RNA-Seq. (1st-col: Genes, 2nd-col~n-1-col: Groups, n-col: Pathways).
#' @usage data(gene_expression3)
#'
#' @keywords datasets
#'
#' @references https://github.com/BioSciTools/BioSciToolsDatasets/tree/main/CorPlot/
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Load example dataset
#' data(gene_expression3)
#'
#' # 3. View gene_expression3
#' gene_expression3
#'
"gene_expression3"

# data <- read.table(file = "data-tables/gene_expression3.txt",
# 									 header = TRUE,
# 									 sep = "\t",
# 									 stringsAsFactors = F)
# gene_expression3 <- data
# usethis::use_data(gene_expression3, overwrite = T)
