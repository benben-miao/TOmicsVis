#' @title Gene ranking dotplot for visualizing differentailly expressed genes.
#' @description Gene ranking dotplot for visualizing differentailly expressed genes.
#' @author wei dong
#'
#' @return Plot: Gene ranking dotplot for visualizing differentailly expressed genes.
#' @param data Dataframe: All DEGs of paired comparison CT-vs-LT12 stats dataframe (1st-col: Genes, 2nd-col: log2FoldChange, 3rd-col: Pvalue, 4th-col: FDR).
#' @param log2fc Numeric: log2(FoldChange) cutoff log2(2) = 1. Default: 1.0, min: 0.0, max: null.
#' @param palette Character: color palette used for the point. Default: "spectral", options: 'Spectral', 'BrBG', 'PiYG', 'PRGn', 'PuOr', 'RdBu', 'RdGy', 'RdYlBu', 'RdYlGn'.
#' @param top_n Numeric: number of top differentailly expressed genes. Default: 10, min: 0.
#' @param genes_to_label Character: a vector of selected genes. Default: "NULL".
#' @param label_size Numeric: gene label size. Default: 5, min: 0.
#' @param base_size Numeric: base font size. Default: 12, min: 0.
#' @param title Character: main plot title. Default: "Gene ranking dotplot".
#' @param xlab Character: title of the xlab. Default: "Ranking of differentially expressed genes".
#' @param ylab Character: title of the ylab. Default: "Log2FoldChange".
#'
#' @import ggplot2
#' @importFrom stats median
#' @importFrom utils head tail
#' @importFrom grDevices colorRampPalette
#' @importFrom ggrepel geom_text_repel
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset
#' data(degs_stats)
#' head(degs_stats)
#'
#' # 3. Default parameters
#' gene_rank_plot(degs_stats)
#'
#' # 4. Set top_n = 5
#' gene_rank_plot(degs_stats, top_n = 5, palette = "PiYG")
#'
#' # 5. Set genes_to_label = c("SELL","CCR7","KLRG1","IL7R")
#' gene_rank_plot(degs_stats, genes_to_label = c("SELL","CCR7","KLRG1","IL7R"), palette = "PuOr")
#'

