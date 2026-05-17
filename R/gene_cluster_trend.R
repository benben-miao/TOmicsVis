#' @title Gene cluster trend plot for visualizing gene expression trend profile in multiple samples.
#' @description Gene cluster trend plot for visualizing gene expression trend profile in multiple samples.
#' @author wei dong
#'
#' @return Plot: Gene cluster trend plot for visualizing gene expression trend profile in multiple samples.
#' @param data Dataframe: Shared DEGs of all paired comparisons in all groups expression dataframe of RNA-Seq. (1st-col: Genes, 2nd-col~n-1-col: Groups, n-col: Pathways).
#' @param thres Number: set the threshold for excluding genes. Default: 0.25.
#' @param min_std Number: set the threshold for minimum standard deviation. Default: 0.2.
#' @param palette Character: set the color palette to be used for plotting. Default: "PiYG", options: 'Spectral', 'BrBG', 'PiYG', 'PRGn', 'PuOr', 'RdBu', 'RdGy', 'RdYlBu', 'RdYlGn'.
#' @param cluster_num Number: set the number of clusters. Default: 4.
#'
#' @importFrom Mfuzz filter.NA filter.std standardise mestimate mfuzz mfuzz.plot
#' @importFrom Biobase ExpressionSet exprs
#' @importFrom e1071 cmeans
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset gene_cluster_data
#' data(gene_expression3)
#' head(gene_expression3)
#'
#' # 3. Default parameters
#' gene_cluster_trend(gene_expression3[,-7])
#'
#' # 4. Set palette = "RdBu"
#' gene_cluster_trend(gene_expression3[,-7], palette = "RdBu")
#'
#' # 5. Set cluster_num = 6
#' gene_cluster_trend(gene_expression3[,-7], cluster_num = 6, palette = "Spectral")
#'
gene_cluster_trend <- function(data,
															 thres = 0.25,
															 min_std = 0.2,
															 palette = "PiYG",
															 cluster_num = 4) {

	if (!requireNamespace("Mfuzz", quietly = TRUE)) {
		stop("Package 'Mfuzz' is required for gene_cluster_trend().\n",
				 "Please install: BiocManager::install('Mfuzz')",
				 call. = FALSE)
	}

	# create ExpressionSet object
	data <- as.data.frame(data)
	rownames(data) <- data[, 1]
	data <- data[, -1]

	if (!requireNamespace("Biobase", quietly = TRUE)) {
		stop("Package 'Biobase' is required for gene_cluster_trend().\n",
				 "Please install: BiocManager::install('Biobase')",
				 call. = FALSE)
	}
	suppressPackageStartupMessages(suppressWarnings(require(Biobase, quietly = TRUE)))

	if (!requireNamespace("e1071", quietly = TRUE)) {
		stop("Package 'e1071' is required for gene_cluster_trend().\n",
				 "Please install: install.packages('e1071')",
				 call. = FALSE)
	}
	suppressPackageStartupMessages(suppressWarnings(require(e1071, quietly = TRUE)))

	exprs_data <- as.matrix(data)
	eset <- methods::new("ExpressionSet", exprs = exprs_data)

	# Data pre-processing
	eset <- Mfuzz::filter.NA(eset, thres = thres)
	#eset <- fill.NA(eset,mode="mean",k=10)
	eset <- Mfuzz::filter.std(eset, min.std = min_std, visu = F)

	# data normalization
	eset <- Mfuzz::standardise(eset)
	# set cluster number
	c <- cluster_num
	# estimate m value
	m <- Mfuzz::mestimate(eset)

	# perform mfuzz clustering
	cl <- Mfuzz::mfuzz(eset, centers = c, m = m)

	# set the color palettes
	# The diverging palettes are: BrBG PiYG PRGn PuOr RdBu RdGy RdYlBu RdYlGn Spectral
	palette_map <- list(
		"Spectral" = c("#9E0142", "#D53E4F", "#F46D43", "#FDAE61", "#FEE08B", "#FFFFBF", "#E6F598", "#ABDDA4", "#66C2A5", "#3288BD", "#5E4FA2"),
		"BrBG" = c("#543005", "#8C510A", "#BF812D", "#DFC27D", "#F6E8C3", "#F5F5F5", "#C7EAE5", "#80CDC1", "#35978F", "#01665E", "#003C30"),
		"PiYG" = c("#8E0152", "#C51B7D", "#DE77AE", "#F1B6DA", "#FDE0EF", "#F7F7F7", "#E6F5D0", "#B8E186", "#7FBC41", "#4D9221", "#276419"),
		"PRGn" = c("#40004B", "#762A83", "#9970AB", "#C2A5CF", "#E7D4E8", "#F7F7F7", "#D9F0D3", "#A6DBA0", "#5AAE61", "#1B7837", "#00441B"),
		"PuOr" = c("#7F3B08", "#B35806", "#E08214", "#FDB863", "#FEE0B6", "#F7F7F7", "#D8DAEB", "#B2ABD2", "#8073AC", "#542788", "#2D004B"),
		"RdBu" = c("#67001F", "#B2182B", "#D6604D", "#F4A582", "#FDDBC7", "#F7F7F7", "#D1E5F0", "#92C5DE", "#4393C3", "#2166AC", "#053061"),
		"RdGy" = c("#67001F", "#B2182B", "#D6604D", "#F4A582", "#FDDBC7", "#FFFFFF", "#E0E0E0", "#BABABA", "#878787", "#4D4D4D", "#1A1A1A"),
		"RdYlBu" = c("#A50026", "#D73027", "#F46D43", "#FDAE61", "#FEE090", "#FFFFBF", "#E0F3F8", "#ABD9E9", "#74ADD1", "#4575B4", "#313695"),
		"RdYlGn" = c("#A50026", "#D73027", "#F46D43", "#FDAE61", "#FEE08B", "#FFFFBF", "#D9EF8B", "#A6D96A", "#66BD63", "#1A9850", "#006837")
	)
	
	if (palette %in% names(palette_map)) {
		palettes <- palette_map[[palette]]
	} else {
		palettes <- palette_map[["PiYG"]]
	}
	colors <- rev(grDevices::colorRampPalette(palettes)(1000))

	# plot gene cluster trend
	p <- Mfuzz::mfuzz.plot(
		eset,
		cl,
		mfrow = c(2, (c / 2 + 0.5)),
		colo = colors,
		time.labels = colnames(eset),
		new.window = FALSE
	)

	return(p)
}
