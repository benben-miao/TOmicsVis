#' @title Violin plot support two levels and multiple groups with P value.
#' @description Violin plot support two levels and multiple groups with P value.
#' @author benben-miao
#'
#' @return Plot: violin plot support two levels and multiple groups with P value.
#' @param data Dataframe: Length, Width, Weight, and Sex traits dataframe (1st-col: Value, 2nd-col: Traits, 3rd-col: Sex).
#' @param test_method Character: test methods of P value. Default: "t.test", options: "wilcox.test", "t.test", "anova", "kruskal.test".
#' @param test_label Character: test label of P value. Default: "p.format", options: "p.signif", "p.format". c(0, 0.0001, 0.001, 0.01, 0.05, 1).
#' @param group_level Character: group levels. Default: "Three_Column", options: "Two_Column", "Three_Column".
#' @param violin_orientation Character: violin orientation. Default: "vertical", options: "vertical", "horizontal", "reverse".
#' @param add_element Character: add new plot. Default: "boxplot", options: "none", "dotplot", "jitter", "boxplot", "point", "mean", "mean_se", "mean_sd", "mean_ci", "mean_range", "median", "median_iqr", "median_hilow", "median_q1q3", "median_mad", "median_range".
#' @param element_alpha Numeric: element color alpha. Default: 0.50, min: 0.00, max: 1.00.
#' @param my_shape Character: box scatter shape. Default: "plus_times", options: "border_square", "border_circle", "border_triangle", "plus", "times", "border_diamond", "border_triangle_down", "square_times", "plus_times", "diamond_plus", "circle_plus", "di_triangle", "square_plus", "circle_times","square_triangle", "fill_square", "fill_circle", "fill_triangle", "fill_diamond", "large_circle", "small_circle", "fill_border_circle", "fill_border_square", "fill_border_diamond", "fill_border_triangle".
#' @param sci_fill_color Character: ggsci color pallet. Default: "Sci_AAAS", options: "Sci_AAAS", "Sci_NPG", "Sci_Simpsons", "Sci_JAMA", "Sci_GSEA", "Sci_Lancet", "Sci_Futurama", "Sci_JCO", "Sci_NEJM", "Sci_IGV", "Sci_UCSC", "Sci_D3", "Sci_Material".
#' @param sci_fill_alpha Numeric: ggsci fill color alpha. Default: 0.50, min: 0.00, max: 1.00.
#' @param sci_color_alpha Numeric: ggsci border color alpha. Default: 1.00, min: 0.00, max: 1.00.
#' @param legend_pos Character: legend position. Default: "right", options: "none", "left", "right", "bottom", "top".
#' @param legend_dir Character: legend direction. Default: "vertical", options: "horizontal", "vertical".
#' @param ggTheme Character: ggplot2 themes. Default: "theme_publication", options: "theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw", "theme_dark", "theme_minimal", "theme_classic", "theme_void"
#'
#' @import ggplot2
#' @import ggsci
#' @importFrom utils combn
#' @export
#' @note Requires package 'ggpubr' (install via: install.packages("ggpubr"))
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset
#' data(traits_sex)
#' head(traits_sex)
#'
#' # 3. Default parameters
#' violin_plot(traits_sex)
#'
#' # 4. Set test_label = "p.signif",
#' violin_plot(traits_sex, test_label = "p.signif")
#'
#' # 5. Set violin_orientation = "horizontal"
#' violin_plot(traits_sex, violin_orientation = "horizontal")
#'
#' # 6. Set group_level = "Two_Column"
#' violin_plot(traits_sex, group_level = "Two_Column")
#'
#' # 7. Set add_element = "jitter"
#' violin_plot(traits_sex, add_element = "jitter")
#'

