#' @title Volcano plot for visualizing differentailly expressed genes.
#' @description Volcano plot for visualizing differentailly expressed genes.
#' @author benben-miao
#'
#' @return Plot: volcano plot for visualizing differentailly expressed genes.
#' @param data Dataframe: differentially expressed genes (DEGs) stats (1st-col: Genes, 2nd-col: log2FoldChange, 3rd-col: Pvalue, 4th-col: FDR).
#' @param title Character: title of plot. Default: CT-vs-LT12.
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
#' data(degs_stats)
#' head(degs_stats)
#'
#' # 3. Default parameters
#' volcano_plot(degs_stats)
#'
#' # 4. Set color_Log2fc_p = "#ff8800"
#' volcano_plot(degs_stats, color_Log2fc_p = "#ff8800")
#'
#' # 5. Set boxed_labels = TRUE
#' volcano_plot(degs_stats, boxed_labels = TRUE)
#'
volcano_plot <- function(data,
												 title = "CT-vs-LT12",
												 log2fc_cutoff = 1.0,
												 pq_value = "pvalue",
												 pq_cutoff = 0.05,
												 cutoff_line = "longdash",
												 point_shape = "large_circle",
												 point_size = 2.0,
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

	if (!requireNamespace("EnhancedVolcano", quietly = TRUE)) {
		stop("Package 'EnhancedVolcano' is required for volcano_plot().\n",
				 "Please install: BiocManager::install('EnhancedVolcano')",
				 call. = FALSE)
	}

	if (!is.data.frame(data) && !is.matrix(data)) {
		stop("Input must be a data.frame or matrix", call. = FALSE)
	}

	if (ncol(data) < 4) {
		stop("Data must have at least 4 columns: Genes, log2FC, Pvalue, FDR", call. = FALSE)
	}

	if (!pq_value %in% c("pvalue", "padj")) {
		stop("pq_value must be 'pvalue' or 'padj'", call. = FALSE)
	}

	color_params <- list(
		color_normal = color_normal,
		color_log2fc = color_log2fc,
		color_pvalue = color_pvalue,
		color_Log2fc_p = color_Log2fc_p
	)

	for (param_name in names(color_params)) {
		validate_hex_color(color_params[[param_name]], param_name)
	}

	if (!is.numeric(log2fc_cutoff) || log2fc_cutoff <= 0) {
		stop("log2fc_cutoff must be a positive number", call. = FALSE)
	}

	if (!is.numeric(pq_cutoff) || pq_cutoff <= 0 || pq_cutoff >= 1) {
		stop("pq_cutoff must be between 0 and 1 (exclusive)", call. = FALSE)
	}

	if (!is.numeric(point_size) || point_size <= 0) {
		stop("point_size must be a positive number", call. = FALSE)
	}

	validate_numeric_range(point_alpha, "point_alpha", min_val = 0, max_val = 1)

	if (!is.numeric(label_size) || label_size <= 0) {
		stop("label_size must be a positive number", call. = FALSE)
	}

	valid_legend_pos <- c("none", "left", "right", "bottom", "top")
	if (!legend_pos %in% valid_legend_pos) {
		stop(sprintf("legend_pos must be one of: %s", paste(valid_legend_pos, collapse = ", ")), call. = FALSE)
	}

	data <- as.data.frame(data)
	rownames(data) <- data[,1]
	data <- data[,-1]
	colnames(data) <- c("log2FoldChange", "pvalue", "padj")

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

	if (!point_shape %in% names(shape_map)) {
		stop("Invalid point_shape: ", point_shape, call. = FALSE)
	}
	shape <- unname(shape_map[point_shape])

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
		title = title,
		subtitle = NULL,
		caption = paste0('Total = ', nrow(data), ' variables'),
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
		gridlines.major = FALSE,
		gridlines.minor = FALSE,
		border = "full",
		borderWidth = 0.8,
		borderColour = "black") +
		theme_publication() +
		theme(
			plot.title = element_text(hjust = 0.5, face = "bold", size = 18),
			axis.title = element_text(face = "plain", size = 14),
			axis.text = element_text(size = 10)
		)

	return(p)
}
