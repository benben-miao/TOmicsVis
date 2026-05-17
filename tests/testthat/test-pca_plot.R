test_that("pca_plot input validation works", {
  data(gene_expression)
  data(samples_groups)
  
  expect_error(
    pca_plot("invalid", samples_groups),
    "'sample_gene' must be a data.frame or matrix"
  )
  
  expect_error(
    pca_plot(gene_expression, "not_data"),
    "'group_sample' must be a data.frame or matrix"
  )
})

test_that("pca_plot produces correct output with different themes", {
  data(gene_expression)
  data(samples_groups)
  
  p_default <- pca_plot(gene_expression, samples_groups)
  expect_s3_class(p_default, "ggplot")
  
  p_bw <- pca_plot(gene_expression, samples_groups, ggTheme = "theme_bw")
  expect_s3_class(p_bw, "ggplot")
  
  p_npg <- pca_plot(gene_expression, samples_groups, sci_fill_color = "Sci_NPG")
  expect_s3_class(p_npg, "ggplot")
  
  p_no_shape <- pca_plot(gene_expression, samples_groups, multi_shape = FALSE)
  expect_s3_class(p_no_shape, "ggplot")
})
