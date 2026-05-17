test_that("umap_plot input validation works", {
  data(gene_expression)
  data(samples_groups)
  
  expect_error(
    umap_plot("invalid", samples_groups),
    "'sample_gene' must be a data.frame or matrix"
  )
  
  expect_error(
    umap_plot(gene_expression, "not_data"),
    "'group_sample' must be a data.frame or matrix"
  )
})

test_that("umap_plot produces correct output with different parameters", {
  data(gene_expression)
  data(samples_groups)
  
  p_default <- umap_plot(gene_expression, samples_groups, seed = 123)
  expect_s3_class(p_default, "ggplot")
  
  p_simpsons <- umap_plot(gene_expression, samples_groups, 
                          sci_fill_color = "Sci_Simpsons", seed = 123)
  expect_s3_class(p_simpsons, "ggplot")
  
  p_no_shape <- umap_plot(gene_expression, samples_groups, 
                           multi_shape = FALSE, seed = 123)
  expect_s3_class(p_no_shape, "ggplot")
})
