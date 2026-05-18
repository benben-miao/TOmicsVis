# Table split used for splitting a grouped column to multiple columns.

Table split used for splitting a grouped column to multiple columns.

## Usage

``` r
table_split(
  data,
  grouped_var = "go_category",
  value_var = "go_term",
  miss_drop = TRUE
)
```

## Arguments

- data:

  Dataframe: GO and KEGG annotation of background genes (1st-col: Genes,
  2nd-col: biological_process, 3rd-col: cellular_component, 4th-col:
  molecular_function, 5th-col: kegg_pathway).

- grouped_var:

  Character: grouped column name. Default: "go_category".

- value_var:

  Character: value column name. Default: "go_term".

- miss_drop:

  Logical: drop missing values or NA values. Default: TRUE, options:
  TRUE, FALSE.

## Value

Table: table split used for splitting a grouped column to multiple
columns.

## Author

benben-miao

## Examples

``` r
# 1. Library TOmicsVis package
library(TOmicsVis)

# 2. Use example dataset
data(gene_go_kegg2)
head(gene_go_kegg2)
#>        Genes
#> 1        FN1
#> 2 14-3-3ZETA
#> 3       A1I3
#> 4        A2M
#> 5       AARS
#> 6       ABAT
#>                                                                                                                                                                                                                                kegg_pathway
#> 1                                                                                                   ko04810(Regulation of actin cytoskeleton);ko04510(Focal adhesion);ko04151(PI3K-Akt signaling pathway);ko04512(ECM-receptor interaction)
#> 2 ko04110(Cell cycle);ko04114(Oocyte meiosis);ko04390(Hippo signaling pathway);ko04391(Hippo signaling pathway -fly);ko04013(MAPK signaling pathway - fly);ko04151(PI3K-Akt signaling pathway);ko04212(Longevity regulating pathway - worm)
#> 3                                                                                                                                                                                              ko04610(Complement and coagulation cascades)
#> 4                                                                                                                                                                                              ko04610(Complement and coagulation cascades)
#> 5                                                                                                                                                                                                      ko00970(Aminoacyl-tRNA biosynthesis)
#> 6         ko00250(Alanine, aspartate and glutamate metabolism);ko00280(Valine, leucine and isoleucine degradation);ko00650(Butanoate metabolism);ko00640(Propanoate metabolism);ko00410(beta-Alanine metabolism);ko04727(GABAergic synapse)
#>          go_category
#> 1 biological_process
#> 2 biological_process
#> 3 biological_process
#> 4 biological_process
#> 5 biological_process
#> 6 biological_process
#>                                                                                                            go_term
#> 1 GO:0003181(atrioventricular valve morphogenesis);GO:0003128(heart field specification);GO:0001756(somitogenesis)
#> 2                                                                                                             <NA>
#> 3                                                                                                             <NA>
#> 4                                                                                                             <NA>
#> 5                                                                           GO:0006419(alanyl-tRNA aminoacylation)
#> 6                                                            GO:0009448(gamma-aminobutyric acid metabolic process)

# 3. Default parameters
res <- table_split(gene_go_kegg2)
head(res)
#> # A tibble: 6 × 5
#>   Genes kegg_pathway    biological_process cellular_component molecular_function
#>   <chr> <chr>           <chr>              <chr>              <chr>             
#> 1 FN1   ko04810(Regula… GO:0003181(atriov… GO:0005576(extrac… NA                
#> 2 AARS  ko00970(Aminoa… GO:0006419(alanyl… GO:0005737(cytopl… GO:0004813(alanin…
#> 3 ABAT  ko00250(Alanin… GO:0009448(gamma-… NA                 GO:0003867(4-amin…
#> 4 ACADL ko00071(Fatty … GO:0042758(long-c… NA                 GO:0050660(flavin…
#> 5 ACADM ko00280(Valine… GO:0006635(fatty … GO:0005739(mitoch… GO:0050660(flavin…
#> 6 ACMSD ko00380(Trypto… GO:1904985(negati… GO:0005829(cytoso… GO:0001760(aminoc…
```
