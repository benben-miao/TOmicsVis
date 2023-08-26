#' @title Table merge used to merge multiple variables to on variable.
#' @description Table merge used to merge multiple variables to on variable.
#' @author benben-miao
#'
#' @return Table: include multiple variables.
#' @param data Dataframe: GO and KEGG annotation of background genes (1st-col: Genes, 2nd-col: biological_process, 3rd-col: cellular_component, 4th-col: molecular_function, 5th-col: kegg_pathway).
#' @param merge_vars Vector: include merged variable (column) names. Default: c("Ozone", "Solar.R", "Wind", "Temp") in example data.
#' @param new_var Character: new variable (column) name. Default: "Variable".
#' @param new_value Character: new variable (column) value name. Default: "Value".
#' @param na_remove Logical: remove NA value. Default: FALSE, options: TRUE, FALSE.
#'
#' @importFrom reshape2 melt
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset
#' data(gene_go_kegg)
#' head(gene_go_kegg)
#'
#' # 3. Default parameters
#' res <- table_merge(gene_go_kegg)
#' head(res)
#'
#' # 4. Set new_var = "GO", new_value = "Terms"
#' res <- table_merge(gene_go_kegg, new_var = "GO", new_value = "Terms")
#' head(res)
#'
table_merge <- function(data,
												merge_vars = c("biological_process", "cellular_component", "molecular_function"),
												new_var = "go_category",
												new_value = "go_term",
												na_remove = FALSE
												){
	res <- reshape2::melt(data,
							measure.vars = merge_vars,
							variable.name = new_var,
							na.rm = na_remove,
							value.name = new_value,
							factorsAsStrings = TRUE
							)

	return(res)
	invisible()
}
