#' @title KEGG enrichment analysis based on KEGG annotation results (None/Exist Reference Genome).
#' @description KEGG enrichment analysis based on KEGG annotation results (None/Exist Reference Genome).
#' @author benben-miao
#'
#' @return Table: include columns ("ID", "Description", "GeneRatio", "BgRatio", "pvalue", "p.adjust", "qvalue", "geneID", "Count").
#' @param kegg_anno Dataframe: include columns (id, kegg_pathway),  symbol ";" split ko pathways.
#' @param kegg_deg_fc Dataframe: include columns (id, log2FC).
#' @param padjust_method Character: P-value adjust to Q-value. Default: "fdr" (false discovery rate), options: "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none".
#' @param pvalue_cutoff Numeric: P-value cutoff. Recommend: small than 0.05.
#' @param qvalue_cutoff Numeric: Q-value cutoff. Recommend: small than 0.05.
#'
#' @import stats
#' @import ggplot2
#' @import ggsci
#' @import reshape2
#' @import tidyr
#' @import dplyr
#' @import clusterProfiler
#' @import enrichplot
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset
#' data(kegg_anno)
#' head(kegg_anno)
#'
#' data(kegg_deg_fc)
#' head(kegg_deg_fc)
#'
#' # 3. Default parameters
#' res <- kegg_enrich(kegg_anno, kegg_deg_fc)
#' head(res)
#'
#' # 4. Set padjust_method = "BH"
#' res <- kegg_enrich(kegg_anno, kegg_deg_fc, padjust_method = "BH")
#' head(res)
#'
#' # 5. Set pvalue_cutoff = 0.80
#' res <- kegg_enrich(kegg_anno, kegg_deg_fc, pvalue_cutoff = 0.80)
#' head(res)
#'
kegg_enrich <- function(kegg_anno,
												kegg_deg_fc,
											 padjust_method = "fdr",
											 pvalue_cutoff = 1.00,
											 qvalue_cutoff = 1.00
											){
	# -> 2. Data Parameters
	# padjust_method <- "fdr"
	# ChoiceBox: "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none"

	# pvalue_cutoff <- 0.30
	# Slider: 0.30, 0.00, 0.01, 1.00

	# qvalue_cutoff <- 0.50
	# Slider: 0.50, 0.00, 0.01, 1.00
	# <- 2. Data Parameters

	# -> 3. Data
	gene_kegg <- kegg_anno
	deg_fc <- kegg_deg_fc

	deg_fc["log2FC"] <- 2^(deg_fc["log2FC"])
	deg_list <- with(deg_fc, setNames(log2FC, id))

	gene_kegg7 <- separate_rows(data = gene_kegg,
															"kegg_pathway",
															sep = ";"
	)

	gene_kegg8 <- separate(gene_kegg7,
												 "kegg_pathway",
												 c("kegg_pathway", "description"),
												 "\\("
	)

	gene_kegg9 <- drop_na(gene_kegg8)
	gene_kegg9["description"] <- gsub(")", "", gene_kegg9$description)

	enrich_kegg <- enricher(gene = deg_fc[[1]],
													TERM2GENE = data.frame(gene_kegg9[,2],gene_kegg9[,1]),
													TERM2NAME = gene_kegg9[,2:3],
													pvalueCutoff = pvalue_cutoff,
													pAdjustMethod = padjust_method, # "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none"
													qvalueCutoff = qvalue_cutoff,
													minGSSize = 1,
													maxGSSize = 1000
													)

	enrich_result <- enrich_kegg@result

	# write.table(enrich_result,
	# 						file = "Results.txt",
	# 						append = FALSE,
	# 						sep = "\t",
	# 						quote = TRUE,
	# 						na = "NA"
	# )
	# <- 3. Data

	return(enrich_result)
	invisible()
}
