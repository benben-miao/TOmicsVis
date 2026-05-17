#' @title MversusA plot for visualizing differentially expressed genes.
#' @description MversusA plot for visualizing differentially expressed genes.
#' @author benben-miao
#'
#' @return Plot: MversusA plot for visualizing differentially expressed genes.
#' @param data Dataframe: differentially expressed genes (DEGs) stats 2 (1st-col: Gene, 2nd-col: baseMean, 3rd-col: Log2FoldChange, 4th-col: FDR).
#' @param foldchange Numeric: fold change value. Default: 1.0, min: 0.0, max: null.
#' @param fdr_value Numeric: false discovery rate. Default: 0.05, min: 0.00, max: 1.00.
#' @param point_size Numeric: point size. Default: 1.0, min: 0.0, max: null.
#' @param color_up Character: up-regulated genes color (color name or hex value). Default: "#FF0000".
#' @param color_down Character: down-regulated genes color (color name or hex value). Default: "#008800".
#' @param color_alpha Numeric: point color alpha. Default: 0.50, min: 0.00, max: 1.00.
#' @param top_method Character: top genes select method. Default: "fc" (fold change), options: "padj" (p-adjust), "fc".
#' @param top_num Numeric: top genes number. Default: 20, min: 0, max: null.
#' @param label_size Numeric: label font size. Default: 8.00, min: 0.00, max: null.
#' @param label_box Logical: add box to label. Default: TRUE, options: TRUE, FALSE.
#' @param title Character: plot title. Default: "CT-vs-Trait1".
#' @param xlab Character: x label. Default: "Log2 mean expression".
#' @param ylab Character: y label. Default: "Log2 fold change".
#' @param ggTheme Character: ggplot2 themes. Default: "theme_publication", options: "theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw", "theme_dark", "theme_minimal", "theme_classic", "theme_void"
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
#' data(degs_stats2)
#' head(degs_stats2)
#'
#' # 3. Default parameters
#' ma_plot(degs_stats2)
#'
#' # 4. Set color_up = "#FF8800"
#' ma_plot(degs_stats2, color_up = "#FF8800")
#'
#' # 5. Set top_num = 10
#' ma_plot(degs_stats2, top_num = 10)
#'
ma_plot <- function(data,
										foldchange = 1.0,
										fdr_value = 0.05,
										point_size = 3.0,
										color_up = "#FF0000",
										color_down = "#008800",
										color_alpha = 0.50,
										top_method = "fc",
										top_num = 20,
										label_size = 8.00,
										label_box = TRUE,
										title = "CT-vs-LT12",
										xlab = "Log2 mean expression",
										ylab = "Log2 fold change",
										ggTheme = "theme_publication") {

	validate_is_dataframe_or_matrix(data, "data")
	validate_numeric_range(ncol(data), "ncol(data)", min = 4)
	validate_character_options(top_method, "top_method", c("fc", "pvalue"))
	validate_numeric_range(foldchange, "foldchange", min = 0)
	validate_numeric_range(fdr_value, "fdr_value", min = 0, max = 1)
	validate_numeric_range(point_size, "point_size", min = 0)
	validate_hex_color(color_up, "color_up")
	validate_hex_color(color_down, "color_down")
	validate_numeric_range(color_alpha, "color_alpha", min = 0, max = 1)
	validate_numeric_range(top_num, "top_num", min = 0)
	validate_numeric_range(label_size, "label_size", min = 0)
	validate_logical(label_box, "label_box")
	validate_character_options(ggTheme, "ggTheme",
														 c("theme_default", "theme_bw", "theme_gray", "theme_light",
															 "theme_linedraw", "theme_dark", "theme_minimal", "theme_classic", "theme_void",
															 "theme_publication"))

	if (!requireNamespace("ggpubr", quietly = TRUE)) {
		stop("Package 'ggpubr' is required for ma_plot().\n",
             "Please install: install.packages('ggpubr')",
             call. = FALSE)
	}

	gg_theme <- get_ggtheme(ggTheme)

	p <- ggpubr::ggmaplot(
		data,
		fdr = fdr_value,
		fc = foldchange,
		genenames = as.vector(data[[1]]),
		detection_call = NULL,
		size = point_size,
		alpha = color_alpha,
		seed = 123,
		font.label = c(label_size, "bold", "black"),
		label.rectangle = label_box,
		palette = c(color_up, color_down, "#AAAAAA"),
		top = top_num,
		select.top.method = top_method,
		label.select = NULL,
		main = title,
		xlab = xlab,
		ylab = ylab
	) +
		gg_theme +
		theme(
			plot.title = element_text(face = "bold", size = 18, hjust = 0.5),
			axis.title = element_text(face = "plain", size = 16),
			axis.text = element_text(face = "plain", size = 10),
			legend.title = element_text(face = "plain", size = 12),
			legend.position = "right",
			legend.direction = "vertical"
		)

	return(p)
}
