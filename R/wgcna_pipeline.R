#' @title WGCNA analysis pipeline for RNA-Seq.
#' @description WGCNA analysis pipeline for RNA-Seq.
#' @author benben-miao
#'
#' @param wgcna_gene_exp Dataframe: include gene expression data.
#' @param wgcna_sample_group Dataframe: include samples and groups data.
#'
#' @import WGCNA
#' @import dplyr
#' @import reshape2
#' @import stringr
#' @import ggsci
#' @import factoextra
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset
#' data(wgcna_gene_exp)
#'
#' data(wgcna_sample_group)
#'
#' # 3. Default parameters
#' # wgcna_pipeline(wgcna_gene_exp, wgcna_sample_group)
#'
wgcna_pipeline <- function(wgcna_gene_exp,
													 wgcna_sample_group
													){
	dir.create("WGCNA")
	tempdir <- "WGCNA"

	expData <- wgcna_gene_exp
	# dim(expData)
	# head(expData, 10)
	m.mad <- apply(expData,1,mad)
	expData <- expData[which(m.mad >
													 	max(quantile(m.mad,
													 							 probs = seq(0, 1, 0.25))[2],0.01)),]
	expData <- t(expData)

	groupData <- wgcna_sample_group

	gsg = goodSamplesGenes(expData, verbose = 3);
	gsg$allOK

	treeType <- "phylogenic"
	# ChoiceBox: "rectangle", "circular", "phylogenic"

	cor <- WGCNA::cor

	powers <- c(seq(1, 10, by = 1), seq(12, 20, by = 2))
	sft = pickSoftThreshold(expData,
													dataIsExpr = TRUE,
													weights = NULL,
													RsquaredCut = 0.85,
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
	pdf(file = paste(tempdir, "1.SoftPower.pdf", sep = "/"),
			width = 10, height = 7,
			family = "Times"
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


	jpeg(filename = paste(tempdir, "1.SoftPower.jpg", sep = "/"),
			 width = 10,
			 height = 7,
			 units = "in",
			 res = 300,
			 quality = 100,
			 family = "Times")
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
													 # maxBlockSize = 2500,
													 TOMType = "unsigned",
													 minModuleSize = 25,
													 networkType = "unsigned",
													 reassignThreshold = 0,
													 mergeCutHeight = 0.25,
													 numericLabels = TRUE,
													 pamRespectsDendro = FALSE,
													 saveTOMs = TRUE,
													 corType = "pearson",
													 loadTOM = FALSE,
													 TOMDenom = "min",
													 deepSplit = 1,
													 stabilityCriterion = "Individual fraction",
													 saveTOMFileBase = paste(tempdir, "TOM.tom", sep = "/"),
													 verbose = 5,
													 randomSeed = 123
	)
	# table(bwnet$colors)

	moduleLabels = bwnet$colors
	moduleColors = labels2colors(moduleLabels,
															 zeroIsGrey = TRUE,
															 # colorSeq = pal_igv(palette = c("default", "alternating"), alpha = 0.90)(51),
															 colorSeq = NULL,
															 naColor = "grey",
															 commonColorCode = TRUE
	)
	# table(moduleColors)
	module_gene <- data.frame(Module = names(table(moduleColors)),
														Genes = table(moduleColors)[names(table(moduleColors))]
	)
	write.table(module_gene,
							file = paste(tempdir, "1.ModuleGene.txt", sep = "/"),
							sep = "\t",
							quote = F,
							row.names = F
	)

	# Figure4
	pdf(file = paste(tempdir, "2.SamplesModules.pdf", sep = "/"),
			width = 10, height = 7,
			family = "Times"
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

	jpeg(filename = paste(tempdir, "2.SamplesModules.jpg", sep = "/"),
			 width = 10,
			 height = 7,
			 units = "in",
			 res = 300,
			 quality = 100,
			 family = "Times")
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
							file = paste(tempdir, "2.GeneModule.txt", sep = "/"),
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
							file = paste(tempdir, "3.ModuleEipgengene.txt", sep = "/"),
							sep = "\t",
							quote = F,
							row.names = F
	)

	# Figure5
	pdf(file = paste(tempdir, "3.ModulesModules.pdf", sep = "/"),
			width = 10, height = 7,
			family = "Times"
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

	jpeg(filename = paste(tempdir, "3.ModulesModules.jpg", sep = "/"),
			 width = 10,
			 height = 7,
			 units = "in",
			 res = 300,
			 quality = 100,
			 family = "Times")
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


	table(groupData$Group)
	design = model.matrix(~0 + groupData$Group)
	colnames(design) = levels(groupData$Group)

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
	pdf(file = paste(tempdir, "4.ModulesTraits.pdf", sep = "/"),
			width = 10, height = 7,
			bg = "white",
			family = "Times"
	)
	labeledHeatmap(Matrix = moduleTraitCor,
								 xLabels = colnames(design),
								 yLabels = names(MEs),
								 ySymbols = names(MEs),
								 checkColorsValid = TRUE,
								 invertColors = FALSE,
								 setStdMargins = TRUE,
								 xLabelsPosition = "bottom",
								 xLabelsAngle = 0,
								 xLabelsAdj = 1,
								 yLabelsPosition = "left",
								 xColorWidth = 2 * strheight("M"),
								 yColorWidth = 2 * strwidth("M"),
								 xColorOffset = strheight("M")/3,
								 yColorOffset = strwidth("M")/3,
								 colorLabels = FALSE,
								 colors = blueWhiteRed(100), # greenWhiteRed(50)
								 textMatrix = textMatrix,
								 cex.text = 0.7,
								 zlim = c(-1,1),
								 plotLegend = TRUE,
								 legendLabel = "",
								 cex.legendLabel = 1,
								 main = paste("Module-trait relationships")
	)
	dev.off()

	jpeg(filename = paste(tempdir, "4.ModulesTraits.jpg", sep = "/"),
			 width = 10,
			 height = 7,
			 units = "in",
			 res = 300,
			 quality = 100,
			 family = "Times")
	labeledHeatmap(Matrix = moduleTraitCor,
								 xLabels = colnames(design),
								 yLabels = names(MEs),
								 ySymbols = names(MEs),
								 checkColorsValid = TRUE,
								 invertColors = FALSE,
								 setStdMargins = TRUE,
								 xLabelsPosition = "bottom",
								 xLabelsAngle = 0,
								 xLabelsAdj = 1,
								 yLabelsPosition = "left",
								 xColorWidth = 2 * strheight("M"),
								 yColorWidth = 2 * strwidth("M"),
								 xColorOffset = strheight("M")/3,
								 yColorOffset = strwidth("M")/3,
								 colorLabels = FALSE,
								 colors = blueWhiteRed(100), # greenWhiteRed(50)
								 textMatrix = textMatrix,
								 cex.text = 0.7,
								 zlim = c(-1,1),
								 plotLegend = TRUE,
								 legendLabel = "",
								 cex.legendLabel = 1,
								 main = paste("Module-trait relationships")
	)
	dev.off()
}
