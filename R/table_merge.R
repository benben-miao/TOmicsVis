#' @title Table merge used to merge multiple variables to on variable.
#' @description Table merge used to merge multiple variables to on variable.
#' @author benben-miao
#'
#' @return Table: include multiple variables.
#' @param data Dataframe: include multiple variables (columns).
#' @param merge_vars Vector: include merged variable (column) names. Default: c("Ozone", "Solar.R", "Wind", "Temp") in example data.
#' @param new_var Character: new variable (column) name. Default: "Variable".
#' @param new_value Character: new variable (column) value name. Default: "Value".
#' @param na_remove Logical: remove NA value. Default: FALSE, options: TRUE, FALSE.
#'
#' @import stats
#' @import reshape2
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset
#' data(table_merge_data)
#' head(table_merge_data)
#'
#' # 3. Default parameters
#' res <- table_merge(table_merge_data)
#' head(res)
#'
#' # 4. Set merge_vars = c("Ozone", "Solar.R")
#' res <- table_merge(table_merge_data, merge_vars = c("Ozone", "Solar.R"))
#' head(res)
#'
table_merge <- function(data,
												merge_vars = c("Ozone", "Solar.R", "Wind", "Temp"),
												new_var = "Variable",
												new_value = "Value",
												na_remove = FALSE
												){
	res <- melt(data,
							measure.vars = merge_vars,
							variable.name = new_var,
							na.rm = na_remove,
							value.name = new_value,
							factorsAsStrings = TRUE
							)

	return(res)
	invisible()
}
