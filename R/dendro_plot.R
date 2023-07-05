#' @title Dendrograms for multiple samples/groups clustering.
#' @description Dendrograms for multiple samples/groups clustering.
#' @author wei dong
#'
#' @return Plot: Dendrograms for multiple samples/groups clustering.
#' @param data Dataframe: gene expression dataframe with cols (samples) and rows (genes).
#' @param dist_method Character: distance measure method. Default: "euclidean", options: "euclidean", "maximum", "manhattan", "canberra", "binary" or "minkowski".
#' @param hc_method Character: hierarchical clustering method. Default: "average", options: "ward.D", "ward.D2", "single", "complete","average" (= UPGMA), "mcquitty" (= WPGMA), "median" (= WPGMC) or "centroid" (= UPGMC).
#' @param tree_type Character: plot tree type. Default: "rectangle", options: "rectangle", "circular", "phylogenic".
#' @param k_num Numeric: the number of groups for cutting the tree. Default: 3.
#' @param palette Character: color palette used for the group. Default: "npg", options: "npg", "aaas", "lancet", "jco", "ucscgb", "uchicago", "simpsons" and "rickandmorty".
#' @param color_labels_by_k Logical: labels colored by group. Default: TRUE, options: TRUE or FALSE.
#' @param horiz Logical: horizontal dendrogram. Default: FALSE, options: TRUE or FALSE.
#' @param label_size Numeric: tree label size. Default: 0.8, min: 0.
#' @param line_width Numeric: branches and rectangle line width. Default: 0.7, min: 0.
#' @param rect Logical: add a rectangle around groups. Default: TRUE, options: TRUE or FALSE.
#' @param rect_fill Logical: fill the rectangle. Default: TRUE, options: TRUE or FALSE.
#' @param title Character: main plot title. Default: "Cluster Dendrogram".
#' @param xlab Character: title of the xlab. Default: "".
#' @param ylab Character: title of the ylab. Default: "Height".
#'
#' @import ggplot2
#' @importFrom stats dist hclust as.dendrogram
#' @importFrom factoextra fviz_dend
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset gene_exp
#' data(gene_exp)
#' head(gene_exp)
#'
#' # 3. Default parameters
#' dendro_plot(gene_exp)
#'
#' # 4. Set palette = "aaas"
#' dendro_plot(gene_exp, palette = "aaas")
#'
#' # 5. Set k_num = 5
#' dendro_plot(gene_exp, k_num = 5)
#'
#' # 6. Set tree_type = "circular"
#' dendro_plot(gene_exp, tree_type = "circular")
#'
#' # 7. Set tree_type = "phylogenic"
#' dendro_plot(gene_exp, tree_type = "phylogenic")
#'
dendro_plot <- function(data,
												dist_method = "euclidean",
												hc_method = "average",
												tree_type = "rectangle",
												k_num = 3,
												palette = "npg",
												color_labels_by_k = TRUE,
												horiz = TRUE,
												label_size = 0.8,
												line_width = 0.7,
												rect = TRUE,
												rect_fill = TRUE,
												title = "Cluster Dendrogram",
												xlab = "",
												ylab = "Height"
												){

	# -> 2. NA and Duplicated
	data <- as.data.frame(t(data))
	# data <- data[!is.na(data[, 1]), ]
	# idx <- duplicated(data[, 1])
	# data[idx, 1] <- paste0(data[idx, 1], "--dup-", cumsum(idx)[idx])
	# rownames(data) <- data[, 1]
	# data <- data[, -1]
	# <- 2. NA and Duplicated

	# -> 3. Plot parameters
	# dist_method <- "euclidean"
	# ChoiceBox: "euclidean", "maximum", "manhattan", "canberra", "binary" or "minkowski"

	# hc_method <- "average"
	# ChoiceBox: "ward.D", "ward.D2", "single", "complete", "average" (= UPGMA), "mcquitty" (= WPGMA), "median" (= WPGMC) or "centroid" (= UPGMC)

	# tree_type <- "rectangle"
	# ChoiceBox: "rectangle", "triangle", "circular", "phylogenic"

	# title <- "Cluster Dendrogram"
	# k_num = 3
	# label_size = 0.8
	# line_width = 0.7
	# <- 3. Plot parameters

	# Calculate distance matrix，method = "euclidean"
	# This must be one of "euclidean", "maximum", "manhattan", "canberra", "binary" or "minkowski"
	dists <- dist(data, method = dist_method)

	# Perform hierarchical clustering，method = "average"
	# This should be (an unambiguous abbreviation of) one of "ward.D", "ward.D2", "single", "complete", "average" (= UPGMA), "mcquitty" (= WPGMA), "median" (= WPGMC) or "centroid" (= UPGMC).
	hc <- hclust(dists, method = hc_method)

	# Create dendrogram object
	dend <- as.dendrogram(hc)

	p <- factoextra::fviz_dend(dend,
														 k = k_num,
														 k_colors = palette,
														 color_labels_by_k = color_labels_by_k,
														 show_labels = TRUE,
														 repel = TRUE,
														 type = tree_type,
														 rect = rect,
														 rect_border = palette,
														 rect_fill = rect_fill,
														 horiz = horiz,
														 cex = label_size,
														 lwd = line_width,
														 main = title,
														 xlab = xlab,
														 ylab = ylab
														 ) +
		theme(plot.title = element_text(hjust = 0.5))

	return(p)
}
