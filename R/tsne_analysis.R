#' @title TSNE analysis for analyzing and visualizing TSNE algorithm.
#' @description TSNE analysis for analyzing and visualizing TSNE algorithm.
#' @author benben-miao
#'
#' @return Table: TSNE analysis for analyzing and visualizing TSNE algorithm.
#' @param sample_gene Dataframe: All genes in all samples expression dataframe of RNA-Seq (1st-col: Genes, 2nd-col~: Samples).
#' @param group_sample Dataframe: Samples and groups for gene expression (1st-col: Samples, 2nd-col: Groups).
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
											tsne_dims = 2) {

	validate_is_dataframe_or_matrix(sample_gene, "sample_gene")
	validate_is_dataframe_or_matrix(group_sample, "group_sample")
	validate_numeric_range(tsne_dims, "tsne_dims", min = 2, max = 3)

	sample_gene <- as.data.frame(sample_gene)
	rownames(sample_gene) <- sample_gene[,1]
	sample_gene <- sample_gene[,-1]
	sample_gene <- sample_gene[rowSums(sample_gene > 0) > 0, ]
	t_sample_gene <- t(sample_gene)
	groups <- group_sample[,2]

	m_sample_gene <- as.matrix(t_sample_gene)
	tsne_res <- Rtsne::Rtsne(m_sample_gene,
										dims = tsne_dims,
										perplexity = 3,
										check_duplicates = FALSE,
										verbose = getOption("verbose", FALSE))
	tsne_out <- as.data.frame(tsne_res$Y)
	colnames(tsne_out) <- paste("TSNE", seq_len(tsne_dims), sep = "")

	return(tsne_out)
}
