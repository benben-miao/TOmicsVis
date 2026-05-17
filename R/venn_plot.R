#' @title Venn plot for stat common and unique gene among multiple sets.
#' @description Venn plot for stat common and unique gene among multiple sets.
#' @author benben-miao
#'
#' @return Plot: venn plot for stat common and unique gene among multiple sets.
#' @param data Dataframe: Paired comparisons differentially expressed genes (degs) among groups (1st-col~: degs of paired comparisons).
#' @param title_size Numeric: sets title size. Default: 1.2, min: 0, max: NULL.
#' @param label_show Logical: show intersection labels. Default: TRUE, options: TRUE, FALSE.
#' @param label_size Numeric: intersection labels size. Default: 1, min: 0, max: NULL.
#' @param label_color Character: label text color. Default: "#333333", options: hex color code.
#' @param border_show Logical: show border line. Default: TRUE, options: TRUE, FALSE.
#' @param border_color Character: ellipse border color. Default: "#666666", options: hex color code.
#' @param line_type Character: ellipse border line type. Default: "solid", options: "blank", "solid", "dashed", "dotted", "dotdash", "longdash", "twodash".
#' @param line_width Numeric: border line width. Default: 0.8, min: 0, max: NULL.
#' @param ellipse_shape Character: ellipse shape. Default: "circle", options: "circle", "ellipse".
#' @param color_scheme Character: venn color scheme. Default: "Vibrant", options: "Vibrant", "Pastel", "Ocean", "Sunset", "Forest", "Neon", "Candy", "Earth", "Wine", "Sci_AAAS", "Sci_NPG", "Sci_Simpsons", "Sci_JAMA", "Sci_GSEA", "Sci_Lancet", "Sci_Futurama", "Sci_JCO", "Sci_NEJM", "Sci_IGV", "Sci_UCSC", "Sci_D3", "Sci_Material".
#' @param fill_alpha Numeric: fill color alpha (transparency). Default: 0.55, min: 0.00, max: 1.00.
#' @param custom_colors Character vector: custom colors for sets (overrides color_scheme).
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
#' # 3. Default parameters (Vibrant theme)
#' venn_plot(degs_lists)
#'
#' # 4. Pastel soft colors
#' venn_plot(degs_lists, color_scheme = "Pastel")
#'
#' # 5. Ocean theme
#' venn_plot(degs_lists, color_scheme = "Ocean")
#'
#' # 6. Sunset warm colors
#' venn_plot(degs_lists, color_scheme = "Sunset")
#'
#' # 7. Custom colors
#' venn_plot(degs_lists, custom_colors = c("#E64B35FF", "#4DBBD5FF", "#00A087FF"))
#'

venn_plot <- function(data,
											title_size = 1.2,
											label_show = TRUE,
											label_size = 1,
											label_color = "#333333",
											border_show = TRUE,
											border_color = "#666666",
											line_type = "solid",
											line_width = 0.8,
											ellipse_shape = "circle",
											color_scheme = "Vibrant",
											fill_alpha = 0.55,
											custom_colors = NULL) {

	validate_is_dataframe(data, "data")
	validate_numeric_range(title_size, "title_size", min = 0)
	validate_logical(label_show, "label_show")
	validate_numeric_range(label_size, "label_size", min = 0)
	validate_hex_color(label_color, "label_color")
	validate_logical(border_show, "border_show")
	validate_hex_color(border_color, "border_color")
	validate_character_options(line_type, "line_type", c("blank", "solid", "dashed", "dotted", "dotdash", "longdash", "twodash"))
	validate_numeric_range(line_width, "line_width", min = 0)
	validate_character_options(ellipse_shape, "ellipse_shape", c("circle", "ellipse"))
	validate_character_options(color_scheme, "color_scheme",
														 c("Vibrant", "Pastel", "Ocean", "Sunset", "Forest", "Neon",
															 "Candy", "Earth", "Wine",
															 "Sci_AAAS", "Sci_NPG", "Sci_Simpsons", "Sci_JAMA", "Sci_GSEA",
															 "Sci_Lancet", "Sci_Futurama", "Sci_JCO", "Sci_NEJM", "Sci_IGV",
															 "Sci_UCSC", "Sci_D3", "Sci_Material"))
	validate_numeric_range(fill_alpha, "fill_alpha", min = 0, max = 1)

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

	if (!is.null(custom_colors)) {
		colors <- custom_colors
	} else {
		colors <- get_venn_palette(color_scheme, n = ncol(data), alpha = fill_alpha)
	}

	p <- venn::venn(x = data_venn,
									ilabels = label_show,
									ilcs = label_size,
									sncs = title_size,
									ggplot = TRUE,
									linetype = line_type,
									zcolor = colors,
									opacity = fill_alpha,
									borders = border_show,
									ellipse = ellipse,
									box = FALSE)

	if (!border_show) {
		p <- p + theme(legend.position = "none")
	}

	return(p)
}


