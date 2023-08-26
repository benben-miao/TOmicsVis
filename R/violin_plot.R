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
#' @param ggTheme Character: ggplot2 themes. Default: "theme_light", options: "theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw", "theme_dark", "theme_minimal", "theme_classic", "theme_void"
#'
#' @import ggplot2
#' @import ggsci
#' @importFrom ggpubr ggviolin
#' @importFrom utils combn
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

	# sci_fill_alpha <- 0.50
	# sci_color_alpha <- 1.00
	# sci_fill_color <- "Sci_AAAS"
	# ChoiceBox: "Sci_AAAS", "Sci_NPG", "Sci_Simpsons", "Sci_JAMA", "Sci_GSEA", "Sci_Lancet", "Sci_Futurama", "Sci_JCO", "Sci_NEJM", "Sci_IGV", "Sci_UCSC", "Sci_D3", "Sci_Material"
	if (sci_fill_color == "Default") {
		sci_fill <- NULL
		sci_color <- NULL
	} else if (sci_fill_color == "Sci_AAAS") {
		sci_fill <- scale_fill_aaas(alpha = sci_fill_alpha)
		sci_color <- scale_color_aaas(alpha = sci_color_alpha)
		# Science and Science Translational Medicine:
	} else if (sci_fill_color == "Sci_NPG") {
		sci_fill <- scale_fill_npg(alpha = sci_fill_alpha)
		sci_color <- scale_color_npg(alpha = sci_color_alpha)
	} else if (sci_fill_color == "Sci_Simpsons") {
		sci_fill <- scale_fill_simpsons(alpha = sci_fill_alpha)
		sci_color <- scale_color_simpsons(alpha = sci_color_alpha)
		# The Simpsons
	} else if (sci_fill_color == "Sci_JAMA") {
		sci_fill <- scale_fill_jama(alpha = sci_fill_alpha)
		sci_color <- scale_color_jama(alpha = sci_color_alpha)
		# The Journal of the American Medical Association
	} else if (sci_fill_color == "Sci_Lancet") {
		sci_fill <- scale_fill_lancet(alpha = sci_fill_alpha)
		sci_color <- scale_color_lancet(alpha = sci_color_alpha)
		#  Lancet Oncology
	} else if (sci_fill_color == "Sci_Futurama") {
		sci_fill <- scale_fill_futurama(alpha = sci_fill_alpha)
		sci_color <- scale_color_futurama(alpha = sci_color_alpha)
		# Futurama
	} else if (sci_fill_color == "Sci_JCO") {
		sci_fill <- scale_fill_jco(alpha = sci_fill_alpha)
		sci_color <- scale_color_jco(alpha = sci_color_alpha)
		# Journal of Clinical Oncology:
	} else if (sci_fill_color == "Sci_NEJM") {
		sci_fill <- scale_fill_nejm(alpha = sci_fill_alpha)
		sci_color <- scale_color_nejm(alpha = sci_color_alpha)
		# The New England Journal of Medicine
	} else if (sci_fill_color == "Sci_IGV") {
		sci_fill <- scale_fill_igv(alpha = sci_fill_alpha)
		sci_color <- scale_color_igv(alpha = sci_color_alpha)
		# Integrative Genomics Viewer (IGV)
	} else if (sci_fill_color == "Sci_UCSC") {
		sci_fill <- scale_fill_ucscgb(alpha = sci_fill_alpha)
		sci_color <- scale_color_ucscgb(alpha = sci_color_alpha)
		# UCSC Genome Browser chromosome sci_fill
	} else if (sci_fill_color == "Sci_D3") {
		sci_fill <- scale_fill_d3(alpha = sci_fill_alpha)
		sci_color <- scale_color_d3(alpha = sci_color_alpha)
		# D3.JS
	} else if (sci_fill_color == "Sci_Material") {
		sci_fill <- scale_fill_material(alpha = sci_fill_alpha)
		sci_color <- scale_color_material(alpha = sci_color_alpha)
		# The Material Design color palettes
	}

	# my_shape <- "plus_times"
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

	# title <- "Violin with Stat"
	# TextField

	xlab <- colnames(data)[2]
	ylab <- colnames(data)[1]

	# group_level <- "Three_Column"
	# ChoiceBox: "Two_Column", "Three_Column"

	violinAlpha = 0.50
	# Slider: 0.50, 0.01, 1.00, 0.01

	violinWidth <- 0.8
	# Slider: 0.8, 0.0, 1.0, 0.1

	# violin_orientation <- "vertical"
	# ChoiceBox: "vertical", "horizontal", "reverse"

	lineType <- "solid"
	# ChoiceBox: "blank", "solid", "dashed", "dotted", "dotdash", "longdash", "twodash"

	lineSize <- 1.0
	# ChoiceBox: 1.0, 0.0, 10.0, 0.1

	# add_element <- "boxplot"
	# ChoiceBox: "none", "dotplot", "jitter", "boxplot", "point", "mean", "mean_se", "mean_sd", "mean_ci", "mean_range", "median", "median_iqr", "median_hilow", "median_q1q3", "median_mad", "median_range"

	boxError <- "errorbar"
	# ChoiceBox: "pointrange", "linerange", "crossbar", "errorbar", "upper_errorbar", "lower_errorbar", "upper_pointrange", "lower_pointrange", "upper_linerange", "lower_linerange"

	elementSize <- 1.0
	# Slider: 1.0, 0.0, 10.0, 0.1

	# element_alpha <- 0.50
	# Slider: 0.50, 0.00, 1.00, 0.01

	# test_method <- "wilcox.test"
	# ChoiceBox: "wilcox.test", "t.test", "anova", "kruskal.test"

	nsShow <- "NS_Show"
	# ChoiceBox: "NS_Show", "NS_Hidden"
	if (nsShow == "NS_Show") {
		hide_ns <- FALSE
	} else if (nsShow == "NS_Hidden") {
		hide_ns <- TRUE
	}

	# test_label <- "p.format"
	# ChoiceBox: "p.signif", "p.format"

	bracketSize <- 1.0
	# Slider: 1.0, 0.0, 10.0, 0.1

	plotTitleFace <- "bold"
	# ChoiceBox: "plain", "italic", "bold", "bold.italic"

	plotTitleSize <- 18
	# Slider: 18, 0, 50, 1

	plotTitleHjust <- 0.5
	# Slider: 0.5, 0.0, 1.0, 0.1

	axisTitleFace <- "plain"
	# ChoiceBox: "plain", "italic", "bold", "bold.italic"

	axisTitleSize <- 16
	# Slider: 16, 0, 50, 1

	axisTextSize <- 10
	# Slider: 10, 0, 50, 1

	legendTitleSize <- 12
	# Slider: 12, 0, 50, 1

	# legend_pos <- "right"
	# ChoiceBox: "none", "left", "right", "bottom", "top"

	# legend_dir <- "vertical"
	# ChoiceBox: "horizontal", "vertical"

	groups <- unique(data[[2]])
	my_comparisons <- utils::combn(groups, 2, simplify = FALSE)
	my_comparisons <- lapply(my_comparisons, as.character)

	symnum_args <- list(cutpoints = c(0, 0.0001, 0.001, 0.01, 0.05, 1),
											symbols = c("****", "***", "**", "*", "ns"))
	# <- 3. Plot Parameters

	# # -> 4. Plot
	if (group_level == "Two_Column") {
		p <- ggpubr::ggviolin(data,
									x = colnames(data)[2],
									y = colnames(data)[1],
									combine = FALSE,
									merge = FALSE,
									color = colnames(data)[2],
									fill = colnames(data)[2],
									alpha = violinAlpha,
									# title = title,
									xlab = xlab,
									ylab = ylab,
									# facet.by = colnames(data)[3],
									# panel.labs = NULL,
									# short.panel.labs = FALSE,
									linetype = lineType,
									size = lineSize, # Numeric value (e.g.: size = 1). change the size of points and outlines
									width = violinWidth, # numeric value between 0 and 1 specifying box width
									trim = FALSE,
									# draw_quantiles = 0.5,
									orientation = violin_orientation, # "vertical", "horizontal", "reverse"
									# "blank", "solid", "dashed", "dotted", "dotdash", "longdash", "twodash"
									add = add_element,
									add.params = list(color = colnames(data)[2],
																		fill = colnames(data)[2],
																		size = elementSize,
																		alpha = element_alpha),
									shape = shape,
									# "none", "dotplot", "jitter", "boxplot", "point", "mean", "mean_se", "mean_sd", "mean_ci", "mean_range", "median", "median_iqr", "median_hilow", "median_q1q3", "median_mad", "median_range"
									error.plot = boxError
									# "pointrange", "linerange", "crossbar", "errorbar", "upper_errorbar", "lower_errorbar", "upper_pointrange", "lower_pointrange", "upper_linerange", "lower_linerange"
		) +
			stat_compare_means(
				comparisons = my_comparisons,
				method = test_method, # "wilcox.test", "t.test", "anova", "kruskal.test"
				hide.ns = hide_ns,
				label = test_label, # "p.signif", "p.format"
				tip.length = 0.03,
				bracket.size = bracketSize,
				# symnum.args = symnum_args,
				show.legend = FALSE
			) +
			sci_fill +
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
						legend.direction = legend_dir,
						# "horizontal" or "vertical"
						strip.background = element_rect(fill = "#cdcdcd", color = "#cdcdcd"),
						strip.text = element_text(color = "#333333", size = 10, face = "bold")
			)
	} else if (group_level == "Three_Column") {
		p <- ggviolin(data,
									x = colnames(data)[2],
									y = colnames(data)[1],
									combine = FALSE,
									merge = FALSE,
									color = colnames(data)[2],
									fill = colnames(data)[2],
									alpha = violinAlpha,
									# title = title,
									xlab = xlab,
									ylab = ylab,
									facet.by = colnames(data)[3],
									panel.labs = NULL,
									short.panel.labs = FALSE,
									linetype = lineType,
									size = lineSize, # Numeric value (e.g.: size = 1). change the size of points and outlines
									width = violinWidth, # numeric value between 0 and 1 specifying box width
									trim = FALSE,
									# draw_quantiles = 0.5,
									orientation = violin_orientation, # "vertical", "horizontal", "reverse"
									# "blank", "solid", "dashed", "dotted", "dotdash", "longdash", "twodash"
									add = add_element,
									add.params = list(color = colnames(data)[2],
																		fill = colnames(data)[2],
																		size = elementSize,
																		alpha = element_alpha),
									shape = shape,
									# "none", "dotplot", "jitter", "boxplot", "point", "mean", "mean_se", "mean_sd", "mean_ci", "mean_range", "median", "median_iqr", "median_hilow", "median_q1q3", "median_mad", "median_range"
									error.plot = boxError
									# "pointrange", "linerange", "crossbar", "errorbar", "upper_errorbar", "lower_errorbar", "upper_pointrange", "lower_pointrange", "upper_linerange", "lower_linerange"
		) +
			stat_compare_means(
				comparisons = my_comparisons,
				method = test_method, # "wilcox.test", "t.test", "anova", "kruskal.test"
				hide.ns = hide_ns,
				label = test_label, # "p.signif", "p.format"
				tip.length = 0.03,
				bracket.size = bracketSize,
				# symnum.args = symnum_args,
				show.legend = FALSE
			) +
			sci_fill +
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
						legend.direction = legend_dir,
						# "horizontal" or "vertical"
						strip.background = element_rect(fill = "#cdcdcd", color = "#cdcdcd"),
						strip.text = element_text(color = "#333333", size = 10, face = "bold")
			)
	}
	# <- 4. Plot

	return(p)
}