violin_plot <- function(data,
										 test_method = "t.test",
										 test_label = "p.format",
										 group_level = "Three_Column",
										 violin_orientation = "vertical",
										 add_element = "boxplot",
										 element_alpha = 0.50,
										 my_shape = "plus_times",
										 sci_fill_color = "Sci_AAAS",
										 sci_fill_alpha = 0.50,
										 sci_color_alpha = 1.00,
										 legend_pos = "right",
										 legend_dir = "vertical",
										 ggTheme = "theme_publication"
										){

	validate_character_options(ggTheme, "ggTheme",
														 c("theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw",
															 "theme_dark", "theme_minimal", "theme_classic", "theme_void",
															 "theme_publication"))

	if (!is.data.frame(data) && !is.matrix(data)) {
		stop("data must be a data.frame or matrix", call. = FALSE)
	}

	if (ncol(data) < 2) {
		stop("data must have at least 2 columns", call. = FALSE)
	}

	if (!requireNamespace("ggpubr", quietly = TRUE)) {
		stop("Package 'ggpubr' is required for violin_plot().\n",
             "Please install: install.packages('ggpubr')",
             call. = FALSE)
	}

	gg_theme <- get_ggtheme(ggTheme)

	if (sci_fill_color == "Default") {
		sci_fill <- NULL
		sci_color <- NULL
	} else {
		sci_fill <- get_ggsci_fill(sci_fill_color, alpha = sci_fill_alpha)
		sci_color <- get_ggsci_color(sci_fill_color)
		if (!is.null(sci_color)) {
			sci_color <- sci_color(alpha = sci_color_alpha)
		}
	}

	shape_map <- c(
		"border_square" = 0, "border_circle" = 1, "border_triangle" = 2,
		"plus" = 3, "times" = 4, "border_diamond" = 5,
		"border_triangle_down" = 6, "square_times" = 7, "plus_times" = 8,
		"diamond_plus" = 9, "circle_plus" = 10, "di_triangle" = 11,
		"square_plus" = 12, "circle_times" = 13, "square_triangle" = 14,
		"fill_square" = 15, "fill_circle" = 16, "fill_triangle" = 17,
		"fill_diamond" = 18, "large_circle" = 19, "small_circle" = 20,
		"fill_border_circle" = 21, "fill_border_square" = 22,
		"fill_border_diamond" = 23, "fill_border_triangle" = 24
	)

	if (!my_shape %in% names(shape_map)) {
		warning("Invalid my_shape: ", my_shape, ", using default 'plus_times'")
		my_shape <- "plus_times"
	}
	shape <- unname(shape_map[my_shape])

	xlab <- colnames(data)[2]
	ylab <- colnames(data)[1]

	violinAlpha = 0.50
	violinWidth <- 0.8
	lineType <- "solid"
	lineSize <- 1.0
	boxError <- "errorbar"
	elementSize <- 1.0

	hide_ns <- FALSE
	bracketSize <- 1.0

	plotTitleFace <- "bold"
	plotTitleSize <- 18
	plotTitleHjust <- 0.5
	axisTitleFace <- "plain"
	axisTitleSize <- 16
	axisTextSize <- 10
	legendTitleSize <- 12

	groups <- unique(data[[2]])
	my_comparisons <- utils::combn(groups, 2, simplify = FALSE)
	my_comparisons <- lapply(my_comparisons, as.character)

	if (group_level == "Two_Column") {
		p <- ggpubr::ggviolin(
			data,
			x = colnames(data)[2],
			y = colnames(data)[1],
			combine = FALSE,
			merge = FALSE,
			color = colnames(data)[2],
			fill = colnames(data)[2],
			alpha = violinAlpha,
			xlab = xlab,
			ylab = ylab,
			linetype = lineType,
			size = lineSize,
			width = violinWidth,
			trim = FALSE,
			orientation = violin_orientation,
			add = add_element,
			add.params = list(
				color = colnames(data)[2],
				fill = colnames(data)[2],
				size = elementSize,
				alpha = element_alpha
			),
			shape = shape,
			error.plot = boxError
		) +
		ggpubr::stat_compare_means(
			comparisons = my_comparisons,
			method = test_method,
			hide.ns = hide_ns,
			label = test_label,
			tip.length = 0.03,
			bracket.size = bracketSize,
			show.legend = FALSE
		) +
		sci_fill +
		sci_color +
		gg_theme +
		theme(
			plot.title = element_text(
				face = plotTitleFace,
				size = plotTitleSize,
				hjust = plotTitleHjust
			),
			axis.title = element_text(face = axisTitleFace, size = axisTitleSize),
			axis.text = element_text(face = "plain", size = axisTextSize),
			legend.title = element_text(face = "plain", size = legendTitleSize),
			legend.position = legend_pos,
			legend.direction = legend_dir,
			strip.background = element_rect(fill = "#cdcdcd", color = "#cdcdcd"),
			strip.text = element_text(
				color = "#333333",
				size = 10,
				face = "bold"
			)
		)
	} else if (group_level == "Three_Column") {
		p <- ggpubr::ggviolin(
			data,
			x = colnames(data)[2],
			y = colnames(data)[1],
			combine = FALSE,
			merge = FALSE,
			color = colnames(data)[2],
			fill = colnames(data)[2],
			alpha = violinAlpha,
			xlab = xlab,
			ylab = ylab,
			facet.by = colnames(data)[3],
			panel.labs = NULL,
			short.panel.labs = FALSE,
			linetype = lineType,
			size = lineSize,
			width = violinWidth,
			trim = FALSE,
			orientation = violin_orientation,
			add = add_element,
			add.params = list(
				color = colnames(data)[2],
				fill = colnames(data)[2],
				size = elementSize,
				alpha = element_alpha
			),
			shape = shape,
			error.plot = boxError
		) +
		ggpubr::stat_compare_means(
			comparisons = my_comparisons,
			method = test_method,
			hide.ns = hide_ns,
			label = test_label,
			tip.length = 0.03,
			bracket.size = bracketSize,
			show.legend = FALSE
		) +
		sci_fill +
		sci_color +
		gg_theme +
		theme(
			plot.title = element_text(
				face = plotTitleFace,
				size = plotTitleSize,
				hjust = plotTitleHjust
			),
			axis.title = element_text(face = axisTitleFace, size = axisTitleSize),
			axis.text = element_text(face = "plain", size = axisTextSize),
			legend.title = element_text(face = "plain", size = legendTitleSize),
			legend.position = legend_pos,
			legend.direction = legend_dir,
			strip.background = element_rect(fill = "#cdcdcd", color = "#cdcdcd"),
			strip.text = element_text(
				color = "#333333",
				size = 10,
				face = "bold"
			)
		)
	}

	return(p)
}
