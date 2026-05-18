# Table merge used to merge multiple variables to on variable.

Table merge used to merge multiple variables to on variable.

## Usage

``` r
table_merge(
  data,
  merge_vars = c("biological_process", "cellular_component", "molecular_function"),
  new_var = "go_category",
  new_value = "go_term",
  na_remove = FALSE
)
```

## Arguments

- data:

  Dataframe: GO and KEGG annotation of background genes (1st-col: Genes,
  2nd-col: biological_process, 3rd-col: cellular_component, 4th-col:
  molecular_function, 5th-col: kegg_pathway).

- merge_vars:

  Vector: include merged variable (column) names. Default: c("Ozone",
  "Solar.R", "Wind", "Temp") in example data.

- new_var:

  Character: new variable (column) name. Default: "Variable".

- new_value:

  Character: new variable (column) value name. Default: "Value".

- na_remove:

  Logical: remove NA value. Default: FALSE, options: TRUE, FALSE.

## Value

Table: include multiple variables.

## Author

benben-miao

## Examples

``` r
# 1. Library TOmicsVis package
library(TOmicsVis)

# 2. Use example dataset
data(gene_go_kegg)
head(gene_go_kegg)
#>        Genes
#> 1        FN1
#> 2 14-3-3ZETA
#> 3       A1I3
#> 4        A2M
#> 5       AARS
#> 6       ABAT
#>                                                                                                 biological_process
#> 1 GO:0003181(atrioventricular valve morphogenesis);GO:0003128(heart field specification);GO:0001756(somitogenesis)
#> 2                                                                                                             <NA>
#> 3                                                                                                             <NA>
#> 4                                                                                                             <NA>
#> 5                                                                           GO:0006419(alanyl-tRNA aminoacylation)
#> 6                                                            GO:0009448(gamma-aminobutyric acid metabolic process)
#>                 cellular_component
#> 1 GO:0005576(extracellular region)
#> 2                             <NA>
#> 3  GO:0005615(extracellular space)
#> 4  GO:0005615(extracellular space)
#> 5            GO:0005737(cytoplasm)
#> 6                             <NA>
#>                                                                                                       molecular_function
#> 1                                                                                                                   <NA>
#> 2                                                                            GO:0019904(protein domain specific binding)
#> 3                                                                           GO:0004866(endopeptidase inhibitor activity)
#> 4                                                                           GO:0004866(endopeptidase inhibitor activity)
#> 5 GO:0004813(alanine-tRNA ligase activity);GO:0005524(ATP binding);GO:0000049(tRNA binding);GO:0008270(zinc ion binding)
#> 6                              GO:0003867(4-aminobutyrate transaminase activity);GO:0030170(pyridoxal phosphate binding)
#>                                                                                                                                                                                                                                kegg_pathway
#> 1                                                                                                   ko04810(Regulation of actin cytoskeleton);ko04510(Focal adhesion);ko04151(PI3K-Akt signaling pathway);ko04512(ECM-receptor interaction)
#> 2 ko04110(Cell cycle);ko04114(Oocyte meiosis);ko04390(Hippo signaling pathway);ko04391(Hippo signaling pathway -fly);ko04013(MAPK signaling pathway - fly);ko04151(PI3K-Akt signaling pathway);ko04212(Longevity regulating pathway - worm)
#> 3                                                                                                                                                                                              ko04610(Complement and coagulation cascades)
#> 4                                                                                                                                                                                              ko04610(Complement and coagulation cascades)
#> 5                                                                                                                                                                                                      ko00970(Aminoacyl-tRNA biosynthesis)
#> 6         ko00250(Alanine, aspartate and glutamate metabolism);ko00280(Valine, leucine and isoleucine degradation);ko00650(Butanoate metabolism);ko00640(Propanoate metabolism);ko00410(beta-Alanine metabolism);ko04727(GABAergic synapse)

# 3. Default parameters
res <- table_merge(gene_go_kegg)
head(res)
#> # A tibble: 6 × 4
#>   Genes      kegg_pathway                                    go_category go_term
#>   <chr>      <chr>                                           <chr>       <chr>  
#> 1 FN1        ko04810(Regulation of actin cytoskeleton);ko04… biological… GO:000…
#> 2 FN1        ko04810(Regulation of actin cytoskeleton);ko04… cellular_c… GO:000…
#> 3 FN1        ko04810(Regulation of actin cytoskeleton);ko04… molecular_… NA     
#> 4 14-3-3ZETA ko04110(Cell cycle);ko04114(Oocyte meiosis);ko… biological… NA     
#> 5 14-3-3ZETA ko04110(Cell cycle);ko04114(Oocyte meiosis);ko… cellular_c… NA     
#> 6 14-3-3ZETA ko04110(Cell cycle);ko04114(Oocyte meiosis);ko… molecular_… GO:001…

# 4. Set new_var = "GO", new_value = "Terms"
res <- table_merge(gene_go_kegg, new_var = "GO", new_value = "Terms")
head(res)
#> # A tibble: 6 × 4
#>   Genes      kegg_pathway                                            GO    Terms
#>   <chr>      <chr>                                                   <chr> <chr>
#> 1 FN1        ko04810(Regulation of actin cytoskeleton);ko04510(Foca… biol… GO:0…
#> 2 FN1        ko04810(Regulation of actin cytoskeleton);ko04510(Foca… cell… GO:0…
#> 3 FN1        ko04810(Regulation of actin cytoskeleton);ko04510(Foca… mole… NA   
#> 4 14-3-3ZETA ko04110(Cell cycle);ko04114(Oocyte meiosis);ko04390(Hi… biol… NA   
#> 5 14-3-3ZETA ko04110(Cell cycle);ko04114(Oocyte meiosis);ko04390(Hi… cell… NA   
#> 6 14-3-3ZETA ko04110(Cell cycle);ko04114(Oocyte meiosis);ko04390(Hi… mole… GO:0…
```
