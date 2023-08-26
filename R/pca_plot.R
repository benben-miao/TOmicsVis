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
#' @param ggTheme Character: ggplot2 theme. Default: "theme_light", options: "theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw", "theme_dark", "theme_minimal", "theme_classic", "theme_void".
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
										 ggTheme = "theme_light"
										 ){
	# -> 2. Data
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
	# <- 2. Data

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

	# pca_geom_point_size <- 5
	# Slider: 4, 0, 0.1, 20

	# pca_geom_text_size <- 5
	# Slider: 6, 0, 0.1, 20

	# pca_ellipse_alpha <- 0.3
	# Slider: 0.3, 0, 0.1, 1

	# pca_ellipse_level <- 0.95
	# Slider: 0.95, 0, 0.01, 1

	# pca_legend_pos <- "right"
	# ChoiceBox: "none", "left", "right", "bottom", "top"

	# pca_legend_dir <- "vertical"
	# ChoiceBox: "vertical", "horizontal"

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

	# -> 4. Plot
	# colors <- distinctColorPalette(3)
	labels <- row.names(pca_out)

	if (multi_shape) {
		p <- ggplot(pca_out,
								aes_string(x = paste("PC", xPC, sep = ""),
													 y = paste("PC", yPC, sep = ""),
													 color = "groups",
													 shape = "groups",
													 label = "labels"
								))
	}else {
		p <- ggplot(pca_out,
								aes_string(x = paste("PC", xPC, sep = ""),
													 y = paste("PC", yPC, sep = ""),
													 color = "groups",
													 # shape = "groups",
													 label = "labels"
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
											# level = pca_ellipse_level
		) +
		labs(fill = "Groups", color = "Groups", shape = "Groups") +
		# coord_fixed() +
		# stat_ellipse(aes(x = PC1, y = PC2,
		#                  fill = groups),
		#              geom = "polygon",
		#              alpha = pca_ellipse_alpha,
		#              show.legend = FALSE,
		#              level = pca_ellipse_level
		# ) +
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
	# <- 4. Plot

	return(p)
}
