#' @title Dendrograms for multiple samples/groups clustering.
#' @description Dendrograms for multiple samples/groups clustering.
#' @author wei dong
#'
#' @return Plot: dendrogram for multiple samples clustering.
#' @param data Dataframe: All genes in all samples expression dataframe of RNA-Seq (1st-col: Genes, 2nd-col~: Samples).
#' @param dist_method Character: distance measure method. Default: "euclidean", options: "euclidean", "maximum", "manhattan", "canberra", "binary" or "minkowski".
#' @param hc_method Character: hierarchical clustering method. Default: "ward.D2", options: "ward.D", "ward.D2", "single", "complete","average" (= UPGMA), "mcquitty" (= WPGMA), "median" (= WPGMC) or "centroid" (= UPGMC).
#' @param tree_type Character: plot tree type. Default: "rectangle", options: "rectangle", "circular", "phylogenic".
#' @param k_num Numeric: the number of groups for cutting the tree. Default: 3.
#' @param palette Character: color palette used for the group. Default: "npg", options: "npg", "aaas", "lancet", "jco", "ucscgb", "uchicago", "simpsons" and "rickandmorty".
#' @param color_labels_by_k Logical: labels colored by group. Default: TRUE, options: TRUE or FALSE.
#' @param horiz Logical: horizontal dendrogram. Default: FALSE, options: TRUE or FALSE.
#' @param label_size Numeric: tree label size. Default: 0.8, min: 0.
#' @param line_width Numeric: branches and rectangle line width. Default: 0.5, min: 0.
#' @param rect Logical: add a rectangle around groups. Default: TRUE, options: TRUE or FALSE.
#' @param rect_fill Logical: fill the rectangle. Default: TRUE, options: TRUE or FALSE.
#' @param xlab Character: title of the xlab. Default: "".
#' @param ylab Character: title of the ylab. Default: "Height".
#' @param ggTheme Character: ggplot2 theme. Default: "theme_publication", options: "theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw", "theme_dark", "theme_minimal", "theme_classic", "theme_void".
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
#' # 2. Use example dataset gene_expression
#' data(gene_expression)
#' head(gene_expression)
#'
#' # 3. Default parameters
#' dendro_plot(gene_expression)
#'
#' # 4. Set palette = "aaas"
#' dendro_plot(gene_expression, palette = "aaas")
#'
#' # 5. Set tree_type = "circular"
#' dendro_plot(gene_expression, tree_type = "circular")
#'
dendro_plot <- function(data,
												dist_method = "euclidean",
												hc_method = "ward.D2",
												tree_type = "rectangle",
												k_num = 5,
												palette = "npg",
												color_labels_by_k = TRUE,
												horiz = FALSE,
												label_size = 1.00,
												line_width = 1.00,
												rect = TRUE,
												rect_fill = TRUE,
												xlab = "Samples",
												ylab = "Height",
												ggTheme = "theme_publication") {

	if (!requireNamespace("factoextra", quietly = TRUE)) {
		stop("Package 'factoextra' is required for dendro_plot().\n",
				 "Please install: install.packages('factoextra')",
				 call. = FALSE)
	}

	data <- as.data.frame(data)
	data <- data[, -1]
	data <- data[rowSums(data > 0) > 0, ]
	data <- as.data.frame(t(data))

	validate_is_dataframe_or_matrix(data, "data")
	validate_character_options(dist_method, "dist_method",
														 c("euclidean", "maximum", "manhattan", "canberra", "binary", "minkowski"))
	validate_character_options(hc_method, "hc_method",
														 c("ward.D", "ward.D2", "single", "complete", "average", "mcquitty", "median", "centroid"))
	validate_character_options(tree_type, "tree_type", c("rectangle", "circular", "phylogenic"))
	validate_numeric_range(k_num, "k_num", min = 2)
	validate_character_options(palette, "palette",
														 c("npg", "aaas", "lancet", "jco", "ucscgb", "uchicago", "simpsons", "rickandmorty"))
	validate_logical(color_labels_by_k, "color_labels_by_k")
	validate_logical(horiz, "horiz")
	validate_numeric_range(label_size, "label_size", min = 0)
	validate_numeric_range(line_width, "line_width", min = 0)
	validate_logical(rect, "rect")
	validate_logical(rect_fill, "rect_fill")
	validate_character_options(ggTheme, "ggTheme",
														 c("theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw",
															 "theme_dark", "theme_minimal", "theme_classic", "theme_void", "theme_publication"))

	# Calculate distance matrix，method = "euclidean"
	# This must be one of "euclidean", "maximum", "manhattan", "canberra", "binary" or "minkowski"
	dists <- dist(data, method = dist_method)

	# Perform hierarchical clustering，method = "average"
	# This should be (an unambiguous abbreviation of) one of "ward.D", "ward.D2", "single", "complete", "average" (= UPGMA), "mcquitty" (= WPGMA), "median" (= WPGMC) or "centroid" (= UPGMC).
	hc <- hclust(dists, method = hc_method)

	# Create dendrogram object
	dend <- as.dendrogram(hc)

	gg_theme <- get_ggtheme(ggTheme)

	p <- factoextra::fviz_dend(
		dend,
		k = k_num,
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
		main = NULL,
		xlab = xlab,
		ylab = ylab,
		k_colors = palette
	) +
		gg_theme

	return(p)
}
