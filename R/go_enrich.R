#' @title GO enrichment analysis based on GO annotation results (None/Exist Reference Genome).
#' @description GO enrichment analysis based on GO annotation results (None/Exist Reference Genome).
#' @author benben-miao
#'
#' @return Table: include columns ("ID", "ontology", "Description", "GeneRatio", "BgRatio", "pvalue", "p.adjust", "qvalue", "geneID", "Count").
#' @param go_anno Dataframe: GO and KEGG annotation of background genes (1st-col: Genes, 2nd-col: biological_process, 3rd-col: cellular_component, 4th-col: molecular_function, 5th-col: kegg_pathway).
#' @param degs_list Dataframe: degs list.
#' @param padjust_method Character: P-value adjust to Q-value. Default: "fdr" (false discovery rate), options: "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none".
#' @param pvalue_cutoff Numeric: P-value cutoff. Recommend: small than 0.05.
#' @param qvalue_cutoff Numeric: Q-value cutoff. Recommend: small than 0.05.
#'
#' @import ggplot2
#' @import ggsci
#' @importFrom tidyr pivot_longer separate_rows separate drop_na
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
#' res <- go_enrich(gene_go_kegg[,-5], gene_go_kegg[100:200,1])
#' head(res)
#'
#' # 4. Set padjust_method = "BH"
#' res <- go_enrich(gene_go_kegg[,-5], gene_go_kegg[100:200,1], padjust_method = "BH")
#' head(res)
#'
#' # 5. Set pvalue_cutoff = 0.10
#' res <- go_enrich(gene_go_kegg[,-5], gene_go_kegg[100:200,1], pvalue_cutoff = 0.10)
#' head(res)
#'

go_enrich <- function(go_anno,
											degs_list,
											padjust_method = "fdr",
											pvalue_cutoff = 0.05,
											qvalue_cutoff = 0.05) {

	if (!requireNamespace("clusterProfiler", quietly = TRUE)) {
		stop("Package 'clusterProfiler' is required for go_enrich().\n",
				 "Please install: BiocManager::install('clusterProfiler')",
				 call. = FALSE)
	}

	if (!is.data.frame(go_anno) && !is.matrix(go_anno)) {
		stop("go_anno must be a data.frame or matrix", call. = FALSE)
	}

	valid_methods <- c("holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none")
	if (!padjust_method %in% valid_methods) {
		stop(sprintf("padjust_method must be one of: %s", paste(valid_methods, collapse = ", ")), call. = FALSE)
	}

	gene_go <- go_anno

	gene_go1 <- tidyr::pivot_longer(
		gene_go,
		cols = c(biological_process, cellular_component, molecular_function),
		names_to = "ontology",
		values_to = "term"
	)

	gene_go1 <- gene_go1[!is.na(gene_go1$term), ]

	gene_go2 <- tidyr::separate_rows(data = gene_go1, "term", sep = ";")

	gene_go3 <- tidyr::separate(gene_go2, "term", c("term", "description"), "\\(", extra = "merge")

	gene_go4 <- tidyr::drop_na(gene_go3)
	gene_go4["description"] <- gsub(")", "", gene_go4$description)
	gene_go4["ontology"] <- gsub("_", " ", gene_go4$ontology)

	gene_go5 <- data.frame(gene_go4["Genes"], gene_go4["term"], gene_go4["ontology"], gene_go4["description"])

	enrich_results <- clusterProfiler::enricher(
		gene = degs_list,
		TERM2GENE = data.frame(gene_go5[, 2], gene_go5[, 1]),
		TERM2NAME = data.frame(gene_go5[, 2], gene_go5[, 4]),
		pvalueCutoff = pvalue_cutoff,
		pAdjustMethod = padjust_method,
		qvalueCutoff = qvalue_cutoff,
		minGSSize = 1,
		maxGSSize = 1000
	)

	enrich_result <- enrich_results@result

	gene_go6 <- data.frame(gene_go5["term"], gene_go5["ontology"])
	gene_go6 <- dplyr::distinct(gene_go6, .keep_all = TRUE)

	enrich_table <- merge(gene_go6, enrich_result, by.x = "term", by.y = "ID")
	colnames(enrich_table)[1] <- "ID"

	return(enrich_table)
}
