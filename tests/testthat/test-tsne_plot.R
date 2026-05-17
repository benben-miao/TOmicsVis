test_that("tsne_plot input validation works", {
  data(gene_expression)
  data(samples_groups)
  
  expect_error(
    tsne_plot("invalid", samples_groups),
    "'sample_gene' must be a data.frame or matrix"
  )
  
  expect_error(
    tsne_plot(gene_expression, "not_data"),
    "'group_sample' must be a data.frame or matrix"
  )
})

test_that("tsne_plot produces correct output with different parameters", {
  data(gene_expression)
  data(samples_groups)
  
  p_default <- tsne_plot(gene_expression, samples_groups, seed = 123)
  expect_s3_class(p_default, "ggplot")
  
  p_npg <- tsne_plot(gene_expression, samples_groups, 
                      sci_fill_color = "Sci_NPG", seed = 123)
  expect_s3_class(p_npg, "ggplot")
  
  p_shape <- tsne_plot(gene_expression, samples_groups, 
                        multi_shape = TRUE, seed = 123)
  expect_s3_class(p_shape, "ggplot")
})
