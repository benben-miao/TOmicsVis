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
												 group_sample) {

	validate_is_dataframe_or_matrix(sample_gene, "sample_gene")
	validate_is_dataframe_or_matrix(group_sample, "group_sample")

	sample_gene <- as.data.frame(sample_gene)
	if (ncol(sample_gene) < 2) {
		stop("sample_gene must have at least 2 columns (Genes + Samples)", call. = FALSE)
	}

	if (ncol(group_sample) < 2) {
		stop("group_sample must have at least 2 columns (Samples + Groups)", call. = FALSE)
	}

	rownames(sample_gene) <- sample_gene[,1]
	sample_gene <- sample_gene[,-1]
	sample_gene <- sample_gene[rowSums(sample_gene > 0) > 0, ]
	t_sample_gene <- t(sample_gene)

	pca_res <- stats::prcomp(t_sample_gene)
	pca_out <- as.data.frame(pca_res$x)

	return(pca_out)
}
