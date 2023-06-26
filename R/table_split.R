#' @title Table split used for splitting a grouped column to multiple columns.
#' @description Table split used for splitting a grouped column to multiple columns.
#' @author benben-miao
#'
#' @return Table: table split used for splitting a grouped column to multiple columns.
#' @param data Dataframe: include columns (variables), rows (records).
#' @param grouped_var Character: grouped column name. Default: "variables".
#' @param miss_drop Logical: drop missing values or NA values. Default: TRUE, options: TRUE, FALSE.
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
#' data(table_split_data)
#' head(table_split_data)
#'
#' # 3. Default parameters
#' res <- table_split(table_split_data)
#' head(res)
#'
#' # 4. Set miss_drop = FALSE
#' res <- table_split(table_split_data, miss_drop = FALSE)
#' head(res)
#'
table_split <- function(data,
												grouped_var = "variable",
												miss_drop = TRUE
												){
	res <- dcast(data,
							 as.formula(paste("... ~ ",
							 								 grouped_var,
							 								 sep = "")
							 					 ),
							 margins = NULL,
							 drop = miss_drop
							 )

	return(res)
	invisible()
}
