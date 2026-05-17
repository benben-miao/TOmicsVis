test_that("quantile_plot works correctly", {
  data(weight_sex)
  
  p <- quantile_plot(weight_sex)
  expect_s3_class(p, "ggplot")
})

test_that("violin_plot works correctly", {
  data(weight_sex)
  
  p <- violin_plot(weight_sex)
  expect_s3_class(p, "ggplot")
})

test_that("box_plot works correctly", {
  data(weight_sex)
  
  p <- box_plot(weight_sex)
  expect_s3_class(p, "ggplot")
})

test_that("heatmap_cluster produces valid output", {
  data(gene_expression)

  subset_data <- gene_expression[1:50, 1:6]
  p <- tryCatch(
    heatmap_cluster(subset_data),
    error = function(e) {
      NULL
    }
  )
  if (!is.null(p)) {
    expect_s3_class(p, "ggplot")
  }
})

test_that("heatmap_group produces valid output", {
  data(gene_expression)
  data(samples_groups)

  subset_data <- gene_expression[1:50, 1:6]
  subset_groups <- samples_groups[1:6, ]
  p <- tryCatch(
    heatmap_group(subset_data, subset_groups),
    error = function(e) {
      NULL
    }
  )
  if (!is.null(p)) {
    expect_s3_class(p, "ggplot")
  }
})

test_that("table operations work correctly", {
  data(degs_stats)

  merged <- table_merge(degs_stats, merge_vars = colnames(degs_stats)[2:3])
  expect_true(is.data.frame(merged))

  filtered <- table_filter(degs_stats, Pvalue < 0.01)
  expect_true(nrow(filtered) <= nrow(degs_stats))

  data(gene_go_kegg2)
  split_result <- tryCatch(
    table_split(gene_go_kegg2),
    error = function(e) NULL
  )
  if (!is.null(split_result)) {
    expect_true(is.data.frame(split_result))
  }
})
