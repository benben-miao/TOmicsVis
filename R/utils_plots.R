#' @title Get ggplot2 theme by name
#' @description Get ggplot2 theme object by theme name with enhanced customization
#' @param theme_name Character: theme name
#' @param base_size Numeric: base font size. Default: 12
#' @return Theme object
#' @keywords internal

get_ggtheme <- function(theme_name = "theme_publication", base_size = 12) {
	theme_map <- list(
		"theme_default" = theme(),
		"theme_bw" = theme_bw(base_size = base_size),
		"theme_gray" = theme_gray(base_size = base_size),
		"theme_light" = theme_light(base_size = base_size),
		"theme_linedraw" = theme_linedraw(base_size = base_size),
		"theme_dark" = theme_dark(base_size = base_size),
		"theme_minimal" = theme_minimal(base_size = base_size),
		"theme_classic" = theme_classic(base_size = base_size),
		"theme_void" = theme_void(base_size = base_size),
		"theme_publication" = theme_publication(base_size = base_size)
	)

	if (theme_name %in% names(theme_map)) {
		base_theme <- theme_map[[theme_name]]
	} else {
		warning("Unknown theme '", theme_name, "', using theme_publication")
		base_theme <- theme_publication(base_size = base_size)
	}

	base_theme +
		theme(
			plot.title = element_text(face = "bold", size = base_size * 1.5, hjust = 0.5),
			plot.subtitle = element_text(size = base_size * 1.1, color = "gray30"),
			axis.title = element_text(face = "plain", size = base_size * 1.17),
			axis.text = element_text(size = base_size, color = "black"),
			legend.title = element_text(face = "bold", size = base_size),
			legend.text = element_text(size = base_size * 0.9),
			strip.text = element_text(face = "bold", size = base_size, color = "#333333"),
			strip.background = element_rect(fill = "#E8E8E8", color = "#E8E8E8")
		)
}

#' @title Publication-quality clean theme (No grid lines)
#' @description Create a publication-ready clean theme without background grid lines for professional figures
#' @param base_size Numeric: base font size. Default: 12
#' @return Theme object with no grid lines and professional styling
#' @keywords internal

theme_publication <- function(base_size = 12) {
	theme_minimal(base_size = base_size) +
		theme(
			panel.grid.major = element_blank(),
			panel.grid.minor = element_blank(),
			panel.border = element_rect(fill = NA, color = "black", linewidth = 0.5),
			plot.background = element_rect(fill = "white", color = NA),
			panel.background = element_rect(fill = "white"),
			legend.background = element_rect(fill = "white", color = NA),
			legend.key = element_rect(fill = "white", color = NA),
			axis.line = element_line(linewidth = 0.5, color = "black"),
			axis.ticks = element_line(linewidth = 0.5, color = "black")
		)
}

#' @title Get ggsci color scale by name
#' @description Get ggsci color scale function by palette name
#' @param pal_name Character: ggsci palette name
#' @return Scale function or NULL
#' @keywords internal

get_ggsci_color <- function(pal_name = "Sci_AAAS", alpha = 1) {
	sci_color_map <- list(
		"Sci_AAAS" = function(alpha = 1) scale_color_aaas(alpha = alpha),
		"Sci_NPG" = function(alpha = 1) scale_color_npg(alpha = alpha),
		"Sci_Simpsons" = function(alpha = 1) scale_color_simpsons(alpha = alpha),
		"Sci_JAMA" = function(alpha = 1) scale_color_jama(alpha = alpha),
		"Sci_Lancet" = function(alpha = 1) scale_color_lancet(alpha = alpha),
		"Sci_Futurama" = function(alpha = 1) scale_color_futurama(alpha = alpha),
		"Sci_JCO" = function(alpha = 1) scale_color_jco(alpha = alpha),
		"Sci_NEJM" = function(alpha = 1) scale_color_nejm(alpha = alpha),
		"Sci_IGV" = function(alpha = 1) scale_color_igv(alpha = alpha),
		"Sci_UCSC" = function(alpha = 1) scale_color_ucscgb(alpha = alpha),
		"Sci_D3" = function(alpha = 1) scale_color_d3(alpha = alpha),
		"Sci_Material" = function(alpha = 1) scale_color_material(alpha = alpha)
	)

	if (pal_name %in% names(sci_color_map)) {
		return(sci_color_map[[pal_name]])
	} else {
		return(NULL)
	}
}

