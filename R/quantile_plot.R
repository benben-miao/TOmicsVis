#' @title Quantile plot for visualizing data distribution.
#' @description Quantile plot for visualizing data distribution.
#' @author benben-miao
#'
#' @return Plot: quantile plot for visualizing data distribution.
#' @param data Dataframe: Weight and Sex traits dataframe (1st-col: Weight, 2nd-col: Sex).
#'
#' @param my_shape Character: scatter shape. Default: "fill_circle", options: "border_square", "border_circle", "border_triangle", "plus", "times", "border_diamond", "border_triangle_down", "square_times", "plus_times", "diamond_plus", "circle_plus", "di_triangle", "square_plus", "circle_times","square_triangle", "fill_square", "fill_circle", "fill_triangle", "fill_diamond", "large_circle", "small_circle", "fill_border_circle", "fill_border_square", "fill_border_diamond", "fill_border_triangle".
#' @param point_size Numeric: point size. Default: 1.5, min: 0.0, max: not required.
#' @param conf_int Logical: confidence interval (CI). Default: TRUE, options: TRUE or FALSE.
#' @param conf_level Numeric: confidence interval value. Default: 0.95, min: 0.00, max: 1.00.
#' @param split_panel Character: split panel by groups. Default: "Split_Panel", options: "One_Panel", "Split_Panel".
#' @param legend_pos Character: legend position. Default: "right", options: "none", "left", "right", "bottom", "top".
#' @param legend_dir Character: legend direction. Default: "vertical", options: "horizontal", "vertical".
#' @param sci_fill_color Character: ggsci fill or color palette. Default: "Sci_NPG", options: "Sci_AAAS", "Sci_NPG", "Sci_Simpsons", "Sci_JAMA", "Sci_GSEA", "Sci_Lancet", "Sci_Futurama", "Sci_JCO", "Sci_NEJM", "Sci_IGV", "Sci_UCSC", "Sci_D3", "Sci_Material".
#' @param sci_color_alpha Numeric: ggsci border color alpha. Default: 0.75, min: 0.00, max: 1.00.
#' @param ggTheme Character: ggplot2 themes. Default: "theme_publication", options: "theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw", "theme_dark", "theme_minimal", "theme_classic", "theme_void".
#'
#' @import ggplot2
#' @import ggsci
#' @export
#' @note Requires package 'ggpubr' (install via: install.packages("ggpubr"))
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset
#' data(weight_sex)
#' head(weight_sex)
#'
#' # 3. Default parameters
#' quantile_plot(weight_sex)
#'
#' # 4. Set split_panel = "Split_Panel"
#' quantile_plot(weight_sex, split_panel = "Split_Panel")
#'
#' # 5. Set sci_fill_color = "Sci_Futurama"
#' quantile_plot(weight_sex, sci_fill_color = "Sci_Futurama")
#'
#' # 6. Set conf_int = FALSE
#' quantile_plot(weight_sex, conf_int = FALSE)
#'

quantile_plot <- function(data,
													my_shape = "fill_circle",
													point_size = 1.5,
													conf_int = TRUE,
													conf_level = 0.95,
													split_panel = "Split_Panel",
													legend_pos = "right",
													legend_dir = "vertical",
													sci_fill_color = "Sci_NPG",
													sci_color_alpha = 0.75,
													ggTheme = "theme_publication") {

	validate_is_dataframe_or_matrix(data, "data")
	validate_numeric_range(ncol(data), "ncol(data)", min = 2)
	validate_character_options(my_shape, "my_shape",
														 c("border_square", "border_circle", "border_triangle", "plus", "times",
															 "border_diamond", "border_triangle_down", "square_times", "plus_times",
															 "diamond_plus", "circle_plus", "di_triangle", "square_plus",
															 "circle_times", "square_triangle", "fill_square", "fill_circle",
															 "fill_triangle", "fill_diamond", "large_circle", "small_circle",
															 "fill_border_circle", "fill_border_square", "fill_border_diamond",
															 "fill_border_triangle"))
	validate_numeric_range(point_size, "point_size", min = 0)
	validate_logical(conf_int, "conf_int")
	validate_numeric_range(conf_level, "conf_level", min = 0, max = 1)
	validate_character_options(split_panel, "split_panel", c("One_Panel", "Split_Panel"))
	validate_character_options(legend_pos, "legend_pos", c("none", "left", "right", "bottom", "top"))
	validate_character_options(legend_dir, "legend_dir", c("horizontal", "vertical"))
	validate_character_options(sci_fill_color, "sci_fill_color",
														 c("Sci_AAAS", "Sci_NPG", "Sci_Simpsons", "Sci_JAMA", "Sci_GSEA",
															 "Sci_Lancet", "Sci_Futurama", "Sci_JCO", "Sci_NEJM", "Sci_IGV",
															 "Sci_UCSC", "Sci_D3", "Sci_Material"))
	validate_numeric_range(sci_color_alpha, "sci_color_alpha", min = 0, max = 1)
	validate_character_options(ggTheme, "ggTheme",
														 c("theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw",
															 "theme_dark", "theme_minimal", "theme_classic", "theme_void",
															 "theme_publication"))

	if (!requireNamespace("ggpubr", quietly = TRUE)) {
		stop("Package 'ggpubr' is required for quantile_plot().\n",
             "Please install: install.packages('ggpubr')",
             call. = FALSE)
	}

	gg_theme <- get_ggtheme(ggTheme)

	if (sci_fill_color == "Default") {
		sci_color <- NULL
	} else {
		sci_color <- get_ggsci_color(sci_fill_color)
		if (!is.null(sci_color)) {
			sci_color <- sci_color(alpha = sci_color_alpha)
		}
	}

	shape_lookup <- list(
		border_square = 0, border_circle = 1, border_triangle = 2, plus = 3, times = 4,
		border_diamond = 5, border_triangle_down = 6, square_times = 7, plus_times = 8,
		diamond_plus = 9, circle_plus = 10, di_triangle = 11, square_plus = 12,
		circle_times = 13, square_triangle = 14, fill_square = 15, fill_circle = 16,
		fill_triangle = 17, fill_diamond = 18, large_circle = 19, small_circle = 20,
		fill_border_circle = 21, fill_border_square = 22, fill_border_diamond = 23,
		fill_border_triangle = 24
	)
	shape <- shape_lookup[[my_shape]]

	if (split_panel == "One_Panel") {
		facet_by <- NULL
	} else if (split_panel == "Split_Panel") {
		facet_by <- colnames(data)[2]
	}

	suppressWarnings(
	p <- ggpubr::ggqqplot(data,
														 x = colnames(data)[1],
														 color = colnames(data)[2],
														 combine = FALSE,
														 merge = FALSE,
														 size = point_size,
														 shape = shape,
														 add = c("qqline", "none"),
														 add.params = list(linetype = "solid",
														 									size = 1.5,
														 									alpha = 0.8
														 ),
														 conf.int = conf_int,
														 conf.int.level = conf_level,
														 facet.by = facet_by,
														 panel.labs = NULL,
														 short.panel.labs = FALSE
	) +
		sci_color +
		gg_theme +
		theme(plot.title = element_text(face = "bold", size = 18, hjust = 0.5),
		axis.title = element_text(face = "plain", size = 16),
		axis.text = element_text(face = "plain", size = 10),
		legend.title = element_text(face = "plain", size = 12),
		legend.position = legend_pos,
		legend.direction = legend_dir,
		strip.background = element_rect(fill = "#cdcdcd", color = "#cdcdcd"),
		strip.text = element_text(color = "#333333", size = 10, face = "bold")
		)
	)

	return(p)
}
