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
#' @param ggTheme Character: ggplot2 themes. Default: "theme_publication", options: "theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw", "theme_dark", "theme_minimal", "theme_classic", "theme_void"
#'
#' @import ggplot2
#' @import ggsci
#' @importFrom tidyr pivot_longer separate_rows separate drop_na
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
#' head(gene_go_kegg, 10)
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
													ggTheme = "theme_publication") {

	validate_is_dataframe(go_anno, "go_anno")
	validate_character_options(padjust_method, "padjust_method",
														 c("holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none"))
	validate_numeric_range(pvalue_cutoff, "pvalue_cutoff", min = 0)
	validate_numeric_range(qvalue_cutoff, "qvalue_cutoff", min = 0)
	validate_character_options(sign_by, "sign_by", c("pvalue", "p.adjust", "qvalue"))
	validate_numeric_range(category_num, "category_num", min = 1)
	validate_numeric_range(font_size, "font_size", min = 0)
	validate_character_options(ggTheme, "ggTheme",
														 c("theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw",
															 "theme_dark", "theme_minimal", "theme_classic", "theme_void",
															 "theme_publication"))

	if (!requireNamespace("clusterProfiler", quietly = TRUE)) {
		stop("Package 'clusterProfiler' is required for go_enrich_bar().\n",
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

	gene_go5 <- data.frame(gene_go4["Genes"], gene_go4["term"], gene_go4["ontology"], gene_go4["description"])

	enrich_results <- clusterProfiler::enricher(
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

	gg_theme <- get_ggtheme(ggTheme)

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
			aes(label = Count),
			vjust = 0.5,
			hjust = -0.5,
			size = 3,
			color = "#333333"
		) +
		xlab("Gene Number") +
		ylab("GO terms") +
		gg_theme +
		theme(axis.text = element_text(colour = "#000000")) +
		scale_fill_gradient(low = low_color,
												high = high_color,
												space = "Lab")

	return(p)
}
