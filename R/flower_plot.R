#' @title Flower plot for stat common and unique gene among multiple sets.
#' @description Flower plot for stat common and unique gene among multiple sets.
#' @author wei dong
#'
#' @return Plot: Flower plot for stat common and unique gene among multiple sets.
#' @param flower_dat Dataframe: Paired comparisons differentially expressed genes (degs) among groups (1st-col~: degs of paired comparisons).
#' @param angle Number: set the angle of rotation in degress. Default: 90.
#' @param a Number: set the radii of the ellipses along the x-axes. Default: 0.5.
#' @param b Number: set the radii of the ellipses along the y-axes. Default: 2.
#' @param r Number: set the radius of the circle. Default: 1.
#' @param ellipse_col_pal Character: set the color palette for filling the ellipse. Default: "Spectral", options: 'Spectral', 'Set1', 'Set2', 'Set3', 'Accent', 'Dark2', 'Paired', 'Pastel1', 'Pastel2'.
#' @param circle_col Character: set the color for filling the circle. Default: "white".
#' @param label_text_cex Number: set the label text cex. Default: 1.
#'

#' @export
#' @note Requires package 'plotrix' (install via: install.packages("plotrix"))
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
#' flower_plot(degs_lists)
#'
#' # 4. Set angle = 60
#' flower_plot(degs_lists, angle = 60)
#'
#' # 5. Set ellipse_col_pal = "Accent"
#' flower_plot(degs_lists, ellipse_col_pal = "Accent")
#'
#' # 6. Set a = 1, b = 2, r = 1
#' flower_plot(degs_lists, a = 1, b = 2, r = 1, ellipse_col_pal = "Set2")
#'
flower_plot <- function(flower_dat,
												angle = 90,
												a = 1,
												b = 2,
												r = 1,
												ellipse_col_pal = "Spectral",
												circle_col = "white",
												label_text_cex = 1) {

	if (!requireNamespace("plotrix", quietly = TRUE)) {
		stop("Package 'plotrix' is required for flower_plot().\n",
             "Please install: install.packages('plotrix')",
             call. = FALSE)
	}

	set_name <- colnames(flower_dat)
	item_id <- unique(flower_dat[, 1])
	item_id <- item_id[item_id != '']
	core_item_id <- item_id
	item_num <- length(item_id)

	for (i in 2:ncol(flower_dat)) {
		item_id <- unique(flower_dat[, i])
		item_id <- item_id[item_id != '']
		core_item_id <- intersect(core_item_id, item_id)
		item_num <- c(item_num, length(item_id))
	}
	core_num <- length(core_item_id)

	graphics::par(
		bty = 'n',
		ann = F,
		xaxt = 'n',
		yaxt = 'n',
		mar = c(1, 1, 1, 1)
	)
	graphics::plot(c(0, 10), c(0, 10), type = 'n')
	n   <- length(set_name)
	# set the angle of degress
	deg <- 360 / n
	# set the ellipse filling color
	palette_map <- list(
		"Spectral" = c("#9E0142", "#D53E4F", "#F46D43", "#FDAE61", "#FEE08B", "#FFFFBF", "#E6F598", "#ABDDA4", "#66C2A5", "#3288BD", "#5E4FA2"),
		"Set1" = c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"),
		"Set2" = c("#66C2A5", "#FC8D62", "#8DA0CB", "#E78AC3", "#A6D854", "#FFD92F", "#E5C494", "#B3B3B3"),
		"Set3" = c("#8DD3C7", "#FFFFB3", "#BEBADA", "#FB8072", "#80B1D3", "#FDB462", "#B3DE69", "#FCCDE5", "#D9D9D9", "#BC80BD", "#CCEBC5", "#FFED6F"),
		"Accent" = c("#7FC97F", "#BEAED4", "#FDC086", "#FFFF99", "#386CB0", "#F0027F", "#BF5B17", "#666666"),
		"Dark2" = c("#1B9E77", "#D95F02", "#7570B3", "#E7298A", "#66A61E", "#E6AB02", "#A6761D", "#666666"),
		"Paired" = c("#A6CEE3", "#1F78B4", "#B2DF8A", "#33A02C", "#FB9A99", "#E31A1C", "#FDBF6F", "#FF7F00", "#CAB2D6", "#6A3D9A", "#FFFF99", "#B15928"),
		"Pastel1" = c("#FBB4AE", "#B3CDE3", "#CCEBC5", "#DECBE4", "#FED9A6", "#FFFFCC", "#E5D8BD", "#FDDAEC", "#F2F2F2"),
		"Pastel2" = c("#B3E2CD", "#FDCDAC", "#CBD5E8", "#F4CAE4", "#E6F5C9", "#FFF2AE", "#F1E2CC", "#CCCCCC")
	)
	
	if (ellipse_col_pal %in% names(palette_map)) {
		colors <- palette_map[[ellipse_col_pal]]
	} else {
		colors <- palette_map[["Spectral"]]
	}
	ellipse_col <- grDevices::colorRampPalette(colors)(n)

	res <- lapply(1:n, function(t) {
		plotrix::draw.ellipse(
			x = 5 + cos((angle + deg * (t - 1)) * pi / 180),
			y = 5 + sin((angle + deg * (t - 1)) * pi / 180),
			col = ellipse_col[t],
			border = ellipse_col[t],
			a = a,
			b = b,
			angle = deg * (t - 1)
		)
		graphics::text(x = 5 + 2.5 * cos((angle + deg * (t - 1)) * pi / 180),
									 y = 5 + 2.5 * sin((angle + deg * (t - 1)) * pi / 180),
									 item_num[t])

		if (deg * (t - 1) < 180 && deg * (t - 1) > 0) {
			graphics::text(
				x = 5 + 3.3 * cos((angle + deg * (t - 1)) * pi / 180),
				y = 5 + 3.3 * sin((angle + deg * (t - 1)) * pi / 180),
				set_name[t],
				srt = deg * (t - 1) - angle,
				adj = 1,
				cex = label_text_cex
			)
		} else {
			graphics::text(
				x = 5 + 3.3 * cos((angle + deg * (t - 1)) * pi / 180),
				y = 5 + 3.3 * sin((angle + deg * (t - 1)) * pi / 180),
				set_name[t],
				srt = deg * (t - 1) + angle,
				adj = 0,
				cex = label_text_cex
			)
		}
	})
	plotrix::draw.circle(
		x = 5,
		y = 5,
		r = r,
		col = circle_col,
		border = NA
	)
	graphics::text(
		x = 5,
		y = 5,
		paste('Core items:', core_num),
		cex = label_text_cex
	)
}
