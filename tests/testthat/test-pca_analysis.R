test_that("pca_analysis input validation works", {
  data(gene_expression)
  data(samples_groups)
  
  expect_error(
    pca_analysis("not_data", samples_groups),
    "'sample_gene' must be a data.frame or matrix"
  )
  
  expect_error(
    pca_analysis(gene_expression, "not_data"),
    "'group_sample' must be a data.frame or matrix"
  )
  
  expect_error(
    pca_analysis(gene_expression[, 1, drop = FALSE], samples_groups),
    "sample_gene must have at least 2 columns"
  )

  expect_error(
    pca_analysis(gene_expression, samples_groups[, 1, drop = FALSE]),
    "group_sample must have at least 2 columns"
  )
})

test_that("pca_analysis produces correct output", {
  data(gene_expression)
  data(samples_groups)
  
  res <- pca_analysis(gene_expression, samples_groups)
  expect_s3_class(res, "data.frame")
  expect_true(ncol(res) >= 2)
  expect_true(nrow(res) > 0)
})
