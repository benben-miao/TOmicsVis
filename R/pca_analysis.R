#' @title PCA dimensional reduction analysis for RNA-Seq.
#' @description PCA dimensional reduction analysis for RNA-Seq.
#' @author benben-miao
#'
#' @return Table: PCA dimensional reduction analysis for RNA-Seq.
#' @param sample_gene Dataframe: All genes in all samples expression dataframe of RNA-Seq (1st-col: Genes, 2nd-col~: Samples).
#' @param group_sample Dataframe: Samples and groups for gene expression (1st-col: Samples, 2nd-col: Groups).
#'
#' @importFrom stats prcomp
#' @export
#'
#' @examples
#' # 1. Library package TOmicsVis
#' library(TOmicsVis)
#'
#' # 2. Load example datasets
#' data(gene_expression)
#' head(gene_expression)
#'
#' data(samples_groups)
#' head(samples_groups)
#'
#' # 3. Default parameters
#' res <- pca_analysis(gene_expression, samples_groups)
#' head(res)
#'
pca_analysis <- function(sample_gene,
												 group_sample
												){
	# -> 2. Data
	sample_gene <- as.data.frame(sample_gene)
	rownames(sample_gene) <- sample_gene[,1]
	sample_gene <- sample_gene[,-1]
	sample_gene <- sample_gene[rowSums(sample_gene > 0) > 0, ]
	t_sample_gene <- t(sample_gene)
	groups <- group_sample[,2]

	pca_res <- stats::prcomp(t_sample_gene)
	pca_out <- as.data.frame(pca_res$x)
	# <- 2. Data

	return(pca_out)
}
