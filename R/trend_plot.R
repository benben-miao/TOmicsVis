#' @title Trend plot for visualizing gene expression trend profile in multiple traits.
#' @description Trend plot for visualizing gene expression trend profile in multiple traits.
#' @author benben-miao
#'
#' @return Plot: box plot support two levels and multiple groups with P value.
#' @param data Dataframe: include columns (Gene, Trait1, Trait2, ..., Pathway), rows (Genes).
#' @param scale_method Character: data scale methods. Default: "globalminmax" (global min and max values), options: "std" (standard), "robust", "uniminmax" (unique min and max values), "globalminmax", "center", "centerObs" (center observes).
#' @param miss_value Character: deal method for missing values. Default: "exclude", options: "exclude", "mean", "median", "min10", "random".
#' @param line_alpha Numeric: lines color alpha. Default: 0.50, min: 0.00, max: 1.00.
#' @param show_points Logical: show points at trait node. Default: TRUE, options: TRUE, FALSE.
#' @param show_boxplot Logical: show boxplot at trait node. Default: TRUE, options: TRUE, FALSE.
#' @param num_column Logical: column number. Default: 2, min: 1, max: null.
#' @param xlab Character: x label. Default: "Traits".
#' @param ylab Character: y label. Default: "Genes Expression".
#' @param sci_fill_color Character: ggsci color pallet. Default: "Sci_AAAS", options: "Sci_AAAS", "Sci_NPG", "Sci_Simpsons", "Sci_JAMA", "Sci_GSEA", "Sci_Lancet", "Sci_Futurama", "Sci_JCO", "Sci_NEJM", "Sci_IGV", "Sci_UCSC", "Sci_D3", "Sci_Material".
#' @param sci_fill_alpha Numeric: ggsci fill color alpha. Default: 0.50, min: 0.00, max: 1.00.
#' @param sci_color_alpha Numeric: ggsci border color alpha. Default: 1.00, min: 0.00, max: 1.00.
#' @param legend_pos Character: legend position. Default: "right", options: "none", "left", "right", "bottom", "top".
#' @param legend_dir Character: legend direction. Default: "vertical", options: "horizontal", "vertical".
#' @param ggTheme Character: ggplot2 themes. Default: "theme_light", options: "theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw", "theme_dark", "theme_minimal", "theme_classic", "theme_void"
#'
#' @import stats
#' @import ggplot2
#' @import ggsci
#' @import GGally
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset
#' data(trend_data)
#'
#' # 3. Default parameters
#' trend_plot(trend_data)
#'
#' # 4. Set scale_method = "std"
#' trend_plot(trend_data, scale_method = "std")
#'
#' # 5. Set miss_value = "mean"
#' trend_plot(trend_data, miss_value = "mean")
#'
#' # 6. Set line_alpha = 0.30
#' trend_plot(trend_data, line_alpha = 0.30)
#'
#' # 7. Set sci_fill_color = "Sci_IGV"
#' trend_plot(trend_data, sci_fill_color = "Sci_IGV")
#'
trend_plot <- function(data,
											 scale_method = "globalminmax",
											 miss_value = "exclude",
											 line_alpha = 0.50,
											 show_points = TRUE,
											 show_boxplot = TRUE,
											 num_column = 2,
											 xlab = "Traits",
											 ylab = "Genes Expression",
											 sci_fill_color = "Sci_AAAS",
											 sci_fill_alpha = 0.80,
											 sci_color_alpha = 0.80,
											 legend_pos = "right",
											 legend_dir = "vertical",
											 ggTheme = "theme_light"
											){
	# -> 2. Data Operation
	# set.seed(123)
	# df <- data.frame(x = rnorm(200), y = rnorm(200))
	# write.table(df, "DensityContour.txt", quote = F, sep = "\t", row.names = F)
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

	# sci_fill_alpha <- 0.80
	# sci_color_alpha <- 0.80
	# sci_fill_color <- "Sci_NPG"
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

	# title <- "Gene Expression Trend"
	# TextField

	# xlab <- "Traits"
	# ylab <- "Expression Value"
	# ==========

	# scale_method <- "globalminmax"
	# ChoiceBox: "std", "robust", "uniminmax", "globalminmax", "center", "centerObs"

	# miss_value <- "exclude"
	# ChoiceBox: "exclude", "mean", "median", "min10", "random"

	# line_alpha <- 0.50
	# Slider: 0.50, 0.00, 1.00, 0.01

	# pointShow <- "Point_Show"
	# # ChoiceBox: "Point_Show", "Point_Hidden"
	# if (pointShow == "Point_Show") {
	# 	show_points <- TRUE
	# } else if (pointShow == "Point_Hidden") {
	# 	show_points <- FALSE
	# }

	# boxShow <- "Box_Show"
	# # ChoiceBox: "Box_Show", "Box_Hidden"
	# if (boxShow == "Box_Show") {
	# 	show_boxplot <- TRUE
	# } else if (boxShow == "Box_Hidden") {
	# 	show_boxplot <- FALSE
	# }

	# num_column <- 2
	# Slider: 2, 1, 10, 1

	# =========
	plotTitleFace <- "bold"
	# ChoiceBox: "plain", "italic", "bold", "bold.italic"

	plotTitleSize <- 18
	# Slider: 18, 0, 50, 1

	plotTitleHjust <- 0.5
	# Slider: 0.5, 0.0, 1.0, 0.1

	axisTitleFace <- "plain"
	# ChoiceBox: "plain", "italic", "bold", "bold.italic"

	axisTitleSize <- 14
	# Slider: 16, 0, 50, 1

	axisTextSize <- 10
	# Slider: 10, 0, 50, 1

	legendTitleSize <- 12
	# Slider: 12, 0, 50, 1

	# legend_pos <- "right"
	# ChoiceBox: "none", "left", "right", "bottom", "top"

	# legend_dir <- "vertical"
	# ChoiceBox: "horizontal", "vertical"
	# <- 3. Plot Parameters

	# # -> 4. Plot
	p <- ggparcoord(data,
									columns = 2:(ncol(data) - 1),
									groupColumn = ncol(data),
									scale = scale_method, # "std", "robust", "uniminmax", "globalminmax", "center", "centerObs"
									missing = miss_value, # "exclude", "mean", "median", "min10", "random"
									# order = columns,
									alphaLines = line_alpha,
									showPoints = show_points,
									boxplot = show_boxplot
									# title = title
	) +
		facet_wrap(formula(paste("~", (colnames(data)[ncol(data)]))),
							 ncol = num_column
		) +
		labs(x = xlab,
				 y = ylab
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
					legend.direction = legend_dir
					# "horizontal" or "vertical"
		)
	# # <- 4. Plot

	return(p)
	invisible()
}
