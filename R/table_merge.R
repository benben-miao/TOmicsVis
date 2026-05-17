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
#' @importFrom tidyr pivot_longer
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

	if (!is.data.frame(data) && !is.matrix(data)) {
		stop("data must be a data.frame or matrix", call. = FALSE)
	}

	if (!all(merge_vars %in% colnames(data))) {
		stop("Some merge_vars not found in data columns", call. = FALSE)
	}

	res <- tidyr::pivot_longer(data,
														 cols = all_of(merge_vars),
															names_to = new_var,
															values_to = new_value
	)

	if (na_remove) {
		res <- res[!is.na(res[[new_value]]), ]
	}

	return(res)
}
