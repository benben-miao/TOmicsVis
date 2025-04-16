#' @title GO enrichment analysis and bar plot (None/Exist Reference Genome).
#' @description GO enrichment analysis and bar plot (None/Exist Reference Genome).
#' @author benben-miao
#'
#' @return Plot: GO enrichment analysis and bar plot (None/Exist Reference Genome).
#' @param go_anno Dataframe: GO and KEGG annotation of background genes (1st-col: Genes, 2nd-col: biological_process, 3rd-col: cellular_component, 4th-col: molecular_function, 5th-col: kegg_pathway).
#' @param degs_list Dataframe: degs list.
#' @param padjust_method Character: P-value adjust to Q-value. Default: "fdr" (false discovery rate), options: "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none".
#' @param pvalue_cutoff Numeric: P-value cutoff. Recommend: small than 0.05.
#' @param qvalue_cutoff Numeric: Q-value cutoff. Recommend: small than 0.05.
#' @param sign_by Character: significant by. Default: "p.adjust", options: "pvalue", "p.adjust", "qvalue".
#' @param category_num Numeric: categories number to display. Default: 30, min: 1, max: NULL.
#' @param font_size Numeric: category font size. Default: 12.
#' @param low_color Character: low value (p-value or q-value) color (color name or hex value).
#' @param high_color Character: high value (p-value or q-value) color (color name or hex value).
#' @param ggTheme Character: ggplot2 themes. Default: "theme_light", options: "theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw", "theme_dark", "theme_minimal", "theme_classic", "theme_void"
#'
#' @import ggplot2
#' @import ggsci
#' @importFrom reshape2 melt
#' @importFrom tidyr separate_rows separate drop_na
#' @importFrom clusterProfiler enricher
#' @importFrom dplyr distinct
#' @import enrichplot
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
#' go_enrich_bar(gene_go_kegg[,-5], gene_go_kegg[100:200,1])
#'
#' # 4. Set padjust_method = "BH"
#' go_enrich_bar(gene_go_kegg[,-5], gene_go_kegg[100:200,1], padjust_method = "BH")
#'
#' # 5. Set category_num = 10
#' go_enrich_bar(gene_go_kegg[,-5], gene_go_kegg[100:200,1], category_num = 10)
#'
#' # 6. Set ggTheme = "theme_bw"
#' go_enrich_bar(gene_go_kegg[,-5], gene_go_kegg[100:200,1], ggTheme = "theme_bw")
#'
go_enrich_bar <- function(go_anno,
													degs_list,
													padjust_method = "fdr",
													pvalue_cutoff = 0.05,
													qvalue_cutoff = 0.05,
													sign_by = "p.adjust",
													category_num = 30,
													font_size = 12,
													low_color = "#ff0000aa",
													high_color = "#008800aa",
													ggTheme = "theme_light") {
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
	degs_list <- degs_list

	# deg_fc["log2FC"] <- 2^(deg_fc["log2FC"])
	# deg_list <- with(deg_fc, setNames(log2FC, id))

	gene_go1 <- melt(
		gene_go,
		na.rm = FALSE,
		id.vars = c("Genes"),
		measure.vars = c(
			"biological_process",
			"cellular_component",
			"molecular_function"
		),
		variable.name = "ontology",
		value.name = "term",
		factorsAsStrings = TRUE
	)

	gene_go2 <- separate_rows(data = gene_go1, "term", sep = ";")

	gene_go3 <- separate(gene_go2, "term", c("term", "description"), "\\(")

	gene_go4 <- drop_na(gene_go3)
	gene_go4["description"] <- gsub(")", "", gene_go4$description)
	gene_go4["ontology"] <- gsub("_", " ", gene_go4$ontology)

	gene_go5 <- data.frame(gene_go4["Genes"], gene_go4["term"], gene_go4["ontology"], gene_go4["description"])

	enrich_results <- enricher(
		gene = degs_list,
		TERM2GENE = data.frame(gene_go5[, 2], gene_go5[, 1]),
		TERM2NAME = data.frame(gene_go5[, 2], gene_go5[, 4]),
		pvalueCutoff = pvalue_cutoff,
		pAdjustMethod = padjust_method,
		# "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none"
		qvalueCutoff = qvalue_cutoff,
		minGSSize = 1,
		maxGSSize = 1000
	)

	enrich_result <- enrich_results@result

	gene_go6 <- data.frame(gene_go5["term"], gene_go5["ontology"])
	gene_go6 <- distinct(gene_go6, .keep_all = TRUE)

	enrich_table <- merge(gene_go6, enrich_result, by.x = "term", by.y = "ID")
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

	# ggTheme <- "theme_bw"
	# ChoiceBox: "theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw", "theme_dark", "theme_minimal", "theme_classic", "theme_void"
	if (ggTheme == "theme_default") {
		gg_theme <- theme()
	} else if (ggTheme == "theme_bw") {
		gg_theme <- theme_bw()
	} else if (ggTheme == "theme_gray") {
		gg_theme <- theme_gray()
	} else if (ggTheme == "theme_light") {
		gg_theme <- theme_light()
	} else if (ggTheme == "theme_linedraw") {
		gg_theme <- theme_linedraw()
	} else if (ggTheme == "theme_dark") {
		gg_theme <- theme_dark()
	} else if (ggTheme == "theme_minimal") {
		gg_theme <- theme_minimal()
	} else if (ggTheme == "theme_classic") {
		gg_theme <- theme_classic()
	} else if (ggTheme == "theme_void") {
		gg_theme <- theme_void()
	} else if (ggTheme == "theme_test") {
		gg_theme <- theme_test()
	}

	# sign_by <- "p.adjust"
	# ChoiceBox: "pvalue", "p.adjust", "qvalue"

	# category_num <- 30
	# ChoiceBox: 30, 10, 1, 50

	# low_color <- "#ff0000aa"
	# ColorPicker

	# high_color <- "#0000ffaa"
	# ColorPicker

	# font_size <- 12
	# Slider: 12, 2, 2, 30
	# <- 4. Plot parameters

	# -> 5. Plot
	p <- barplot(
		height = enrich_results,
		x = "GeneRatio",
		# 'Count' and 'GeneRatio'
		color = sign_by,
		showCategory = category_num,
		font.size = font_size,
		title = "",
		label_format = 200
	) +
		geom_text(
			aes_string(label = "Count"),
			vjust = 0.5,
			hjust = -0.5,
			size = 3,
			color = "#333333"
		) +
		# geom_text(aes(label = paste("(",round(enrich_result$GeneRatio, 2),")", sep = "")),
		# 					vjust = 0.5,
		# 					hjust = -0.5,
		# 					size = 3,
		# 					color = "#333333") +
		xlab("Gene Number") +
		ylab("GO terms") +
		gg_theme +
		theme(# text = element_text(family = fonts),
			axis.text = element_text(colour = "#000000")) +
		scale_fill_gradient(low = low_color,
												high = high_color,
												space = "Lab")

	# p
	# <- 5. Plot

	return(p)
	invisible()
}
