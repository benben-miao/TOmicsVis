#' @title Table cross used to cross search and merge results in two tables.
#' @description Table cross used to cross search and merge results in two tables.
#' @author benben-miao
#'
#' @return Table: include multiple columns.
#' @param data1 Dataframe: Shared DEGs of all paired comparisons in all samples expression dataframe of RNA-Seq. (1st-col: Genes, 2nd-col~: Samples).
#' @param data2 Dataframe: GO and KEGG annotation of background genes (1st-col: Genes, 2nd-col: biological_process, 3rd-col: cellular_component, 4th-col: molecular_function, 5th-col: kegg_pathway).
#' @param inter_var Character: Intersecting variable (column name). Default: "geneID" in example data.
#' @param left_index Logical: left table as index. Default: TRUE, options: TRUE, FALSE.
#' @param right_index Logical: right table as index. Default: FALSE, options: TRUE, FALSE.
#'
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset
#' data(gene_expression2)
#' head(gene_expression2)
#'
#' data(gene_go_kegg)
#' head(gene_go_kegg)
#'
#' # 3. Default parameters
#' res <- table_cross(gene_expression2, gene_go_kegg, inter_var = "Genes")
#' head(res)
#'
#' # 4. Set left_index = TRUE, right_index = FALSE
#' res <- table_cross(gene_expression2, gene_go_kegg,
#' inter_var = "Genes", left_index = TRUE, right_index = FALSE)
#' head(res)
#'
#' # 5. Set left_index = FALSE, right_index = TRUE
#' res <- table_cross(gene_expression2, gene_go_kegg,
#' inter_var = "Genes", left_index = FALSE, right_index = TRUE)
#' head(res)
#'
table_cross <- function(data1, data2,
												inter_var = "Genes",
												left_index = TRUE,
												right_index = TRUE
												){
	res <- merge(x = data1,
							 y = data2,
							 by = inter_var,
							 all.x = left_index,
							 all.y = right_index
							 )

	return(res)
	invisible()
}
