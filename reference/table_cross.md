# Table cross used to cross search and merge results in two tables.

Table cross used to cross search and merge results in two tables.

## Usage

``` r
table_cross(
  data1,
  data2,
  inter_var = "Genes",
  left_index = TRUE,
  right_index = TRUE
)
```

## Arguments

- data1:

  Dataframe: Shared DEGs of all paired comparisons in all samples
  expression dataframe of RNA-Seq. (1st-col: Genes, 2nd-col~: Samples).

- data2:

  Dataframe: GO and KEGG annotation of background genes (1st-col: Genes,
  2nd-col: biological_process, 3rd-col: cellular_component, 4th-col:
  molecular_function, 5th-col: kegg_pathway).

- inter_var:

  Character: Intersecting variable (column name). Default: "geneID" in
  example data.

- left_index:

  Logical: left table as index. Default: TRUE, options: TRUE, FALSE.

- right_index:

  Logical: right table as index. Default: FALSE, options: TRUE, FALSE.

## Value

Table: include multiple columns.

## Author

benben-miao

## Examples

``` r
# 1. Library TOmicsVis package
library(TOmicsVis)

# 2. Use example dataset
data(gene_expression2)
head(gene_expression2)
#>   Genes  CT_1    CT_2  CT_3 LT20_1 LT20_2 LT20_3 LT15_1 LT15_2 LT15_3 LT12_1
#> 1 ACAA2 24.50   39.83 55.38 114.11 159.32  96.88 169.56 464.84 182.66 116.08
#> 2  ACAN 14.97   18.71 10.30  71.23 142.67 213.54 253.15 320.80 104.15 174.02
#> 3  ADH1  1.54    1.56  2.04  14.95  13.60  15.87  12.80  17.74   6.06  10.97
#> 4  AHSG  0.00 1911.99  0.00   0.00   0.00   0.00   0.00   0.00   0.00   0.00
#> 5 ALDH2  2.07    2.86  2.54   0.85   0.49   0.47   0.42   0.13   0.26   0.00
#> 6 AP1S3  6.62   14.59  9.30  24.90  33.94  23.19  24.00  36.08  27.40  24.06
#>   LT12_2 LT12_3 LT12_6_1 LT12_6_2 LT12_6_3
#> 1 497.29 464.48   471.43   693.62   229.77
#> 2 305.81 469.48  1291.90   991.90   966.77
#> 3  10.71  30.95     9.84    10.91     7.28
#> 4   0.00   0.00     0.00     0.00     0.00
#> 5   0.28   0.11     0.37     0.15     0.11
#> 6  38.74  34.54    62.72    41.36    28.75

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
res <- table_cross(gene_expression2, gene_go_kegg, inter_var = "Genes")
head(res)
#>        Genes CT_1 CT_2 CT_3 LT20_1 LT20_2 LT20_3 LT15_1 LT15_2 LT15_3 LT12_1
#> 1 14-3-3ZETA   NA   NA   NA     NA     NA     NA     NA     NA     NA     NA
#> 2       A1I3   NA   NA   NA     NA     NA     NA     NA     NA     NA     NA
#> 3        A2M   NA   NA   NA     NA     NA     NA     NA     NA     NA     NA
#> 4       AARS   NA   NA   NA     NA     NA     NA     NA     NA     NA     NA
#> 5       ABAT   NA   NA   NA     NA     NA     NA     NA     NA     NA     NA
#> 6      ABCB7   NA   NA   NA     NA     NA     NA     NA     NA     NA     NA
#>   LT12_2 LT12_3 LT12_6_1 LT12_6_2 LT12_6_3
#> 1     NA     NA       NA       NA       NA
#> 2     NA     NA       NA       NA       NA
#> 3     NA     NA       NA       NA       NA
#> 4     NA     NA       NA       NA       NA
#> 5     NA     NA       NA       NA       NA
#> 6     NA     NA       NA       NA       NA
#>                                      biological_process
#> 1                                                  <NA>
#> 2                                                  <NA>
#> 3                                                  <NA>
#> 4                GO:0006419(alanyl-tRNA aminoacylation)
#> 5 GO:0009448(gamma-aminobutyric acid metabolic process)
#> 6                                                  <NA>
#>                           cellular_component
#> 1                                       <NA>
#> 2            GO:0005615(extracellular space)
#> 3            GO:0005615(extracellular space)
#> 4                      GO:0005737(cytoplasm)
#> 5                                       <NA>
#> 6 GO:0016021(integral component of membrane)
#>                                                                                                       molecular_function
#> 1                                                                            GO:0019904(protein domain specific binding)
#> 2                                                                           GO:0004866(endopeptidase inhibitor activity)
#> 3                                                                           GO:0004866(endopeptidase inhibitor activity)
#> 4 GO:0004813(alanine-tRNA ligase activity);GO:0005524(ATP binding);GO:0000049(tRNA binding);GO:0008270(zinc ion binding)
#> 5                              GO:0003867(4-aminobutyrate transaminase activity);GO:0030170(pyridoxal phosphate binding)
#> 6      GO:0005524(ATP binding);GO:0016887(ATPase activity);GO:0042626(ATPase-coupled transmembrane transporter activity)
#>                                                                                                                                                                                                                                kegg_pathway
#> 1 ko04110(Cell cycle);ko04114(Oocyte meiosis);ko04390(Hippo signaling pathway);ko04391(Hippo signaling pathway -fly);ko04013(MAPK signaling pathway - fly);ko04151(PI3K-Akt signaling pathway);ko04212(Longevity regulating pathway - worm)
#> 2                                                                                                                                                                                              ko04610(Complement and coagulation cascades)
#> 3                                                                                                                                                                                              ko04610(Complement and coagulation cascades)
#> 4                                                                                                                                                                                                      ko00970(Aminoacyl-tRNA biosynthesis)
#> 5         ko00250(Alanine, aspartate and glutamate metabolism);ko00280(Valine, leucine and isoleucine degradation);ko00650(Butanoate metabolism);ko00640(Propanoate metabolism);ko00410(beta-Alanine metabolism);ko04727(GABAergic synapse)
#> 6                                                                                                                                                                                                                 ko02010(ABC transporters)

# 4. Set left_index = TRUE, right_index = FALSE
res <- table_cross(gene_expression2, gene_go_kegg,
inter_var = "Genes", left_index = TRUE, right_index = FALSE)
head(res)
#>   Genes  CT_1    CT_2  CT_3 LT20_1 LT20_2 LT20_3 LT15_1 LT15_2 LT15_3 LT12_1
#> 1 ACAA2 24.50   39.83 55.38 114.11 159.32  96.88 169.56 464.84 182.66 116.08
#> 2  ACAN 14.97   18.71 10.30  71.23 142.67 213.54 253.15 320.80 104.15 174.02
#> 3  ADH1  1.54    1.56  2.04  14.95  13.60  15.87  12.80  17.74   6.06  10.97
#> 4  AHSG  0.00 1911.99  0.00   0.00   0.00   0.00   0.00   0.00   0.00   0.00
#> 5 ALDH2  2.07    2.86  2.54   0.85   0.49   0.47   0.42   0.13   0.26   0.00
#> 6 AP1S3  6.62   14.59  9.30  24.90  33.94  23.19  24.00  36.08  27.40  24.06
#>   LT12_2 LT12_3 LT12_6_1 LT12_6_2 LT12_6_3
#> 1 497.29 464.48   471.43   693.62   229.77
#> 2 305.81 469.48  1291.90   991.90   966.77
#> 3  10.71  30.95     9.84    10.91     7.28
#> 4   0.00   0.00     0.00     0.00     0.00
#> 5   0.28   0.11     0.37     0.15     0.11
#> 6  38.74  34.54    62.72    41.36    28.75
#>                                                                   biological_process
#> 1                                                                               <NA>
#> 2                                                                               <NA>
#> 3                                                                               <NA>
#> 4                                                                               <NA>
#> 5                                                                               <NA>
#> 6 GO:0006886(intracellular protein transport);GO:0016192(vesicle-mediated transport)
#>          cellular_component
#> 1                      <NA>
#> 2                      <NA>
#> 3                      <NA>
#> 4                      <NA>
#> 5                      <NA>
#> 6 GO:0030117(membrane coat)
#>                                                                                            molecular_function
#> 1                     GO:0016747(transferase activity, transferring acyl groups other than amino-acyl groups)
#> 2                                                                                                        <NA>
#> 3                                            GO:0016491(oxidoreductase activity);GO:0008270(zinc ion binding)
#> 4                                                                                                        <NA>
#> 5 GO:0016620(oxidoreductase activity, acting on the aldehyde or oxo group of donors, NAD or NADP as acceptor)
#> 6                                                                                                        <NA>
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             kegg_pathway
#> 1                                                                                                                                                                                                                                                                                                                                                                                      ko00280(Valine, leucine and isoleucine degradation);ko00071(Fatty acid degradation);ko00062(Fatty acid elongation);ko01212(Fatty acid metabolism)
#> 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   <NA>
#> 3                                                                                                                  ko00350(Tyrosine metabolism);ko00010(Glycolysis / Gluconeogenesis);ko00680(Methane metabolism);ko00071(Fatty acid degradation);ko00830(Retinol metabolism);ko01200(Carbon metabolism);ko01220(Degradation of aromatic compounds);ko00625(Chloroalkane and chloroalkene degradation);ko00982(Drug metabolism - cytochrome P450);ko00980(Metabolism of xenobiotics by cytochrome P450);ko00626(Naphthalene degradation)
#> 4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   <NA>
#> 5 ko00330(Arginine and proline metabolism);ko00340(Histidine metabolism);ko00310(Lysine degradation);ko00380(Tryptophan metabolism);ko00280(Valine, leucine and isoleucine degradation);ko00053(Ascorbate and aldarate metabolism);ko00010(Glycolysis / Gluconeogenesis);ko00620(Pyruvate metabolism);ko00071(Fatty acid degradation);ko00561(Glycerolipid metabolism);ko00410(beta-Alanine metabolism);ko00981(Insect hormone biosynthesis);ko00903(Limonene and pinene degradation);ko00625(Chloroalkane and chloroalkene degradation)
#> 6                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      ko04142(Lysosome)

# 5. Set left_index = FALSE, right_index = TRUE
res <- table_cross(gene_expression2, gene_go_kegg,
inter_var = "Genes", left_index = FALSE, right_index = TRUE)
head(res)
#>        Genes CT_1 CT_2 CT_3 LT20_1 LT20_2 LT20_3 LT15_1 LT15_2 LT15_3 LT12_1
#> 1 14-3-3ZETA   NA   NA   NA     NA     NA     NA     NA     NA     NA     NA
#> 2       A1I3   NA   NA   NA     NA     NA     NA     NA     NA     NA     NA
#> 3        A2M   NA   NA   NA     NA     NA     NA     NA     NA     NA     NA
#> 4       AARS   NA   NA   NA     NA     NA     NA     NA     NA     NA     NA
#> 5       ABAT   NA   NA   NA     NA     NA     NA     NA     NA     NA     NA
#> 6      ABCB7   NA   NA   NA     NA     NA     NA     NA     NA     NA     NA
#>   LT12_2 LT12_3 LT12_6_1 LT12_6_2 LT12_6_3
#> 1     NA     NA       NA       NA       NA
#> 2     NA     NA       NA       NA       NA
#> 3     NA     NA       NA       NA       NA
#> 4     NA     NA       NA       NA       NA
#> 5     NA     NA       NA       NA       NA
#> 6     NA     NA       NA       NA       NA
#>                                      biological_process
#> 1                                                  <NA>
#> 2                                                  <NA>
#> 3                                                  <NA>
#> 4                GO:0006419(alanyl-tRNA aminoacylation)
#> 5 GO:0009448(gamma-aminobutyric acid metabolic process)
#> 6                                                  <NA>
#>                           cellular_component
#> 1                                       <NA>
#> 2            GO:0005615(extracellular space)
#> 3            GO:0005615(extracellular space)
#> 4                      GO:0005737(cytoplasm)
#> 5                                       <NA>
#> 6 GO:0016021(integral component of membrane)
#>                                                                                                       molecular_function
#> 1                                                                            GO:0019904(protein domain specific binding)
#> 2                                                                           GO:0004866(endopeptidase inhibitor activity)
#> 3                                                                           GO:0004866(endopeptidase inhibitor activity)
#> 4 GO:0004813(alanine-tRNA ligase activity);GO:0005524(ATP binding);GO:0000049(tRNA binding);GO:0008270(zinc ion binding)
#> 5                              GO:0003867(4-aminobutyrate transaminase activity);GO:0030170(pyridoxal phosphate binding)
#> 6      GO:0005524(ATP binding);GO:0016887(ATPase activity);GO:0042626(ATPase-coupled transmembrane transporter activity)
#>                                                                                                                                                                                                                                kegg_pathway
#> 1 ko04110(Cell cycle);ko04114(Oocyte meiosis);ko04390(Hippo signaling pathway);ko04391(Hippo signaling pathway -fly);ko04013(MAPK signaling pathway - fly);ko04151(PI3K-Akt signaling pathway);ko04212(Longevity regulating pathway - worm)
#> 2                                                                                                                                                                                              ko04610(Complement and coagulation cascades)
#> 3                                                                                                                                                                                              ko04610(Complement and coagulation cascades)
#> 4                                                                                                                                                                                                      ko00970(Aminoacyl-tRNA biosynthesis)
#> 5         ko00250(Alanine, aspartate and glutamate metabolism);ko00280(Valine, leucine and isoleucine degradation);ko00650(Butanoate metabolism);ko00640(Propanoate metabolism);ko00410(beta-Alanine metabolism);ko04727(GABAergic synapse)
#> 6                                                                                                                                                                                                                 ko02010(ABC transporters)
```
