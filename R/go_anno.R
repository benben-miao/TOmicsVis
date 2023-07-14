#' @title GO annotation (BP, CC, MF) of genes as template data.
#' @description GO annotation (BP, CC, MF) of genes as template data.
#' @author benben-miao
#'
#' @docType data
#' @format Dataframe: include columns (id, biological_process, cellular_component, molecular_function),  symbol ";" split GO terms.
#' @usage data(go_anno)
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
#' data(go_anno)
#'
#' # 3. View example data
#' go_anno
#'
"go_anno"

# go_anno <- gene_go
# usethis::use_data(go_anno, overwrite = T)
