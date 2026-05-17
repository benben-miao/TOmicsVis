#' @title PCA dimensional reduction visualization for RNA-Seq.
#' @description PCA dimensional reduction visualization for RNA-Seq.
#' @author benben-miao
#'
#' @return Plot: PCA dimensional reduction visualization for RNA-Seq.
#' @param sample_gene Dataframe: All genes in all samples expression dataframe of RNA-Seq (1st-col: Genes, 2nd-col~: Samples).
#' @param group_sample Dataframe: Samples and groups for gene expression (1st-col: Samples, 2nd-col: Groups).
#' @param xPC Numeric: PC index at x axis. Default: 1, options: 1, 2, 3, ...
#' @param yPC Numeric: PC index at y axis. Default: 2, options: 2, 3, 4, ...
#' @param multi_shape Logical: groups as shapes. Default: TRUE, options: TRUE, FALSE.
#' @param point_size Numeric: PCA plot point size. Default: 5, min: 0.
#' @param point_alpha Numeric: point color alpha. Default: 0.80, min: 0.00, max: 1.00.
#' @param text_size Numeric: PCA plot annotation size. Default: 5, min: 0.
#' @param fill_alpha Numeric: ellipse fill color alpha. Default: 0.10, min: 0.00, max: 1.00.
#' @param border_alpha Numeric: ellipse border color alpha. Default: 0.10, min: 0.00, max: 1.00.
#' @param sci_fill_color Character: ggsci color pallet. Default: "Sci_AAAS", options: "Sci_AAAS", "Sci_NPG", "Sci_Simpsons", "Sci_JAMA", "Sci_GSEA", "Sci_Lancet", "Sci_Futurama", "Sci_JCO", "Sci_NEJM", "Sci_IGV", "Sci_UCSC", "Sci_D3", "Sci_Material".
#' @param legend_pos Character: legend position. Default: "right", options: "none", "left", "right", "bottom", "top".
#' @param legend_dir Character: legend director. Default: "vertical", options: "horizontal", "vertical".
#' @param ggTheme Character: ggplot2 theme. Default: "theme_publication", options: "theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw", "theme_dark", "theme_minimal", "theme_classic", "theme_void".
#'
#' @import ggplot2
#' @importFrom stats prcomp
#' @importFrom grDevices rgb
#' @importFrom ggforce geom_mark_ellipse
#' @export
#'
#' @examples
#' # 1. Library package TOmicsVis
#' library(TOmicsVis)
#'
#' # 2. Load example datasets
#' data(gene_expression)
#' head(gene_expression)
#'
#' data(samples_groups)
#' head(samples_groups)
#'
#' # 3. Default parameters
#' pca_plot(gene_expression, samples_groups)
#'
#' # 4. Set multi_shape = FALSE
#' pca_plot(gene_expression, samples_groups, multi_shape = FALSE)
#'
#' # 5. Set sci_fill_color = "Sci_NPG", fill_alpha = 0.10
#' pca_plot(gene_expression, samples_groups, sci_fill_color = "Sci_NPG", fill_alpha = 0.10)
#'
pca_plot <- function(sample_gene,
										 group_sample,
										 xPC = 1,
										 yPC = 2,
										 multi_shape = TRUE,
										 point_size = 5,
										 point_alpha = 0.80,
										 text_size = 5,
										 fill_alpha = 0.05,
										 border_alpha = 0.00,
										 sci_fill_color = "Sci_AAAS",
										 legend_pos = "right",
										 legend_dir = "vertical",
										 ggTheme = "theme_publication"
										){

	validate_character_options(ggTheme, "ggTheme",
														 c("theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw",
															 "theme_dark", "theme_minimal", "theme_classic", "theme_void",
															 "theme_publication"))

	validate_is_dataframe_or_matrix(sample_gene, "sample_gene")
	validate_is_dataframe_or_matrix(group_sample, "group_sample")

	if (ncol(sample_gene) < 2) {
		stop("sample_gene must have at least 2 columns (1 gene column + 1+ sample columns)", call. = FALSE)
	}

	if (ncol(group_sample) < 2) {
		stop("group_sample must have at least 2 columns (Samples, Groups)", call. = FALSE)
	}

	if (!is.numeric(xPC) || xPC < 1 || !is.numeric(yPC) || yPC < 1) {
		stop("xPC and yPC must be positive integers", call. = FALSE)
	}

	if (xPC == yPC) {
		stop("xPC and yPC must be different values", call. = FALSE)
	}

	if (!validate_numeric_range(point_size, min_val = 0)) {
		stop("point_size must be a non-negative number", call. = FALSE)
	}

	if (!validate_numeric_range(point_alpha, min_val = 0, max_val = 1)) {
		stop("point_alpha must be between 0 and 1", call. = FALSE)
	}

	if (!validate_numeric_range(text_size, min_val = 0)) {
		stop("text_size must be a non-negative number", call. = FALSE)
	}

	if (!validate_numeric_range(fill_alpha, min_val = 0, max_val = 1)) {
		stop("fill_alpha must be between 0 and 1", call. = FALSE)
	}

	if (!validate_numeric_range(border_alpha, min_val = 0, max_val = 1)) {
		stop("border_alpha must be between 0 and 1", call. = FALSE)
	}

	valid_legend_pos <- c("none", "left", "right", "bottom", "top")
	if (!legend_pos %in% valid_legend_pos) {
		stop(sprintf("legend_pos must be one of: %s", paste(valid_legend_pos, collapse = ", ")), call. = FALSE)
	}

	valid_legend_dir <- c("horizontal", "vertical")
	if (!legend_dir %in% valid_legend_dir) {
		stop(sprintf("legend_dir must be one of: %s", paste(valid_legend_dir, collapse = ", ")), call. = FALSE)
	}

	sample_gene <- as.data.frame(sample_gene)
	rownames(sample_gene) <- sample_gene[,1]
	sample_gene <- sample_gene[,-1]
	sample_gene <- sample_gene[rowSums(sample_gene > 0) > 0, ]
	t_sample_gene <- t(sample_gene)
	groups <- group_sample[,2]

	pca_res <- stats::prcomp(t_sample_gene)
	pca_out <- as.data.frame(pca_res$x)

	percentage <- round(pca_res$sdev / sum(pca_res$sdev) * 100, 2)
	percentage <- paste(colnames(pca_out), "(", paste( as.character(percentage), "%", ")", sep = ""))

	gg_theme <- get_ggtheme(ggTheme)

	sci_color <- get_ggsci_color(sci_fill_color)
	if (!is.null(sci_color)) {
		sci_color <- sci_color()
	}

	labels <- row.names(pca_out)

	if (multi_shape) {
		p <- ggplot(pca_out,
								aes(x = .data[[paste("PC", xPC, sep = "")]],
									y = .data[[paste("PC", yPC, sep = "")]],
									color = groups,
									shape = groups,
									label = labels
								))
	} else {
		p <- ggplot(pca_out,
								aes(x = .data[[paste("PC", xPC, sep = "")]],
									y = .data[[paste("PC", yPC, sep = "")]],
									color = groups,
									label = labels
								))
	}

	p <- p +
		geom_point(size = point_size,
							 show.legend = TRUE,
							 alpha = point_alpha) +
		geom_text(size = text_size,
							show.legend = FALSE,
							alpha = 1,
							hjust = -0.1,
							vjust = 0.5) +
		xlab(percentage[xPC]) +
		ylab(percentage[yPC]) +
		geom_mark_ellipse(aes(fill = groups),
											color = rgb(0, 0, 0, border_alpha),
											alpha = fill_alpha,
											show.legend = TRUE
		) +
		labs(fill = "Groups", color = "Groups", shape = "Groups") +
		sci_color +
		gg_theme +
		theme(plot.title = element_text(face = "bold",
																		size = 18,
																		hjust = 0.5
					),
					axis.title = element_text(face = "plain",
																		size = 14
					),
					axis.text = element_text(face = "plain",
																	 size = 10
					),
					legend.title = element_text(face = "plain",
																			size = 12
					),
					legend.position = legend_pos,
					legend.direction = legend_dir
		)

	return(p)
}
