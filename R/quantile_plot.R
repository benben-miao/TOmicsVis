#' @title Quantile plot for visualizing data distribution.
#' @description Quantile plot for visualizing data distribution.
#' @author benben-miao
#'
#' @return Plot: quantile plot for visualizing data distribution.
#' @param data Dataframe: include Value, Group columns.
#'
#' @param my_shape Character: scatter shape. Default: "fill_circle", options: "border_square", "border_circle", "border_triangle", "plus", "times", "border_diamond", "border_triangle_down", "square_times", "plus_times", "diamond_plus", "circle_plus", "di_triangle", "square_plus", "circle_times","square_triangle", "fill_square", "fill_circle", "fill_triangle", "fill_diamond", "large_circle", "small_circle", "fill_border_circle", "fill_border_square", "fill_border_diamond", "fill_border_triangle".
#' @param point_size Numeric: point size. Default: 1.5, min: 0.0, max: not required.
#' @param conf_int Logical: confidence interval (CI). Default: TRUE, options: TRUE or FALSE.
#' @param conf_level Numeric: confidence interval value. Default: 0.95, min: 0.00, max: 1.00.
#' @param split_panel Character: split panel by groups. Default: "One_Panel", options: "One_Panel", "Split_Panel".
#' @param legend_pos Character: legend position. Default: "right", options: "none", "left", "right", "bottom", "top".
#' @param legend_dir Character: legend direction. Default: "vertical", options: "horizontal", "vertical".
#' @param sci_fill_color Character: ggsci fill or color palette. Default: "Sci_AAAS", options: "Sci_AAAS", "Sci_NPG", "Sci_Simpsons", "Sci_JAMA", "Sci_GSEA", "Sci_Lancet", "Sci_Futurama", "Sci_JCO", "Sci_NEJM", "Sci_IGV", "Sci_UCSC", "Sci_D3", "Sci_Material".
#' @param sci_color_alpha Numeric: ggsci border color alpha. Default: 0.75, min: 0.00, max: 1.00.
#' @param ggTheme Character: ggplot2 themes. Default: "theme_light", options: "theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw", "theme_dark", "theme_minimal", "theme_classic", "theme_void".
#'
#' @import ggplot2
#' @import ggsci
#' @importFrom ggpubr ggqqplot
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset
#' data(quantile_data)
#'
#' # 3. Default parameters
#' quantile_plot(quantile_data)
#'
#' # 4. Set split_panel = "Split_Panel"
#' quantile_plot(quantile_data, split_panel = "Split_Panel")
#'
#' # 5. Set sci_fill_color = "Sci_Futurama"
#' quantile_plot(quantile_data, sci_fill_color = "Sci_Futurama")
#'
#' # 6. Set conf_int = FALSE
#' quantile_plot(quantile_data, conf_int = FALSE)
#'
quantile_plot <- function(data,
													my_shape = "fill_circle",
													point_size = 1.5,
													conf_int = TRUE,
													conf_level = 0.95,
													split_panel = "One_Panel",
													legend_pos = "right",
													legend_dir = "vertical",
													sci_fill_color = "Sci_AAAS",
													sci_color_alpha = 0.75,
													ggTheme = "theme_light"
										){
	# -> 2. Data Operation
	# set.seed(123)
	# wdata = data.frame(
	#     sex = factor(rep(c("F", "M"), each=200)),
	#     weight = c(rnorm(200, 55), rnorm(200, 58)))
	# <- 2. Data Operation

	# -> 3. Plot Parameters
	# fonts <- "Times"
	# ChoiceBox: "Times", "Palatino", "Bookman", "Courier", "Helvetica", "URWGothic", "NimbusMon", "NimbusSan"

	# ggTheme <- "theme_light"
	# ChoiceBox: "theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw", "theme_dark", "theme_minimal", "theme_classic", "theme_void"
	if (ggTheme == "theme_default") {
		gg_theme <- theme()
	} else if (ggTheme == "theme_bw") {
		gg_theme <- theme_bw()
	} else if (ggTheme == "theme_gray") {
		gg_theme <- theme_gray()
	} else if (ggTheme == "theme_light") {
		gg_theme <- theme_light()
	} else if (ggTheme == "theme_linedraw") {
		gg_theme <- theme_linedraw()
	} else if (ggTheme == "theme_dark") {
		gg_theme <- theme_dark()
	} else if (ggTheme == "theme_minimal") {
		gg_theme <- theme_minimal()
	} else if (ggTheme == "theme_classic") {
		gg_theme <- theme_classic()
	} else if (ggTheme == "theme_void") {
		gg_theme <- theme_void()
	} else if (ggTheme == "theme_test") {
		gg_theme <- theme_test()
	}

	# sci_color_alpha <- 0.75
	# sci_fill_color <- "Sci_AAAS"
	# ChoiceBox: "Sci_AAAS", "Sci_NPG", "Sci_Simpsons", "Sci_JAMA", "Sci_GSEA", "Sci_Lancet", "Sci_Futurama", "Sci_JCO", "Sci_NEJM", "Sci_IGV", "Sci_UCSC", "Sci_D3", "Sci_Material"
	if (sci_fill_color == "Default") {
		sci_color <- NULL
	} else if (sci_fill_color == "Sci_AAAS") {
		sci_color <- scale_color_aaas(alpha = sci_color_alpha)
		# Science and Science Translational Medicine:
	} else if (sci_fill_color == "Sci_NPG") {
		sci_color <- scale_color_npg(alpha = sci_color_alpha)
	} else if (sci_fill_color == "Sci_Simpsons") {
		sci_color <- scale_color_simpsons(alpha = sci_color_alpha)
		# The Simpsons
	} else if (sci_fill_color == "Sci_JAMA") {
		sci_color <- scale_color_jama(alpha = sci_color_alpha)
		# The Journal of the American Medical Association
	} else if (sci_fill_color == "Sci_Lancet") {
		sci_color <- scale_color_lancet(alpha = sci_color_alpha)
		#  Lancet Oncology
	} else if (sci_fill_color == "Sci_Futurama") {
		sci_color <- scale_color_futurama(alpha = sci_color_alpha)
		# Futurama
	} else if (sci_fill_color == "Sci_JCO") {
		sci_color <- scale_color_jco(alpha = sci_color_alpha)
		# Journal of Clinical Oncology:
	} else if (sci_fill_color == "Sci_NEJM") {
		sci_color <- scale_color_nejm(alpha = sci_color_alpha)
		# The New England Journal of Medicine
	} else if (sci_fill_color == "Sci_IGV") {
		sci_color <- scale_color_igv(alpha = sci_color_alpha)
		# Integrative Genomics Viewer (IGV)
	} else if (sci_fill_color == "Sci_UCSC") {
		sci_color <- scale_color_ucscgb(alpha = sci_color_alpha)
		# UCSC Genome Browser chromosome sci_color
	} else if (sci_fill_color == "Sci_D3") {
		sci_color <- scale_color_d3(alpha = sci_color_alpha)
		# D3.JS
	} else if (sci_fill_color == "Sci_Material") {
		sci_color <- scale_color_material(alpha = sci_color_alpha)
		# The Material Design color palettes
	}

	# my_shape <- "fill_circle"
	# ChoiceBox: "border_square", "border_circle", "border_triangle", "plus", "times", "border_diamond", "border_triangle_down", "square_times", "plus_times", "diamond_plus", "circle_plus", "di_triangle", "square_plus", "circle_times","square_triangle", "fill_square", "fill_circle", "fill_triangle", "fill_diamond", "large_circle", "small_circle", "fill_border_circle", "fill_border_square", "fill_border_diamond", "fill_border_triangle"
	if (my_shape == "border_square") {
		shape <- 0
	} else if (my_shape == "border_circle") {
		shape <- 1
	} else if (my_shape == "border_triangle") {
		shape <- 2
	} else if (my_shape == "plus") {
		shape <- 3
	} else if (my_shape == "times") {
		shape <- 4
	} else if (my_shape == "border_diamond") {
		shape <- 5
	} else if (my_shape == "border_triangle_down") {
		shape <- 6
	} else if (my_shape == "square_times") {
		shape <- 7
	} else if (my_shape == "plus_times") {
		shape <- 8
	} else if (my_shape == "diamond_plus") {
		shape <- 9
	} else if (my_shape == "circle_plus") {
		shape <- 10
	} else if (my_shape == "di_triangle") {
		shape <- 11
	} else if (my_shape == "square_plus") {
		shape <- 12
	} else if (my_shape == "circle_times") {
		shape <- 13
	} else if (my_shape == "square_triangle") {
		shape <- 14
	} else if (my_shape == "fill_square") {
		shape <- 15
	} else if (my_shape == "fill_circle") {
		shape <- 16
	} else if (my_shape == "fill_triangle") {
		shape <- 17
	} else if (my_shape == "fill_diamond") {
		shape <- 18
	} else if (my_shape == "large_circle") {
		shape <- 19
	} else if (my_shape == "small_circle") {
		shape <- 20
	} else if (my_shape == "fill_border_circle") {
		shape <- 21
	} else if (my_shape == "fill_border_square") {
		shape <- 22
	} else if (my_shape == "fill_border_diamond") {
		shape <- 23
	} else if (my_shape == "fill_border_triangle") {
		shape <- 24
	}

	# title = "QuantileQuantile Plot"
	# TextField

	# xlab = "Theoretical"
	# ylab = "Sample"

	# point_size = 1.5
	# Slider: 10, 1, 50, 1

	# confInt = "Conf_Show"
	# # ChoiceBox: "Conf_Show", "Conf_Hidden"
	# if (confInt == "Conf_Show") {
	# 	conf_int = TRUE
	# } else if (confInt == "Conf_Hidden") {
	# 	conf_int = FALSE
	# }

	# conf_level = 0.95
	# Slider: 0.95, 0.00, 1.00, 0.01

	# split_panel = "One_Panel"
	# ChoiceBox: "One_Panel", "Split_Panel"
	if (split_panel == "One_Panel") {
		facet_by = NULL
	} else if (split_panel == "Split_Panel") {
		facet_by = colnames(data)[2]
	}

	plotTitleFace = "bold"
	# ChoiceBox: "plain", "italic", "bold", "bold.italic"

	plotTitleSize = 18
	# Slider: 18, 0, 50, 1

	plotTitleHjust = 0.5
	# Slider: 0.5, 0.0, 1.0, 0.1

	axisTitleFace = "plain"
	# ChoiceBox: "plain", "italic", "bold", "bold.italic"

	axisTitleSize = 16
	# Slider: 16, 0, 50, 1

	axisTextSize = 10
	# Slider: 10, 0, 50, 1

	legendTitleSize = 12
	# Slider: 12, 0, 50, 1

	# legend_pos = "right"
	# ChoiceBox: "none", "left", "right", "bottom", "top"

	# legend_dir = "vertical"
	# ChoiceBox: "horizontal", "vertical"
	# <- 3. Plot Parameters

	# # -> 4. Plot
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
								# title = title,
								# xlab = xlab,
								# ylab = ylab,
								facet.by = facet_by,
								panel.labs = NULL,
								short.panel.labs = FALSE
		) +
		sci_color +
		gg_theme +
		theme(plot.title = element_text(face = plotTitleFace,
																		# "plain", "italic", "bold", "bold.italic"
																		size = plotTitleSize,
																		hjust = plotTitleHjust
					),
					axis.title = element_text(face = axisTitleFace,
																		# "plain", "italic", "bold", "bold.italic"
																		size = axisTitleSize
					),
					axis.text = element_text(face = "plain",
																	 size = axisTextSize
					),
					legend.title = element_text(face = "plain",
																			size = legendTitleSize
					),
					legend.position = legend_pos,
					# "none", "left", "right", "bottom", "top"
					legend.direction = legend_dir
					# "horizontal" or "vertical"
		)
	# # <- 4. Plot

	return(p)
}
