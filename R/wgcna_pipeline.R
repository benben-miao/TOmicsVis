#' @title WGCNA analysis pipeline for RNA-Seq.
#' @description WGCNA analysis pipeline for RNA-Seq.
#' @author benben-miao
#'
#' @return WGCNA results in tempdir() directory of current session.
#' @param sample_gene Dataframe: All genes in all samples expression dataframe of RNA-Seq (1st-col: Genes, 2nd-col~: Samples).
#' @param group_sample Dataframe: Samples and groups for gene expression (1st-col: Samples, 2nd-col: Groups).
#' @param R_cutofff Numeric: Rsquare cutoff. Default: 0.85, min: 0.00, max: 1.00.
#' @param max_block Numeric: max block size. Default: 5000.
#' @param min_module Numeric: min module gene number. Default: 20.
#' @param network_type Character: network type. Default: "unsigned", options: "unsigned", "signed", "signed hybrid".
#' @param merge_cutoff Numeric: merge modules cutoff. Default: 0.15.
#' @param cor_type Character: correlation type. Default: "pearson", options: "pearson", "bicor".
#' @param na_color Character: NA value color (color name or hex value). Default: "#cdcdcd".
#' @param xlab_angle Numeric: X axis lable angle. Default: 45, min: 0, max: 360.
#' @param text_size Numeric: cell text size. Default: 0.7, min: 0, max: NULL.
#'
#' @import WGCNA
#' @import stringr
#' @import ggsci
#' @importFrom stats mad model.matrix quantile
#' @importFrom grDevices dev.off jpeg pdf
#' @importFrom graphics abline barplot legend strheight strwidth text
#' @importFrom utils write.table
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset
#' data(gene_expression)
#' head(gene_expression)
#'
#' data(samples_groups)
#' head(samples_groups)
#'
wgcna_pipeline <- function(sample_gene,
													 group_sample,
													 R_cutofff = 0.85,
													 max_block = 5000,
													 min_module = 20,
													 network_type = "unsigned",
													 merge_cutoff = 0.15,
													 cor_type = "pearson",
													 na_color = "#cdcdcd",
													 xlab_angle = 45,
													 text_size = 0.7
													){
	pipeline <- function(){

	results_dir <- tempdir()

	sample_gene <- as.data.frame(sample_gene)
	rownames(sample_gene) <- sample_gene[,1]
	expData <- as.data.frame(sample_gene[,-1])
	# dim(expData)
	# head(expData, 10)
	m.mad <- apply(expData,1,mad)
	expData <- expData[which(m.mad >
													 	max(quantile(m.mad,
													 							 probs = seq(0, 1, 0.25))[2],0.01)),]
	expData <- t(expData)

	group_sample <- as.data.frame(group_sample)
	rownames(group_sample) <- group_sample[,1]
	groupData <- as.data.frame(group_sample[,-1])
	colnames(groupData) <- "Groups"

	gsg = WGCNA::goodSamplesGenes(expData, verbose = 3);
	gsg$allOK

	treeType <- "phylogenic"
	# ChoiceBox: "rectangle", "circular", "phylogenic"

	cor <- WGCNA::cor

	powers <- c(seq(1, 10, by = 1), seq(12, 20, by = 2))
	sft = pickSoftThreshold(expData,
													dataIsExpr = TRUE,
													weights = NULL,
													RsquaredCut = R_cutofff,
													powerVector = powers,
													removeFirst = FALSE,
													corFnc = cor,
													networkType = "unsigned",
													moreNetworkConcepts = FALSE,
													gcInterval = NULL,
													verbose = 5,
													indent = 0
	)
	# Figure3
	# sizeGrWindow(9, 5)
	# par(mfrow = c(1,2))
	pdf(file = paste(results_dir, "1.SoftPower.pdf", sep = "/"),
			width = 10, height = 7
	)
	plot(sft$fitIndices[,1],
			 -sign(sft$fitIndices[,3])*sft$fitIndices[,2],
			 xlab = "Soft Threshold (power)",
			 ylab = "Scale Free Topology Model Fit,signed R^2",
			 type = "l",
			 lwd = 2,
			 col = "#ff000088",
			 main = paste("Scale independence")
	)
	text(sft$fitIndices[,1],
			 -sign(sft$fitIndices[,3])*sft$fitIndices[,2],
			 labels = powers,
			 cex = 1.2,
			 col = "red"
	)
	abline(h = 0.90,
				 col = "#ff000088",
				 lwd = 2)

	# plot(sft$fitIndices[,1],
	#      sft$fitIndices[,5],
	#      xlab="Soft Threshold (power)",
	#      ylab="Mean Connectivity",
	#      type="l",
	#      lwd=2,
	#      col="#ff000088",
	#      main = paste("Mean connectivity")
	#      )
	# text(sft$fitIndices[,1],
	#      sft$fitIndices[,5],
	#      labels=powers,
	#      cex=1.2,
	#      col="red"
	#      )
	dev.off()


	jpeg(filename = paste(results_dir, "1.SoftPower.jpg", sep = "/"),
			 width = 10,
			 height = 7,
			 units = "in",
			 res = 300,
			 quality = 100)
	plot(sft$fitIndices[,1],
			 -sign(sft$fitIndices[,3])*sft$fitIndices[,2],
			 xlab = "Soft Threshold (power)",
			 ylab = "Scale Free Topology Model Fit,signed R^2",
			 type = "l",
			 lwd = 2,
			 col = "#ff000088",
			 main = paste("Scale independence")
	)
	text(sft$fitIndices[,1],
			 -sign(sft$fitIndices[,3])*sft$fitIndices[,2],
			 labels = powers,
			 cex = 1.2,
			 col = "red"
	)
	abline(h = 0.90,
				 col = "#ff000088",
				 lwd = 2)

	# plot(sft$fitIndices[,1],
	#      sft$fitIndices[,5],
	#      xlab="Soft Threshold (power)",
	#      ylab="Mean Connectivity",
	#      type="l",
	#      lwd=2,
	#      col="#ff000088",
	#      main = paste("Mean connectivity")
	# )
	# text(sft$fitIndices[,1],
	#      sft$fitIndices[,5],
	#      labels=powers,
	#      cex=1.2,
	#      col="red"
	# )
	dev.off()

	bwnet = blockwiseModules(expData,
													 power = sft$powerEstimate,
													 maxBlockSize = max_block,
													 TOMType = "unsigned",
													 minModuleSize = min_module,
													 networkType = network_type,
													 reassignThreshold = 0,
													 mergeCutHeight = merge_cutoff,
													 numericLabels = TRUE,
													 pamRespectsDendro = FALSE,
													 saveTOMs = TRUE,
													 corType = cor_type,
													 loadTOM = FALSE,
													 TOMDenom = "min",
													 deepSplit = 1,
													 stabilityCriterion = "Individual fraction",
													 saveTOMFileBase = paste(results_dir, "TOM.tom", sep = "/"),
													 verbose = 5,
													 randomSeed = 123
	)
	# table(bwnet$colors)

	moduleLabels = bwnet$colors
	moduleColors = labels2colors(moduleLabels,
															 zeroIsGrey = TRUE,
															 # colorSeq = pal_igv(palette = c("default", "alternating"), alpha = 0.90)(51),
															 colorSeq = NULL,
															 naColor = na_color,
															 commonColorCode = TRUE
	)
	# table(moduleColors)
	module_gene <- data.frame(Module = names(table(moduleColors)),
														Genes = table(moduleColors)[names(table(moduleColors))]
	)
	write.table(module_gene,
							file = paste(results_dir, "1.ModuleGene.txt", sep = "/"),
							sep = "\t",
							quote = F,
							row.names = F
	)

	# Figure4
	pdf(file = paste(results_dir, "2.SamplesModules.pdf", sep = "/"),
			width = 10, height = 7
	)
	plotDendroAndColors(bwnet$dendrograms[[1]],
											moduleColors[bwnet$blockGenes[[1]]],
											"Module colors",
											dendroLabels = FALSE,
											hang = 0.03,
											addGuide = TRUE,
											guideHang = 0.05
	)
	dev.off()

	jpeg(filename = paste(results_dir, "2.SamplesModules.jpg", sep = "/"),
			 width = 10,
			 height = 7,
			 units = "in",
			 res = 300,
			 quality = 100)
	plotDendroAndColors(bwnet$dendrograms[[1]],
											moduleColors[bwnet$blockGenes[[1]]],
											"Module colors",
											dendroLabels = FALSE,
											hang = 0.03,
											addGuide = TRUE,
											guideHang = 0.05
	)
	dev.off()

	gene_module <- data.frame(ID = colnames(expData),
														module = moduleColors)
	gene_module = gene_module[order(gene_module$module),]
	write.table(gene_module,
							file = paste(results_dir, "2.GeneModule.txt", sep = "/"),
							sep = "\t",
							quote = F,
							row.names = F
	)

	MEs = bwnet$MEs
	MEs_col = MEs
	colnames(MEs_col) = paste0("ME", labels2colors(
		as.numeric(str_replace_all(colnames(MEs),"ME","")))
	)
	MEs_col = orderMEs(MEs_col)

	MEs_colt = as.data.frame(t(MEs_col))
	colnames(MEs_colt) = rownames(expData)
	write.table(MEs_colt,
							file = paste(results_dir, "3.ModuleEipgengene.txt", sep = "/"),
							sep = "\t",
							quote = F,
							row.names = F
	)

	# Figure5
	pdf(file = paste(results_dir, "3.ModulesModules.pdf", sep = "/"),
			width = 10, height = 7
	)
	plotEigengeneNetworks(MEs_col, "Eigengene adjacency heatmap",
												marDendro = c(3,3,2,4),
												marHeatmap = c(3,4,2,2),
												plotDendrograms = TRUE,
												plotHeatmaps = TRUE,
												setMargins = TRUE,
												colorLabels = TRUE,
												signed = TRUE,
												heatmapColors = blueWhiteRed(100),
												plotAdjacency = TRUE,
												printAdjacency = FALSE,
												cex.adjacency = 0.9,
												coloredBarplot = TRUE,
												barplotMeans = TRUE,
												barplotErrors = FALSE,
												plotPreservation = "standard",
												zlimPreservation = c(0, 1),
												printPreservation = FALSE,
												cex.preservation = 0.9,
												xLabelsAngle = 90
	)
	dev.off()

	jpeg(filename = paste(results_dir, "3.ModulesModules.jpg", sep = "/"),
			 width = 10,
			 height = 7,
			 units = "in",
			 res = 300,
			 quality = 100)
	plotEigengeneNetworks(MEs_col, "Eigengene adjacency heatmap",
												marDendro = c(3,3,2,4),
												marHeatmap = c(3,4,2,2),
												plotDendrograms = TRUE,
												plotHeatmaps = TRUE,
												setMargins = TRUE,
												colorLabels = TRUE,
												signed = TRUE,
												heatmapColors = blueWhiteRed(100),
												plotAdjacency = TRUE,
												printAdjacency = FALSE,
												cex.adjacency = 0.9,
												coloredBarplot = TRUE,
												barplotMeans = TRUE,
												barplotErrors = FALSE,
												plotPreservation = "standard",
												zlimPreservation = c(0, 1),
												printPreservation = FALSE,
												cex.preservation = 0.9,
												xLabelsAngle = 90
	)
	dev.off()


	table(groupData$Groups)
	design = model.matrix(~0 + groupData$Groups)
	groupData$Groups <- as.factor(groupData$Groups)
	colnames(design) = levels(groupData$Groups)

	MEs0 = moduleEigengenes(expData, moduleColors)$eigengenes
	MEs = orderMEs(MEs0)

	moduleTraitCor = cor(MEs, design , use = "p")
	moduleTraitPvalue = corPvalueStudent(moduleTraitCor,
																			 nrow(expData)
	)

	# Figure6
	# sizeGrWindow(10,6)
	textMatrix = paste(signif(moduleTraitCor, 2), " (",
										 signif(moduleTraitPvalue, 1), ")",
										 sep = ""
	)
	dim(textMatrix) = dim(moduleTraitCor)
	# par(mar = c(6, 8.5, 3, 3))
	pdf(file = paste(results_dir, "4.ModulesTraits.pdf", sep = "/"),
			width = 10, height = 7,
			bg = "white"
	)
	labeledHeatmap(Matrix = moduleTraitCor,
								 xLabels = colnames(design),
								 yLabels = names(MEs),
								 ySymbols = names(MEs),
								 checkColorsValid = TRUE,
								 invertColors = FALSE,
								 setStdMargins = TRUE,
								 xLabelsPosition = "bottom",
								 xLabelsAngle = xlab_angle,
								 xLabelsAdj = 1,
								 yLabelsPosition = "left",
								 xColorWidth = 2 * strheight("M"),
								 yColorWidth = 2 * strwidth("M"),
								 xColorOffset = strheight("M")/3,
								 yColorOffset = strwidth("M")/3,
								 colorLabels = FALSE,
								 colors = blueWhiteRed(100), # greenWhiteRed(50)
								 naColor = na_color,
								 textMatrix = textMatrix,
								 cex.text = text_size,
								 zlim = c(-1,1),
								 plotLegend = TRUE,
								 legendLabel = "Pearson's correlation coefficient",
								 cex.legendLabel = 1,
								 main = paste("Module-trait relationships")
	)
	dev.off()

	jpeg(filename = paste(results_dir, "4.ModulesTraits.jpg", sep = "/"),
			 width = 10,
			 height = 7,
			 units = "in",
			 res = 300,
			 quality = 100)
	labeledHeatmap(Matrix = moduleTraitCor,
								 xLabels = colnames(design),
								 yLabels = names(MEs),
								 ySymbols = names(MEs),
								 checkColorsValid = TRUE,
								 invertColors = FALSE,
								 setStdMargins = TRUE,
								 xLabelsPosition = "bottom",
								 xLabelsAngle = xlab_angle,
								 xLabelsAdj = 1,
								 yLabelsPosition = "left",
								 xColorWidth = 2 * strheight("M"),
								 yColorWidth = 2 * strwidth("M"),
								 xColorOffset = strheight("M")/3,
								 yColorOffset = strwidth("M")/3,
								 colorLabels = FALSE,
								 colors = blueWhiteRed(100), # greenWhiteRed(50)
								 naColor = na_color,
								 textMatrix = textMatrix,
								 cex.text = text_size,
								 zlim = c(-1,1),
								 plotLegend = TRUE,
								 legendLabel = "Pearson's correlation coefficient",
								 cex.legendLabel = 1,
								 main = paste("Module-trait relationships")
	)
	dev.off()
	}

	return(pipeline())
	invisible()
}
