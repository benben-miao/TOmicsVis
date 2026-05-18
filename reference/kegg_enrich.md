# KEGG enrichment analysis based on KEGG annotation results (None/Exist Reference Genome).

KEGG enrichment analysis based on KEGG annotation results (None/Exist
Reference Genome).

## Usage

``` r
kegg_enrich(
  kegg_anno,
  degs_list,
  padjust_method = "fdr",
  pvalue_cutoff = 0.05,
  qvalue_cutoff = 0.05
)
```

## Arguments

- kegg_anno:

  Dataframe: GO and KEGG annotation of background genes (1st-col: Genes,
  2nd-col: biological_process, 3rd-col: cellular_component, 4th-col:
  molecular_function, 5th-col: kegg_pathway).

- degs_list:

  Dataframe: degs list.

- padjust_method:

  Character: P-value adjust to Q-value. Default: "fdr" (false discovery
  rate), options: "holm", "hochberg", "hommel", "bonferroni", "BH",
  "BY", "fdr", "none".

- pvalue_cutoff:

  Numeric: P-value cutoff. Recommend: small than 0.05.

- qvalue_cutoff:

  Numeric: Q-value cutoff. Recommend: small than 0.05.

## Value

Table: include columns ("ID", "Description", "GeneRatio", "BgRatio",
"pvalue", "p.adjust", "qvalue", "geneID", "Count").

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
res <- kegg_enrich(gene_go_kegg[,c(1,5)], gene_go_kegg[100:200,1])
#> Warning: Expected 2 pieces. Additional pieces discarded in 27 rows [695, 696, 744, 747,
#> 750, 968, 977, 1177, 1474, 1646, 1653, 1659, 1886, 2163, 2174, 2187, 2193,
#> 2198, 2258, 2259, ...].
head(res)
#>              ID                         Description GeneRatio BgRatio
#> ko04966 ko04966      Collecting duct acid secretion     7/101  7/1279
#> ko00190 ko00190           Oxidative phosphorylation    23/101 88/1279
#> ko04721 ko04721              Synaptic vesicle cycle     8/101 13/1279
#> ko04610 ko04610 Complement and coagulation cascades    13/101 43/1279
#> ko04145 ko04145                           Phagosome    11/101 33/1279
#> ko04971 ko04971              Gastric acid secretion     4/101  4/1279
#>         RichFactor FoldEnrichment   zScore       pvalue     p.adjust
#> ko04966  1.0000000      12.663366 9.056968 1.573976e-08 2.030430e-06
#> ko00190  0.2613636       3.309743 6.572077 5.232645e-08 3.375056e-06
#> ko04721  0.6153846       7.792841 7.205427 1.069634e-06 4.599427e-05
#> ko04610  0.3023256       3.828460 5.522407 1.078094e-05 3.476853e-04
#> ko04145  0.3333333       4.221122 5.487299 1.941460e-05 5.008968e-04
#> ko04971  1.0000000      12.663366 6.838365 3.679084e-05 7.910030e-04
#>               qvalue
#> ko04966 1.723090e-06
#> ko00190 2.864185e-06
#> ko04721 3.903227e-05
#> ko04610 2.950573e-04
#> ko04145 4.250776e-04
#> ko04971 6.712714e-04
#>                                                                                                                                                                                        geneID
#> ko04966                                                                                                                              ATP6V0C/ATP6V0E1/ATP6V1B2/ATP6V1C1A/ATP6V1F/ATP6V1G1/CA1
#> ko00190 ATP5F1A/ATP5F1B/ATP5F1C/ATP5F1D/ATP5F1E/ATP5MC1/ATP5MC2/ATP5MC3/ATP5ME/ATP5MF/ATP5MG/ATP5PB/ATP5PD/ATP5PF/ATP5PO/ATP6V0B/ATP6V0C/ATP6V0E1/ATP6V1B2/ATP6V1C1A/ATP6V1F/ATP6V1G1/ATP6V1H
#> ko04721                                                                                                                  ATP6V0B/ATP6V0C/ATP6V0E1/ATP6V1B2/ATP6V1C1A/ATP6V1F/ATP6V1G1/ATP6V1H
#> ko04610                                                                                                                                       C1QC/C1S/C3/C4/C4A/C5/C6/C7/C8A/C8B/C8G/C9/CD59
#> ko04145                                                                                                     ATP6V0B/ATP6V0C/ATP6V0E1/ATP6V1B2/ATP6V1C1A/ATP6V1F/ATP6V1G1/ATP6V1H/C3/CALR/CANX
#> ko04971                                                                                                                                                               ATP1B1/CA1/CALM1/CAMK2D
#>         Count
#> ko04966     7
#> ko00190    23
#> ko04721     8
#> ko04610    13
#> ko04145    11
#> ko04971     4

