#' @title KEGG enrichment analysis and net plot (None/Exist Reference Genome).
#' @description KEGG enrichment analysis and net plot (None/Exist Reference Genome).
#' @author benben-miao
#'
#' @return Plot: KEGG enrichment analysis and net plot (None/Exist Reference Genome).
#' @param kegg_anno Dataframe: GO and KEGG annotation of background genes (1st-col: Genes, 2nd-col: biological_process, 3rd-col: cellular_component, 4th-col: molecular_function, 5th-col: kegg_pathway).
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
#' @importFrom tidyr separate_rows separate drop_na
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
#' kegg_enrich_net(gene_go_kegg[,c(1,5)], gene_go_kegg[100:200,1])
#'
#' # 4. Set category_num = 10
#' kegg_enrich_net(gene_go_kegg[,c(1,5)], gene_go_kegg[100:200,1], category_num = 10)
#'
kegg_enrich_net <- function(kegg_anno,
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
		stop("Package 'clusterProfiler' is required for kegg_enrich_net().\n",
				 "Please install: BiocManager::install('clusterProfiler')",
				 call. = FALSE)
	}

	gene_kegg <- kegg_anno

	gene_kegg7 <- tidyr::separate_rows(data = gene_kegg, "kegg_pathway", sep = ";")

	gene_kegg8 <- tidyr::separate(gene_kegg7,
												 "kegg_pathway",
												 c("kegg_pathway", "description"),
												 "\\(", extra = "merge")

	gene_kegg9 <- tidyr::drop_na(gene_kegg8)
	gene_kegg9["description"] <- gsub(")", "", gene_kegg9$description)

	enrich_kegg <- clusterProfiler::enricher(gene = degs_list,
													TERM2GENE = data.frame(gene_kegg9[,2],gene_kegg9[,1]),
													TERM2NAME = gene_kegg9[,2:3],
													pvalueCutoff = pvalue_cutoff,
													pAdjustMethod = padjust_method, # "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none"
													qvalueCutoff = qvalue_cutoff,
													minGSSize = 1,
													maxGSSize = 1000
	)

	enrich_result <- enrich_kegg@result

	p <- cnetplot(
		x = enrich_kegg,
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
		theme() +
		scale_fill_gradient(low = low_color, high = high_color,
												space = "Lab",
												guide = "colourbar", aesthetics = "fill")

	return(p)
}
