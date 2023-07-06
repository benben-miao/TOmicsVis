#' @title Volcano plot for visualizing differentailly expressed genes.
#' @description Volcano plot for visualizing differentailly expressed genes.
#' @author benben-miao
#'
#' @return Plot: volcano plot for visualizing differentailly expressed genes.
#' @param data Dataframe: include columns (Genes, Log2FoldChange, Pvalue, Padj), rows (Genes).
#' @param log2fc_cutoff Numeric: log2(FoldChange) cutoff log2(2) = 1. Default: 1.0, min: 0.0, max: null.
#' @param pq_value Character: select pvalue or qvalue. Default: "pvalue", options: "pvalue", "padj".
#' @param pq_cutoff Numeric: pvalue or qvalue cutoff. Default: 0.005, min: 0.000, max: 1.000.
#' @param cutoff_line Character: cutoff line type. Default: "longdash", options: "blank", "solid", "dashed", "dotted", "dotdash", "longdash", "twodash".
#' @param point_shape Character: point shape. Default: "large_circle", options: "border_square", "border_circle", "border_triangle", "plus", "times", "border_diamond", "border_triangle_down", "square_times", "plus_times", "diamond_plus", "circle_plus", "di_triangle", "square_plus", "circle_times","square_triangle", "fill_square", "fill_circle", "fill_triangle", "fill_diamond", "large_circle", "small_circle", "fill_border_circle", "fill_border_square", "fill_border_diamond", "fill_border_triangle".
#' @param point_size Numeric: point size. Default: 1.0, min: 0.0, max: null.
#' @param point_alpha Numeric: point color alpha. Default: 0.50, min: 0.00, max: 1.00.
#' @param color_normal Character: normal genes color (color name or hex value). Default: "#888888".
#' @param color_log2fc Character: genes color that log2fc >= log2fc_cutoff. Default: "#008000".
#' @param color_pvalue Character: genes color that pvalue > pq_cutoff. Default: "#0088ee".
#' @param color_Log2fc_p Character: genes color that log2fc >= log2fc_cutoff and pvalue > pq_cutoff. Default: "#ff0000".
#' @param label_size Numeric: DEG labels size. Default: 3.0, min: 0.0, max: null.
#' @param boxed_labels Logical: add box to every DEG label. Default: FALSE.
#' @param draw_connectors Logical: add connector between DEGs and labels. Default: FALSE.
#' @param legend_pos Character: legend position. Default: "right", options: "right", "left", "top", "bottom".
#'
#' @import ggplot2
#' @import ggsci
#' @importFrom EnhancedVolcano EnhancedVolcano
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset
#' data(deg_data)
#'
#' # 3. Default parameters
#' volcano_plot(deg_data)
#'
#' # 4. Set color_Log2fc_p = "#ff8800"
#' volcano_plot(deg_data, color_Log2fc_p = "#ff8800")
#'
#' # 5. Set boxed_labels = TRUE
#' volcano_plot(deg_data, boxed_labels = TRUE)
#'
volcano_plot <- function(data,
										 log2fc_cutoff = 1.0,
										 pq_value = "pvalue",
										 pq_cutoff = 0.005,
										 cutoff_line = "longdash",
										 point_shape = "large_circle",
										 point_size = 1.0,
										 point_alpha = 0.50,
										 color_normal = "#888888",
										 color_log2fc = "#008000",
										 color_pvalue = "#0088ee",
										 color_Log2fc_p = "#ff0000",
										 label_size = 3.0,
										 boxed_labels = FALSE,
										 draw_connectors = FALSE,
										 legend_pos = "right"
										){

	# -> 2. Data
	data <- as.data.frame(data)
	rownames(data) <- data[,1]
	data <- data[,-1]
	colnames(data) <- c("log2FoldChange", "pvalue", "padj")
	# <- 2. Data

	# -> 3. Plot parameters
	# fonts <- "Times"
	# ChoiceBox: "Times", "Palatino", "Bookman", "Courier", "Helvetica", "URWGothic", "NimbusMon", "NimbusSan"

	# color_normal <- "#888888"
	# ColorPicker

	# color_log2fc <- "#008000"
	# ColorPicker

	# color_pvalue <- "#0088ee"
	# ColorPicker

	# color_Log2fc_p <- "#ff0000"
	# ColorPicker

	# pq_value <- "pvalue"
	# ChoiceBox: "pvalue", "padj"

	# pq_cutoff <- 0.005
	# Slider: 0.005, 0.000, 0.001, 1.000

	# log2fc_cutoff <- 1.0
	# Slider: 1.0, 0.0, 0.1, 10.0

	# cutoff_line <- "longdash"
	# ChoiceBox: "blank", "solid", "dashed", "dotted", "dotdash", "longdash", "twodash"

	# point_size <- 1.0
	# Slider: 1.0, 0.0, 0.1, 5.0

	# label_size <- 3.0
	# Slider: 3.0, 0.0, 0.1, 10.0

	# boxedLabel <- "OnlyLable"
	# if (boxedLabel == "BoxLable") {
	# 	boxedLabels <- TRUE
	# } else if (boxedLabel == "OnlyLable") {
	# 	boxedLabels <- FALSE
	# }
	# # ChoiceBox: "OnlyLable", "BoxLable"

	# drawConnector <- "OnlyLable"
	# if (drawConnector == "OnlyLable") {
	# 	drawConnectors <- FALSE
	# } else if (drawConnector == "LineLable") {
	# 	drawConnectors <- TRUE
	# }
	# # ChoiceBox: "OnlyLable", "LineLable"

	# pointShape <- 19
	# Slider: 19, 0, 1, 25

	# point_shape <- "large_circle"
	# ChoiceBox: "border_square", "border_circle", "border_triangle", "plus", "times", "border_diamond", "border_triangle_down", "square_times", "plus_times", "diamond_plus", "circle_plus", "di_triangle", "square_plus", "circle_times","square_triangle", "fill_square", "fill_circle", "fill_triangle", "fill_diamond", "large_circle", "small_circle", "fill_border_circle", "fill_border_square", "fill_border_diamond", "fill_border_triangle"
	if (point_shape == "border_square") {
		shape <- 0
	} else if (point_shape == "border_circle") {
		shape <- 1
	} else if (point_shape == "border_triangle") {
		shape <- 2
	} else if (point_shape == "plus") {
		shape <- 3
	} else if (point_shape == "times") {
		shape <- 4
	} else if (point_shape == "border_diamond") {
		shape <- 5
	} else if (point_shape == "border_triangle_down") {
		shape <- 6
	} else if (point_shape == "square_times") {
		shape <- 7
	} else if (point_shape == "plus_times") {
		shape <- 8
	} else if (point_shape == "diamond_plus") {
		shape <- 9
	} else if (point_shape == "circle_plus") {
		shape <- 10
	} else if (point_shape == "di_triangle") {
		shape <- 11
	} else if (point_shape == "square_plus") {
		shape <- 12
	} else if (point_shape == "circle_times") {
		shape <- 13
	} else if (point_shape == "square_triangle") {
		shape <- 14
	} else if (point_shape == "fill_square") {
		shape <- 15
	} else if (point_shape == "fill_circle") {
		shape <- 16
	} else if (point_shape == "fill_triangle") {
		shape <- 17
	} else if (point_shape == "fill_diamond") {
		shape <- 18
	} else if (point_shape == "large_circle") {
		shape <- 19
	} else if (point_shape == "small_circle") {
		shape <- 20
	} else if (point_shape == "fill_border_circle") {
		shape <- 21
	} else if (point_shape == "fill_border_square") {
		shape <- 22
	} else if (point_shape == "fill_border_diamond") {
		shape <- 23
	} else if (point_shape == "fill_border_triangle") {
		shape <- 24
	}

	# point_alpha <- 0.5
	# Slider: 0.5, 0.0, 0.1, 1.0

	# legend_pos <- "right"
	# ChoiceBox: "right", "left", "top", "bottom"

	majorGrid <- "Show"
	if (majorGrid == "Show") {
		majorGrids <- TRUE
	} else if (majorGrid == "Hidden") {
		majorGrids <- FALSE
	}
	# ChoiceBox: "Show", "Hidden"

	minorGrid <- "Show"
	if (minorGrid == "Show") {
		minorGrids <- TRUE
	} else if (minorGrid == "Hidden") {
		minorGrids <- FALSE
	}
	# ChoiceBox: "Show", "Hidden"
	# <- 3. Plot parameters

	# # -> 4. Plot
	p <- EnhancedVolcano::EnhancedVolcano(
		data,
		lab = rownames(data),
		x = "log2FoldChange",
		y = pq_value,
		xlim = c(min(data[,"log2FoldChange"], na.rm = TRUE),
						 max(data[,"log2FoldChange"], na.rm = TRUE)),
		ylim = c(0, max(-log10(data[,pq_value]), na.rm = TRUE) + 5),
		xlab = paste("Log2","fold change"),
		ylab = paste("-Log10",pq_value),
		axisLabSize = 16,
		title = NULL,
		subtitle = NULL,
		caption = paste0('Total = ', nrow(data), ' variables'),
		# titleLabSize = 20,
		# subtitleLabSize = 18,
		captionLabSize = 16,
		pCutoff = pq_cutoff,
		FCcutoff = log2fc_cutoff,
		cutoffLineType = cutoff_line,
		cutoffLineCol = 'black',
		cutoffLineWidth = 0.4,
		pointSize = point_size,
		labSize = label_size,
		labCol = 'black',
		labFace = 'plain',
		boxedLabels = boxed_labels,
		drawConnectors = draw_connectors,
		shape = shape,
		col = c(color_normal, color_log2fc, color_pvalue, color_Log2fc_p),
		colAlpha = point_alpha,
		legendLabels = c("NS","Log2 FC","P","P & Log2 FC"),
		legendPosition = legend_pos,
		legendLabSize = 14,
		legendIconSize = 5.0,
		legendDropLevels = TRUE,
		widthConnectors = 0.5,
		typeConnectors = 'closed',
		endsConnectors = 'first',
		lengthConnectors = unit(0.01, 'npc'),
		colConnectors = 'grey10',
		gridlines.major = majorGrids,
		gridlines.minor = minorGrids,
		border = "partial",
		borderWidth = 0.8,
		borderColour = "black") +
		theme()
	# # <- 4. Plot

	return(p)
	invisible()
}
