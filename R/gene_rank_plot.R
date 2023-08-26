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
#' @importFrom RColorBrewer brewer.pal
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
									  			ylab = "Log2FoldChange"
												 ){

	# -> 2. NA and Duplicated
	data <- as.data.frame(data)
	# rename data
	colnames(data) <- c("gene","log2FC","pvalue","padj")
	data <- data[!duplicated(data$gene),]
	rownames(data) <- data$gene
	# <- 2. NA and Duplicated

	# -> 3. Plot parameters
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
	palettes <- RColorBrewer::brewer.pal(8, palette)
	colors <- grDevices::colorRampPalette(palettes)(1000)
	# <- 3. Plot parameters

	# ordered by log2FoldChange and pvalue
	data <- data[order(-data$log2FC,data$pvalue),]
	# add the rank column
	data$rank <- 1:nrow(data)

	# get the top n up and down gene for labeling
	if (!is.null(genes_to_label)) {
		genes_to_label <- genes_to_label
	}
	else{
		top_n_up <- rownames(head(data,top_n))
		top_n_down <- rownames(tail(data,top_n))
		genes_to_label <- c(top_n_up,top_n_down)
	}

	data["log2FC_abs"] <- abs(data["log2FC"])

	p <- ggplot(data,
							aes_string(x = "rank", y = "log2FC",
		color = "pvalue", size = "log2FC_abs")) +
		geom_point() +
		scale_color_gradientn(colours = colors) +
		geom_hline(yintercept = c(-log2fc, log2fc), linetype = 2, size = 0.3) +
		geom_hline(yintercept = 0, linetype = 1, size = 0.5) +
		geom_vline(xintercept = median(data$rank), linetype = 2, size = 0.3) +
		ggrepel::geom_text_repel(data = data[genes_to_label,],
														 aes_string(x = "rank", y = "log2FC", label = "gene"),
					size = label_size, color = "red",
					max.overlaps = 20) +
		xlab(xlab) + ylab(ylab) +
		labs(title = title, color = "Pvalue", size = "Log2FoldChange") +
		ylim(c(-max(abs(data$log2FC)), max(abs(data$log2FC)))) +
		theme_bw(base_size = base_size) +
		theme(plot.title = element_text(hjust = 0.5),
					panel.grid = element_blank())

	return(p)
}
