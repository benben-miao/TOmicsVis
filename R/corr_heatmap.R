#' @title Correlation Heatmap for samples/groups based on Pearson algorithm.
#' @description Correlation Heatmap for samples/groups based on Pearson algorithm.
#' @author benben-miao
#'
#' @return Plot: heatmap plot filled with Pearson correlation values and P values.
#' @param data Dataframe: All genes in all samples expression dataframe of RNA-Seq (1st-col: Genes, 2nd-col~: Samples).
#' @param corr_method Character: correlation method. Default: "pearson", options: "pearson", "spearman", "kendall".
#' @param cell_shape Character: heatmap cell shape. Default: "square", options: "circle", "square".
#' @param fill_type Character: heatmap fill type. Default: "full", options: "upper", "low", "full".
#' @param lable_size Numeric: heatmap label size. Default: 3, min: 0.
#' @param axis_angle Numeric: axis rotate angle. Default: 45, min: 0, max: 360.
#' @param axis_size Numberic: axis font size. Default: 12, min: 0.
#' @param lable_digits Numeric: heatmap label digits. Default: 3, min: 0, max: 3.
#' @param color_low Character: low value color name or hex value. Default: "blue".
#' @param color_mid Character: middle value color name or hex value. Default: "white".
#' @param color_high Character: high value color name or hex value. Default: "red".
#' @param outline_color Character: outline color name or hex value. Default: "white".
#' @param ggTheme Character: ggplot2 theme. Default: "theme_light", options: "theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw", "theme_dark", "theme_minimal", "theme_classic", "theme_void".
#'
#' @import ggplot2
#' @importFrom ggcorrplot ggcorrplot
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset gene_exp
#' data(gene_expression)
#' head(gene_expression)
#'
#' # 3. Default parameters
#' corr_heatmap(gene_expression)
#'
#' # 4. Set color_low = "#008800"
#' corr_heatmap(gene_expression, color_low = "#008800")
#'
#' # 5. Set cell_shape = "circle"
#' corr_heatmap(gene_expression, cell_shape = "circle")
#'
corr_heatmap <- function(data,
												 corr_method = "pearson",
												 cell_shape = "square",
												 fill_type = "full",
												 lable_size = 3,
												 axis_angle = 45,
												 axis_size = 12,
												 lable_digits = 3,
												 color_low = "blue",
												 color_mid = "white",
												 color_high = "red",
												 outline_color = "white",
												 ggTheme = "theme_light") {
	# -> 2. NA and Duplicated
	data <- as.data.frame(data)
	data <- data[!is.na(data[, 1]), ]
	idx <- duplicated(data[, 1])
	data[idx, 1] <- paste0(data[idx, 1], "--dup-", cumsum(idx)[idx])
	rownames(data) <- data[, 1]
	data <- data[, -1]
	# <- 2. NA and Duplicated

	# -> 3. Plot parameters
	# corr_method <- "pearson"
	# ChoiceBox: "pearson", "spearman", "kendall"

	corr <- round(cor(data, use = "na.or.complete", method = corr_method), 3)
	if (corr_method == "pearson") {
		legend_title <- "Pearson's\ncorrelation\ncoefficient"
	} else if (corr_method == "spearman") {
		legend_title <- "Spearman's\ncorrelation\ncoefficient"
	} else if (corr_method == "kendall") {
		legend_title <- "Kendall's\ncorrelation\ncoefficient"
	}

	# method <- "square"
	# ChoiceBox: "circle", "square"

	# type <- "full"
	# ChoiceBox: "upper", "low", "full"

	lab <- TRUE
	# lab_size <- 3

	# color_low <- "blue"
	# color_mid <- "white"
	# color_high <- "red"

	# digits <- 3
	# Slider: 3, 0, 1, 3

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
	# <- 3. Plot parameters

	p <- ggcorrplot::ggcorrplot(
		corr,
		hc.method = "complete",
		method = cell_shape,
		# colors = c(color_low, color_mid, color_high),
		outline.color = outline_color,
		hc.order = FALSE,
		type = fill_type,
		lab = lab,
		lab_size = lable_size,
		tl.srt = axis_angle,
		tl.cex = axis_size,
		ggtheme = gg_theme,
		digits = lable_digits,
		# sig.level = 0.05,
		# insig = "pch",
		# pch = 4,
		# pch.col = "black",
		# pch.cex = 5,
		show.legend = TRUE,
		legend.title = legend_title
	) +
		scale_fill_gradient2(
			low = color_low,
			mid = color_mid,
			high = color_high,
			# limits = c(min(corr), max(corr)),
			midpoint = median(corr),
			space = "Lab",
			guide = "colourbar",
			aesthetics = "fill"
		) +
		labs(fill = legend_title)

	return(p)
}
