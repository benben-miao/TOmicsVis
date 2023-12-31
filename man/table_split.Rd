% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/table_split.R
\name{table_split}
\alias{table_split}
\title{Table split used for splitting a grouped column to multiple columns.}
\usage{
table_split(
  data,
  grouped_var = "go_category",
  value_var = "go_term",
  miss_drop = TRUE
)
}
\arguments{
\item{data}{Dataframe: GO and KEGG annotation of background genes (1st-col: Genes, 2nd-col: biological_process, 3rd-col: cellular_component, 4th-col: molecular_function, 5th-col: kegg_pathway).}

\item{grouped_var}{Character: grouped column name. Default: "go_category".}

\item{value_var}{Character: value column name. Default: "go_term".}

\item{miss_drop}{Logical: drop missing values or NA values. Default: TRUE, options: TRUE, FALSE.}
}
\value{
Table: table split used for splitting a grouped column to multiple columns.
}
\description{
Table split used for splitting a grouped column to multiple columns.
}
\examples{
# 1. Library TOmicsVis package
library(TOmicsVis)

# 2. Use example dataset
data(gene_go_kegg2)
head(gene_go_kegg2)

# 3. Default parameters
res <- table_split(gene_go_kegg2)
head(res)

}
\author{
benben-miao
}
