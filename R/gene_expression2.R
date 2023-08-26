#' @title Shared DEGs of all paired comparisons in all samples expression dataframe of RNA-Seq.
#' @description Shared DEGs of all paired comparisons in all samples expression dataframe of RNA-Seq.
#' @author benben-miao
#'
#' @docType data
#' @format Dataframe: Shared DEGs of all paired comparisons in all samples expression dataframe of RNA-Seq. (1st-col: Genes, 2nd-col~: Samples).
#' @usage data(gene_expression2)
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
#' data(gene_expression2)
#'
#' # 3. View gene_expression2
#' gene_expression2
#'
"gene_expression2"

# data <- read.table(file = "data-tables/gene_expression2.txt",
# 									 header = TRUE,
# 									 sep = "\t",
# 									 stringsAsFactors = F)
# gene_expression2 <- data
# usethis::use_data(gene_expression2, overwrite = T)
