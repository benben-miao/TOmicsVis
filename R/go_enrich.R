#' @title GO enrichment analysis based on GO annotation results (None/Exist Reference Genome).
#' @description GO enrichment analysis based on GO annotation results (None/Exist Reference Genome).
#' @author benben-miao
#'
#' @return Table: include columns ("ID", "ontology", "Description", "GeneRatio", "BgRatio", "pvalue", "p.adjust", "qvalue", "geneID", "Count").
#' @param go_anno Dataframe: include columns (id, biological_process, cellular_component, molecular_function),  symbol ";" split GO terms.
#' @param go_deg_fc Dataframe: include columns (id, log2FC).
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
#' data(go_anno)
#' head(go_anno)
#'
#' data(go_deg_fc)
#' head(go_deg_fc)
#'
#' # 3. Default parameters
#' res <- go_enrich(go_anno, go_deg_fc)
#' head(res)
#'
#' # 4. Set padjust_method = "BH"
#' res <- go_enrich(go_anno, go_deg_fc, padjust_method = "BH")
#' head(res)
#'
#' # 5. Set pvalue_cutoff = 0.10
#' res <- go_enrich(go_anno, go_deg_fc, pvalue_cutoff = 0.10)
#' head(res)
#'
go_enrich <- function(go_anno,
										 go_deg_fc,
										 padjust_method = "fdr",
										 pvalue_cutoff = 0.50,
										 qvalue_cutoff = 0.50
										){
	# -> 2. Data Parameters
	maxItem <- 15
	# Slider: 15, 0, 1, 20

	# padjust_method <- "fdr"
	# ChoiceBox: "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none"

	# pvalue_cutoff <- 0.30
	# Slider: 0.30, 0.00, 0.01, 1.00

	# qvalue_cutoff <- 0.50
	# Slider: 0.50, 0.00, 0.01, 1.00
	# <- 2. Data Parameters

	# -> 3. Data
	gene_go <- go_anno
	deg_fc <- go_deg_fc

	deg_fc["log2FC"] <- 2^(deg_fc["log2FC"])
	deg_list <- with(deg_fc, setNames(log2FC, id))

	gene_go1 <- melt(gene_go,
									 na.rm = FALSE,
									 id.vars = c("id"),
									 measure.vars = c("biological_process", "cellular_component", "molecular_function"),
									 variable.name = "ontology",
									 value.name = "term",
									 factorsAsStrings = TRUE
	)

	gene_go2 <- separate_rows(data = gene_go1,
														"term",
														sep = ";"
	)

	gene_go3 <- separate(gene_go2,
											 "term",
											 c("term", "description"),
											 "\\("
	)

	gene_go4 <- drop_na(gene_go3)
	gene_go4["description"] <- gsub(")", "", gene_go4$description)
	gene_go4["ontology"] <- gsub("_", " ", gene_go4$ontology)

	gene_go5 <- data.frame(gene_go4["id"],
												 gene_go4["term"],
												 gene_go4["ontology"],
												 gene_go4["description"]
	)

	enrich_results <- enricher(gene = deg_fc[[1]],
														 TERM2GENE = data.frame(gene_go5[,2],gene_go5[,1]),
														 TERM2NAME = data.frame(gene_go5[,2],gene_go5[,4]),
														 pvalueCutoff = pvalue_cutoff,
														 pAdjustMethod = padjust_method, # "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none"
														 qvalueCutoff = qvalue_cutoff,
														 minGSSize = 1,
														 maxGSSize = 1000
	)

	# head(enrich_results@result)
	# length(enrich_results@result$ID)
	enrich_result <- enrich_results@result

	gene_go6 <- data.frame(gene_go5["term"], gene_go5["ontology"])
	gene_go6 <- distinct(gene_go6, .keep_all = TRUE)

	enrich_table <- merge(gene_go6,
												enrich_result,
												by.x = "term",
												by.y = "ID"
	)
	colnames(enrich_table)[1] <- "ID"

	return(enrich_table)
	invisible()
}
