#' @title Network plot for analyzing and visualizing relationship of genes.
#' @description Network plot for analyzing and visualizing relationship of genes.
#' @author benben-miao
#'
#' @return Plot: network plot for analyzing and visualizing relationship of genes.
#' @param data Dataframe: include columns (source_node, target_node).
#' @param calcBy Character: calculate relationship by "degree", "node". Default: "degree".
#' @param degreeValue Numeric: degree value when calcBy = "degree". Default: 0.05, min: 0.00, max: 1.00.
#' @param nodeColorNormal Character: normal relationship nodes color (color name of hex value).
#' @param nodeBorderColor Character: node border color (color name or hex value).
#' @param nodeColorFrom Character: the start color of nodes that meet degreeValue.
#' @param nodeColorTo Character: the end color of nodes that meet degreeValue.
#' @param nodeShapeNormal Character: normal node shape. Default: "circle", options: "circle", "crectangle", "csquare", "none", "pie", "raster", "rectangle", "sphere", "square", "vrectangle".
#' @param nodeShapeSpatial Character: meet degreeValue node shape. Default: "csquare", options: "circle", "crectangle", "csquare", "none", "pie", "raster", "rectangle", "sphere", "square", "vrectangle".
#' @param nodeSize Numeric: node size. Default: 10, min: 0, max: NULL.
#' @param labelSize Numeric: node label size. Default: 0.5, min: 0, max: NULL.
#' @param edgeCurved Logical: curved edges. Default: TRUE, options: TRUE, FALSE.
#' @param netLayout Character: network layout. Default: "layout_on_sphere", options: "layout_as_bipartite", "layout_as_star", "layout_as_tree", "layout_components", "layout_in_circle", "layout_nicely", "layout_on_grid", "layout_on_sphere","layout_randomly","layout_with_dh","layout_with_drl","layout_with_fr","layout_with_gem","layout_with_graphopt","layout_with_kk","layout_with_lgl","layout_with_mds","layout_with_sugiyama".
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
#' # 4. Set calcBy = "node"
#' network_plot(network_data, calcBy = "node")
#'
#' # 5. Set degreeValue = 0.1
#' network_plot(network_data, degreeValue = 0.1)
#'
#' # 6. Set nodeColorNormal = "#00888833"
#' network_plot(network_data, nodeColorNormal = "#00888833")
#'
#' # 7. Set labelSize = 0
#' network_plot(network_data, labelSize = 0)
#'
network_plot <- function(data,
												 calcBy = "degree",
												 degreeValue = 0.05,
												 nodeColorNormal = "#00888888",
												 nodeBorderColor = "#FFFFFF",
												 nodeColorFrom = "#FF000088",
												 nodeColorTo = "#00880088",
												 nodeShapeNormal = "circle",
												 nodeShapeSpatial = "csquare",
												 nodeSize = 10,
												 labelSize = 0.5,
												 edgeCurved = TRUE,
												 netLayout = "layout_on_sphere"
												){
	# -> 2. Data
	data <- as.data.frame(data)
	# 3.node
	# <- 2. Data

	# -> 3. Plot parameters
	# fonts <- "Times"
	# ChoiceBox: "Times", "Palatino", "Bookman", "Courier", "Helvetica", "URWGothic", "NimbusMon", "NimbusSan"

	# calcBy <- "degree"
	# ChoiceBox: "degree", "node"

	# degreeValue <- 0.05
	# Slider: 0.07, 0.00, 0.01, 1.00

	# nodeColorNormal <- "#21abcdcc"
	# ColerPicker

	# nodeColorFrom <- "#FF000088"
	# ColorPicker

	# nodeColorTo <- "#00800088"
	# ColorPicker

	# nodeBorderColor <- "#FFFFFF"
	# ColorPicker

	# nodeShapeNormal <- "circle"
	# ChoiceBox: "circle", "crectangle", "csquare", "none", "pie", "raster", "rectangle", "sphere", "square", "vrectangle"

	# nodeShapeSpatial <- "circle"
	# ChoiceBox: "circle", "crectangle", "csquare", "none", "pie", "raster", "rectangle", "sphere", "square", "vrectangle"

	# nodeSize <- 10
	# Slider: 10, 0, 1, 100

	# labelSize <- 0.5
	# Slider: 0.5, 0.0, 0.1, 10.0

	labelColor <- "#333333"
	# ColorPicker

	edgeColor <- "#888888"
	# ColorPicker

	edgeWidth <- 2.0
	# Slider: 2.0, 0.0, 0.1, 10.0

	linkDir <- "HiddenArrow"
	if (linkDir == "HiddenArrow") {
		directed <- FALSE
	} else if (linkDir == "ShowArrow") {
		directed <- TRUE
	}
	# ChoiceBox: "HiddenArrow", "ShowArrow"

	# edgeCurved <- "EdgeStraight"
	# if (edgeCurved == "EdgeStraight") {
	# 	edgeCurved <- FALSE
	# } else if (edgeCurved == "EdgeCurved") {
	# 	edgeCurved <- TRUE
	# }
	# ChoiceBox: "EdgeStraight", "EdgeCurved"

	edgeArrowType <- 1
	# Slider: 1, 0, 1, 3

	edgeArrowSize <- 0.0
	# Slider: 0.0, 0.0, 0.1, 5.0
	# ChoiceBox: "EdgeStraight", "EdgeCurved"

	# netLayout <- "layout_on_sphere"
	# ChoiceBox: "layout_as_bipartite", "layout_as_star", "layout_as_tree", "layout_components", "layout_in_circle", "layout_nicely", "layout_on_grid", "layout_on_sphere","layout_randomly","layout_with_dh","layout_with_drl","layout_with_fr","layout_with_gem","layout_with_graphopt","layout_with_kk","layout_with_lgl","layout_with_mds","layout_with_sugiyama"
	# <- 3. Plot parameters

	# -> 4. Plot
	net <- igraph::graph_from_data_frame(
		data,
		directed = directed,
		vertices = NULL
	)

	if (calcBy == "degree") {
		deg <- igraph::degree(
			net,
			v = igraph::V(net),
			mode = c("all"),
			loops = TRUE,
			normalized = T
		)

		vcolor <- rep(nodeColorNormal,
									vcount(net))
		vcolor[deg > degreeValue] <- colorRampPalette(c(nodeColorFrom,
																										nodeColorTo))(10)
		vertex_shape <- rep(nodeShapeNormal,
												vcount(net))
		vertex_shape[deg > degreeValue] <- nodeShapeSpatial
	}else if (calcBy == "node") {
		vcolor <- rep(nodeColorNormal,
									vcount(net))
		vcolor[V(net)$name %in% data$node1] <- colorRampPalette(c(nodeColorFrom,
																															nodeColorTo))(10)
		vertex_shape <- rep(nodeShapeNormal,
												vcount(net))
		vertex_shape[V(net)$name %in% data$node1] <- nodeShapeSpatial
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
			vertex.size = nodeSize,
			vertex.shape = vertex_shape, # "circle","crectangle","csquare","none","pie","raster","rectangle","sphere","square","vrectangle"
			# vertex.size2 = 30,
			vertex.frame.color = nodeBorderColor,
			# vertex.label = NA,
			vertex.label.color = labelColor,
			vertex.label.family = "Times",
			vertex.label.cex = labelSize,
			vertex.label.font = 1, # 1 is plain text, 2 is bold face, 3 is italic, 4 is bold and italic and 5 specifies the symbol font.
			vertex.label.dist = 0,
			vertex.label.degree = -pi/4,
			edge.color = edgeColor,
			# edge.label.cex = input$label_cex,
			# edge.label.color = input$label_color,
			# edge.label.family = input$label_family,
			# edge.label.font = input$label_font,
			layout = do.call(netLayout, list(net)), # String to Matrix
			edge.arrow.mode = edgeArrowType,
			edge.arrow.size = edgeArrowSize,
			# edge.arrow.width = input$arrow_width,
			edge.width = edgeWidth,
			edge.lty = 1,
			edge.curved = edgeCurved,
			margin = c(0, 0, 0, 0)
		)
	)
	invisible()
}
