#' @title GO enrichment analysis and stat plot (None/Exist Reference Genome).
#' @description GO enrichment analysis and stat plot (None/Exist Reference Genome).
#' @author benben-miao
#'
#' @return Plot: GO enrichment analysis and stat plot (None/Exist Reference Genome).
#' @param go_anno Dataframe: GO and KEGG annotation of background genes (1st-col: Genes, 2nd-col: biological_process, 3rd-col: cellular_component, 4th-col: molecular_function, 5th-col: kegg_pathway).
#' @param degs_list Dataframe: degs list.
#' @param padjust_method Character: P-value adjust to Q-value. Default: "fdr" (false discovery rate), options: "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none".
#' @param pvalue_cutoff Numeric: P-value cutoff. Recommend: small than 0.05.
#' @param qvalue_cutoff Numeric: Q-value cutoff. Recommend: small than 0.05.
#' @param max_go_item Numeric: max BP/CC/MF terms. Default: 15, min: 1, max: NULL.
#' @param strip_fill Character: strip fill color (color name or hex value). Default: "#CDCDCD".
#' @param xtext_angle Numeric: x axis texts angle. Default: 45, min: 0, max: 360.
#' @param sci_fill_color Character: ggsci color pallet. Default: "Sci_AAAS", options: "Sci_AAAS", "Sci_NPG", "Sci_Simpsons", "Sci_JAMA", "Sci_GSEA", "Sci_Lancet", "Sci_Futurama", "Sci_JCO", "Sci_NEJM", "Sci_IGV", "Sci_UCSC", "Sci_D3", "Sci_Material".
#' @param sci_fill_alpha Numeric: ggsci fill color alpha. Default: 0.80, min: 0.00, max: 1.00.
#' @param ggTheme Character: ggplot2 themes. Default: "theme_light", options: "theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw", "theme_dark", "theme_minimal", "theme_classic", "theme_void"
#'
#' @import ggplot2
#' @import ggsci
#' @importFrom reshape2 melt
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
#' go_enrich_stat(gene_go_kegg[,-5], gene_go_kegg[100:200,1])
#'
#' # 4. Set padjust_method = "BH"
#' go_enrich_stat(gene_go_kegg[,-5], gene_go_kegg[100:200,1], padjust_method = "BH")
#'
#' # 5. Set max_go_item = 10
#' go_enrich_stat(gene_go_kegg[,-5], gene_go_kegg[100:200,1], max_go_item = 10)
#'
#' # 6. Set strip_fill = "#008888"
#' go_enrich_stat(gene_go_kegg[,-5], gene_go_kegg[100:200,1], strip_fill = "#008888")
#'
#' # 7. Set sci_fill_color = "Sci_JAMA"
#' go_enrich_stat(gene_go_kegg[,-5], gene_go_kegg[100:200,1], sci_fill_color = "Sci_JAMA")
#'
go_enrich_stat <- function(go_anno,
										 degs_list,
										 padjust_method = "fdr",
										 pvalue_cutoff = 0.05,
										 qvalue_cutoff = 0.05,
										 max_go_item = 15,
										 strip_fill = "#CDCDCD",
										 xtext_angle = 45,
										 sci_fill_color = "Sci_AAAS",
										 sci_fill_alpha = 0.80,
										 ggTheme = "theme_light"
										){
	# -> 2. Data Parameters
	# max_item <- 15
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
	degs_list <- degs_list

	# deg_fc["log2FC"] <- 2^(deg_fc["log2FC"])
	# deg_list <- with(deg_fc, setNames(log2FC, id))

	gene_go1 <- reshape2::melt(gene_go,
									 na.rm = FALSE,
									 id.vars = c("Genes"),
									 measure.vars = c("biological_process", "cellular_component", "molecular_function"),
									 variable.name = "ontology",
									 value.name = "term",
									 factorsAsStrings = TRUE
	)

	gene_go2 <- tidyr::separate_rows(data = gene_go1,
														"term",
														sep = ";"
	)

	gene_go3 <- tidyr::separate(gene_go2,
											 "term",
											 c("term", "description"),
											 "\\("
	)

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

	# head(enrich_results@result)
	# length(enrich_results@result$ID)
	enrich_result <- enrich_results@result

	gene_go6 <- data.frame(gene_go5["term"], gene_go5["ontology"])
	gene_go6 <- dplyr::distinct(gene_go6, .keep_all = TRUE)

	enrich_table <- merge(gene_go6,
												enrich_result,
												by.x = "term",
												by.y = "ID"
	)
	colnames(enrich_table)[1] <- "ID"

	GetTop <- function(df, item){
		if (nrow(df) > item) {
			return(df[1:item,])
		}else{
			return(df[1:nrow(df),])
		}
	}

	GetGoTopEnrich <- function(df, max_item = max_go_item){
		go_MF <- GetTop(df[df$ontology == "molecular function",], max_item)
		go_CC <- GetTop(df[df$ontology == "cellular component",][1:max_item,],max_item)
		go_BP <- GetTop(df[df$ontology == "biological process",][1:max_item,],max_item)
		enrich_df <- data.frame(ID = c(go_BP$ID, go_CC$ID, go_MF$ID),
														Ontology = factor(c(rep("Biological Process", nrow(go_BP)), rep("Cellular Component", nrow(go_CC)),rep("Molecular Function",nrow(go_MF))),levels = c("Molecular Function", "Cellular Component", "Biological Process")),
														Description = c(go_BP$Description, go_CC$Description, go_MF$Description),
														GeneRatio = c(go_BP$GeneRatio, go_CC$GeneRatio, go_MF$GeneRatio),
														pvalue = c(go_BP$pvalue, go_CC$pvalue, go_MF$pvalue),
														p.adjust = c(go_BP$p.adjust, go_CC$p.adjust, go_MF$p.adjust),
														qvalue = c(go_BP$qvalue, go_CC$qvalue, go_MF$qvalue),
														Count = c(go_BP$Count, go_CC$Count, go_MF$Count)
		)
		return(enrich_df)
	}
	enrich_df <- GetGoTopEnrich(enrich_table)
	# <- 3. Data

	# -> 4. Plot parameters
	# fonts <- "Times"
	# ChoiceBox: "Times", "Palatino", "Bookman", "Courier", "Helvetica", "URWGothic", "NimbusMon", "NimbusSan"

	# sci_fill_alpha <- 0.92
	# sci_fill_color <- "Sci_D3"
	# ChoiceBox: "Sci_AAAS", "Sci_NPG", "Sci_Simpsons", "Sci_JAMA", "Sci_GSEA", "Sci_Lancet", "Sci_Futurama", "Sci_JCO", "Sci_NEJM", "Sci_IGV", "Sci_UCSC", "Sci_D3", "Sci_Material"
	if (sci_fill_color == "Default") {
		sci_fill <- NULL
	} else if (sci_fill_color == "Sci_AAAS") {
		sci_fill <- scale_fill_aaas(alpha = sci_fill_alpha)
		# Science and Science Translational Medicine:
	} else if (sci_fill_color == "Sci_NPG") {
		sci_fill <- scale_fill_npg(alpha = sci_fill_alpha)
	} else if (sci_fill_color == "Sci_Simpsons") {
		sci_fill <- scale_fill_simpsons(alpha = sci_fill_alpha)
		# The Simpsons
	} else if (sci_fill_color == "Sci_JAMA") {
		sci_fill <- scale_fill_jama(alpha = sci_fill_alpha)
		# The Journal of the American Medical Association
	} else if (sci_fill_color == "Sci_Lancet") {
		sci_fill <- scale_fill_lancet(alpha = sci_fill_alpha)
		#  Lancet Oncology
	} else if (sci_fill_color == "Sci_Futurama") {
		sci_fill <- scale_fill_futurama(alpha = sci_fill_alpha)
		# Futurama
	} else if (sci_fill_color == "Sci_JCO") {
		sci_fill <- scale_fill_jco(alpha = sci_fill_alpha)
		# Journal of Clinical Oncology:
	} else if (sci_fill_color == "Sci_NEJM") {
		sci_fill <- scale_fill_nejm(alpha = sci_fill_alpha)
		# The New England Journal of Medicine
	} else if (sci_fill_color == "Sci_IGV") {
		sci_fill <- scale_fill_igv(alpha = sci_fill_alpha)
		# Integrative Genomics Viewer (IGV)
	} else if (sci_fill_color == "Sci_UCSC") {
		sci_fill <- scale_fill_ucscgb(alpha = sci_fill_alpha)
		# UCSC Genome Browser chromosome sci_fill
	} else if (sci_fill_color == "Sci_D3") {
		sci_fill <- scale_fill_d3(alpha = sci_fill_alpha)
		# D3.JS
	} else if (sci_fill_color == "Sci_Material") {
		sci_fill <- scale_fill_material(alpha = sci_fill_alpha)
		# The Material Design color palettes
	}

	# ggTheme <- "theme_light"
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

	stripPos <- "top"
	# ChoiceBox: "top", "bottom", "right", "left"

	# strip_fill <- "#ff000033"
	# ColorPicker:

	# xtext_angle <- 45
	# Slider: 45, 0, 5, 360
	# <- 4. Plot parameters

	enrich_df["new_x"] <- reorder(enrich_df$Description, -enrich_df$Count)

	# -> 5. Plot
	p <- ggplot(data = enrich_df,
							aes_string(x = "new_x",
									y = "Count",
									fill = "Ontology")) +
		geom_bar(stat = 'identity',
						 position = 'dodge')  +
		geom_text(aes_string(label = "Count"),
							vjust = -0.3,
							hjust = 0.5) +
		facet_wrap(~enrich_df$Ontology,
							 scales = 'free_x',
							 strip.position = stripPos) +
		xlab('GO terms') +
		ylab('Gene counts') +
		gg_theme +
		theme(axis.text.x = element_text(angle = xtext_angle,
																		 hjust = 1
		),
		# text = element_text(family = fonts),
		axis.text = element_text(colour = "#000000"),
		strip.text.x = element_text(size = 10,
																colour = "#333333",
																face = "bold"),
		strip.background.x = element_rect(fill = strip_fill,
																			color = strip_fill),
		legend.position = "top",
		legend.direction = "horizontal",
		legend.title = element_text(
			size = 12,
			hjust = 0.5
		),
		legend.text = element_text(
			size = 10
		),
		plot.margin = margin(5, 5, 5, 80)
		) +
		sci_fill

	# p
	# <- 5. Plot

	return(p)
	invisible()
}
