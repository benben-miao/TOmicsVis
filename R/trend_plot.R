#' @title Trend plot for visualizing gene expression trend profile in multiple traits.
#' @description Trend plot for visualizing gene expression trend profile in multiple traits.
#' @author benben-miao
#'
#' @return Plot: box plot support two levels and multiple groups with P value.
#' @param data Dataframe: Shared degs of all paired comparisons in all groups expression dataframe of RNA-Seq. (1st-col: Genes, 2nd-col~n-1-col: Groups, n-col: Pathways).
#' @param scale_method Character: data scale methods. Default: "globalminmax" (global min and max values), options: "std" (standard), "robust", "uniminmax" (unique min and max values), "globalminmax", "center", "centerObs" (center observes).
#' @param miss_value Character: deal method for missing values. Default: "exclude", options: "exclude", "mean", "median", "min10", "random".
#' @param line_alpha Numeric: lines color alpha. Default: 0.50, min: 0.00, max: 1.00.
#' @param show_points Logical: show points at trait node. Default: TRUE, options: TRUE, FALSE.
#' @param show_boxplot Logical: show boxplot at trait node. Default: TRUE, options: TRUE, FALSE.
#' @param num_column Logical: column number. Default: 2, min: 1, max: null.
#' @param xlab Character: x label. Default: "Traits".
#' @param ylab Character: y label. Default: "Genes Expression".
#' @param sci_fill_color Character: ggsci color pallet. Default: "Sci_AAAS", options: "Sci_AAAS", "Sci_NPG", "Sci_Simpsons", "Sci_JAMA", "Sci_GSEA", "Sci_Lancet", "Sci_Futurama", "Sci_JCO", "Sci_NEJM", "Sci_IGV", "Sci_UCSC", "Sci_D3", "Sci_Material".
#' @param sci_fill_alpha Numeric: ggsci fill color alpha. Default: 0.50, min: 0.00, max: 1.00.
#' @param sci_color_alpha Numeric: ggsci border color alpha. Default: 1.00, min: 0.00, max: 1.00.
#' @param legend_pos Character: legend position. Default: "right", options: "none", "left", "right", "bottom", "top".
#' @param legend_dir Character: legend direction. Default: "vertical", options: "horizontal", "vertical".
#' @param ggTheme Character: ggplot2 themes. Default: "theme_publication", options: "theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw", "theme_dark", "theme_minimal", "theme_classic", "theme_void"
#'
#' @import ggplot2
#' @import ggsci
#' @importFrom GGally ggparcoord
#' @importFrom stats formula
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset
#' data(gene_expression3)
#' head(gene_expression3)
#'
#' # 3. Default parameters
#' trend_plot(gene_expression3[1:50,])
#'
#' # 4. Set line_alpha = 0.30
#' trend_plot(gene_expression3[1:50,], line_alpha = 0.30)
#'
#' # 5. Set sci_fill_color = "Sci_NPG"
#' trend_plot(gene_expression3[1:50,], sci_fill_color = "Sci_NPG")
#'
trend_plot <- function(data,
											 scale_method = "centerObs",
											 miss_value = "exclude",
											 line_alpha = 0.50,
											 show_points = TRUE,
											 show_boxplot = TRUE,
											 num_column = 1,
											 xlab = "Traits",
											 ylab = "Genes Expression",
											 sci_fill_color = "Sci_AAAS",
											 sci_fill_alpha = 0.80,
											 sci_color_alpha = 0.80,
											 legend_pos = "right",
											 legend_dir = "vertical",
											 ggTheme = "theme_publication") {

	if (!requireNamespace("GGally", quietly = TRUE)) {
		stop("Package 'GGally' is required for trend_plot().\n",
				 "Please install: install.packages('GGally')",
				 call. = FALSE)
	}

	validate_is_dataframe(data, "data")
	validate_character_options(scale_method, "scale_method",
														 c("std", "robust", "uniminmax", "globalminmax", "center", "centerObs"))
	validate_character_options(miss_value, "miss_value", c("exclude", "mean", "median", "min10", "random"))
	validate_numeric_range(line_alpha, "line_alpha", min = 0, max = 1)
	validate_logical(show_points, "show_points")
	validate_logical(show_boxplot, "show_boxplot")
	validate_numeric_range(num_column, "num_column", min = 1)
	validate_character_options(sci_fill_color, "sci_fill_color",
														 c("Default", "Sci_AAAS", "Sci_NPG", "Sci_Simpsons", "Sci_JAMA", "Sci_GSEA",
															 "Sci_Lancet", "Sci_Futurama", "Sci_JCO", "Sci_NEJM", "Sci_IGV", "Sci_UCSC",
															 "Sci_D3", "Sci_Material"))
	validate_numeric_range(sci_fill_alpha, "sci_fill_alpha", min = 0, max = 1)
	validate_numeric_range(sci_color_alpha, "sci_color_alpha", min = 0, max = 1)
	validate_character_options(legend_pos, "legend_pos", c("none", "left", "right", "bottom", "top"))
	validate_character_options(legend_dir, "legend_dir", c("horizontal", "vertical"))
	validate_character_options(ggTheme, "ggTheme",
														 c("theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw",
															 "theme_dark", "theme_minimal", "theme_classic", "theme_void", "theme_publication"))

	gg_theme <- get_ggtheme(ggTheme)

	if (sci_fill_color == "Default") {
		sci_fill <- NULL
		sci_color <- NULL
	} else {
		sci_fill <- get_ggsci_fill(sci_fill_color, alpha = sci_fill_alpha)
		sci_color <- get_ggsci_color(sci_fill_color)
		if (!is.null(sci_color)) {
			sci_color <- sci_color(alpha = sci_color_alpha)
		}
	}

	plotTitleFace <- "bold"
	plotTitleSize <- 18
	plotTitleHjust <- 0.5
	axisTitleFace <- "plain"
	axisTitleSize <- 14
	axisTextSize <- 10
	legendTitleSize <- 12

	p <- GGally::ggparcoord(data,
									columns = 2:(ncol(data) - 1),
									groupColumn = ncol(data),
									scale = scale_method, # "std", "robust", "uniminmax", "globalminmax", "center", "centerObs"
									missing = miss_value, # "exclude", "mean", "median", "min10", "random"
									# order = columns,
									alphaLines = line_alpha,
									showPoints = show_points,
									boxplot = show_boxplot
									# title = title
	) +
		facet_wrap(formula(paste("~", (colnames(data)[ncol(data)]))),
							 ncol = num_column
		) +
		labs(x = xlab,
				 y = ylab
		) +
		sci_fill +
		sci_color +
		gg_theme +
		theme(plot.title = element_text(face = plotTitleFace,
																		size = plotTitleSize,
																		hjust = plotTitleHjust
					),
					axis.title = element_text(face = axisTitleFace,
																		size = axisTitleSize
					),
					axis.text = element_text(face = "plain",
																	 size = axisTextSize
					),
					legend.title = element_text(face = "plain",
																			size = legendTitleSize
					),
					legend.position = legend_pos,
					legend.direction = legend_dir,
					strip.background = element_rect(fill = "#cdcdcd", color = "#cdcdcd"),
					strip.text = element_text(color = "#333333", size = 10, face = "bold")
		)

	return(p)
}
