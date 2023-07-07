#' @title flower plot for stat common and unique gene among multiple sets.
#' @description flower plot for stat common and unique gene among multiple sets.
#' @author wei dong
#'
#' @return Plot: flower plot for stat common and unique gene among multiple sets.
#' @param data Dataframe: multiple gene sets as columns.
#' @param angle Number: set the angle of rotation in degress. Default: 90.
#' @param a Number: set the radii of the ellipses along the x-axes. Default: 0.5.
#' @param b Number: set the radii of the ellipses along the y-axes. Default: 2.
#' @param r Number: set the radius of the circle. Default: 1.
#' @param ellipse_col_pal Character: set the color palette for filling the ellipse. Default: "Spectral", options: 'Spectral', 'Set1', 'Set2', 'Set3', 'Accent', 'Dark2', 'Paired', 'Pastel1', 'Pastel2'..
#' @param circle_col Character: set the color for filling the circle. Default: "white".
#' @param label_text_cex Number: set the label text cex. Default: 1.
#'
#' @import plotrix
#' @import RColorBrewer
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset venn_data
#' data(venn_data)
#' head(venn_data)
#'
#' # 3. Default parameters
#' flower_plot(venn_data)
#'
#' # 4. Set angle = 60
#' flower_plot(venn_data, angle = 60)
#'
#' # 5. Set ellipse_col_pal = "Spectral"
#' flower_plot(venn_data, ellipse_col_pal = "Spectral")
#'
#' # 6. Set a = 1, b = 2, r = 1
#' flower_plot(venn_data, a = 1, b = 2, r = 1, ellipse_col_pal = "Set2")
#'
#' # 7. Set circle_col = "red", label_text_cex = 1.5
#' flower_plot(venn_data, circle_col = "red", label_text_cex = 1.5, ellipse_col_pal = "Set3")
#'
flower_plot <- function(flower_dat, angle = 90,
                        a = 0.5, b = 2, r = 1,
                        ellipse_col_pal = "Spectral",
                        circle_col = "white",
                        label_text_cex = 1
                        ){
  
  set_name <- colnames(flower_dat)
  item_id <- unique(flower_dat[,1])
  item_id <- item_id[item_id != '']
  core_item_id <- item_id
  item_num <- length(item_id)
  
  for (i in 2:ncol(flower_dat)) {
    item_id <- unique(flower_dat[,i])
    item_id <- item_id[item_id != '']
    core_item_id <- intersect(core_item_id, item_id)
    item_num <- c(item_num, length(item_id))
  }
  core_num <- length(core_item_id)
  
  graphics::par( bty = 'n', ann = F, xaxt = 'n', yaxt = 'n', mar = c(1,1,1,1))
  graphics::plot(c(0,10), c(0,10), type='n')
  n   <- length(set_name)
  # set the angle of degress
  deg <- 360 / n
  # set the ellipse filling color
  colors <- RColorBrewer::brewer.pal(8, ellipse_col_pal)
  ellipse_col <- grDevices::colorRampPalette(colors)(n)
  
  res <- lapply(1:n, function(t){
    plotrix::draw.ellipse(x = 5 + cos((angle + deg * (t - 1)) * pi / 180),
                          y = 5 + sin((angle + deg * (t - 1)) * pi / 180),
                          col = ellipse_col[t],
                          border = ellipse_col[t],
                          a = a, b = b,
                          angle = deg * (t - 1))
    graphics::text(x = 5 + 2.5 * cos((angle + deg * (t - 1)) * pi / 180),
                   y = 5 + 2.5 * sin((angle + deg * (t - 1)) * pi / 180),
                   item_num[t])
    
    if (deg * (t - 1) < 180 && deg * (t - 1) > 0 ) {
      graphics::text(x = 5 + 3.3 * cos((angle + deg * (t - 1)) * pi / 180),
                     y = 5 + 3.3 * sin((angle + deg * (t - 1)) * pi / 180),
                     set_name[t],
                     srt = deg * (t - 1) - angle,
                     adj = 1,
                     cex = label_text_cex
      )
    } else {
      graphics::text(x = 5 + 3.3 * cos((angle + deg * (t - 1)) * pi / 180),
                     y = 5 + 3.3 * sin((angle + deg * (t - 1)) * pi / 180),
                     set_name[t],
                     srt = deg * (t - 1) + angle,
                     adj = 0,
                     cex = label_text_cex
      )
    }
  })
  plotrix::draw.circle(x = 5, y = 5, r = r, col = circle_col, border = NA)
  graphics::text(x = 5, y = 5, paste('Core items:', core_num), cex = label_text_cex)
}