# 4. Set padjust_method = "BH"
res <- kegg_enrich(gene_go_kegg[,c(1,5)], gene_go_kegg[100:200,1], padjust_method = "BH")
#> Warning: Expected 2 pieces. Additional pieces discarded in 27 rows [695, 696, 744, 747,
#> 750, 968, 977, 1177, 1474, 1646, 1653, 1659, 1886, 2163, 2174, 2187, 2193,
#> 2198, 2258, 2259, ...].
head(res)
#>              ID                         Description GeneRatio BgRatio
#> ko04966 ko04966      Collecting duct acid secretion     7/101  7/1279
#> ko00190 ko00190           Oxidative phosphorylation    23/101 88/1279
#> ko04721 ko04721              Synaptic vesicle cycle     8/101 13/1279
#> ko04610 ko04610 Complement and coagulation cascades    13/101 43/1279
#> ko04145 ko04145                           Phagosome    11/101 33/1279
#> ko04971 ko04971              Gastric acid secretion     4/101  4/1279
#>         RichFactor FoldEnrichment   zScore       pvalue     p.adjust
#> ko04966  1.0000000      12.663366 9.056968 1.573976e-08 2.030430e-06
#> ko00190  0.2613636       3.309743 6.572077 5.232645e-08 3.375056e-06
#> ko04721  0.6153846       7.792841 7.205427 1.069634e-06 4.599427e-05
#> ko04610  0.3023256       3.828460 5.522407 1.078094e-05 3.476853e-04
#> ko04145  0.3333333       4.221122 5.487299 1.941460e-05 5.008968e-04
#> ko04971  1.0000000      12.663366 6.838365 3.679084e-05 7.910030e-04
#>               qvalue
#> ko04966 1.723090e-06
#> ko00190 2.864185e-06
#> ko04721 3.903227e-05
#> ko04610 2.950573e-04
#> ko04145 4.250776e-04
#> ko04971 6.712714e-04
#>                                                                                                                                                                                        geneID
#> ko04966                                                                                                                              ATP6V0C/ATP6V0E1/ATP6V1B2/ATP6V1C1A/ATP6V1F/ATP6V1G1/CA1
#> ko00190 ATP5F1A/ATP5F1B/ATP5F1C/ATP5F1D/ATP5F1E/ATP5MC1/ATP5MC2/ATP5MC3/ATP5ME/ATP5MF/ATP5MG/ATP5PB/ATP5PD/ATP5PF/ATP5PO/ATP6V0B/ATP6V0C/ATP6V0E1/ATP6V1B2/ATP6V1C1A/ATP6V1F/ATP6V1G1/ATP6V1H
#> ko04721                                                                                                                  ATP6V0B/ATP6V0C/ATP6V0E1/ATP6V1B2/ATP6V1C1A/ATP6V1F/ATP6V1G1/ATP6V1H
#> ko04610                                                                                                                                       C1QC/C1S/C3/C4/C4A/C5/C6/C7/C8A/C8B/C8G/C9/CD59
#> ko04145                                                                                                     ATP6V0B/ATP6V0C/ATP6V0E1/ATP6V1B2/ATP6V1C1A/ATP6V1F/ATP6V1G1/ATP6V1H/C3/CALR/CANX
#> ko04971                                                                                                                                                               ATP1B1/CA1/CALM1/CAMK2D
#>         Count
#> ko04966     7
#> ko00190    23
#> ko04721     8
#> ko04610    13
#> ko04145    11
#> ko04971     4

