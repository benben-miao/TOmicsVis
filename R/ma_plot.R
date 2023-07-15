#' @title MversusA plot for visualizing differentially expressed genes.
#' @description MversusA plot for visualizing differentially expressed genes.
#' @author benben-miao
#'
#' @return Plot: MversusA plot for visualizing differentially expressed genes.
#' @param data Dataframe: include columns (Genes, baseMean, Log2FoldChange, Padj), rows (Genes).
#' @param foldchange Numeric: fold change value. Default: 2.00, min: 0.00, max: null.
#' @param fdr_value Numeric: false discovery rate. Default: 0.05, min: 0.00, max: 1.00.
#' @param point_size Numeric: point size. Default: 0.50, min: 0.00, max: null.
#' @param color_up Character: up-regulated genes color (color name or hex value). Default: "#FF0000".
#' @param color_down Character: down-regulated genes color (color name or hex value). Default: "#008800".
#' @param color_alpha Numeric: point color alpha. Default: 0.50, min: 0.00, max: 1.00.
#' @param top_method Character: top genes select method. Default: "fc" (fold change), options: "padj" (p-adjust), "fc".
#' @param top_num Numeric: top genes number. Default: 20, min: 0, max: null.
#' @param label_size Numeric: label font size. Default: 8.00, min: 0.00, max: null.
#' @param label_box Logical: add box to label. Default: TRUE, options: TRUE, FALSE.
#' @param title Character: plot title. Default: "Group1 -versus- Group2".
#' @param xlab Character: x label. Default: "Log2 mean expression".
#' @param ylab Character: y label. Default: "Log2 fold change".
#' @param ggTheme Character: ggplot2 themes. Default: "theme_minimal", options: "theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw", "theme_dark", "theme_minimal", "theme_classic", "theme_void"
#'
#' @import ggplot2
#' @import ggsci
#' @importFrom ggpubr ggmaplot
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset
#' data(deg_data2)
#'
#' # 3. Default parameters
#' ma_plot(deg_data2)
#'
#' # 4. Set color_up = "#FF8800"
#' ma_plot(deg_data2, color_up = "#FF8800")
#'
#' # 5. Set color_alpha = 0.30
#' ma_plot(deg_data2, color_alpha = 0.30)
#'
ma_plot <- function(data,
										foldchange = 2.00,
										fdr_value = 0.05,
										point_size = 0.50,
										color_up = "#FF0000",
										color_down = "#008800",
										color_alpha = 0.50,
										top_method = "fc",
										top_num = 20,
										label_size = 8.00,
										label_box = TRUE,
										title = "Group1 -versus- Group2",
										xlab = "Log2 mean expression",
										ylab = "Log2 fold change",
										ggTheme = "theme_minimal"
										){

	# -> 2. Data Operation
	# data(diff_express)
	# # diff_express <- diff_express[diff_express$detection_call == 1,]
	# write.table(diff_express, file = "MversusA.txt", quote = F, sep = "\t", row.names = T)
	# <- 2. Data Operation

	# -> 3. Plot Parameters
	# fonts <- "Times"
	# ChoiceBox: "Times", "Palatino", "Bookman", "Courier", "Helvetica", "URWGothic", "NimbusMon", "NimbusSan"

	# ggTheme <- "theme_minimal"
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

	# title <- "Group1 -versus- Group2"
	# TextField

	# xlab <- "Log2 mean expression"
	# ylab <- "Log2 fold change"
	# =====

	# fdr_value <- 0.05
	# Slider: 0.05, 0.00, 1.00, 0.01

	# foldchange <- 2.00
	# Slider: 2.00, 0.00, 10.00, 0.01

	# point_size <- 0.50
	# Slider: 0.50, 0.00, 10.00, 0.01

	# label_size <- 8.00
	# Slider: 8.00, 0.00, 50.00, 1.00

	# labelBox <- "LabelBox_Show"
	# # ChoiceBox: "LabelBox_Show", "LabelBox_Hidden"
	# if (labelBox == "LabelBox_Show") {
	# 	label_box <- TRUE
	# } else if (labelBox == "LabelBox_Hidden") {
	# 	label_box <- FALSE
	# }

	# color_up <- "#FF0000"
	# ColorPicker:

	# color_down <- "#008800"
	# ColorPicker:

	# top_num <- 20
	# Slider: 20, 0, 100, 1

	# top_method <- "fc"
	# ChoiceBox: "padj", "fc"

	# =====
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

	legendPosition <- "right"
	# ChoiceBox: "none", "left", "right", "bottom", "top"

	legendDirection <- "vertical"
	# ChoiceBox: "horizontal", "vertical"
	# <- 3. Plot Parameters

	# # -> 4. Plot
	p <- ggpubr::ggmaplot(data,
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
								select.top.method = top_method, # "padj", "fc"
								label.select = NULL,
								main = title,
								xlab = xlab,
								ylab = ylab
	) +
		# geom_text_repel(max.overlaps = Inf) +
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
		legend.position = legendPosition,
		# "none", "left", "right", "bottom", "top"
		legend.direction = legendDirection
		# "horizontal" or "vertical"
		)
	# # <- 4. Plot

	return(p)
	invisible()
}
