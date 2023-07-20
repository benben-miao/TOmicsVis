#' @title Heatmap cluster for visualizing clustered gene expression data.
#' @description Heatmap cluster for visualizing clustered gene expression data.
#' @author wei dong
#'
#' @return Plot: Heatmap cluster for visualizing clustered gene expression data.
#' @param data Dataframe: gene expression dataframe with cols (samples) and rows (genes).
#' @param dist_method Character: distance measure method. Default: "euclidean", options: "euclidean", "maximum", "manhattan", "canberra", "binary" or "minkowski".
#' @param hc_method Character: hierarchical clustering method. Default: "average", options: "ward.D", "ward.D2", "single", "complete","average" (= UPGMA), "mcquitty" (= WPGMA), "median" (= WPGMC) or "centroid" (= UPGMC).
#' @param k_num Numeric: the number of groups for cutting the tree. Default: 5.
#' @param show_rownames Logical: boolean specifying if column names are be shown. Default: FALSE, options: TRUE or FALSE.
#' @param palette Character: color palette used in heatmap. Default: "Spectral", options: 'Spectral', 'BrBG', 'PiYG', 'PRGn', 'PuOr', 'RdBu', 'RdGy', 'RdYlBu', 'RdYlGn'.
#' @param cluster_pal Character: color palette used for the cluster. Default: "Set1", options: 'Set1', 'Set2', 'Set3', 'Accent', 'Dark2', 'Paired', 'Pastel1', 'Pastel2'.
#' @param gaps_col Character: vector of columns indices that show where to put gaps into heatmap. Default: "NULL".
#' @param angle_col Numeric: angle of the column labels. Default: 45.
#' @param label_size Numeric: fontsize for the plot. Default: 10, min: 0.
#' @param base_size Numeric: base font size. Default: 12, min: 0.
#'
#' @import ggplot2
#' @import pheatmap
#' @importFrom RColorBrewer brewer.pal
#' @importFrom grDevices colorRampPalette
#' @importFrom reshape2 melt
#' @importFrom ggplotify as.ggplot
#' @importFrom cowplot plot_grid
#' @importFrom stats sd
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset gene_exp
#' data(gene_exp2)
#' head(gene_exp2)
#'
#' # 3. Default parameters
#' heatmap_cluster(gene_exp2)
#'
#' # 4. Set palette = "RdBu"
#' heatmap_cluster(gene_exp2, palette = "RdBu")
#'
#' # 5. Set cluster_pal = "Accent"
#' heatmap_cluster(gene_exp2, cluster_pal = "Accent")
#'
heatmap_cluster <- function(data,
                            dist_method = "euclidean",
                            hc_method = "average",
                            k_num = 5,
														show_rownames = FALSE,
                            palette = "Spectral",
                            cluster_pal = "Set1",
                            gaps_col = NULL,
                            angle_col = 45,
                            label_size = 10,
                            base_size = 12
                            ){

  # -> 2. NA and Duplicated
  data <- as.data.frame(data)

  # Define ZScore function
  ZScore <- function(x){
    return((x - mean(x)) / sd(x))
  }

  # Row Z-Score normalization
  data <- t(apply(data, 1, ZScore))
  # <- 2. NA and Duplicated

  # -> 3. Plot parameters
  # dist_method <- "euclidean"
  # ChoiceBox: "euclidean", "maximum", "manhattan", "canberra", "binary" or "minkowski"

  # hc_method <- "average"
  # ChoiceBox: "ward.D", "ward.D2", "single", "complete", "average" (= UPGMA), "mcquitty" (= WPGMA), "median" (= WPGMC) or "centroid" (= UPGMC)

  # k_num = 5
  # palette = "Spectral"
  # cluster_pal = "Set1"
  # label_size = 10
  # base_size = 12
  # angle_col = 45

  # set the color palettes
  # The diverging palettes are: BrBG PiYG PRGn PuOr RdBu RdGy RdYlBu RdYlGn Spectral
  palettes <- rev(RColorBrewer::brewer.pal(8, palette))
  colors <- grDevices::colorRampPalette(palettes)(100)
  # <- 3. Plot parameters

  p <- pheatmap::pheatmap(data, cluster_cols = F,
                          cutree_rows = k_num, show_rownames = show_rownames,
                          clustering_distance_rows = dist_method,
                          clustering_method = hc_method)

  row_cluster = stats::cutree(p$tree_row, k = k_num)
  newOrder = as.data.frame(data[p$tree_row$order,])
  newOrder$Cluster = paste0("C", row_cluster[match(rownames(newOrder), names(row_cluster))])
  row_annot <- data.frame(Cluster = newOrder$Cluster, row.names = rownames(newOrder))
  # The qualitative palettes are: Accent Dark2 Paired Pastel1 Pastel2 Set1 Set2 Set3
  cluster_colors <- RColorBrewer::brewer.pal(length(unique(newOrder$Cluster)), cluster_pal)
  names(cluster_colors) <- unique(newOrder$Cluster)
  ann_colors <- list(Cluster = cluster_colors)

  # plot heatmap
  p1 <- pheatmap::pheatmap(data, cluster_cols = F,
                           cutree_rows = k_num,
                           gaps_col = gaps_col,
                           fontsize = label_size,
                           clustering_distance_rows = dist_method,
                           clustering_method = hc_method,
                           annotation_row = row_annot,
  												 show_rownames = show_rownames,
                           color = colors, annotation_colors = ann_colors,
                           angle_col = angle_col, border_color = "white")

  newOrder$gene = rownames(newOrder)
  data_new = reshape2::melt(newOrder,variable.name = "Sample", value.name = "Expression")
  data_new$Cluster <- factor(data_new$Cluster, levels = unique(data_new$Cluster))

  # plot line trend
  p2 <- ggplot2::ggplot(data_new,
                        aes_string("Sample", "Expression", group = "gene")) +
    geom_line(color = "gray90",size = 0.8) +
    geom_hline(yintercept = 0,linetype = 2) +
    stat_summary(aes(group = 1), fun.y = mean, geom = "line", size = 1.2, color = "#c51b7d") +
    facet_wrap(Cluster~., ncol = 1) +
    theme_bw(base_size = base_size) +
    theme(panel.grid = element_blank(),
          axis.text = element_text(size = label_size),
          axis.text.x = element_text(angle = angle_col, hjust = 1),
          strip.text = element_text(size = label_size, face = "bold"))

  p1 <- ggplotify::as.ggplot(p1)
  p <- cowplot::plot_grid(p1, p2, align = "hv",
                          rel_widths = c(3, 1),
                          labels = "auto")

  return(p)
}