# 5. Set pvalue_cutoff = 0.80
res <- kegg_enrich(gene_go_kegg[,c(1,5)], gene_go_kegg[100:200,1], pvalue_cutoff = 0.80)
#> Warning: Expected 2 pieces. Additional pieces discarded in 27 rows [695, 696, 744, 747,
#> 750, 968, 977, 1177, 1474, 1646, 1653, 1659, 1886, 2163, 2174, 2187, 2193,
#> 2198, 2258, 2259, ...].
head(res)
#>              ID                         Description GeneRatio BgRatio
#> ko04966 ko04966      Collecting duct acid secretion     7/101  7/1279
#> ko00190 ko00190           Oxidative phosphorylation    23/101 88/1279
#> ko04721 ko04721              Synaptic vesicle cycle     8/101 13/1279
#> ko04610 ko04610 Complement and coagulation cascades    13/101 43/1279
#> ko04145 ko04145                           Phagosome    11/101 33/1279
#> ko04971 ko04971              Gastric acid secretion     4/101  4/1279
#>         RichFactor FoldEnrichment   zScore       pvalue     p.adjust
#> ko04966  1.0000000      12.663366 9.056968 1.573976e-08 2.030430e-06
#> ko00190  0.2613636       3.309743 6.572077 5.232645e-08 3.375056e-06
#> ko04721  0.6153846       7.792841 7.205427 1.069634e-06 4.599427e-05
#> ko04610  0.3023256       3.828460 5.522407 1.078094e-05 3.476853e-04
#> ko04145  0.3333333       4.221122 5.487299 1.941460e-05 5.008968e-04
#> ko04971  1.0000000      12.663366 6.838365 3.679084e-05 7.910030e-04
#>               qvalue
#> ko04966 1.723090e-06
#> ko00190 2.864185e-06
#> ko04721 3.903227e-05
#> ko04610 2.950573e-04
#> ko04145 4.250776e-04
#> ko04971 6.712714e-04
#>                                                                                                                                                                                        geneID
#> ko04966                                                                                                                              ATP6V0C/ATP6V0E1/ATP6V1B2/ATP6V1C1A/ATP6V1F/ATP6V1G1/CA1
#> ko00190 ATP5F1A/ATP5F1B/ATP5F1C/ATP5F1D/ATP5F1E/ATP5MC1/ATP5MC2/ATP5MC3/ATP5ME/ATP5MF/ATP5MG/ATP5PB/ATP5PD/ATP5PF/ATP5PO/ATP6V0B/ATP6V0C/ATP6V0E1/ATP6V1B2/ATP6V1C1A/ATP6V1F/ATP6V1G1/ATP6V1H
#> ko04721                                                                                                                  ATP6V0B/ATP6V0C/ATP6V0E1/ATP6V1B2/ATP6V1C1A/ATP6V1F/ATP6V1G1/ATP6V1H
#> ko04610                                                                                                                                       C1QC/C1S/C3/C4/C4A/C5/C6/C7/C8A/C8B/C8G/C9/CD59
#> ko04145                                                                                                     ATP6V0B/ATP6V0C/ATP6V0E1/ATP6V1B2/ATP6V1C1A/ATP6V1F/ATP6V1G1/ATP6V1H/C3/CALR/CANX
#> ko04971                                                                                                                                                               ATP1B1/CA1/CALM1/CAMK2D
#>         Count
#> ko04966     7
#> ko00190    23
#> ko04721     8
#> ko04610    13
#> ko04145    11
#> ko04971     4
```
