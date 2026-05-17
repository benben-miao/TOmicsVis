#' @title Venn plot for stat common and unique gene among multiple sets.
#' @description Venn plot for stat common and unique gene among multiple sets.
#' @author benben-miao
#'
#' @return Plot: venn plot for stat common and unique gene among multiple sets.
#' @param data Dataframe: Paired comparisons differentially expressed genes (degs) among groups (1st-col~: degs of paired comparisons).
#' @param title_size Numeric: sets title size. Default: 1, min: 0, max: NULL.
#' @param label_show Logical: show intersection labels. Default: TRUE, options: TRUE, FALSE.
#' @param label_size Numeric: intersection labels size. Default: 0.8, min: 0, max: NULL.
#' @param border_show Logical: show border line. Default: TRUE, options: TRUE, FALSE.
#' @param line_type Character: ellipse border line type. Default: "blank", options: "blank", "solid", "dashed", "dotted", "dotdash", "longdash", "twodash".
#' @param ellipse_shape Character: ellipse shape. Default: "circle", options: "circle", "ellipse".
#' @param sci_fill_color Character: ggsci color palette. Default: "Sci_AAAS", options: "Sci_AAAS", "Sci_NPG", "Sci_Simpsons", "Sci_JAMA", "Sci_GSEA", "Sci_Lancet", "Sci_Futurama", "Sci_JCO", "Sci_NEJM", "Sci_IGV", "Sci_UCSC", "Sci_D3", "Sci_Material".
#' @param sci_fill_alpha Numeric: ggsci fill color alpha. Default: 0.65, min: 0.00, max: 1.00.
#'
#' @import ggplot2
#' @import ggsci
#' @importFrom venn venn
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset
#' data(degs_lists)
#' head(degs_lists)
#'
#' # 3. Default parameters
#' venn_plot(degs_lists)
#'
#' # 4. Set line_type = "blank"
#' venn_plot(degs_lists, line_type = "blank")
#'
#' # 5. Set ellipse_shape = "ellipse"
#' venn_plot(degs_lists, ellipse_shape = "ellipse")
#'
#' # 6. Set sci_fill_color = "Sci_IGV"
#' venn_plot(degs_lists, sci_fill_color = "Sci_IGV")
#'
venn_plot <- function(data,
											title_size = 1,
											label_show = TRUE,
											label_size = 0.8,
											border_show = TRUE,
											line_type = "longdash",
											ellipse_shape = "circle",
											sci_fill_color = "Sci_AAAS",
											sci_fill_alpha = 0.65) {

	validate_is_dataframe(data, "data")
	validate_numeric_range(title_size, "title_size", min = 0)
	validate_logical(label_show, "label_show")
	validate_numeric_range(label_size, "label_size", min = 0)
	validate_logical(border_show, "border_show")
	validate_character_options(line_type, "line_type", c("blank", "solid", "dashed", "dotted", "dotdash", "longdash", "twodash"))
	validate_character_options(ellipse_shape, "ellipse_shape", c("circle", "ellipse"))
	validate_character_options(sci_fill_color, "sci_fill_color",
														 c("Sci_AAAS", "Sci_NPG", "Sci_Simpsons", "Sci_JAMA", "Sci_GSEA",
															 "Sci_Lancet", "Sci_Futurama", "Sci_JCO", "Sci_NEJM", "Sci_IGV",
															 "Sci_UCSC", "Sci_D3", "Sci_Material"))
	validate_numeric_range(sci_fill_alpha, "sci_fill_alpha", min = 0, max = 1)

	data_venn <- as.list(data)
	data_venn <- lapply(data_venn, function(x) {
		x[is.na(x)] <- ""
		x <- x[x != ""]
		return(x)
	})

	if (ellipse_shape == "circle") {
		ellipse <- FALSE
	} else if (ellipse_shape == "ellipse") {
		ellipse <- TRUE
	}

	colors <- get_ggsci_palette(sci_fill_color, n = 10, alpha = sci_fill_alpha)

	p <- venn::venn(x = data_venn,
									ilabels = label_show,
									ilcs = label_size,
									sncs = title_size,
									ggplot = TRUE,
									linetype = line_type,
									zcolor = colors,
									opacity = sci_fill_alpha,
									borders = border_show,
									ellipse = ellipse,
									box = FALSE)

	return(p)
}
