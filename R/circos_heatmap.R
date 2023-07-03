#' @title Circos heatmap plot for visualizing gene expressing in multiple samples.
#' @description Circos heatmap plot for visualizing gene expressing in multiple samples.
#' @author benben-miao
#'
#' @return Plot: circos heatmap plot for visualizing gene expressing in multiple samples.
#' @param data Dataframe: include columns (Sample1, Sample2, ...), rows (Gene1, Gene2, ...).
#' @param low_color Character: min value color (color name or hex value). Default: "#0000ff".
#' @param mid_color Character: middle value color (color name or hex value). Default: "#ffffff".
#' @param high_color Character: high value color (color name or hex value). Default: "#ff0000".
#' @param gap_size Numeric: heatmap gap size. Default: 10, min: 0.
#' @param cluster_method Character: cluster methods. Default: "complete", options: "ward.D", "ward.D2", "single", "complete", "average", "mcquitty", "median", "centroid".
#' @param distance_method Character: distance methods. Default: "euclidean", options: "euclidean", "maximum", "manhattan", "canberra", "binary", "minkowski".
#' @param dend_height Numeric: dendgram height. Default: 0.20, min: 0.00, max: 0.50.
#' @param rowname_size Numeric: rowname font size. Default: 0.80, min: 0.10, max: 10.00.
#'
#' @importFrom stats reorder
#' @importFrom grid grid.draw
#' @importFrom graphics par
#' @importFrom circlize circos.clear colorRamp2 circos.par circos.heatmap
#' @importFrom ComplexHeatmap Legend
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset
#' data(circos_heatmap_data)
#'
#' # 3. Default parameters
#' circos_heatmap(circos_heatmap_data)
#'
#' # 4. Set low_color = "#008800"
#' # circos_heatmap(circos_heatmap_data, low_color = "#008800")
#'
#' # 5. Set gap_size = 5
#' # circos_heatmap(circos_heatmap_data, gap_size = 5)
#'
#' # 6. Set dend_height = 0.40
#' # circos_heatmap(circos_heatmap_data, dend_height = 0.40)
#'
circos_heatmap <- function(data,
													 low_color = "#0000ff",
													 mid_color = "#ffffff",
													 high_color = "#ff0000",
													 gap_size = 10,
													 cluster_method = "complete",
													 distance_method = "euclidean",
													 dend_height = 0.20,
													 rowname_size = 0.80
													){

	# -> 2. Data Operation
	# mat = rbind(cbind(matrix(rnorm(50*5, mean = 1), nr = 50),
	# 				   matrix(rnorm(50*5, mean = -1), nr = 50)),
	# 			 cbind(matrix(rnorm(50*5, mean = -1), nr = 50),
	# 			 	  matrix(rnorm(50*5, mean = 1), nr = 50))
	# )
	# rownames(mat) = paste0("R", 1:100)
	# colnames(mat) = paste0("C", 1:10)
	# mat = mat[sample(100, 100), ]
	#
	# write.table(mat, file = "CircosHeatmap.txt", quote = FALSE, sep = "\t", row.names = TRUE)
	# <- 2. Data Operation

	# -> 3. Plot Parameters
	# fonts <- "Times"
	# ChoiceBox: "Times", "Palatino", "Bookman", "Courier", "Helvetica", "URWGothic", "NimbusMon", "NimbusSan"

	# low_color <- "#0000ff"
	# ColorPicker

	# mid_color <- "#ffffff"
	# ColorPicker

	# high_color <- "#ff0000"
	# ColorPicker

	# gap_size <- 10
	# Slider: 10, 0, 90, 1

	# cluster_method <- "complete"
	# ChoiceBox: "ward.D", "ward.D2", "single", "complete", "average", "mcquitty", "median", "centroid"

	# distance_method <- "euclidean"
	# ChoiceBox: "euclidean", "maximum", "manhattan", "canberra", "binary", "minkowski"

	# dend_height <- 0.20
	# Slider: 0.20, 0.10, 0.50, 0.01

	# rowname_size <- 0.80
	# Slider: 0.80, 0.00, 5.00, 0.01
	# <- 3. Plot Parameters

	# # -> 4. Plot

	p <- function(){
		circlize::circos.clear()
		col_fun = circlize::colorRamp2(c(round(min(data)), 0, round(max(data))),
												 c(low_color, mid_color, high_color))

		circlize::circos.par(gap.after = c(gap_size))
		circlize::circos.heatmap(data,
									 split = NULL,
									 col = col_fun,
									 na.col = "grey",
									 cell.border = NA,
									 cell.lty = 1,
									 cell.lwd = 1,
									 bg.border = NA,
									 bg.lty = graphics::par("lty"),
									 bg.lwd = graphics::par("lwd"),
									 cluster = TRUE,
									 clustering.method = cluster_method, # "ward.D", "ward.D2", "single", "complete", "average", "mcquitty", "median", "centroid"
									 distance.method = distance_method, # "euclidean", "maximum", "manhattan", "canberra", "binary", "minkowski"
									 dend.callback = function(dend, m, si) stats::reorder(dend, rowMeans(m)),
									 dend.side = "inside", # "none", "outside", "inside"
									 dend.track.height = dend_height,
									 rownames.side = "outside", # "none", "outside", "inside"
									 rownames.cex = rowname_size,
									 rownames.font = graphics::par("font"),
									 rownames.col = "black",
									 track.height = 0.3
		)
		# circos.track(track.index = get.current.track.index(),
		# 			 panel.fun = function(x, y) {
		# 				if (CELL_META$sector.numeric.index == 1) {
		# 					cn = colnames(data)
		# 					n = length(cn)
		# 					circos.text(rep(CELL_META$cell.xlim[2], n) + convert_x(0.1, "mm"),
		# 								12 + (1:n)*1.8,
		# 								cn,
		# 								cex = 0.5, adj = c(-1, 1), facing = "inside")
		# 				}
		# 			}, bg.border = NA)
		legend = ComplexHeatmap::Legend(title = "ColorBar", col_fun = col_fun)
		grid::grid.draw(legend)
		circos.clear()
	}
	# # <- 4. Plot

	return(p())
	invisible()
}
