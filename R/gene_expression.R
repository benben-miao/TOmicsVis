#' @title Gene Expression dataframe of RNA-Seq.
#' @description Gene Expression dataframe of RNA-Seq.
#' @author benben-miao
#'
#' @docType data
#' @format Dataframe: gene expression dataframe (1st-col: Transcripts or Genes, 2nd-col~: Samples).
#' @usage data(gene_expression)
#'
#' @keywords datasets
#'
#' @references https://github.com/BioSciTools/BioSciToolsDatasets/tree/main/CorPlot/
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Load example dataset gene_expression
#' data(gene_expression)
#'
#' # 3. View gene_expression
#' gene_expression
#'
"gene_expression"

# data <- read.table(file = "data-tables/gene_expression.txt",
# 									 header = TRUE,
# 									 sep = "\t",
# 									 stringsAsFactors = F)
# gene_expression <- data
# usethis::use_data(gene_expression, overwrite = T)
