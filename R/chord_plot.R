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
	# -> 2. Data
	rownames(data) <- data[, 1]
	data <- data[, -1]

	dataClass <- "matrix"
	if (dataClass == "matrix") {
		color_num <- length(union(rownames(data), colnames(data)))
	} else if (dataClass == "frame") {
		color_num <- length(union(data[, 1], data[, 2]))
	}
	# ChoiceBox: "matrix", "frame"

	data <- as.matrix(data)
	# <- 2. Data

	# -> 3. Plot parameters
	# multi_colors <- "RainbowColors"
	set.seed(color_seed)
	if (multi_colors == "VividColors") {
		grid_col <- randomcoloR::distinctColorPalette(color_num)
	} else if (multi_colors == "RainbowColors") {
		grid_col <- grDevices::rainbow(color_num)
	}
	# ChoiceBox: "VividColors", "RainbowColors"

	# color_alpha <- 0.5
	# Slider: 0.5 0.0,0.1,1.0

	# link_dir <- 0
	# Slider: 0 -1,1,2

	# link_type <- "diffHeight"
	# ChoiceBox: "diffHeight", "arrows"

	# linkVisible <- "ShowLinks"
	# if (linkVisible == "ShowLinks"){
	# 	link_visible <- TRUE
	# } else if(linkVisible == "HindLinks"){
	# 	link_visible <- FALSE
	# }
	# ChoiceBox: "ShowLinks", "HindLinks"

	# sector_scale <- "Origin"
	if (sector_scale == "Origin") {
		scale <- FALSE
	} else if (sector_scale == "Scale") {
		scale <- TRUE
	}
	# ChoiceBox: "Origin", "Scale"

	# width_circle <- 3.0
	# Slider: 3.0 0.0,0.1,10.0

	# dist_name <- 3.0
	# Slider: 3.0 0.0,0.1,10.0

	# label_dir <- "Horizontal"
	# ChoiceBox: "Horizontal", "Vertical"

	# dist_label <- 0.3
	# Slider: 0.3 0.0,0.1,10.0
	# <- 3. Plot parameters

	# # -> 4. Plot
	if (label_dir == "Horizontal") {
		p <- circlize::chordDiagram(
			data,
			grid.col = grid_col,
			grid.border = NULL,
			transparency = color_alpha,
			# col = colorRamp2(c(min(mat),max(mat)),c("green","blue"),transparency = 0.5),
			row.col = NULL,
			column.col = NULL,
			order = NULL,
			directional = link_dir,
			# 1, -1, 0, 2
			direction.type = link_type,
			# diffHeight and arrows
			diffHeight = circlize::convert_height(2, "mm"),
			reduce = 1e-5,
			xmax = NULL,
			self.link = 2,
			symmetric = FALSE,
			keep.diagonal = FALSE,
			preAllocateTracks = NULL,
			annotationTrack = "grid",
			# c("name", "grid", "axis")
			annotationTrackHeight = circlize::convert_height(c(dist_name, width_circle), "mm"),
			link.border = NA,
			link.lwd = graphics::par("lwd"),
			link.lty = graphics::par("lty"),
			link.sort = FALSE,
			link.decreasing = TRUE,
			# link.arr.length = ifelse(link.arr.type == "big.arrow", 0.02, 0.4),
			# link.arr.width = link.arr.length/2,
			# link.arr.type = "triangle",
			# link.arr.lty = par("lty"),
			# link.arr.lwd = par("lwd"),
			# link.arr.col = par("col"),
			link.largest.ontop = FALSE,
			link.visible = link_visible,
			link.rank = NULL,
			link.overlap = FALSE,
			scale = scale,
			group = NULL,
			big.gap = 10,
			small.gap = 1
		)
		# circos.clear()
	} else if (label_dir == "Vertical") {
		p <- circlize::chordDiagram(
			data,
			grid.col = grid_col,
			grid.border = NULL,
			transparency = color_alpha,
			# col = colorRamp2(c(min(mat),max(mat)),c("green","blue"),transparency = 0.5),
			row.col = NULL,
			column.col = NULL,
			order = NULL,
			directional = link_dir,
			# 1, -1, 0, 2
			direction.type = link_type,
			# diffHeight and arrows
			diffHeight = circlize::convert_height(2, "mm"),
			reduce = 1e-5,
			xmax = NULL,
			self.link = 2,
			symmetric = FALSE,
			keep.diagonal = FALSE,
			preAllocateTracks = 1,
			annotationTrack = "grid",
			# c("name", "grid", "axis")
			annotationTrackHeight = circlize::convert_height(c(dist_name, width_circle), "mm"),
			link.border = NA,
			link.lwd = graphics::par("lwd"),
			link.lty = graphics::par("lty"),
			link.sort = FALSE,
			link.decreasing = TRUE,
			# link.arr.length = ifelse(link.arr.type == "big.arrow", 0.02, 0.4),
			# link.arr.width = link.arr.length/2,
			# link.arr.type = "triangle",
			# link.arr.lty = par("lty"),
			# link.arr.lwd = par("lwd"),
			# link.arr.col = par("col"),
			link.largest.ontop = FALSE,
			link.visible = link_visible,
			link.rank = NULL,
			link.overlap = FALSE,
			scale = scale,
			group = NULL,
			big.gap = 10,
			small.gap = 1
		)
		# circos.clear()
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
	}
	# # <- 4. Plot

	return(head(p))
	invisible()
}
