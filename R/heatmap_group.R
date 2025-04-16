#' @title Heatmap group for visualizing grouped gene expression data.
#' @description Heatmap group for visualizing grouped gene expression data.
#' @author benben-miao
#'
#' @return Plot: Heatmap group for visualizing grouped gene expression data.
#' @param sample_gene Dataframe: Shared degs of all paired comparisons in all samples expression dataframe of RNA-Seq. (1st-col: Genes, 2nd-col~: Samples).
#' @param group_sample Dataframe: Samples and groups for gene expression (1st-col: Samples, 2nd-col: Groups).
#' @param scale_data Character: scale data. Default: "row", options: "row", "column", "none".
#' @param clust_method Character: cluster method. Default: "complete", options: "ward.D", "ward.D2", "single", "complete", "average" (= UPGMA), "mcquitty" (= WPGMA), "median" (= WPGMC) or "centroid" (= UPGMC).
#' @param border_show Logical: show border. Default: TRUE, options: TRUE, FALSE.
#' @param border_color Character: cell border color (color value or hex value with alpha). Default: "#ffffff".
#' @param value_show Logical: show value in cell. Default: TRUE, options: TRUE, FALSE.
#' @param value_decimal Numeric: cell value decimal. Default: 2, min: 0, max: 5.
#' @param value_size Numeric: cell value font size. Default: 5, min: 0, max: NULL.
#' @param axis_size Numeric: axis title font size. Default: 8, min: 0, max: NULL.
#' @param cell_height Numeric: cell height for value size and axis size. Default: 10.
#' @param low_color Character: min value color (color value or hex value with alpha). Default: "#00880055".
#' @param mid_color Character: min value color (color value or hex value with alpha). Default: "#ffffff".
#' @param high_color Character: min value color (color value or hex value with alpha). Default: "#ff000055".
#' @param na_color Character: min value color (color value or hex value with alpha). Default: "#ff8800".
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
#' data(gene_expression2)
#' head(gene_expression2)
#'
#' data(samples_groups)
#' head(samples_groups)
#'
#' # 3. Default parameters
#' heatmap_group(gene_expression2[1:50,], samples_groups)
#'
#' # 4. Set scale_data = "column"
#' heatmap_group(gene_expression2[1:50,], samples_groups, scale_data = "column")
#'
#' # 5. Set value_show = FALSE
#' heatmap_group(gene_expression2[1:50,], samples_groups, value_show = FALSE)
#'
#' # 6. Set low_color = "#00008888"
#' heatmap_group(gene_expression2[1:50,], samples_groups, low_color = "#00008888")
#'
heatmap_group <- function(sample_gene,
													group_sample,
													scale_data = "row",
													clust_method = "complete",
													border_show = TRUE,
													border_color = "#ffffff",
													value_show = TRUE,
													value_decimal = 2,
													value_size = 5,
													axis_size = 8,
													cell_height = 10,
													low_color = "#00880055",
													mid_color = "#ffffff",
													high_color = "#ff000055",
													na_color = "#ff8800",
													x_angle = 45) {
	# -> 2. Data Operation
	sample_gene <- as.data.frame(sample_gene)
	rownames(sample_gene) <- sample_gene[, 1]
	sample_gene <- sample_gene[, -1]

	groups <- group_sample[, 2]
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
	anno_col <- data.frame(Groups = groups)
	rownames(anno_col) <- colnames(sample_gene)

	group <- levels(as.factor(groups))
	group_color <- RColorBrewer::brewer.pal(12, "Paired")[1:length(group)]
	names(group_color) <- group
	group_color

	anno_colors = list(Groups = group_color)

	p <- pheatmap::pheatmap(
		sample_gene,
		color = colorRampPalette(c(low_color, mid_color, high_color))(100),
		scale = scale_data,
		# "row", "column", "none"
		kmeans_k = NA,
		clustering_method = clust_method,
		# "ward.D", "ward.D2", "single", "complete", "average" (= UPGMA), "mcquitty" (= WPGMA), "median" (= WPGMC) or "centroid" (= UPGMC)
		border = border_show,
		border_color = border_color,
		cellwidth = NA,
		cellheight = cell_height,
		display_numbers = value_show,
		number_format = paste("%.", value_decimal, "f", sep = ""),
		number_color = "#333333",
		fontsize_number = value_size,
		na_col = na_color,
		fontsize_row = axis_size,
		fontsize_col = axis_size,
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
