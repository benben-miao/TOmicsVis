test_that("volcano_plot input validation works", {
  data(degs_stats)
  
  expect_error(
    volcano_plot("not_a_dataframe"),
    "Input must be a data.frame or matrix"
  )
  
  expect_error(
    volcano_plot(degs_stats[, 1:2]),
    "Data must have at least 4 columns"
  )
  
  expect_error(
    volcano_plot(degs_stats, pq_value = "invalid"),
    "pq_value must be 'pvalue' or 'padj'"
  )
  
  expect_error(
    volcano_plot(degs_stats, point_shape = "invalid_shape"),
    "Invalid point_shape"
  )
  
  p <- volcano_plot(degs_stats)
  expect_s3_class(p, "ggplot")
})

test_that("volcano_plot produces correct output", {
  data(degs_stats)
  
  p <- volcano_plot(degs_stats)
  expect_s3_class(p, "ggplot")
  
  p_custom <- volcano_plot(degs_stats, 
                          color_Log2fc_p = "#ff8800",
                          boxed_labels = TRUE,
                          draw_connectors = TRUE)
  expect_s3_class(p_custom, "ggplot")
})
