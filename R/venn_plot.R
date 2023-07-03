#' @title Venn plot for stat common and unique gene among multiple sets.
#' @description Venn plot for stat common and unique gene among multiple sets.
#' @author benben-miao
#'
#' @return Plot: venn plot for stat common and unique gene among multiple sets.
#' @param data Dataframe: multiple gene sets as columns.
#' @param line_type Character: ellipse border line type. Default: "blank", options: "blank", "solid", "dashed", "dotted", "dotdash", "longdash", "twodash".
#' @param ellipse_shape Character: ellipse shape. Default: "circle", options: "circle", "ellipse".
#' @param sci_fill_color Character: ggsci color palette. Default: "Sci_AAAS", options: "Sci_AAAS", "Sci_NPG", "Sci_Simpsons", "Sci_JAMA", "Sci_GSEA", "Sci_Lancet", "Sci_Futurama", "Sci_JCO", "Sci_NEJM", "Sci_IGV", "Sci_UCSC", "Sci_D3", "Sci_Material".
#' @param sci_fill_alpha Numeric: ggsci fill color alpha. Default: 0.65, min: 0.00, max: 1.00.
#'
#' @import ggplot2
#' @import ggpolypath
#' @import ggsci
#' @importFrom venn venn
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset
#' data(venn_data)
#'
#' # 3. Default parameters
#' venn_plot(venn_data)
#'
#' # 4. Set line_type = "dashed"
#' venn_plot(venn_data, line_type = "dashed")
#'
#' # 5. Set ellipse_shape = "ellipse"
#' venn_plot(venn_data, ellipse_shape = "ellipse")
#'
#' # 6. Set sci_fill_color = "Sci_IGV"
#' venn_plot(venn_data, sci_fill_color = "Sci_IGV")
#'
venn_plot <- function(data,
										 line_type = "blank",
										 ellipse_shape = "circle",
										 sci_fill_color = "Sci_AAAS",
										 sci_fill_alpha = 0.65
										){
	# -> 2. NA and Duplicated
	data_venn <- as.list(data)
	data_venn <- lapply(data_venn, function(x) {
		x[is.na(x)] <- ""
		x <- x[x != ""]
		return(x)
	})
	# <- 2. NA and Duplicated

	# -> 3. Plot parameters
	# line_type <- "blank"
	# ChoiceBox: "blank", "solid", "dashed", "dotted", "dotdash", "longdash", "twodash"

	# ellipse_shape <- "circle"
	if (ellipse_shape == "circle") {
		ellipse <- FALSE
	} else if (ellipse_shape == "ellipse") {
		ellipse <- TRUE
	}
	# ChoiceBox: "circle", "ellipse"

	# sci_fill_alpha <- 0.65
	# Slider: 0.5, 0, 0.1, 1.0
	# sci_fill_color <- "Sci_AAAS"
	# ChoiceBox: "Sci_AAAS", "Sci_NPG", "Sci_Simpsons", "Sci_JAMA", "Sci_GSEA", "Sci_Lancet", "Sci_Futurama", "Sci_JCO", "Sci_NEJM", "Sci_IGV", "Sci_UCSC", "Sci_D3", "Sci_Material"
	if (sci_fill_color == "Sci_AAAS") {
		colors <- pal_aaas(palette = c("default"), alpha = sci_fill_alpha)(10)
		# Science and Science Translational Medicine:
		# "#3B4992FF" "#EE0000FF" "#008B45FF" "#631879FF" "#008280FF" "#BB0021FF" "#5F559BFF" "#A20056FF" "#808180FF" "#1B1919FF"
	} else if (sci_fill_color == "Sci_NPG") {
		colors <- pal_npg(palette = "nrc", alpha = sci_fill_alpha)(10)
	} else if (sci_fill_color == "Sci_Simpsons") {
		colors <- pal_simpsons(palette = "springfield", alpha = sci_fill_alpha)(16)
		# The Simpsons
	} else if (sci_fill_color == "Sci_JAMA") {
		colors <- pal_jama(palette = c("default"), alpha = sci_fill_alpha)(8)
		# The Journal of the American Medical Association
		# "#374E55FF" "#DF8F44FF" "#00A1D5FF" "#B24745FF" "#79AF97FF" "#6A6599FF" "#80796BFF"
	} else if (sci_fill_color == "Sci_GSEA") {
		colors <- pal_gsea(palette = c("default"), alpha = sci_fill_alpha, reverse = FALSE)(12)
		# GSEA GenePattern
		# "#4500ACFF" "#2600D1FF" "#6B58EEFF" "#8787FFFF" "#C6C0FFFF" "#D4D4FFFF" "#FFBFE5FF" "#FF8888FF" "#FF707FFF" "#FF5959FF" "#EE3F3FFF" "#D60C00FF"
	} else if (sci_fill_color == "Sci_Lancet") {
		colors <- pal_lancet(palette = c("lanonc"), alpha = sci_fill_alpha)(9)
		#  Lancet Oncology
		# "#00468BFF" "#ED0000FF" "#42B540FF" "#0099B4FF" "#925E9FFF" "#FDAF91FF" "#AD002AFF" "#ADB6B6FF" "#1B1919FF"
	} else if (sci_fill_color == "Sci_Futurama") {
		colors <- pal_futurama(palette = c("planetexpress"), alpha = sci_fill_alpha)(12)
		# Futurama
		# "#FF6F00FF" "#C71000FF" "#008EA0FF" "#8A4198FF" "#5A9599FF" "#FF6348FF" "#84D7E1FF" "#FF95A8FF" "#3D3B25FF" "#ADE2D0FF" "#1A5354FF" "#3F4041FF"
	} else if (sci_fill_color == "Sci_JCO") {
		colors <- pal_jco(palette = c("default"), alpha = sci_fill_alpha)(10)
		# Journal of Clinical Oncology:
		# "#0073C2FF" "#EFC000FF" "#868686FF" "#CD534CFF" "#7AA6DCFF" "#003C67FF" "#8F7700FF" "#3B3B3BFF" "#A73030FF" "#4A6990FF"
	} else if (sci_fill_color == "Sci_NEJM") {
		colors <- pal_nejm(palette = c("default"), alpha = sci_fill_alpha)(8)
		# The New England Journal of Medicine
	} else if (sci_fill_color == "Sci_IGV") {
		colors <- pal_igv(palette = c("default", "alternating"), alpha = sci_fill_alpha)(51)
		# Integrative Genomics Viewer (IGV)
	} else if (sci_fill_color == "Sci_UCSC") {
		colors <- pal_ucscgb(palette = "default", alpha = sci_fill_alpha)(26)
		# UCSC Genome Browser chromosome colors
	} else if (sci_fill_color == "Sci_D3") {
		colors <- pal_d3(palette = "category20",alpha = sci_fill_alpha)(20)
		# D3.JS
	} else if (sci_fill_color == "Sci_Material") {
		colors <- pal_material(palette = "orange", n = 100, alpha = sci_fill_alpha, reverse = FALSE)(100)
		# The Material Design color palettes
	}

	# fonts <- "Times"
	# ChoiceBox: "Times", "Palatino", "Bookman", "Courier", "Helvetica", "URWGothic", "NimbusMon", "NimbusSan"
	# <- 3. Plot parameters

	# -> 4. Plot
	p <- venn::venn(x = data_venn,
					 ggplot = TRUE, # FALSE
					 linetype = line_type,
					 zcolor = colors,
					 opacity = sci_fill_alpha,
					 borders = FALSE,
					 ellipse = ellipse,
					 ilcs = 1,
					 sncs = 1,
					 box = FALSE
	)
	# <- 4. Plot

	return(p)
}
