#' @title Chord plot for visualizing the relationships of pathways and genes.
#' @description Chord plot is used to visualize complex relationships between samples and genes, as well as between pathways and genes.
#' @author benben-miao
#'
#' @return Plot: chord plot is used to visualize complex relationships between samples and genes, as well as between pathways and genes.
#' @param data Dataframe: Shared DEGs of all paired comparisons in all samples expression dataframe of RNA-Seq. (1st-col: Genes, 2nd-col~: Samples).
#' @param multi_colors Character: color palette. Default: "VividColors", options: "VividColors", "RainbowColors".
#' @param color_seed Numeric: rand seed for VividColors. Default: 10.
#' @param color_alpha Numeric: color alpha. Default: 0.50, min: 0.00, max: 1.00.
#' @param link_visible Logical: links visible. Default: TRUE, options: TRUE, FALSE.
#' @param link_dir Numeric: links direction, use with link_type. Default: -1, options: -1, 0, 1, 2.
#' @param link_type Character: links type, use with link_dir. Default: "diffHeight", options: "diffHeight", "arrows".
#' @param sector_scale Character: sector scale method. Default: "Origin", options: "Origin", "Scale".
#' @param width_circle Numeric: outside circle width. Default: 3.0, min: 0.0, max: 10.0.
#' @param dist_name Numeric: the distance of name and circle. Default: 3.0, min: 0.0, max: 10.0.
#' @param label_dir Character: label director. Default: "Vertical", options: "Horizontal", "Vertical".
#' @param dist_label Numeric: the distance of label and circle. Default: 0.3, min: 0.0.
#' @param label_scale Numeric: labels font size sclae. Default: 0.8, min: 0, max: NULL.
#'
#' @import ggplot2
#' @import ggsci
#' @importFrom circlize chordDiagram convert_height circos.trackPlotRegion get.cell.meta.data circos.text circos.axis
#' @importFrom randomcoloR distinctColorPalette
#' @importFrom grDevices rainbow
#' @importFrom graphics par
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset
#' data(gene_expression2)
#' head(gene_expression2)
#'
#' # 3. Default parameters
#' chord_plot(gene_expression2[1:20,])
#'

chord_plot <- function(data,
											 multi_colors = "VividColors",
											 color_seed = 10,
											 color_alpha = 0.30,
											 link_visible = TRUE,
											 link_dir = -1,
											 link_type = "diffHeight",
											 sector_scale = "Origin",
											 width_circle = 3.0,
											 dist_name = 3.0,
											 label_dir = "Vertical",
											 dist_label = 0.3,
											 label_scale = 0.8) {

	if (!requireNamespace("randomcoloR", quietly = TRUE)) {
		stop("Package 'randomcoloR' is required for chord_plot().\n",
             "Please install: install.packages('randomcoloR')",
             call. = FALSE)
	}

	if (!is.data.frame(data) && !is.matrix(data)) {
		stop("data must be a data.frame or matrix", call. = FALSE)
	}

	rownames(data) <- data[, 1]
	data <- data[, -1]

	color_num <- length(union(rownames(data), colnames(data)))
	data <- as.matrix(data)

	set.seed(color_seed)
	if (multi_colors == "VividColors") {
		grid_col <- randomcoloR::distinctColorPalette(color_num)
	} else if (multi_colors == "RainbowColors") {
		grid_col <- grDevices::rainbow(color_num)
	} else {
		warning("Unknown multi_colors: ", multi_colors, ", using 'VividColors'")
		grid_col <- randomcoloR::distinctColorPalette(color_num)
	}

	scale <- (sector_scale == "Scale")

	if (label_dir == "Horizontal") {
		p <- circlize::chordDiagram(
			data,
			grid.col = grid_col,
			grid.border = NULL,
			transparency = color_alpha,
			row.col = NULL,
			column.col = NULL,
			order = NULL,
			directional = link_dir,
			direction.type = link_type,
			diffHeight = circlize::convert_height(2, "mm"),
			reduce = 1e-5,
			xmax = NULL,
			self.link = 2,
			symmetric = FALSE,
			keep.diagonal = FALSE,
			preAllocateTracks = NULL,
			annotationTrack = "grid",
			annotationTrackHeight = circlize::convert_height(c(dist_name, width_circle), "mm"),
			link.border = NA,
			link.lwd = graphics::par("lwd"),
			link.lty = graphics::par("lty"),
			link.sort = FALSE,
			link.decreasing = TRUE,
			link.largest.ontop = FALSE,
			link.visible = link_visible,
			link.rank = NULL,
			link.overlap = FALSE,
			scale = scale,
			group = NULL,
			big.gap = 10,
			small.gap = 1
		)
	} else if (label_dir == "Vertical") {
		p <- circlize::chordDiagram(
			data,
			grid.col = grid_col,
			grid.border = NULL,
			transparency = color_alpha,
			row.col = NULL,
			column.col = NULL,
			order = NULL,
			directional = link_dir,
			direction.type = link_type,
			diffHeight = circlize::convert_height(2, "mm"),
			reduce = 1e-5,
			xmax = NULL,
			self.link = 2,
			symmetric = FALSE,
			keep.diagonal = FALSE,
			preAllocateTracks = 1,
			annotationTrack = "grid",
			annotationTrackHeight = circlize::convert_height(c(dist_name, width_circle), "mm"),
			link.border = NA,
			link.lwd = graphics::par("lwd"),
			link.lty = graphics::par("lty"),
			link.sort = FALSE,
			link.decreasing = TRUE,
			link.largest.ontop = FALSE,
			link.visible = link_visible,
			link.rank = NULL,
			link.overlap = FALSE,
			scale = scale,
			group = NULL,
			big.gap = 10,
			small.gap = 1
		)

		circlize::circos.trackPlotRegion(
			track.index = 1,
			panel.fun = function(x, y) {
				xlim <- circlize::get.cell.meta.data("xlim")
				ylim <- circlize::get.cell.meta.data("ylim")
				sector.name <- circlize::get.cell.meta.data("sector.index")
				circlize::circos.text(
					mean(xlim),
					ylim[1] + dist_label,
					sector.name,
					facing = "clockwise",
					niceFacing = TRUE,
					adj = c(0, 0.5),
					cex = label_scale
				)
				circlize::circos.axis(
					h = "top",
					labels.cex = 0.5,
					major.tick.length = 0.2,
					sector.index = sector.name,
					track.index = 2
				)
			},
			bg.border = NA
		)
	} else {
		warning("Unknown label_dir: ", label_dir, ", using 'Vertical'")
	}

	return(head(p))
}
