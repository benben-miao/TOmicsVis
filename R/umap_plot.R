#' @title UMAP plot for analyzing and visualizing UMAP algorithm.
#' @description UMAP plot for analyzing and visualizing UMAP algorithm.
#' @author benben-miao
#'
#' @return Plot: UMAP plot for analyzing and visualizing UMAP algorithm.
#' @param sample_gene Dataframe: gene expression dataframe (1st-col: Transcripts or Genes, 2nd-col~: Samples).
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
#' @param ggTheme Character: ggplot2 themes. Default: "theme_light", options: "theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw", "theme_dark", "theme_minimal", "theme_classic", "theme_void"
#'
#' @import ggplot2
#' @import ggsci
#' @importFrom umap umap
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
#' umap_plot(gene_expression, samples_groups)
#'
#' # 4. Set sci_fill_color = "Sci_Simpsons", seed = 6
#' umap_plot(gene_expression, samples_groups, sci_fill_color = "Sci_Simpsons", seed = 6)
#'
#' # 5. Set fill_alpha = 0.10
#' umap_plot(gene_expression, samples_groups, fill_alpha = 0.10)
#'
umap_plot <- function(sample_gene,
											group_sample,
											seed = 1,
											multi_shape = TRUE,
											point_size = 5,
											point_alpha = 1.00,
											text_size = 5,
											text_alpha = 0.80,
											fill_alpha = 0.00,
											border_alpha = 0.00,
											sci_fill_color = "Sci_AAAS",
											legend_pos = "right",
											legend_dir = "vertical",
											ggTheme = "theme_light"
											){

	# -> 2. NA and Duplicated
	sample_gene <- as.data.frame(sample_gene)
	rownames(sample_gene) <- sample_gene[,1]
	sample_gene <- sample_gene[,-1]
	sample_gene <- sample_gene[rowSums(sample_gene > 0) > 0, ]
	t_sample_gene <- t(sample_gene)
	groups <- group_sample[,2]

	umap_ano <- vegan::anosim(x = t_sample_gene,
										 grouping = groups)
	umap_p <- umap_ano$signif
	umap_r <- round(umap_ano$statistic,3)

	set.seed(seed)
	umap_res <- umap(t_sample_gene)
	umap_out <- as.data.frame(umap_res$layout[,c(1,2)])
	# write.table(umap_out,
	# 						file = "Results.txt",
	# 						append = FALSE,
	# 						sep = "\t",
	# 						quote = FALSE,
	# 						na = "NA"
	# )
	colnames(umap_out) <- c("UMAP1","UMAP2")
	# <- 2. NA and Duplicated

	# -> 3. Plot parameters
	# fonts <- "Times"
	# ChoiceBox: "Times", "Palatino", "Bookman", "Courier", "Helvetica", "URWGothic", "NimbusMon", "NimbusSan"

	# ggTheme <- "theme_light"
	# ChoiceBox: "theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw", "theme_dark", "theme_minimal", "theme_classic", "theme_void"
	if (ggTheme == "theme_default") {
		gg_theme <- theme()
	} else if (ggTheme == "theme_bw") {
		gg_theme <- theme_bw()
	} else if (ggTheme == "theme_gray") {
		gg_theme <- theme_gray()
	} else if (ggTheme == "theme_light") {
		gg_theme <- theme_light()
	} else if (ggTheme == "theme_linedraw") {
		gg_theme <- theme_linedraw()
	} else if (ggTheme == "theme_dark") {
		gg_theme <- theme_dark()
	} else if (ggTheme == "theme_minimal") {
		gg_theme <- theme_minimal()
	} else if (ggTheme == "theme_classic") {
		gg_theme <- theme_classic()
	} else if (ggTheme == "theme_void") {
		gg_theme <- theme_void()
	} else if (ggTheme == "theme_test") {
		gg_theme <- theme_test()
	}

	# point_size <- 3
	# slide: 5, 0, 0.1, 20
	# point_alpha <- 0.8
	# slide: 0.8, 0, 0.1, 1

	# text_size <- 2
	# slide: 6, 0, 0.1, 20
	# text_alpha <- 0.8
	# slide: 0.8, 0, 0.1, 1

	# ellipse_alpha <- 0.3
	# slide: 0.3, 0, 0.1, 1
	# ci_level <- 0.95
	# slide: 0.95, 0, 0.01, 1

	sci_color_alpha <- 1.00
	# sci_fill_color <- "Sci_NPG"
	# ChoiceBox: "Sci_AAAS", "Sci_NPG", "Sci_Simpsons", "Sci_JAMA", "Sci_GSEA", "Sci_Lancet", "Sci_Futurama", "Sci_JCO", "Sci_NEJM", "Sci_IGV", "Sci_UCSC", "Sci_D3", "Sci_Material"
	if (sci_fill_color == "Default") {
		sci_color <- NULL
	} else if (sci_fill_color == "Sci_AAAS") {
		sci_color <- scale_color_aaas(alpha = sci_color_alpha)
		# Science and Science Translational Medicine:
	} else if (sci_fill_color == "Sci_NPG") {
		sci_color <- scale_color_npg(alpha = sci_color_alpha)
	} else if (sci_fill_color == "Sci_Simpsons") {
		sci_color <- scale_color_simpsons(alpha = sci_color_alpha)
		# The Simpsons
	} else if (sci_fill_color == "Sci_JAMA") {
		sci_color <- scale_color_jama(alpha = sci_color_alpha)
		# The Journal of the American Medical Association
	} else if (sci_fill_color == "Sci_Lancet") {
		sci_color <- scale_color_lancet(alpha = sci_color_alpha)
		#  Lancet Oncology
	} else if (sci_fill_color == "Sci_Futurama") {
		sci_color <- scale_color_futurama(alpha = sci_color_alpha)
		# Futurama
	} else if (sci_fill_color == "Sci_JCO") {
		sci_color <- scale_color_jco(alpha = sci_color_alpha)
		# Journal of Clinical Oncology:
	} else if (sci_fill_color == "Sci_NEJM") {
		sci_color <- scale_color_nejm(alpha = sci_color_alpha)
		# The New England Journal of Medicine
	} else if (sci_fill_color == "Sci_IGV") {
		sci_color <- scale_color_igv(alpha = sci_color_alpha)
		# Integrative Genomics Viewer (IGV)
	} else if (sci_fill_color == "Sci_UCSC") {
		sci_color <- scale_color_ucscgb(alpha = sci_color_alpha)
		# UCSC Genome Browser chromosome sci_color
	} else if (sci_fill_color == "Sci_D3") {
		sci_color <- scale_color_d3(alpha = sci_color_alpha)
		# D3.JS
	} else if (sci_fill_color == "Sci_Material") {
		sci_color <- scale_color_material(alpha = sci_color_alpha)
		# The Material Design color palettes
	}

	plotTitleFace <- "bold"
	# ChoiceBox: "plain", "italic", "bold", "bold.italic"

	plotTitleSize <- 18
	# Slider: 18, 0, 50, 1

	plotTitleHjust <- 0.5
	# Slider: 0.5, 0.0, 1.0, 0.1

	axisTitleFace <- "plain"
	# ChoiceBox: "plain", "italic", "bold", "bold.italic"

	axisTitleSize <- 14
	# Slider: 16, 0, 50, 1

	axisTextSize <- 10
	# Slider: 10, 0, 50, 1

	legendTitleSize <- 12
	# Slider: 12, 0, 50, 1

	# legend_pos <- "right"
	# ChoiceBox: "none", "left", "right", "bottom", "top"

	# legend_dir <- "vertical"
	# ChoiceBox: "horizontal", "vertical"
	# <- 3. Plot parameters

	# # -> 4. Plot
	labels <- row.names(t_sample_gene)

	if (multi_shape) {
		p <- ggplot(umap_out,
								aes_string(x = "UMAP1",
													 y = "UMAP2",
													 color = "groups",
													 shape = "groups",
													 label = "labels")
		)
	}else {
		p <- ggplot(umap_out,
								aes_string(x = "UMAP1",
													 y = "UMAP2",
													 color = "groups",
													 # shape = "groups",
													 label = "labels")
		)
	}

	p <- p +
		geom_point(size = point_size,
							 show.legend = TRUE,
							 alpha = point_alpha) +
		geom_text(size = text_size,
							alpha = text_alpha,
							show.legend = FALSE,
							hjust = -0.2,
							vjust = 0.4) +
		xlab("UMAP1") +
		ylab("UMAP2") +
		geom_mark_ellipse(aes(fill = groups),
											label.fontsize = 0,
											label.colour	= "#ffffff00",
											label.fill = "#ffffff00",
											con.size = 0,
											con.colour = "#ffffff00",
											color = rgb(0, 0, 0, border_alpha),
											alpha = fill_alpha,
											show.legend = TRUE
											# level = pca_ellipse_level
		) +
		annotate("text",
						 x = min(umap_out$UMAP1) + ((max(umap_out$UMAP1) - min(umap_out$UMAP1)) * 0.01),
						 y = max(umap_out$UMAP2),
						 parse = TRUE,
						 size = 5,
						 label = paste('R:',umap_r),
						 colour = "black") +
		annotate("text",
						 x = min(umap_out$UMAP1) + ((max(umap_out$UMAP1) - min(umap_out$UMAP1)) * 0.01),
						 y = max(umap_out$UMAP2) - ((max(umap_out$UMAP2) - min(umap_out$UMAP2)) * 0.05),
						 parse = TRUE,
						 size = 5,
						 label = paste('P:',umap_p),
						 colour = "black") +
		sci_color +
		gg_theme +
		theme(plot.title = element_text(face = plotTitleFace,
																		# "plain", "italic", "bold", "bold.italic"
																		size = plotTitleSize,
																		hjust = plotTitleHjust
					),
					axis.title = element_text(face = axisTitleFace,
																		# "plain", "italic", "bold", "bold.italic"
																		size = axisTitleSize
					),
					axis.text = element_text(face = "plain",
																	 size = axisTextSize
					),
					legend.title = element_text(face = "plain",
																			size = legendTitleSize
					),
					legend.position = legend_pos,
					# "none", "left", "right", "bottom", "top"
					legend.direction = legend_dir
					# "horizontal" or "vertical"
		)
	# # <- 4. Plot

	return(p)
	invisible()
}
