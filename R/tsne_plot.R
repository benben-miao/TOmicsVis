#' @title TSNE plot for analyzing and visualizing TSNE algorithm.
#' @description TSNE plot for analyzing and visualizing TSNE algorithm.
#' @author benben-miao
#'
#' @return Plot: TSNE plot for analyzing and visualizing TSNE algorithm.
#' @param data Dataframe: include columns (IDs, Trait1, Trait2, ...).
#' @param point_size Numeric: point size. Default: 3, min: 0, max: null.
#' @param point_alpha Numeric: point color alpha. Default: 0.80, min: 0.00, max: 1.00.
#' @param text_size Numeric: text size. Default: 2, min: 0 (hind), max: null.
#' @param text_alpha Numeric: text alpha. Default: 0.80, min: 0.00, max: 1.00.
#' @param ci_level Numeric: confidence interval level. Default: 0.95, min: 0.00, max: 1.00.
#' @param ellipse_alpha Numeric: ellipse alpha. Default: 0.30, min: 0.00, max: 1.00.
#' @param sci_fill_color Character: ggsci color pallet. Default: "Sci_AAAS", options: "Sci_AAAS", "Sci_NPG", "Sci_Simpsons", "Sci_JAMA", "Sci_GSEA", "Sci_Lancet", "Sci_Futurama", "Sci_JCO", "Sci_NEJM", "Sci_IGV", "Sci_UCSC", "Sci_D3", "Sci_Material".
#' @param sci_color_alpha Numeric: ggsci border color alpha. Default: 1.00, min: 0.00, max: 1.00.
#' @param legend_pos Character: legend position. Default: "right", options: "none", "left", "right", "bottom", "top".
#' @param legend_dir Character: legend direction. Default: "vertical", options: "horizontal", "vertical".
#' @param ggTheme Character: ggplot2 themes. Default: "theme_light", options: "theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw", "theme_dark", "theme_minimal", "theme_classic", "theme_void"
#'
#' @import ggplot2
#' @import ggsci
#' @importFrom Rtsne Rtsne
#' @importFrom vegan anosim
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset
#' data(tsne_data)
#'
#' # 3. Default parameters
#' tsne_plot(tsne_data)
#'
#' # 4. Set point_alpha = 0.50
#' tsne_plot(tsne_data, point_alpha = 0.50)
#'
#' # 5. Set ellipse_alpha = 0.00
#' tsne_plot(tsne_data, ellipse_alpha = 0.00)
#'
#' # 6. Set sci_fill_color = "Sci_NPG"
#' tsne_plot(tsne_data, sci_fill_color = "Sci_NPG")
#'
#' # 7. Set sci_color_alpha = 0.50
#' tsne_plot(tsne_data, sci_color_alpha = 0.50)
#'
tsne_plot <- function(data,
											point_size = 3,
											point_alpha = 0.80,
											text_size = 2,
											text_alpha = 0.80,
											ci_level = 0.95,
											ellipse_alpha = 0.30,
										 sci_fill_color = "Sci_AAAS",
										 sci_color_alpha = 0.90,
										 legend_pos = "right",
										 legend_dir = "vertical",
										 ggTheme = "theme_light"
										){

	# -> 2. NA and Duplicated
	tsne_tb <- as.data.frame(data)
	rownames(tsne_tb) <- tsne_tb[,1]
	tsne_data <- tsne_tb[,2:(ncol(tsne_tb) - 1)]
	groups <- tsne_tb[,ncol(tsne_tb)]

	tsne_ano <- vegan::anosim(x = tsne_data,
										 grouping = groups)
	tsne_p <- tsne_ano$signif
	tsne_r <- round(tsne_ano$statistic,3)

	set.seed(as.numeric(123))
	tsne_res <- Rtsne::Rtsne(as.matrix(unique(tsne_data)),
										dims = 2,
										initial_dims = 50,
										perplexity = 10,
										theta = 0.0,
										check_duplicates = TRUE,
										pca = T,
										partial_pca = FALSE,
										max_iter = 1000,
										verbose = getOption("verbose", FALSE),
										is_distance = FALSE,
										# Y_init = NULL,
										pca_center = TRUE,
										pca_scale = FALSE,
										normalize = TRUE,
										# stop_lying_iter = ifelse(is.null(Y_init), 250L,0L),
										# mom_switch_iter = ifelse(is.null(Y_init), 250L, 0L),
										momentum = 0.5,
										final_momentum = 0.8,
										eta = 200,
										exaggeration_factor = 12,
										num_threads = 2
	)
	# head(tsne_res)
	tsne_out <- as.data.frame(tsne_res$Y)
	# write.table(tsne_out,
	# 						file = "Results.txt",
	# 						append = FALSE,
	# 						sep = "\t",
	# 						quote = FALSE,
	# 						na = "NA"
	# )
	colnames(tsne_out) <- c("tSNE1","tSNE2")

	# percentage <- round(tsne_res$sdev / sum(tsne_res$sdev) * 100, 2)
	# percentage <- paste( colnames(tsne_out), "(", paste( as.character(percentage), "%", ")", sep="") )
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

	# sci_color_alpha <- 0.92
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
	p <- ggplot(tsne_out,
							aes(x = tsne_out$tSNE1,
									y = tsne_out$tSNE2,
									color = groups,
									shape = NULL,
									label = row.names(tsne_data))) +
		geom_point(size = point_size,
							 alpha = point_alpha) +
		geom_text(size = text_size,
							alpha = text_alpha,
							show.legend = FALSE) +
		# xlab("tSNE1") +
		# ylab("tSNE2") +
		stat_ellipse(aes(x = tsne_out$tSNE1,
										 y = tsne_out$tSNE2,
										 fill = groups),
								 geom = "polygon",
								 alpha = ellipse_alpha,
								 level = ci_level,
								 show.legend = FALSE
		) +
		annotate("text",
						 x = min(tsne_out$tSNE1) + ((max(tsne_out$tSNE1) - min(tsne_out$tSNE1)) * 0.2),
						 y = max(tsne_out$tSNE2),
						 parse = TRUE,
						 size = 5,
						 label = paste('R:',tsne_r),
						 colour = "black") +
		annotate("text",
						 x = min(tsne_out$tSNE1) + ((max(tsne_out$tSNE1) - min(tsne_out$tSNE1)) * 0.2),
						 y = max(tsne_out$tSNE2) - ((max(tsne_out$tSNE2) - min(tsne_out$tSNE2)) * 0.1),
						 parse = TRUE,
						 size = 5,
						 label = paste('P:',tsne_p),
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
