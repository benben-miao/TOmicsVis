#' @title TOmicsVis shiny app start function.
#' @description TOmicsVis shiny app start function.
#' @author benben-miao
#'
#' @return Shinyapp: TOmicsVis shiny app.
#'
#' @importFrom shiny runApp
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
tomicsvis <- function(){

	app_path <- system.file("shinyapp", package = "TOmicsVis")

	if (is.na(app_path)) {
		stop("Shiny app folder not found in the package directory.")
	}

	shiny::runApp(appDir = app_path)
}
