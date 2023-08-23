#' @title UpSet plot for stat common and unique gene among multiple sets.
#' @description UpSet plot for stat common and unique gene among multiple sets.
#' @author benben-miao
#'
#' @return Plot: UpSet plot for stat common and unique gene among multiple sets.
#' @param data Dataframe: Paired comparisons differentially expressed genes (degs) among groups (1st-col~: degs of paired comparisons).
#' @param sets_num Numeric: sets number. Default: 4, min: 2, max: NULL.
#' @param keep_order Logical: keep sets in the order entered using the sets parameter. Default: FALSE, options: TRUE, FALSE.
#' @param order_by Character: intersections in the matrix should be ordered by. Default: "freq" (frequency), options: "freq", "degree", "both".
#' @param decrease Logical: order by decrease. Default: TRUE, options: TRUE, FALSE.
#' @param mainbar_color Charactor: mainbar color (color name or hex value). Default: "#006600".
#' @param number_angle Numeric: number display angle. Default: 45, min: 0, max: 360.
#' @param matrix_color Charactor: matrix point color (color name or hex value). Default: "#cc0000".
#' @param point_size Numeric: point size. Default: 4.5, min: 0.0, max: NULL.
#' @param point_alpha Numeric: point color alpha. Default: 0.50, min: 0.00, max: 1.00.
#' @param line_size Numeric: connection line size. Default: 0.8, min: 0.00, max: NULL.
#' @param shade_color Character: matrix shade color. Default: "#cdcdcd".
#' @param shade_alpha Numeric: shade color alpha. Default: 0.50, min: 0.00, max: 1.00.
#' @param setsbar_color Character: sets bar color. Default: "#000066".
#' @param setsnum_size Numeric: sets bar number size. Default: 6.
#' @param text_scale Numeric: all text scale. Default: 1.2, min: 0.01, max: NULL.
#'
#' @importFrom UpSetR upset fromList
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset
#' data(paired_degs)
#' head(paired_degs)
#'
#' # 3. Default parameters
#' upsetr_plot(paired_degs)
#'
#' # 4. Set keep_order = TRUE, order_by = "degree"
#' upsetr_plot(paired_degs, keep_order = TRUE, order_by = "degree")
#'
#' # 5. Set mainbar_color = "#333333", number_angle = 0
#' upsetr_plot(paired_degs, mainbar_color = "#333333", number_angle = 0)
#'
#' # 6. Set shade_color = "#ffcc00", setsbar_color = "#0000cc"
#' upsetr_plot(paired_degs, shade_color = "#ffcc00", setsbar_color = "#0000cc")
#'
upsetr_plot <- function(data,
												sets_num = 4,
												keep_order = FALSE,
												order_by = "freq",
												decrease = TRUE,
												mainbar_color = "#006600",
												number_angle = 45,
												matrix_color = "#cc0000",
												point_size = 4.5,
												point_alpha = 0.50,
												line_size = 0.8,
												shade_color = "#cdcdcd",
												shade_alpha = 0.50,
												setsbar_color = "#000066",
												setsnum_size = 6,
												text_scale = 1.2
											){
	# -> 2. NA and Duplicated
	data_upset <- as.list(data)
	data_upset <- lapply(data_upset, function(x) {
		x[is.na(x)] <- ""
		x <- x[x != ""]
		return(x)
	})
	# <- 2. NA and Duplicated

	# -> 4. Plot
	p <- UpSetR::upset(data = fromList(data_upset),
										 nsets = sets_num,
										 nintersects = NA,
										 sets = NULL,
										 keep.order = keep_order,
										 set.metadata = NULL,
										 intersections = NULL,
										 matrix.color = matrix_color,
										 main.bar.color = mainbar_color,
										 mainbar.y.label = "Intersection Size",
										 mainbar.y.max = NULL,
										 sets.bar.color = setsbar_color,
										 sets.x.label = "Set Size",
										 point.size = point_size,
										 line.size = line_size,
										 mb.ratio = c(0.7, 0.3),
										 expression = NULL,
										 att.pos = NULL,
										 att.color = mainbar_color,
										 order.by = order_by,
										 decreasing = decrease,
										 show.numbers = "yes",
										 number.angles = number_angle,
										 group.by = "degree",
										 cutoff = NULL,
										 queries = NULL,
										 query.legend = "none",
										 shade.color = shade_color,
										 shade.alpha = shade_alpha,
										 matrix.dot.alpha = point_alpha,
										 empty.intersections = NULL,
										 color.pal = 1,
										 boxplot.summary = NULL,
										 attribute.plots = NULL,
										 scale.intersections = "identity",
										 scale.sets = "identity",
										 text.scale = text_scale,
										 set_size.angles = 0,
										 set_size.show = TRUE,
										 set_size.numbers_size = setsnum_size,
										 set_size.scale_max = NULL
				)
	# <- 4. Plot

	return(p)
}
