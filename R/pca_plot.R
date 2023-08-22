#' @title PCA dimensional reduction visualization for RNA-Seq.
#' @description PCA dimensional reduction visualization for RNA-Seq.
#' @author benben-miao
#'
#' @return Plot: PCA dimensional reduction visualization for RNA-Seq.
#' @param sample_gene Dataframe: gene expression dataframe (1st-col: Transcripts or Genes, 2nd-col~: Samples).
#' @param group_sample Dataframe: Samples and groups for gene expression (1st-col: Samples, 2nd-col: Groups).
#' @param xPC Numeric: PC index at x axis. Default: 1, options: 1, 2, 3, ...
#' @param yPC Numeric: PC index at y axis. Default: 2, options: 2, 3, 4, ...
#' @param point_size Numeric: PCA plot point size. Default: 5, min: 0.
#' @param text_size Numeric: PCA plot annotation size. Default: 5, min: 0.
#' @param fill_alpha Numeric: ellipse fill color alpha. Default: 0.10, min: 0.00, max: 1.00.
#' @param border_alpha Numeric: ellipse border color alpha. Default: 0.10, min: 0.00, max: 1.00.
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
#' # 4. Set ellipse_alpha = 0.30
#' pca_plot(gene_expression, samples_groups, ellipse_alpha = 0.00)
#'
#' # 5. Set legend_pos = "right", legend_dir = "vertical"
#' pca_plot(gene_expression, samples_groups, legend_pos = "top", legend_dir = "horizontal")
#'
pca_plot <- function(sample_gene,
										 group_sample,
										 xPC = 1,
										 yPC = 2,
										 point_size = 5,
										 text_size = 5,
										 fill_alpha = 0.10,
										 border_alpha = 0.00,
										 legend_pos = "right",
										 legend_dir = "vertical",
										 ggTheme = "theme_light"
										 ){
	# -> 2. Data
	sample_gene <- as.data.frame(sample_gene)
	rownames(sample_gene) <- sample_gene[,1]
	sample_gene <- sample_gene[,-1]
	sample_gene <- sample_gene[rowSums(sample_gene > 0) > 0, ]
	groups <- group_sample[,2]

	pca_res <- stats::prcomp(t(sample_gene))
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
	p <- ggplot(pca_out,
							aes_string(x = paste("PC", xPC, sep = ""),
												 y = paste("PC", yPC, sep = ""),
									color = "groups",
									shape = "groups",
									label = "labels"
									)) +
		geom_point(size = point_size,
							 show.legend = TRUE,
							 alpha = 0.5) +
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
											show.legend = FALSE
											# level = pca_ellipse_level
		) +
		# coord_fixed() +
		# stat_ellipse(aes(x = PC1, y = PC2,
		#                  fill = groups),
		#              geom = "polygon",
		#              alpha = pca_ellipse_alpha,
		#              show.legend = FALSE,
		#              level = pca_ellipse_level
		# ) +
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
