#' @title TSNE plot for analyzing and visualizing TSNE algorithm.
#' @description TSNE plot for analyzing and visualizing TSNE algorithm.
#' @author benben-miao
#'
#' @return Plot: TSNE plot for analyzing and visualizing TSNE algorithm.
#' @param sample_gene Dataframe: All genes in all samples expression dataframe of RNA-Seq (1st-col: Genes, 2nd-col~: Samples).
#' @param group_sample Dataframe: Samples and groups for gene expression (1st-col: Samples, 2nd-col: Groups).
#' @param seed Numeric: set seed for robust result. Default: 1.
#' @param multi_shape Logical: groups as shapes. Default: FALSE, options: TRUE, FALSE.
#' @param point_size Numeric: point size. Default: 5, min: 0, max: null.
#' @param point_alpha Numeric: point color alpha. Default: 0.80, min: 0.00, max: 1.00.
#' @param text_size Numeric: text size. Default: 5, min: 0 (hind), max: null.
#' @param text_alpha Numeric: text alpha. Default: 0.80, min: 0.00, max: 1.00.
#' @param fill_alpha Numeric: ellipse alpha. Default: 0.30, min: 0.00, max: 1.00.
#' @param border_alpha Numeric: ellipse border color alpha. Default: 0.10, min: 0.00, max: 1.00.
#' @param sci_fill_color Character: ggsci color pallet. Default: "Sci_AAAS", options: "Sci_AAAS", "Sci_NPG", "Sci_Simpsons", "Sci_JAMA", "Sci_GSEA", "Sci_Lancet", "Sci_Futurama", "Sci_JCO", "Sci_NEJM", "Sci_IGV", "Sci_UCSC", "Sci_D3", "Sci_Material".
#' @param legend_pos Character: legend position. Default: "right", options: "none", "left", "right", "bottom", "top".
#' @param legend_dir Character: legend direction. Default: "vertical", options: "horizontal", "vertical".
#' @param ggTheme Character: ggplot2 themes. Default: "theme_publication", options: "theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw", "theme_dark", "theme_minimal", "theme_classic", "theme_void"
#'
#' @import ggplot2
#' @import ggsci
#' @importFrom Rtsne Rtsne
#' @importFrom vegan anosim
#' @importFrom grDevices rgb
#' @importFrom ggforce geom_mark_ellipse
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset
#' data(gene_expression)
#' head(gene_expression)
#'
#' data(samples_groups)
#' head(samples_groups)
#'
#' # 3. Default parameters
#' tsne_plot(gene_expression, samples_groups)
#'
#' # 4. Set sci_fill_color = "Sci_NPG", seed = 6
#' tsne_plot(gene_expression, samples_groups, sci_fill_color = "Sci_NPG", seed = 6)
#'
#' # 5. Set multi_shape = TRUE, fill_alpha = 0.00
#' tsne_plot(gene_expression, samples_groups, multi_shape = TRUE, fill_alpha = 0.00)
#'
tsne_plot <- function(sample_gene,
											group_sample,
											seed = 1,
											multi_shape = FALSE,
											point_size = 5,
											point_alpha = 0.80,
											text_size = 5,
											text_alpha = 0.80,
											fill_alpha = 0.10,
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

	sample_gene <- as.data.frame(sample_gene)
	rownames(sample_gene) <- sample_gene[,1]
	sample_gene <- sample_gene[,-1]
	sample_gene <- sample_gene[rowSums(sample_gene > 0) > 0, ]
	t_sample_gene <- t(sample_gene)
	groups <- group_sample[,2]

	tsne_ano <- vegan::anosim(x = t_sample_gene,
										 grouping = groups)
	tsne_p <- tsne_ano$signif
	tsne_r <- round(tsne_ano$statistic,3)

	set.seed(seed)
	m_sample_gene <- as.matrix(t_sample_gene)
	tsne_res <- Rtsne::Rtsne(m_sample_gene,
										dims = 2,
										perplexity = 3,
										check_duplicates = FALSE,
										verbose = getOption("verbose", FALSE)
	)

	tsne_out <- as.data.frame(tsne_res$Y)
	colnames(tsne_out) <- c("tSNE1","tSNE2")

	gg_theme <- get_ggtheme(ggTheme)

	sci_color <- get_ggsci_color(sci_fill_color)
	if (!is.null(sci_color)) {
		sci_color <- sci_color()
	}

	labels <- row.names(t_sample_gene)

	if (multi_shape) {
		p <- ggplot(tsne_out,
								aes(x = tSNE1,
									y = tSNE2,
									color = groups,
									shape = groups,
									label = labels)
		)
	}else {
		p <- ggplot(tsne_out,
								aes(x = tSNE1,
									y = tSNE2,
									color = groups,
									label = labels)
		)
	}

	p <- p +
		geom_point(size = point_size,
							 show.legend = TRUE,
							 alpha = point_alpha) +
		geom_text(size = text_size,
							alpha = text_alpha,
							show.legend = FALSE,
							hjust = -0.1,
							vjust = 0.5) +
		xlab("tSNE1") +
		ylab("tSNE2") +
		geom_mark_ellipse(aes(fill = groups),
											label.fontsize = 0,
											label.colour	= "#ffffff00",
											label.fill = "#ffffff00",
											con.size = 0,
											con.colour = "#ffffff00",
											color = rgb(0, 0, 0, border_alpha),
											alpha = fill_alpha,
											show.legend = TRUE
		) +
		annotate("text",
						 x = min(tsne_out$tSNE1) + ((max(tsne_out$tSNE1) - min(tsne_out$tSNE1)) * 0.01),
						 y = max(tsne_out$tSNE2),
						 parse = TRUE,
						 size = 5,
						 label = paste('R:',tsne_r),
						 colour = "black") +
		annotate("text",
						 x = min(tsne_out$tSNE1) + ((max(tsne_out$tSNE1) - min(tsne_out$tSNE1)) * 0.01),
						 y = max(tsne_out$tSNE2) - ((max(tsne_out$tSNE2) - min(tsne_out$tSNE2)) * 0.05),
						 parse = TRUE,
						 size = 5,
						 label = paste('P:',tsne_p),
						 colour = "black") +
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
