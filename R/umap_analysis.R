#' @title UMAP analysis for analyzing RNA-Seq data.
#' @description UMAP analysis for analyzing RNA-Seq data.
#' @author benben-miao
#'
#' @return Table: UMAP analysis for analyzing RNA-Seq data.
#' @param sample_gene Dataframe: gene expression dataframe (1st-col: Transcripts or Genes, 2nd-col~: Samples).
#' @param group_sample Dataframe: Samples and groups for gene expression (1st-col: Samples, 2nd-col: Groups).
#' @param seed Numeric: set seed for robust result. Default: 1.
#' @param method Character: 'naive' (an implementation written in pure R) and 'umap-learn' (requires python package 'umap-learn').
#'
#' @importFrom umap umap
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
#' res <- umap_analysis(gene_expression, samples_groups)
#' head(res)
#'
umap_analysis <- function(sample_gene,
											group_sample,
											seed = 1,
											method = "naive"
											){
	# -> 2. Data
	sample_gene <- as.data.frame(sample_gene)
	rownames(sample_gene) <- sample_gene[,1]
	sample_gene <- sample_gene[,-1]
	sample_gene <- sample_gene[rowSums(sample_gene > 0) > 0, ]
	t_sample_gene <- t(sample_gene)
	groups <- group_sample[,2]

	set.seed(seed)
	umap_res <- umap(t_sample_gene, method = method)
	umap_out <- as.data.frame(umap_res$layout)

	colnames(umap_out) <- c("UMAP1","UMAP2")
	# <- 2. Data

	return(umap_out)
}
