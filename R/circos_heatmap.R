#' @title Circos heatmap plot for visualizing gene expressing in multiple samples.
#' @description Circos heatmap plot for visualizing gene expressing in multiple samples.
#' @author benben-miao
#'
#' @return Plot: circos heatmap plot for visualizing gene expressing in multiple samples.
#' @param data Dataframe: Shared degs of all paired comparisons in all samples expression dataframe of RNA-Seq. (1st-col: Genes, 2nd-col~: Samples).
#' @param low_color Character: min value color (color name or hex value). Default: "#0000ff".
#' @param mid_color Character: middle value color (color name or hex value). Default: "#ffffff".
#' @param high_color Character: high value color (color name or hex value). Default: "#ff0000".
#' @param gap_size Numeric: heatmap gap size. Default: 25, min: 0.
#' @param cluster_run Logical: running cluster algorithm. Default: TRUE, options: TRUE, FALSE.
#' @param cluster_method Character: cluster methods. Default: "complete", options: "ward.D", "ward.D2", "single", "complete", "average", "mcquitty", "median", "centroid".
#' @param distance_method Character: distance methods. Default: "euclidean", options: "euclidean", "maximum", "manhattan", "canberra", "binary", "minkowski".
#' @param dend_show Character: control dendgram display and position. Default: "inside", options: "none", "outside", "inside".
#' @param dend_height Numeric: dendgram height. Default: 0.20, min: 0.00, max: 0.50.
#' @param track_height Numeric: heatmap track height. Default: 0.30, min: 0.00, max: 0.50.
#' @param rowname_show Character: control rownames display and position. Hind first rowname by running rownames(data). Default: "outside", options: "none", "outside", "inside".
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
#' data(gene_expression2)
#' head(gene_expression2)
#'
#' # 3. Default parameters
#' circos_heatmap(gene_expression2[1:50,])
#'
circos_heatmap <- function(data,
													 low_color = "#0000ff",
													 mid_color = "#ffffff",
													 high_color = "#ff0000",
													 gap_size = 25,
													 cluster_run = TRUE,
													 cluster_method = "complete",
													 distance_method = "euclidean",
													 dend_show = "inside",
													 dend_height = 0.20,
													 track_height = 0.30,
													 rowname_show = "outside",
													 rowname_size = 0.80
													){

	# -> 2. Data Operation
	data <- as.data.frame(data)
	rownames(data) <- data[,1]
	data <- data[,-1]
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
		medians <- apply(data, 2, median)
		col_fun = circlize::colorRamp2(c(round(min(data)), median(medians), round(max(data))),
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
									 cluster = cluster_run,
									 clustering.method = cluster_method, # "ward.D", "ward.D2", "single", "complete", "average", "mcquitty", "median", "centroid"
									 distance.method = distance_method, # "euclidean", "maximum", "manhattan", "canberra", "binary", "minkowski"
									 dend.callback = function(dend, m, si) stats::reorder(dend, rowMeans(m)),
									 dend.side = dend_show, # "none", "outside", "inside"
									 dend.track.height = dend_height,
									 rownames.side = rowname_show, # "none", "outside", "inside"
									 rownames.cex = rowname_size,
									 rownames.font = graphics::par("font"),
									 rownames.col = "black",
									 track.height = track_height,
									 show.sector.labels = FALSE
		)
		# circlize::circos.text(1, 1,
		# 											cex = 0.5,
		# 						labels = colnames(data),
		# 						facing = "inside",
		# 						niceFacing = TRUE)
		circlize::circos.track(track.index = circlize::get.current.track.index(),
													 panel.fun = function(x, y) {
			if (circlize::CELL_META$sector.numeric.index == 1) { # the last sector
				cn = colnames(data)
				n = length(cn)
				circlize::circos.text(x = rep(circlize::CELL_META$cell.xlim[2], n) + circlize::convert_x(1, "mm"),
										y = 1:n + n,
										labels = cn,
										niceFacing = TRUE,
										cex = 0.5, adj = c(0, 0),
										facing = "inside")
			}
		}, bg.border = NA)

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
		circlize::circos.clear()
	}
	# # <- 4. Plot

	return(p())
	invisible()
}
