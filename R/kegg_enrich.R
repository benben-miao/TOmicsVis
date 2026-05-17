#' @title KEGG enrichment analysis based on KEGG annotation results (None/Exist Reference Genome).
#' @description KEGG enrichment analysis based on KEGG annotation results (None/Exist Reference Genome).
#' @author benben-miao
#'
#' @return Table: include columns ("ID", "Description", "GeneRatio", "BgRatio", "pvalue", "p.adjust", "qvalue", "geneID", "Count").
#' @param kegg_anno Dataframe: GO and KEGG annotation of background genes (1st-col: Genes, 2nd-col: biological_process, 3rd-col: cellular_component, 4th-col: molecular_function, 5th-col: kegg_pathway).
#' @param degs_list Dataframe: degs list.
#' @param padjust_method Character: P-value adjust to Q-value. Default: "fdr" (false discovery rate), options: "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none".
#' @param pvalue_cutoff Numeric: P-value cutoff. Recommend: small than 0.05.
#' @param qvalue_cutoff Numeric: Q-value cutoff. Recommend: small than 0.05.
#'
#' @import ggplot2
#' @import ggsci
#' @importFrom tidyr separate_rows separate drop_na
#' @importFrom clusterProfiler enricher
#' @importFrom dplyr distinct
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset
#' data(gene_go_kegg)
#' head(gene_go_kegg)
#'
#' # 3. Default parameters
#' res <- kegg_enrich(gene_go_kegg[,c(1,5)], gene_go_kegg[100:200,1])
#' head(res)
#'
#' # 4. Set padjust_method = "BH"
#' res <- kegg_enrich(gene_go_kegg[,c(1,5)], gene_go_kegg[100:200,1], padjust_method = "BH")
#' head(res)
#'
#' # 5. Set pvalue_cutoff = 0.80
#' res <- kegg_enrich(gene_go_kegg[,c(1,5)], gene_go_kegg[100:200,1], pvalue_cutoff = 0.80)
#' head(res)
#'
kegg_enrich <- function(kegg_anno,
												degs_list,
												padjust_method = "fdr",
												pvalue_cutoff = 0.05,
												qvalue_cutoff = 0.05) {

	if (!requireNamespace("clusterProfiler", quietly = TRUE)) {
		stop("Package 'clusterProfiler' is required for kegg_enrich().\n",
				 "Please install: BiocManager::install('clusterProfiler')",
				 call. = FALSE)
	}

	gene_kegg <- kegg_anno
	degs_list <- degs_list

	gene_kegg7 <- tidyr::separate_rows(data = gene_kegg, "kegg_pathway", sep = ";")

	gene_kegg8 <- tidyr::separate(gene_kegg7,
												 "kegg_pathway",
												 c("kegg_pathway", "description"),
												 "\\(")

	gene_kegg9 <- tidyr::drop_na(gene_kegg8)
	gene_kegg9["description"] <- gsub(")", "", gene_kegg9$description)

	enrich_kegg <- clusterProfiler::enricher(
		gene = degs_list,
		TERM2GENE = data.frame(gene_kegg9[, 2], gene_kegg9[, 1]),
		TERM2NAME = gene_kegg9[, 2:3],
		pvalueCutoff = pvalue_cutoff,
		pAdjustMethod = padjust_method,
		# "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none"
		qvalueCutoff = qvalue_cutoff,
		minGSSize = 1,
		maxGSSize = 1000
	)

	enrich_result <- enrich_kegg@result

	return(enrich_result)
}
