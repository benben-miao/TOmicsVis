#' @title Table split used for splitting a grouped column to multiple columns.
#' @description Table split used for splitting a grouped column to multiple columns.
#' @author benben-miao
#'
#' @return Table: table split used for splitting a grouped column to multiple columns.
#' @param data Dataframe: GO and KEGG annotation of background genes (1st-col: Genes, 2nd-col: biological_process, 3rd-col: cellular_component, 4th-col: molecular_function, 5th-col: kegg_pathway).
#' @param grouped_var Character: grouped column name. Default: "go_category".
#' @param value_var Character: value column name. Default: "go_term".
#' @param miss_drop Logical: drop missing values or NA values. Default: TRUE, options: TRUE, FALSE.
#'
#' @importFrom reshape2 dcast
#' @importFrom stats as.formula
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset
#' data(gene_go_kegg2)
#' head(gene_go_kegg2)
#'
#' # 3. Default parameters
#' res <- table_split(gene_go_kegg2)
#' head(res)
#'
table_split <- function(data,
												grouped_var = "go_category",
												value_var = "go_term",
												miss_drop = TRUE
												){
	res <- reshape2::dcast(data,
							 as.formula(paste("... ~ ",
							 								 grouped_var,
							 								 sep = "")
							 					 ),
							 value.var = value_var,
							 margins = NULL,
							 drop = miss_drop
							 )

	return(res)
	invisible()
}
