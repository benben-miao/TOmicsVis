#' @title Network plot for analyzing and visualizing relationship of genes.
#' @description Network plot for analyzing and visualizing relationship of genes.
#' @author benben-miao
#'
#' @return Plot: network plot for analyzing and visualizing relationship of genes.
#' @param data Dataframe: Network data from WGCNA tan module top-200 dataframe (1st-col: Source, 2nd-col: Target).
#' @param calc_by Character: calculate relationship by "degree", "node". Default: "degree".
#' @param degree_value Numeric: degree value when calc_by = "degree". Default: 0.05, min: 0.00, max: 1.00.
#' @param normal_color Character: normal relationship nodes color (color name of hex value).
#' @param border_color Character: node border color (color name or hex value).
#' @param from_color Character: the start color of nodes that meet degree_value.
#' @param to_color Character: the end color of nodes that meet degree_value.
#' @param normal_shape Character: normal node shape. Default: "circle", options: "circle", "crectangle", "csquare", "none", "pie", "raster", "rectangle", "sphere", "square", "vrectangle".
#' @param spatial_shape Character: meet degree_value node shape. Default: "csquare", options: "circle", "crectangle", "csquare", "none", "pie", "raster", "rectangle", "sphere", "square", "vrectangle".
#' @param node_size Numeric: node size. Default: 10, min: 0, max: NULL.
#' @param lable_color Character: gene labels color. Default: "#FFFFFF".
#' @param label_size Numeric: node label size. Default: 0.5, min: 0, max: NULL.
#' @param edge_color Character: edges color. Default: "#888888".
#' @param edge_width Numeric: edges width. Default: 1.5.
#' @param edge_curved Logical: curved edges. Default: TRUE, options: TRUE, FALSE.
#' @param net_layout Character: network layout. Default: "layout_on_sphere", options: "layout_as_bipartite", "layout_as_star", "layout_as_tree", "layout_components", "layout_in_circle", "layout_nicely", "layout_on_grid", "layout_on_sphere","layout_randomly","layout_with_dh","layout_with_drl","layout_with_fr","layout_with_gem","layout_with_graphopt","layout_with_kk","layout_with_lgl","layout_with_mds","layout_with_sugiyama".
#'
#' @importFrom grDevices colorRamp
#' @import igraph
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset
#' data(network_data)
#' head(network_data)
#'
#' # 3. Default parameters
#' network_plot(network_data)
#'
#' # 4. Set calc_by = "node"
#' network_plot(network_data, calc_by = "node")
#'
#' # 5. Set degree_value = 0.1
#' network_plot(network_data, degree_value = 0.1)
#'
#' # 6. Set normal_color = "#ff8800cc"
#' network_plot(network_data, normal_color = "#ff8800cc")
#'
#' # 7. Set net_layout = "layout_as_tree"
#' network_plot(network_data, net_layout = "layout_as_tree")
#'
network_plot <- function(data,
												 calc_by = "degree",
												 degree_value = 0.5,
												 normal_color = "#008888cc",
												 border_color = "#FFFFFF",
												 from_color = "#FF0000cc",
												 to_color = "#008800cc",
												 normal_shape = "circle",
												 spatial_shape = "circle",
												 node_size = 25,
												 lable_color = "#FFFFFF",
												 label_size = 0.5,
												 edge_color = "#888888",
												 edge_width = 1.5,
												 edge_curved = TRUE,
												 net_layout = "layout_on_sphere"
												){
	# -> 2. Data
	data <- as.data.frame(data)
	# 3.node
	# <- 2. Data

	# -> 3. Plot parameters
	# fonts <- "Times"
	# ChoiceBox: "Times", "Palatino", "Bookman", "Courier", "Helvetica", "URWGothic", "NimbusMon", "NimbusSan"

	# calc_by <- "degree"
	# ChoiceBox: "degree", "node"

	# degree_value <- 0.05
	# Slider: 0.07, 0.00, 0.01, 1.00

	# normal_color <- "#21abcdcc"
	# ColerPicker

	# from_color <- "#FF000088"
	# ColorPicker

	# to_color <- "#00800088"
	# ColorPicker

	# border_color <- "#FFFFFF"
	# ColorPicker

	# normal_shape <- "circle"
	# ChoiceBox: "circle", "crectangle", "csquare", "none", "pie", "raster", "rectangle", "sphere", "square", "vrectangle"

	# spatial_shape <- "circle"
	# ChoiceBox: "circle", "crectangle", "csquare", "none", "pie", "raster", "rectangle", "sphere", "square", "vrectangle"

	# node_size <- 10
	# Slider: 10, 0, 1, 100

	# label_size <- 0.5
	# Slider: 0.5, 0.0, 0.1, 10.0

	labelColor <- lable_color
	# ColorPicker

	edgeColor <- edge_color
	# ColorPicker

	edgeWidth <- edge_width
	# Slider: 2.0, 0.0, 0.1, 10.0

	linkDir <- "HiddenArrow"
	if (linkDir == "HiddenArrow") {
		directed <- FALSE
	} else if (linkDir == "ShowArrow") {
		directed <- TRUE
	}
	# ChoiceBox: "HiddenArrow", "ShowArrow"

	# edge_curved <- "EdgeStraight"
	# if (edge_curved == "EdgeStraight") {
	# 	edge_curved <- FALSE
	# } else if (edge_curved == "edge_curved") {
	# 	edge_curved <- TRUE
	# }
	# ChoiceBox: "EdgeStraight", "edge_curved"

	edgeArrowType <- 1
	# Slider: 1, 0, 1, 3

	edgeArrowSize <- 0.0
	# Slider: 0.0, 0.0, 0.1, 5.0
	# ChoiceBox: "EdgeStraight", "edge_curved"

	# net_layout <- "layout_on_sphere"
	# ChoiceBox: "layout_as_bipartite", "layout_as_star", "layout_as_tree", "layout_components", "layout_in_circle", "layout_nicely", "layout_on_grid", "layout_on_sphere","layout_randomly","layout_with_dh","layout_with_drl","layout_with_fr","layout_with_gem","layout_with_graphopt","layout_with_kk","layout_with_lgl","layout_with_mds","layout_with_sugiyama"
	# <- 3. Plot parameters

	# -> 4. Plot
	net <- igraph::graph_from_data_frame(
		data,
		directed = directed,
		vertices = NULL
	)

	if (calc_by == "degree") {
		deg <- igraph::degree(
			net,
			v = igraph::V(net),
			mode = c("all"),
			loops = TRUE,
			normalized = T
		)

		vcolor <- rep(normal_color,
									igraph::vcount(net))
		vcolor[deg > degree_value] <- colorRampPalette(c(from_color,
																										to_color))(10)
		vertex_shape <- rep(normal_shape,
												igraph::vcount(net))
		vertex_shape[deg > degree_value] <- spatial_shape
	}else if (calc_by == "node") {
		vcolor <- rep(normal_color,
									igraph::vcount(net))
		vcolor[V(net)$name %in% data$node1] <- colorRampPalette(c(from_color,
																															to_color))(10)
		vertex_shape <- rep(normal_shape,
												igraph::vcount(net))
		vertex_shape[V(net)$name %in% data$node1] <- spatial_shape
	}


	# <- 4. Plot

	return(
		igraph::plot.igraph(
			net,
			# main="Networks",
			xlab = "",
			ylab = "",
			axes = F,
			add = F,
			vertex.color = vcolor,
			vertex.size = node_size,
			vertex.shape = vertex_shape, # "circle","crectangle","csquare","none","pie","raster","rectangle","sphere","square","vrectangle"
			# vertex.size2 = 30,
			vertex.frame.color = border_color,
			# vertex.label = NA,
			vertex.label.color = labelColor,
			# vertex.label.family = "Times",
			vertex.label.cex = label_size,
			vertex.label.font = 2, # 1 is plain text, 2 is bold face, 3 is italic, 4 is bold and italic and 5 specifies the symbol font.
			vertex.label.dist = 0,
			vertex.label.degree = -pi/4,
			edge.color = edgeColor,
			# edge.label.cex = input$label_cex,
			# edge.label.color = input$label_color,
			# edge.label.family = input$label_family,
			# edge.label.font = input$label_font,
			layout = do.call(net_layout, list(net)), # String to Matrix
			edge.arrow.mode = edgeArrowType,
			edge.arrow.size = edgeArrowSize,
			# edge.arrow.width = input$arrow_width,
			edge.width = edgeWidth,
			edge.lty = 1,
			edge.curved = edge_curved,
			margin = c(0, 0, 0, 0)
		)
	)
	invisible()
}
