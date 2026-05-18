#' @title Heatmap cluster for visualizing clustered gene expression data.
#' @description Heatmap cluster for visualizing clustered gene expression data.
#' @author wei dong
#'
#' @return Plot: Heatmap cluster for visualizing clustered gene expression data.
#' @param data Dataframe: Shared DEGs of all paired comparisons in all samples expression dataframe of RNA-Seq. (1st-col: Genes, 2nd-col~: Samples).
#' @param dist_method Character: distance measure method. Default: "euclidean", options: "euclidean", "maximum", "manhattan", "canberra", "binary" or "minkowski".
#' @param hc_method Character: hierarchical clustering method. Default: "average", options: "ward.D", "ward.D2", "single", "complete","average" (= UPGMA), "mcquitty" (= WPGMA), "median" (= WPGMC) or "centroid" (= UPGMC).
#' @param k_num Numeric: the number of groups for cutting the tree. Default: 5.
#' @param show_rownames Logical: boolean specifying if column names are be shown. Default: FALSE, options: TRUE or FALSE.
#' @param palette Character: color palette used in heatmap. Default: "RdBu", options: 'Spectral', 'BrBG', 'PiYG', 'PRGn', 'PuOr', 'RdBu', 'RdGy', 'RdYlBu', 'RdYlGn'.
#' @param cluster_pal Character: color palette used for the cluster. Default: "Set1", options: 'Set1', 'Set2', 'Set3', 'Accent', 'Dark2', 'Paired', 'Pastel1', 'Pastel2'.
#' @param border_color Character: cell border color (color name or hex value). Default: "#ffffff".
#' @param angle_col Numeric: angle of the column labels. Default: 45.
#' @param label_size Numeric: fontsize for the plot. Default: 10, min: 0.
#' @param base_size Numeric: base font size. Default: 12, min: 0.
#' @param line_color Character: trend lines color. Default: "#0000cd".
#' @param line_alpha Numeric: trend lines alpha. Default: 0.20, min: 0.00, max: 1.00.
#' @param summary_color Charater: summary line color. Default: "#0000cd".
#' @param summary_alpha Numeric: summary line alpha. Default: 0.80, min: 0.00, max: 1.00.
#'
#' @import ggplot2
#' @import pheatmap
#' @importFrom grDevices colorRampPalette
#' @importFrom tidyr pivot_longer
#' @importFrom stats sd
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
#' heatmap_cluster(gene_expression2)
#'
#' # 4. Set palette = "PuOr"
#' heatmap_cluster(gene_expression2, palette = "PuOr")
#'
#' # 5. Set line_color = "#ff0000", summary_color = "#ff0000"
#' heatmap_cluster(gene_expression2, line_color = "#ff0000", summary_color = "#ff0000")
#'

