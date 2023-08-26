#' @title TSNE analysis for analyzing and visualizing TSNE algorithm.
#' @description TSNE analysis for analyzing and visualizing TSNE algorithm.
#' @author benben-miao
#'
#' @return Table: TSNE analysis for analyzing and visualizing TSNE algorithm.
#' @param sample_gene Dataframe: All genes in all samples expression dataframe of RNA-Seq (1st-col: Genes, 2nd-col~: Samples).
#' @param group_sample Dataframe: Samples and groups for gene expression (1st-col: Samples, 2nd-col: Groups).
#' @param seed Numeric: set seed for robust result. Default: 1.
#' @param tsne_dims Numeric: TSNE dimensionality number. Default: 2.
#'
#' @importFrom Rtsne Rtsne
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset
#' data(gene_expression)
#' head(gene_expression)
#'
#' data(samples_groups)
#' head(samples_groups)
#'
#' # 3. Default parameters
#' res <- tsne_analysis(gene_expression, samples_groups)
#' head(res)
#'
#' # 4. Set tsne_dims = 3
#' res <- tsne_analysis(gene_expression, samples_groups, tsne_dims = 3)
#' head(res)
#'
tsne_analysis <- function(sample_gene,
											group_sample,
											seed = 1,
											tsne_dims = 2
											){

	# -> 2. NA and Duplicated
	sample_gene <- as.data.frame(sample_gene)
	rownames(sample_gene) <- sample_gene[,1]
	sample_gene <- sample_gene[,-1]
	sample_gene <- sample_gene[rowSums(sample_gene > 0) > 0, ]
	t_sample_gene <- t(sample_gene)
	groups <- group_sample[,2]

	tsne_ano <- vegan::anosim(x = t_sample_gene,
										 grouping = groups)
	tsne_p <- tsne_ano$signif
	tsne_r <- round(tsne_ano$statistic,3)

	set.seed(seed)
	m_sample_gene <- as.matrix(t_sample_gene)
	tsne_res <- Rtsne::Rtsne(m_sample_gene,
										dims = tsne_dims,
										# initial_dims = 50,
										perplexity = 3,
										# theta = 0.0,
										check_duplicates = F,
										# pca = T,
										# partial_pca = FALSE,
										# max_iter = 1000,
										verbose = getOption("verbose", FALSE)
										# is_distance = FALSE,
										# Y_init = NULL,
										# pca_center = TRUE,
										# pca_scale = FALSE,
										# normalize = TRUE,
										# stop_lying_iter = ifelse(is.null(Y_init), 250L,0L),
										# mom_switch_iter = ifelse(is.null(Y_init), 250L, 0L),
										# momentum = 0.5,
										# final_momentum = 0.8,
										# eta = 200,
										# exaggeration_factor = 12,
										# num_threads = 2
	)
	tsne_out <- as.data.frame(tsne_res$Y)
	colnames(tsne_out) <- paste("TSNE", 1:tsne_dims, sep = "")
	# <- 2. NA and Duplicated

	return(tsne_out)
}
