#' @title Table cross used to cross search and merge results in two tables.
#' @description Table cross used to cross search and merge results in two tables.
#' @author benben-miao
#'
#' @return Table: include multiple columns.
#' @param data1 Dataframe: include multiple columns, as left table.
#' @param data2 Dataframe: include multiple columns, as right table.
#' @param inter_var Character: Intersecting variable (column name). Default: "geneID" in example data.
#' @param left_index Logical: left table as index. Default: TRUE, options: TRUE, FALSE.
#' @param right_index Logical: right table as index. Default: FALSE, options: TRUE, FALSE.
#'
#' @import stats
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset
#' data(table_cross_data1)
#' head(table_cross_data1)
#'
#' data(table_cross_data2)
#' head(table_cross_data2)
#'
#' # 3. Default parameters
#' res <- table_cross(table_cross_data1,
#' table_cross_data2,
#' inter_var = "geneID"
#' )
#' head(res)
#'
#' # 4. Set left_index = TRUE, right_index = TRUE
#' res <- table_cross(table_cross_data1,
#' table_cross_data2,
#' inter_var = "geneID",
#' left_index = TRUE,
#' right_index = TRUE
#' )
#' head(res)
#'
#' # 5. Set left_index = FALSE, right_index = FALSE
#' res <- table_cross(table_cross_data1,
#' table_cross_data2,
#' inter_var = "geneID",
#' left_index = FALSE,
#' right_index = FALSE
#' )
#' head(res)
#'
table_cross <- function(data1, data2,
												inter_var = "geneID",
												left_index = TRUE,
												right_index = FALSE
												){
	res <- merge(x = data1,
							 y = data2,
							 by = inter_var,
							 all.x = left_index,
							 all.y = right_index
							 )

	return(res)
	invisible()
}
