#' @title GO and KEGG annotation of background genes.
#' @description GO and KEGG annotation of background genes.
#' @author benben-miao
#'
#' @docType data
#' @format Dataframe: GO and KEGG annotation of background genes (1st-col: Genes, 2nd-col: biological_process, 3rd-col: cellular_component, 4th-col: molecular_function, 5th-col: kegg_pathway).
#' @usage data(gene_go_kegg)
#'
#' @keywords datasets
#'
#' @references https://github.com/BioSciTools/BioSciToolsDatasets/tree/main/GOenrichStat/
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Load example data
#' data(gene_go_kegg)
#'
#' # 3. View example data
#' gene_go_kegg
#'
"gene_go_kegg"

# data <- read.table(file = "data-tables/gene_go_kegg.txt",
# 									 header = TRUE,
# 									 sep = "\t",
# 									 stringsAsFactors = F)
# gene_go_kegg <- data
# usethis::use_data(gene_go_kegg, overwrite = T)
