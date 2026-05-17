#' @title GO enrichment analysis and net plot (None/Exist Reference Genome).
#' @description GO enrichment analysis and net plot (None/Exist Reference Genome).
#' @author benben-miao
#'
#' @return PLot: GO enrichment analysis and net plot (None/Exist Reference Genome).
#' @param go_anno Dataframe: GO and KEGG annotation of background genes (1st-col: Genes, 2nd-col: biological_process, 3rd-col: cellular_component, 4th-col: molecular_function, 5th-col: kegg_pathway).
#' @param degs_list Dataframe: degs list.
#' @param padjust_method Character: P-value adjust to Q-value. Default: "fdr" (false discovery rate), options: "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none".
#' @param pvalue_cutoff Numeric: P-value cutoff. Recommend: small than 0.05.
#' @param qvalue_cutoff Numeric: Q-value cutoff. Recommend: small than 0.05.
#' @param category_num Numeric: categories number to display. Default: 20, min: 1, max: NULL.
#' @param net_layout Character: network layout. Default: "circle", options: 'star', 'circle', 'gem', 'dh', 'graphopt', 'grid', 'mds', 'randomly', 'fr', 'kk', 'drl' or 'lgl'.
#' @param net_circular Logical: network circular. Default: TRUE, options: TRUE, FALSE.
#' @param low_color Character: low value (p-value or q-value) color (color name or hex value).
#' @param high_color Character: high value (p-value or q-value) color (color name or hex value).
#'
#' @import ggplot2
#' @import ggsci
#' @importFrom tidyr pivot_longer separate_rows separate drop_na
#' @importFrom clusterProfiler enricher
#' @importFrom dplyr distinct
#' @import enrichplot
#' @import ggnewscale
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset
#' data(gene_go_kegg)
#' head(gene_go_kegg, 10)
#'
#' # 3. Default parameters
#' go_enrich_net(gene_go_kegg[,-5], gene_go_kegg[100:200,1])
#'
go_enrich_net <- function(go_anno,
													degs_list,
										 padjust_method = "fdr",
										 pvalue_cutoff = 0.05,
										 qvalue_cutoff = 0.05,
										 category_num = 20,
										 net_layout = "circle",
										 low_color = "#ff0000aa",
										 high_color = "#008800aa"
										){
	if (!requireNamespace("clusterProfiler", quietly = TRUE)) {
		stop("Package 'clusterProfiler' is required for go_enrich_net().\n",
				 "Please install: BiocManager::install('clusterProfiler')",
				 call. = FALSE)
	}

	gene_go <- go_anno
	degs_list <- degs_list

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

	gene_go5 <- data.frame(gene_go4["Genes"],
												 gene_go4["term"],
												 gene_go4["ontology"],
												 gene_go4["description"]
	)

	enrich_results <- clusterProfiler::enricher(gene = degs_list,
														 TERM2GENE = data.frame(gene_go5[,2],gene_go5[,1]),
														 TERM2NAME = data.frame(gene_go5[,2],gene_go5[,4]),
														 pvalueCutoff = pvalue_cutoff,
														 pAdjustMethod = padjust_method, # "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none"
														 qvalueCutoff = qvalue_cutoff,
														 minGSSize = 1,
														 maxGSSize = 1000
	)

	enrich_result <- enrich_results@result

	gene_go6 <- data.frame(gene_go5["term"], gene_go5["ontology"])
	gene_go6 <- distinct(gene_go6, .keep_all = TRUE)

	enrich_table <- merge(gene_go6,
												enrich_result,
												by.x = "term",
												by.y = "ID"
	)
	colnames(enrich_table)[1] <- "ID"

	p <- cnetplot(
		x = enrich_results,
		showCategory = category_num,
		layout = net_layout,
		color_category = "#E5C494",
		size_category = 1,
		color_item = "#B3B3B3",
		size_item = 1,
		color_edge = "grey",
		node_label = "all"
	) +
		labs(color = "Genes") +
		theme(
			# text = element_text(family = fonts)
		) +
		scale_fill_gradient(low = low_color, high = high_color,
												 space = "Lab",
												 guide = "colourbar", aesthetics = "fill")

	return(p)
}
