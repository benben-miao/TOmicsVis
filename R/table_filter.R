#' @title Table filter used to filter row by column condition.
#' @description Table filter used to filter row by column condition.
#' @author benben-miao
#'
#' @return Table: table filter used to filter row by column condition.
#' @param data Dataframe: include multiple columns and many rows.
#' @param ... Expression: multiple expressions.
#'
#' @importFrom dplyr filter
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset
#' data(table_filter_data)
#' head(table_filter_data)
#'
#' # 3. Set height > 100 & eye_color == "black"
#' res <- table_filter(table_filter_data, height > 100 & eye_color == "black")
#' head(res)
#'
#' # 4. Set eye_color == "blue" | eye_color == "yellow"
#' res <- table_filter(table_filter_data, eye_color == "blue" | eye_color == "yellow")
#' head(res)
#'
table_filter <- function(data,
												...
												){
	res <- dplyr::filter(data,
								...
								)

	return(res)
	invisible()
}
