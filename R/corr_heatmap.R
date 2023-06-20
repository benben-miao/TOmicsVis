#' @title Correlation Heatmap for samples/groups based on Pearson algorithm.
#' @description Correlation Heatmap for samples/groups based on Pearson algorithm.
#' @author benben-miao
#'
#' @return Plot: heatmap plot filled with Pearson correlation values and P values.
#' @param data Dataframe: gene expression dataframe with cols (samples) and rows (genes).
#' @param corr_method Character: correlation method. Default: "pearson", options: "pearson", "spearman", "kendall".
#' @param cell_shape Character: heatmap cell shape. Default: "square", options: "circle", "square".
#' @param fill_type Character: heatmap fill type. Default: "full", options: "upper", "low", "full".
#' @param lable_size Numeric: heatmap label size. Default: 3, min: 0.
#' @param lable_digits Numeric: heatmap label digits. Default: 3, min: 0, max: 3.
#' @param color_low Character: low value color name or hex value. Default: "blue".
#' @param color_mid Character: middle value color name or hex value. Default: "white".
#' @param color_high Character: high value color name or hex value. Default: "red".
#' @param ggTheme Character: ggplot2 theme. Default: "theme_light", options: "theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw", "theme_dark", "theme_minimal", "theme_classic", "theme_void".
#'
#' @import stats
#' @import ggplot2
#' @import ggcorrplot
#' @export
#'
#' @examples
#' data(gene_exp)
#' corr_heatmap(gene_exp)
#'
corr_heatmap <- function(data,
												 corr_method = "pearson",
												 cell_shape = "square",
												 fill_type = "full",
												 lable_size = 3,
												 lable_digits = 3,
												 color_low = "blue",
												 color_mid = "white",
												 color_high = "red",
												 ggTheme = "theme_light"
												 ){
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

	p <- ggcorrplot(corr,
									hc.method = "complete",
									method = cell_shape,
									# colors = c(color_low, color_mid, color_high),
									outline.color = "white",
									hc.order = TRUE,
									type = fill_type,
									lab = lab,
									lab_size = lable_size,
									legend.title = "Correlation",
									ggtheme = gg_theme,
									digits = lable_digits
									) +
		scale_fill_gradient2(low = color_low,
												 mid = color_mid,
												 high = color_high,
												 limits = c(min(corr), max(corr))
												 ) +
		theme(text = element_text(family = "Times")
					)

	return(p)
}
