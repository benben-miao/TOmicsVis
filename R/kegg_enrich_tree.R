#' @title KEGG enrichment analysis and tree plot (None/Exist Reference Genome).
#' @description KEGG enrichment analysis and tree plot (None/Exist Reference Genome).
#' @author benben-miao
#'
#' @return Plot: KEGG enrichment analysis and tree plot (None/Exist Reference Genome).
#' @param kegg_anno Dataframe: include columns (id, kegg_pathway),  symbol ";" split ko pathways.
#' @param kegg_deg_fc Dataframe: include columns (id, log2FC).
#' @param padjust_method Character: P-value adjust to Q-value. Default: "fdr" (false discovery rate), options: "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none".
#' @param pvalue_cutoff Numeric: P-value cutoff. Recommend: small than 0.05.
#' @param qvalue_cutoff Numeric: Q-value cutoff. Recommend: small than 0.05.
#' @param sign_by Character: significant by. Default: "p.adjust", options: "pvalue", "p.adjust", "qvalue".
#' @param category_num Numeric: categories number to display. Default: 20, min: 1, max: NULL.
#' @param font_size Numeric: category font size. Default: 4.
#' @param low_color Character: low value (p-value or q-value) color (color name or hex value).
#' @param high_color Character: high value (p-value or q-value) color (color name or hex value).
#' @param hclust_method Character: hclust method. Default: "complete", options: "ward.D", "ward.D2", "single", "complete", "average", "mcquitty", "median", "centroid".
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
#' data(kegg_anno)
#' head(kegg_anno)
#'
#' data(kegg_deg_fc)
#' head(kegg_deg_fc)
#'
#' # 3. Default parameters
#' kegg_enrich_tree(kegg_anno, kegg_deg_fc)
#'
#' # 4. Set padjust_method = "BH"
#' kegg_enrich_tree(kegg_anno, kegg_deg_fc, padjust_method = "BH")
#'
#' # 5. Set category_num = 10
#' kegg_enrich_tree(kegg_anno, kegg_deg_fc, category_num = 10)
#'
#' # 6. Set low_color = "#ff8800ff", high_color = "#008888ff"
#' kegg_enrich_tree(kegg_anno, kegg_deg_fc, low_color = "#ff8800ff", high_color = "#008888ff")
#'
#' # 7. Set hclust_method = "ward.D"
#' kegg_enrich_tree(kegg_anno, kegg_deg_fc, hclust_method = "ward.D")
#'
kegg_enrich_tree <- function(kegg_anno,
														 kegg_deg_fc,
														 padjust_method = "fdr",
														 pvalue_cutoff = 1.00,
														 qvalue_cutoff = 1.00,
														 sign_by = "p.adjust",
														 category_num = 20,
														 font_size = 4,
														 low_color = "#ff0000aa",
														 high_color = "#008888aa",
														 hclust_method = "complete",
														 ggTheme = "theme_light"
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

	# category_num <- 20
	# ChoiceBox: 30, 10, 1, 50

	# low_color <- "#ff0000aa"
	# ColorPicker

	# high_color <- "#0000ffaa"
	# ColorPicker

	# font_size <- 12
	# Slider: 12, 2, 2, 30

	# hclust_method <- "ward.D"
	# ChoiceBox: "ward.D", "ward.D2", "single", "complete", "average", "mcquitty", "median", "centroid"
	# <- 4. Plot parameters

	# -> 5. Plot
	enrich_kegg2 <- pairwise_termsim(enrich_kegg)
	p <- treeplot(
		x = enrich_kegg2,
		showCategory = category_num,
		color = sign_by,
		nWords = 5,
		nCluster = 5,
		cex_category = 1,
		label_format = 30,
		xlim = NULL,
		fontsize = font_size,
		# offset = NULL,
		offset_tiplab = 0.5,
		hclust_method = hclust_method,
		group_color = NULL,
		extend = 0.3,
		hilight = TRUE
	) +
		theme(
			# text = element_text(family = fonts)
		) +
		scale_color_gradient(low = low_color, high = high_color, space = "Lab")

	p
	# <- 5. Plot

	return(p)
	invisible()
}
