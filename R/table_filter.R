#' @title Table filter used to filter row by column condition.
#' @description Table filter used to filter row by column condition.
#' @author benben-miao
#'
#' @return Table: table filter used to filter row by column condition.
#' @param data Dataframe: Length, Width, Weight, and Sex traits dataframe (1st-col: Value, 2nd-col: Traits, 3rd-col: Sex).
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
#' data(traits_sex)
#' head(traits_sex)
#'
#' # 3. Set height > 100 & eye_color == "black"
#' res <- table_filter(traits_sex, Sex == "Male" & Traits == "Weight" & Value > 40)
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
