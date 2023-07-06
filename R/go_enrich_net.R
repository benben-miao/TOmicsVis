#' @title GO enrichment analysis and net plot (None/Exist Reference Genome).
#' @description GO enrichment analysis and net plot (None/Exist Reference Genome).
#' @author benben-miao
#'
#' @return PLot: GO enrichment analysis and net plot (None/Exist Reference Genome).
#' @param go_anno Dataframe: include columns (id, biological_process, cellular_component, molecular_function),  symbol ";" split GO terms.
#' @param go_deg_fc Dataframe: include columns (id, log2FC).
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
#' @importFrom reshape2 melt
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
#' data(go_anno)
#' head(go_anno)
#'
#' data(go_deg_fc)
#' head(go_deg_fc)
#'
#' # 3. Set low_color = "#ff8800ff", high_color = "#008888ff"
#' go_enrich_net(go_anno, go_deg_fc, low_color = "#ff8800ff", high_color = "#008888ff")
#'
go_enrich_net <- function(go_anno,
										 go_deg_fc,
										 padjust_method = "fdr",
										 pvalue_cutoff = 0.50,
										 qvalue_cutoff = 0.50,
										 category_num = 20,
										 net_layout = "circle",
										 net_circular = TRUE,
										 low_color = "#ff0000aa",
										 high_color = "#008888aa"
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

	enrich_result <- enrich_results@result

	gene_go6 <- data.frame(gene_go5["term"], gene_go5["ontology"])
	gene_go6 <- distinct(gene_go6, .keep_all = TRUE)

	enrich_table <- merge(gene_go6,
												enrich_result,
												by.x = "term",
												by.y = "ID"
	)
	colnames(enrich_table)[1] <- "ID"

	# write.table(enrich_table,
	# 						file = "Results.txt",
	# 						append = FALSE,
	# 						sep = "\t",
	# 						quote = TRUE,
	# 						na = "NA"
	# )
	# <- 3. Data

	# -> 4. Plot parameters
	# fonts <- "Times"
	# ChoiceBox: "Times", "Palatino", "Bookman", "Courier", "Helvetica", "URWGothic", "NimbusMon", "NimbusSan"

	# category_num <- 30
	# ChoiceBox: 30, 10, 1, 50

	# low_color <- "#ff0000aa"
	# ColorPicker

	# high_color <- "#0000ffaa"
	# ColorPicker

	# net_layout <- "circle"
	# ChoiceBox: 'star', 'circle', 'gem', 'dh', 'graphopt', 'grid', 'mds', 'randomly', 'fr', 'kk', 'drl' or 'lgl'.

	# isCircular <- "circular"
	# if (isCircular == "circular") {
	# 	circular <- TRUE
	# } else if (isCircular == "scattered") {
	# 	circular <- FALSE
	# }
	# # ChoiceBox: "circular", "scattered"


	cateLabelScale <- 0.8
	# Slider: 0.8, 0.1, 0.1, 2.0

	geneLabelScale <- 0.8
	# Slider: 0.8, 0.1, 0.1, 2.0
	# <- 4. Plot parameters

	# -> 5. Plot
	p <- cnetplot(
		x = enrich_results,
		showCategory = category_num,
		foldChange = deg_list,
		layout = net_layout, # 'star', 'circle', 'gem', 'dh', 'graphopt', 'grid', 'mds', 'randomly', 'fr', 'kk', 'drl' or 'lgl'.
		colorEdge = TRUE,
		circular = net_circular,
		node_label = "all",
		cex_category = 1,
		cex_gene = 1,
		cex_label_category = cateLabelScale,
		cex_label_gene = geneLabelScale,
		# color_category = "#ff0000",
		# color_gene = "#008000",
		shadowtext = "all"
	) +
		# guides(color = guide_legend(title="New Legend Title")) +
		labs(color = "Genes") +
		theme(
			# text = element_text(family = fonts)
		) +
		scale_color_gradient(low = low_color, high = high_color, space = "Lab")

	# p
	# <- 5. Plot

	return(p)
	invisible()
}