heatmap_cluster <- function(data,
														dist_method = "euclidean",
														hc_method = "average",
														k_num = 5,
														show_rownames = FALSE,
														palette = "RdBu",
														cluster_pal = "Set1",
														border_color = "#ffffff",
														angle_col = 45,
														label_size = 10,
														base_size = 12,
														line_color = "#0000cd",
														line_alpha = 0.20,
														summary_color = "#0000cd",
														summary_alpha = 0.80) {

	validate_is_dataframe_or_matrix(data, "data")

	data <- as.data.frame(data)

	if (ncol(data) < 2) {
		stop("data must have at least 2 columns (1 gene column + 1+ sample columns)", call. = FALSE)
	}

	if (nrow(data) == 0) {
		stop("data must have at least one row", call. = FALSE)
	}

	validate_character_options(dist_method, "dist_method",
														 c("euclidean", "maximum", "manhattan", "canberra", "binary", "minkowski"))
	validate_character_options(hc_method, "hc_method",
														 c("ward.D", "ward.D2", "single", "complete", "average", "mcquitty", "median", "centroid"))
	validate_numeric_range(k_num, "k_num", min = 2)
	validate_logical(show_rownames, "show_rownames")
	validate_character_options(palette, "palette",
														 c("Spectral", "BrBG", "PiYG", "PRGn", "PuOr", "RdBu", "RdGy", "RdYlBu", "RdYlGn"))
	validate_character_options(cluster_pal, "cluster_pal",
														 c("Set1", "Set2", "Set3", "Accent", "Dark2", "Paired", "Pastel1", "Pastel2"))
	validate_hex_color(border_color, "border_color")
	validate_numeric_range(angle_col, "angle_col", min = 0, max = 360)
	validate_numeric_range(label_size, "label_size", min = 0)
	validate_numeric_range(base_size, "base_size", min = 0)
	validate_hex_color(line_color, "line_color")
	validate_numeric_range(line_alpha, "line_alpha", min = 0, max = 1)
	validate_hex_color(summary_color, "summary_color")
	validate_numeric_range(summary_alpha, "summary_alpha", min = 0, max = 1)

	rownames(data) <- data[, 1]
	data <- data[, -1]

	na_count <- sum(is.na(data))
	if (na_count > 0) {
		warning(sprintf("Data contains %d NA values (%.1f%%), these will be excluded from calculations",
										 na_count, na_count / length(data) * 100))
	}

	data <- t(apply(data, 1, ZScore))

	palette_map <- list(
		"Spectral" = c("#9E0142", "#D53E4F", "#F46D43", "#FDAE61", "#FEE08B", "#FFFFBF", "#E6F598", "#ABDDA4", "#66C2A5", "#3288BD", "#5E4FA2"),
		"BrBG" = c("#543005", "#8C510A", "#BF812D", "#DFC27D", "#F6E8C3", "#F5F5F5", "#C7EAE5", "#80CDC1", "#35978F", "#01665E", "#003C30"),
		"PiYG" = c("#8E0152", "#C51B7D", "#DE77AE", "#F1B6DA", "#FDE0EF", "#F7F7F7", "#E6F5D0", "#B8E186", "#7FBC41", "#4D9221", "#276419"),
		"PRGn" = c("#40004B", "#762A83", "#9970AB", "#C2A5CF", "#E7D4E8", "#F7F7F7", "#D9F0D3", "#A6DBA0", "#5AAE61", "#1B7837", "#00441B"),
		"PuOr" = c("#7F3B08", "#B35806", "#E08214", "#FDB863", "#FEE0B6", "#F7F7F7", "#D8DAEB", "#B2ABD2", "#8073AC", "#542788", "#2D004B"),
		"RdBu" = c("#67001F", "#B2182B", "#D6604D", "#F4A582", "#FDDBC7", "#F7F7F7", "#D1E5F0", "#92C5DE", "#4393C3", "#2166AC", "#053061"),
		"RdGy" = c("#67001F", "#B2182B", "#D6604D", "#F4A582", "#FDDBC7", "#FFFFFF", "#E0E0E0", "#BABABA", "#878787", "#4D4D4D", "#1A1A1A"),
		"RdYlBu" = c("#A50026", "#D73027", "#F46D43", "#FDAE61", "#FEE090", "#FFFFBF", "#E0F3F8", "#ABD9E9", "#74ADD1", "#4575B4", "#313695"),
		"RdYlGn" = c("#A50026", "#D73027", "#F46D43", "#FDAE61", "#FEE08B", "#FFFFBF", "#D9EF8B", "#A6D96A", "#66BD63", "#1A9850", "#006837")
	)

	if (palette %in% names(palette_map)) {
		palettes <- rev(palette_map[[palette]])
	} else {
		palettes <- rev(palette_map[["RdBu"]])
	}
	colors <- grDevices::colorRampPalette(palettes)(100)

	p <- pheatmap::pheatmap(
		data,
		cluster_cols = FALSE,
		cutree_rows = k_num,
		show_rownames = show_rownames,
		clustering_distance_rows = dist_method,
		clustering_method = hc_method
	)

	row_cluster <- stats::cutree(p$tree_row, k = k_num)
	newOrder <- as.data.frame(data[p$tree_row$order, ])
	newOrder$Cluster <- paste0("Cluster", row_cluster[match(rownames(newOrder), names(row_cluster))])
	row_annot <- data.frame(Cluster = newOrder$Cluster,
													row.names = rownames(newOrder))
	
	cluster_palette_map <- list(
		"Set1" = c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"),
		"Set2" = c("#66C2A5", "#FC8D62", "#8DA0CB", "#E78AC3", "#A6D854", "#FFD92F", "#E5C494", "#B3B3B3"),
		"Set3" = c("#8DD3C7", "#FFFFB3", "#BEBADA", "#FB8072", "#80B1D3", "#FDB462", "#B3DE69", "#FCCDE5", "#D9D9D9", "#BC80BD", "#CCEBC5", "#FFED6F"),
		"Accent" = c("#7FC97F", "#BEAED4", "#FDC086", "#FFFF99", "#386CB0", "#F0027F", "#BF5B17", "#666666"),
		"Dark2" = c("#1B9E77", "#D95F02", "#7570B3", "#E7298A", "#66A61E", "#E6AB02", "#A6761D", "#666666"),
		"Paired" = c("#A6CEE3", "#1F78B4", "#B2DF8A", "#33A02C", "#FB9A99", "#E31A1C", "#FDBF6F", "#FF7F00", "#CAB2D6", "#6A3D9A", "#FFFF99", "#B15928"),
		"Pastel1" = c("#FBB4AE", "#B3CDE3", "#CCEBC5", "#DECBE4", "#FED9A6", "#FFFFCC", "#E5D8BD", "#FDDAEC", "#F2F2F2"),
		"Pastel2" = c("#B3E2CD", "#FDCDAC", "#CBD5E8", "#F4CAE4", "#E6F5C9", "#FFF2AE", "#F1E2CC", "#CCCCCC")
	)
	
	if (cluster_pal %in% names(cluster_palette_map)) {
		base_colors <- cluster_palette_map[[cluster_pal]]
	} else {
		base_colors <- cluster_palette_map[["Set1"]]
	}
	
	n_clusters <- length(unique(newOrder$Cluster))
	if (n_clusters <= length(base_colors)) {
		cluster_colors <- base_colors[seq_len(n_clusters)]
	} else {
		cluster_colors <- grDevices::colorRampPalette(base_colors)(n_clusters)
	}
	
	names(cluster_colors) <- unique(newOrder$Cluster)
	ann_colors <- list(Cluster = cluster_colors)

	p1 <- pheatmap::pheatmap(
		data,
		cluster_cols = FALSE,
		cutree_rows = k_num,
		gaps_col = NULL,
		fontsize = label_size,
		clustering_distance_rows = dist_method,
		clustering_method = hc_method,
		annotation_row = row_annot,
		show_rownames = show_rownames,
		color = colors,
		annotation_colors = ann_colors,
		cellheight = 2,
		angle_col = angle_col,
		border_color = border_color
	)

	newOrder$gene <- rownames(newOrder)
	data_new <- tidyr::pivot_longer(newOrder,
																	 cols = -c(gene, Cluster),
																	 names_to = "Sample",
																	 values_to = "Expression")
	data_new$Cluster <- factor(data_new$Cluster, levels = unique(data_new$Cluster))

	p2 <- ggplot2::ggplot(data_new, aes(x = Sample, y = Expression, group = gene)) +
		geom_line(color = line_color,
							linewidth = 0.8,
							alpha = line_alpha) +
		geom_hline(yintercept = 0, linetype = 2) +
		stat_summary(
			aes(group = 1),
			fun = mean,
			geom = "line",
			linewidth = 1.2,
			color = summary_color,
			alpha = summary_alpha
		) +
		facet_wrap(Cluster ~ ., ncol = 1) +
		theme_bw(base_size = base_size) +
		theme(
			panel.grid = element_blank(),
			axis.text = element_text(size = label_size),
			axis.text.x = element_text(angle = angle_col, hjust = 1),
			strip.background = element_rect(fill = "#cdcdcd", color = "#cdcdcd"),
			strip.text = element_text(
				color = "#333333",
				size = label_size,
				face = "bold"
			)
		)

	invisible(p1)
	return(p2)
}
