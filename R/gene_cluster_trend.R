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
#' @import RColorBrewer
#' @import Biobase
#' @import e1071
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
                               cluster_num = 4
                               ){

  # create ExpressionSet object
  data <- as.data.frame(data)
  rownames(data) <- data[,1]
  data <- data[,-1]
  eset <- new("ExpressionSet", exprs = as.matrix(data))

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
  palettes <- RColorBrewer::brewer.pal(8, palette)
  colors <- rev(grDevices::colorRampPalette(palettes)(1000))

  # plot gene cluster trend
  p <- Mfuzz::mfuzz.plot(
    eset,
    cl,
    mfrow = c(2,(c/2 + 0.5)),
    colo = colors,
    time.labels = colnames(eset),
    new.window = FALSE)

  return(p)
}
