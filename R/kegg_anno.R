#' @title KEGG annotation (kegg_pathway) of genes as template data.
#' @description KEGG annotation (kegg_pathway) of genes as template data.
#' @author benben-miao
#'
#' @docType data
#' @format Dataframe: include columns (id, kegg_pathway),  symbol ";" split ko pathways.
#' @usage data(kegg_anno)
#'
#' @keywords datasets
#'
#' @references https://github.com/BioSciTools/BioSciToolsDatasets/tree/main/KEGGenrichBar/
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Load example data
#' data(kegg_anno)
#'
#' # 3. View example data
#' kegg_anno
#'
"kegg_anno"

# kegg_anno <- gene_kegg
# usethis::use_data(kegg_anno, overwrite = T)