get_venn_palette <- function(scheme = "Vibrant", n = 4, alpha = 0.55) {
	venn_palettes <- list(
		"Vibrant" = c("#E64B35FF", "#4DBBD5FF", "#00A087FF", "#3C5488FF",
									"#F39B7FFF", "#8491B4FF", "#91D1C2FF"),
		"Pastel" = c("#FBB4AEFF", "#B3CDE3FF", "#CCEBC5FF", "#DECBE4FF",
								"#FED9A6FF", "#FFFFCCFF", "#F2F2F2FF"),
		"Ocean" = c("#0077BBFF", "#33BBEEFF", "#009988FF", "#33AA44FF",
							"#66CC99FF", "#99DDCCFF", "#CCEEFFFF"),
		"Sunset" = c("#EE7733FF", "#CC3311FF", "#EE3377FF", "#220022FF",
							 "#AA4499FF", "#4466AAFF", "#117733FF"),
		"Forest" = c("#228B22FF", "#32CD32FF", "#90EE90FF", "#006400FF",
							 "#556B2FFF", "#8FBC8FFF", "#98FB98FF"),
		"Neon" = c("#FF00FFFF", "#00FFFFFF", "#00FF00FF", "#FFFF00FF",
							 "#FF8800FF", "#8800FFFF", "#0088FFFF"),
		"Candy" = c("#FF6B6BFF", "#4ECDC4FF", "#45B7D1FF", "#96CEB4FF",
							 "#FFEAA7FF", "#DDA0DDFF", "#98D8C8FF"),
		"Earth" = c("#D4A574FF", "#8B4513FF", "#CD853FFF", "#DEB887FF",
							 "#F4A460FF", "#D2691EFF", "#BC8F8FFF"),
		"Wine" = c("#800020FF", "#722F37FF", "#880044FF", "#A52A2AFF",
							 "#B22222FF", "#DC143CFF", "#CD5C5CFF"),
		"Sci_AAAS" = c("#E4BACC", "#C994C7", "#DF65B0", "#DD1C77", "#980043"),
		"Sci_NPG" = c("#E64B35", "#4DBBD5", "#00A087", "#3C5488", "#F39B7F",
									 "#8491B4", "#91D1C2", "#DC0000", "#7E6148", "#B09C85"),
		"Sci_Simpsons" = c("#FFE0B2", "#FBB4AE", "#C51B7D", "#0072B5", "#00BA38",
										 "#A6761D", "#E69F00", "#CA0020", "#F781BF", "#6A3D9A"),
		"Sci_JAMA" = c("#374E55", "#DF8F44", "#00A1D5", "#B24745", "#79AF97",
								 "#008891", "#DAA526", "#984EA3", "#5A462B", "#FFBC79"),
		"Sci_Lancet" = c("#00468B", "#ED0000", "#42B540", "#0099B4", "#925E9F",
										 "#FDAF91", "#AD0029", "#ADB6B6", "#000000", "#F67C01"),
		"Sci_Futurama" = c("#FF9900", "#CD8500", "#A66C00", "#7F5300", "#583900",
											 "#016651", "#4DAF4A", "#999933", "#C51B7D", "#E6AB02"),
		"Sci_JCO" = c("#0073C2", "#EFC000", "#868686", "#CD534C", "#7AA6DC",
								 "#003C67", "#B14039", "#808180", "#CC61A0", "#8E78EE"),
		"Sci_NEJM" = c("#BC3C29", "#0072B5", "#E18727", "#20854E", "#7876B1",
									 "#6F99AD", "#FFDC91", "#EE4C97", "#8BB0DD", "#B09B85"),
		"Sci_IGV" = c("#000000", "#00FFFF", "#0000FF", "#00FF00", "#FF0000",
								 "#FF00FF", "#0080FF", "#008080", "#800080", "#FF0080"),
		"Sci_UCSC" = c("#F4302D", "#7869B5", "#8595BF", "#69B3C1", "#94C93D",
									 "#E8BC44", "#EB8621", "#B35C22", "#FFFFFF", "#888888"),
		"Sci_D3" = c("#1B9E77", "#D95F02", "#7570B3", "#E7298A", "#66A61E",
							 "#E6AB02", "#A6761D", "#666666", "#1B7837", "#B2AB8D"),
		"Sci_Material" = c("#1ABC9C", "#16A085", "#2ECC71", "#27AE60", "#3498DB",
										 "#2980B9", "#9B59B6", "#8E44AD", "#34495E", "#2C3E50")
	)

	if (scheme %in% names(venn_palettes)) {
		colors <- venn_palettes[[scheme]]
	} else {
		colors <- venn_palettes[["Vibrant"]]
	}

	if (n > length(colors)) {
		colors <- grDevices::colorRampPalette(colors)(n)
	}

	if (alpha < 1) {
		colors <- grDevices::rgb(
			t(grDevices::col2rgb(colors)),
			alpha = round(alpha * 255),
			maxColorValue = 255
		)
	}

	return(colors[1:n])
}