gene_rank_plot <- function(data,
													 log2fc = 1,
													 palette = "Spectral",
													 top_n = 10,
													 genes_to_label = NULL,
													 label_size = 5,
													 base_size = 12,
													 title = "Gene ranking dotplot",
													 xlab = "Ranking of differentially expressed genes",
													 ylab = "Log2FoldChange") {

	if (!is.data.frame(data) && !is.matrix(data)) {
		stop("data must be a data.frame or matrix", call. = FALSE)
	}

	if (ncol(data) < 4) {
		stop("data must have at least 4 columns: gene, log2FC, pvalue, padj", call. = FALSE)
	}

	if (!is.numeric(top_n) || top_n < 1) {
		stop("top_n must be a positive integer", call. = FALSE)
	}

	data <- as.data.frame(data)
	# rename data
	colnames(data) <- c("gene", "log2FC", "pvalue", "padj")
	data <- data[!duplicated(data$gene), ]
	rownames(data) <- data$gene

	# set the number of top_n
	#top_n <- 10
	# set the threshold of log2FoldChange
	#log2fc <- 1
	# set the size of gene label
	#label_size <- 5

	# set the x label
	#xlab <- "Ranking of differentially expressed genes"
	# set the y label
	#ylab <- "Log2FoldChange"
	# set the plot title
	#title <- "Gene ranking dotplot"

	# set the color palettes
	# The diverging palettes are: BrBG PiYG PRGn PuOr RdBu RdGy RdYlBu RdYlGn Spectral
	palette_map <- list(
		"Spectral" = c("#9E0142", "#D53E4F", "#F46D43", "#FDAE61", "#FEE08B", "#FFFFBF", "#E6F598", "#ABDDA4", "#66C2A5", "#3288BD", "#5E4FA2"),
		"BrBG" = c("#543005", "#8C510A", "#BF812D", "#DFC27D", "#F6E8C3", "#F5F5F5", "#C7EAE5", "#80CDC1", "#35978F", "#01665E", "#003C30"),
		"PiYG" = c("#8E0152", "#C51B7D", "#DE77AE", "#F1B6DA", "#FDE0EF", "#F7F7F7", "#E6F5D0", "#B8E186", "#7FBC41", "#4D9221", "#276419"),
		"PRGn" = c("#40004B", "#762A83", "#9970AB", "#C2A5CF", "#E7D4E8", "#F7F7F7", "#D9F0D3", "#A6DBA0", "#5AAE61", "#1B7837", "#00441B"),
		"PuOr" = c("#7F3B08", "#B35806", "#E08214", "#FDB863", "#FEE0B6", "#F7F7F7", "#D8DAEB", "#B2ABD2", "#8073AC", "#542788", "#2D004B"),
		"RdBu" = c("#67001F", "#B2182B", "#D6604D", "#F4A582", "#FDDBC7", "#F7F7F7", "#D1E5F0", "#92C5DE", "#4393C3", "#2166AC", "#053061"),
		"RdGy" = c("#67001F", "#B2182B", "#D6604D", "#F4A582", "#FDDBC7", "#FFFFFF", "#E0E0E0", "#BABABA", "#878787", "#4D4D4D", "#1A1A1A"),
		"RdYlBu" = c("#A50026", "#D73027", "#F46D43", "#FDAE61", "#FEE090", "#FFFFBF", "#E0F3F8", "#ABD9E9", "#74ADD1", "#4575B4", "#313695"),
		"RdYlGn" = c("#A50026", "#D73027", "#F46D43", "#FDAE61", "#FEE08B", "#FFFFBF", "#D9EF8B", "#A6D96A", "#66BD63", "#1A9850", "#006837")
	)
	
	if (palette %in% names(palette_map)) {
		palettes <- palette_map[[palette]]
	} else {
		palettes <- palette_map[["Spectral"]]
	}
	colors <- grDevices::colorRampPalette(palettes)(1000)

	# ordered by log2FoldChange and pvalue
	data <- data[order(-data$log2FC, data$pvalue), ]
	# add the rank column
	data$rank <- 1:nrow(data)

	# get the top n up and down gene for labeling
	if (!is.null(genes_to_label)) {
		genes_to_label <- genes_to_label
	}
	else{
		top_n_up <- rownames(head(data, top_n))
		top_n_down <- rownames(tail(data, top_n))
		genes_to_label <- c(top_n_up, top_n_down)
	}

	data["log2FC_abs"] <- abs(data["log2FC"])

	p <- ggplot(data,
							aes(x = rank,
								y = log2FC,
								color = pvalue,
								size = log2FC_abs
							)) +
		geom_point() +
		scale_color_gradientn(colours = colors) +
		geom_hline(
			yintercept = c(-log2fc, log2fc),
			linetype = 2,
			size = 0.3
		) +
		geom_hline(yintercept = 0,
							 linetype = 1,
							 size = 0.5) +
		geom_vline(
			xintercept = median(data$rank),
			linetype = 2,
			size = 0.3
		) +
		ggrepel::geom_text_repel(
			data = data[genes_to_label, ],
			aes(x = rank, y = log2FC, label = gene),
			size = label_size,
			color = "red",
			max.overlaps = 20
		) +
		xlab(xlab) + ylab(ylab) +
		labs(title = title,
				 color = "Pvalue",
				 size = "Log2FoldChange") +
		ylim(c(-max(abs(data$log2FC)), max(abs(data$log2FC)))) +
		theme_bw(base_size = base_size) +
		theme(plot.title = element_text(hjust = 0.5), panel.grid = element_blank())

	return(p)
}