#' @title Get ggsci color palette (hex colors)
#' @description Get actual hex color values from ggsci palette
#' @param pal_name Character: ggsci palette name
#' @param n Numeric: number of colors to return
#' @param alpha Numeric: transparency (0-1)
#' @return Character vector of hex colors
#' @keywords internal

get_ggsci_palette <- function(pal_name = "Sci_AAAS", n = 10, alpha = 1) {
	palette_map <- list(
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

	if (pal_name %in% names(palette_map)) {
		colors <- palette_map[[pal_name]]
	} else {
		colors <- palette_map[["Sci_AAAS"]]
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

#' @title Validate hex color code
#' @description Validate if a string is a valid hex color code
#' @param x Character: color string to validate
#' @param param_name Character: parameter name for error message
#' @return Logical: TRUE if valid hex color
#' @keywords internal

validate_hex_color <- function(x, param_name = "color_str") {
	if (!is.character(x) || length(x) != 1 || !grepl("^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$", x)) {
		stop(sprintf("'%s' must be a valid hex color code (e.g., '#FF0000')", param_name), call. = FALSE)
	}
	return(invisible(TRUE))
}

#' @title Validate numeric range
#' @description Validate if numeric value is within specified range
#' @param x Numeric: value to validate
#' @param param_name Character: parameter name for error message
#' @param min_val Numeric: minimum allowed value (inclusive). Default: 0
#' @param max_val Numeric: maximum allowed value (inclusive). Default: NULL (no max)
#' @return Logical: TRUE if within range (invisible)
#' @keywords internal

validate_numeric_range <- function(x, param_name = "x", min_val = 0, max_val = NULL) {
	if (!is.numeric(x) || length(x) != 1 || is.na(x)) {
		stop(sprintf("'%s' must be a single numeric value", param_name), call. = FALSE)
	}
	if (x < min_val) {
		stop(sprintf("'%s' must be >= %s (got: %s)", param_name, min_val, x), call. = FALSE)
	}
	if (!is.null(max_val) && x > max_val) {
		stop(sprintf("'%s' must be <= %s (got: %s)", param_name, max_val, x), call. = FALSE)
	}
	return(invisible(TRUE))
}

#' @title Validate logical value
#' @description Validate if value is logical
#' @param x Logical: value to validate
#' @param param_name Character: parameter name for error message
#' @return Logical: TRUE if valid logical (invisible)
#' @keywords internal

validate_logical <- function(x, param_name = "x") {
	if (!is.logical(x) || length(x) != 1) {
		stop(sprintf("'%s' must be a single logical value (TRUE/FALSE)", param_name), call. = FALSE)
	}
	return(invisible(TRUE))
}

#' @title Validate character options
#' @description Validate if character is one of allowed options
#' @param x Character: value to validate
#' @param param_name Character: parameter name for error message
#' @param options Character vector: allowed options
#' @return Logical: TRUE if valid option (invisible)
#' @keywords internal

validate_character_options <- function(x, param_name = "x", options) {
	if (!is.character(x) || length(x) != 1 || !(x %in% options)) {
		stop(sprintf("'%s' must be one of: %s (got: '%s')",
								 param_name, paste(options, collapse = ", "), x), call. = FALSE)
	}
	return(invisible(TRUE))
}

#' @title Validate is data.frame
#' @description Validate input is a data.frame, stop with error if not
#' @param x Object to validate
#' @param param_name Character: parameter name for error message
#' @return Logical: TRUE if valid (invisible)
#' @keywords internal

validate_is_dataframe <- function(x, param_name = "x") {
	if (!is.data.frame(x)) {
		stop(sprintf("'%s' must be a data.frame", param_name), call. = FALSE)
	}
	return(invisible(TRUE))
}

#' @title Validate is data.frame or matrix
#' @description Validate input is a data.frame or matrix
#' @param x Object to validate
#' @param param_name Character: parameter name for error message
#' @return Logical: TRUE if valid (invisible)
#' @keywords internal

validate_is_dataframe_or_matrix <- function(x, param_name = "x") {
	if (!is.data.frame(x) && !is.matrix(x)) {
		stop(sprintf("'%s' must be a data.frame or matrix", param_name), call. = FALSE)
	}
	return(invisible(TRUE))
}

#' @title Safe data preprocessing
#' @description Preprocess data frame/matrix with NA handling and validation
#' @param data Data.frame or Matrix: input data
#' @param min_cols Integer: minimum number of columns required. Default: 1
#' @param remove_na Logical: remove rows with NA in first column. Default: TRUE
#' @return Processed data.frame
#' @keywords internal

safe_preprocess_data <- function(data, min_cols = 1, remove_na = TRUE) {
	if (!is.data.frame(data) && !is.matrix(data)) {
		stop("Input must be a data.frame or matrix", call. = FALSE)
	}

	data <- as.data.frame(data)

	if (ncol(data) < min_cols) {
		stop(sprintf("Data must have at least %d column(s)", min_cols), call. = FALSE)
	}

	if (nrow(data) == 0) {
		stop("Data must have at least one row", call. = FALSE)
	}

	if (remove_na && ncol(data) > 0) {
		data <- data[complete.cases(data[, 1]), , drop = FALSE]
	}

	if (nrow(data) == 0) {
		warning("All rows contained NA values after cleaning")
	}

	return(data)
}

#' @title Safe get ggsci fill scale
#' @description Safely get ggsci fill color scale with error handling
#' @param pal_name Character: palette name
#' @param alpha Numeric: transparency value. Default: 1
#' @return Scale function or default
#' @keywords internal

get_ggsci_fill <- function(pal_name = "Sci_AAAS", alpha = 1) {
	valid_palettes <- c("Sci_AAAS", "Sci_NPG", "Sci_Simpsons", "Sci_JAMA",
											"Sci_Lancet", "Sci_Futurama", "Sci_JCO",
											"Sci_NEJM", "Sci_IGV", "Sci_UCSC",
											"Sci_D3", "Sci_Material")

	pal_base <- gsub("Sci_", "", pal_name)

	if (!(pal_name %in% valid_palettes)) {
		warning("Unknown palette '", pal_name, "', using Sci_AAAS")
		pal_base <- "AAAS"
	}

	tryCatch({
		switch(pal_base,
			"AAAS" = scale_fill_aaas(alpha = alpha),
			"NPG" = scale_fill_npg(alpha = alpha),
			"Simpsons" = scale_fill_simpsons(alpha = alpha),
			"JAMA" = scale_fill_jama(alpha = alpha),
			"Lancet" = scale_fill_lancet(alpha = alpha),
			"Futurama" = scale_fill_futurama(alpha = alpha),
			"JCO" = scale_fill_jco(alpha = alpha),
			"NEJM" = scale_fill_nejm(alpha = alpha),
			"IGV" = scale_fill_igv(alpha = alpha),
			"UCSC" = scale_fill_ucscgb(alpha = alpha),
			"D3" = scale_fill_d3(alpha = alpha),
			"Material" = scale_fill_material(alpha = alpha)
		)
	}, error = function(e) {
		warning("Failed to create scale for '", pal_name, "': ", e$message)
		return(scale_fill_discrete())
	})
}

#' @title Create publication-ready theme enhancements
#' @description Add professional styling for publication-quality plots with no grid lines
#' @param p ggplot object: the plot to enhance
#' @param font_family Character: font family. Default: "sans"
#' @return Enhanced ggplot object
#' @keywords internal

enhance_plot_publication <- function(p, font_family = "sans") {
	p +
		theme(
			text = element_text(family = font_family),
			panel.grid.major = element_blank(),
			panel.grid.minor = element_blank(),
			panel.border = element_rect(fill = NA, color = "black", size = 0.5),
			plot.background = element_rect(fill = "white", color = NA),
			panel.background = element_rect(fill = "white")
		)
}

#' @title Add subtle shadow effect to points
#' @description Add a soft shadow/glow effect to scatter plot points (simplified version)
#' @param p ggplot object: the plot
#' @param shadow_color Character: shadow color. Default: "#00000020"
#' @param shadow_size Numeric: shadow size multiplier. Default: 1.2
#' @return Enhanced ggplot object
#' @keywords internal

add_point_shadow <- function(p, shadow_color = "#00000020", shadow_size = 1.2) {
	warning("add_point_shadow() is experimental and may not work with all plot types")
	return(p)
}

#' @title Get optimized color palette for specific data types
#' @description Return color palettes optimized for different omics data types
#' @param palette_type Character: type of palette. Options: "sequential", "diverging", "categorical", "heatmap"
#' @param n Integer: number of colors needed
#' @return Character vector of hex colors
#' @keywords internal

get_optimized_palette <- function(palette_type = "categorical", n = 10) {
	palettes <- list(
		"sequential" = c("#FFFFCC", "#FFEDA0", "#FED976", "#FEB24C",
										"#FD8D3C", "#FC4E2A", "#E31A1C", "#BD0026",
										"#800026"),
		"diverging" = c("#2166AC", "#4393C3", "#92C5DE", "#D1E5F0",
									"#FFFFFF", "#FDDBC7", "#F4A582", "#D6604D",
									"#B2182B"),
		"categorical" = c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
									 "#FF7F00", "#FFFF33", "#A65628", "#F781BF",
									 "#999999", "#66C2A5", "#FC8D62", "#8DA0CB",
									 "#E78AC3", "#A6D854", "#FFD92F", "#E5C494",
									 "#B3B3B3"),
		"heatmap" = c("#67001F", "#B2182B", "#D6604D", "#F4A582",
								"#FDDBC7", "#FFFFFF", "#D1E5F0", "#92C5DE",
								"#4393C3", "#2166AC", "#053061")
	)

	if (!(palette_type %in% names(palettes))) {
		warning("Unknown palette_type: ", palette_type, ", using categorical")
		palette_type <- "categorical"
	}

	base_palette <- palettes[[palette_type]]

	if (n <= length(base_palette)) {
		return(base_palette[seq_len(n)])
	} else {
		return(colorRampPalette(base_palette)(n))
	}
}

#' @title Format p-value for display
#' @description Format p-value with appropriate significance indicators
#' @param p_value Numeric: p-value to format
#' @param digits Integer: decimal places. Default: 3
#' @return Formatted character string
#' @keywords internal

format_pvalue <- function(p_value, digits = 3) {
	if (is.na(p_value) || is.null(p_value)) {
		return("NA")
	}

	if (p_value < 0.001) {
		return("<0.001")
	} else if (p_value < 0.01) {
		return(sprintf("%.3f", p_value))
	} else if (p_value < 0.1) {
		return(sprintf("%.2f", p_value))
	} else {
		return(sprintf("%.2f", p_value))
	}
}

#' @title Add statistical annotation to plot
#' @description Add formatted statistical test results to plots
#' @param p ggplot object: target plot
#' @param label Character: text label to add
#' @param x Numeric: x position. Default: Inf
#' @param y Numeric: y position. Default: -Inf
#' @param hjust Horizontal justification. Default: 0
#' @param vjust Vertical justification. Default: 0
#' @param size Text size. Default: 5
#' @return Enhanced ggplot object
#' @keywords internal

add_stat_annotation <- function(p, label, x = Inf, y = -Inf,
									 hjust = 0, vjust = 0, size = 5) {
	p + annotate("text", x = x, y = y, label = label,
							hjust = hjust, vjust = vjust,
							size = size, color = "black",
							fontface = "bold")
}

ZScore <- function(x) {
	(x - mean(x)) / stats::sd(x)
}
