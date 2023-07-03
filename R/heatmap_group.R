#' @title Heatmap group for visualizing grouped gene expression data.
#' @description Heatmap group for visualizing grouped gene expression data.
#' @author benben-miao
#'
#' @return Plot: Heatmap group for visualizing grouped gene expression data.
#' @param data Dataframe: include level1 columns (Groups, Group1, Group2, ...), level2 columns (GeneID, Sample1, Sample2, ...).
#' @param scale_data Character: scale data. Default: "none", options: "row", "column", "none".
#' @param clust_method Character: cluster method. Default: "complete", options: "ward.D", "ward.D2", "single", "complete", "average" (= UPGMA), "mcquitty" (= WPGMA), "median" (= WPGMC) or "centroid" (= UPGMC).
#' @param border_show Logical: show border. Default: TRUE, options: TRUE, FALSE.
#' @param value_show Logical: show value in cell. Default: TRUE, options: TRUE, FALSE.
#' @param low_color Character: min value color (color value or hex value with alpha).
#' @param mid_color Character: min value color (color value or hex value with alpha).
#' @param high_color Character: min value color (color value or hex value with alpha).
#' @param na_color Character: min value color (color value or hex value with alpha).
#' @param x_angle Numeric: x axis text angle. Default: 45, min: 0, max: 360.
#'
#' @importFrom RColorBrewer brewer.pal
#' @importFrom pheatmap pheatmap
#' @importFrom grDevices colorRampPalette
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset
#' data(heatmap_group_data)
#' head(heatmap_group_data)
#'
#' # 3. Default parameters
#' heatmap_group(heatmap_group_data)
#'
#' # 4. Set scale_data = "row"
#' heatmap_group(heatmap_group_data, scale_data = "row")
#'
#' # 5. Set border_show = TRUE
#' heatmap_group(heatmap_group_data, border_show = TRUE)
#'
#' # 6. Set low_color = "#00008888"
#' heatmap_group(heatmap_group_data, low_color = "#00008888")
#'
#' # 7. Set x_angle = 90
#' heatmap_group(heatmap_group_data, x_angle = 90)
#'
heatmap_group <- function(data,
													scale_data = "none",
													clust_method = "complete",
													border_show = TRUE,
													value_show = TRUE,
													low_color = "#00880088",
													mid_color = "#ffffff",
													high_color = "#ff000088",
													na_color = "#ff8800",
													x_angle = 45
												 ){
	# -> 2. Data Operation
	data <- as.data.frame(data)
	groups <- as.character(data[1,])

	data2 <- data[-1,]
	colnames(data2) <- as.character(data2[1,])
	data2 <- data2[-1,]

	data3 <- apply(data2[,1:ncol(data2)], 2, as.numeric)
	data3 <- as.data.frame(data3)
	rownames(data3) <- rownames(data2)
	# <- 2. Data Operation

	# -> 3. Plot Parameters
	# low_color <- "#00880088"
	# mid_color <- "#ffffff"
	# high_color <- "#ff000088"

	# scale_data <- "none"
	# "row", "column", "none"

	# clust_method <- "complete"
	# "ward.D", "ward.D2", "single", "complete", "average" (= UPGMA), "mcquitty" (= WPGMA), "median" (= WPGMC) or "centroid" (= UPGMC)

	# border_show <- TRUE
	# value_show <- TRUE

	# na_color <- "#ff8800"
	# x_angle <- 45
	# <- 3. Plot Parameters

	# # -> 4. Plot
	anno_col <- data.frame(
		Groups = groups
	)
	rownames(anno_col) <- colnames(data3)

	group <- levels(as.factor(groups))
	group_color <- RColorBrewer::brewer.pal(12, "Paired")[1:length(group)]
	names(group_color) <- group
	group_color

	anno_colors = list(
		Groups = group_color
	)

	p <- pheatmap::pheatmap(data3,
								color = colorRampPalette(c(low_color, mid_color, high_color))(100),
								scale = "none", # "row", "column", "none"
								kmeans_k = NA,
								clustering_method = clust_method, # "ward.D", "ward.D2", "single", "complete", "average" (= UPGMA), "mcquitty" (= WPGMA), "median" (= WPGMC) or "centroid" (= UPGMC)
								border = border_show,
								border_color = "#ffffff",
								cellwidth = NA,
								cellheight = NA,
								display_numbers = value_show,
								number_format = "%.3f",
								number_color = "#333333",
								na_col = na_color,
								angle_col = x_angle,
								legend = TRUE,
								legend_breaks = NA,
								legend_labels = NA,
								annotation_col = anno_col,
								annotation_colors = anno_colors
	)
	# # <- 4. Plot

	return(p)
	invisible()
}
