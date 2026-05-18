# GO enrichment analysis based on GO annotation results (None/Exist Reference Genome).

GO enrichment analysis based on GO annotation results (None/Exist
Reference Genome).

## Usage

``` r
go_enrich(
  go_anno,
  degs_list,
  padjust_method = "fdr",
  pvalue_cutoff = 0.05,
  qvalue_cutoff = 0.05
)
```

## Arguments

- go_anno:

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

Table: include columns ("ID", "ontology", "Description", "GeneRatio",
"BgRatio", "pvalue", "p.adjust", "qvalue", "geneID", "Count").

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
res <- go_enrich(gene_go_kegg[,-5], gene_go_kegg[100:200,1])
head(res)
#>           ID           ontology
#> 1 GO:0000221 cellular component
#> 2 GO:0000275 cellular component
#> 3 GO:0000276 cellular component
#> 4 GO:0000398 biological process
#> 5 GO:0000774 molecular function
#> 6 GO:0001671 molecular function
#>                                                                   Description
#> 1                       vacuolar proton-transporting V-type ATPase, V1 domain
#> 2  mitochondrial proton-transporting ATP synthase complex, catalytic core F(1
#> 3 mitochondrial proton-transporting ATP synthase complex, coupling factor F(o
#> 4                                              mRNA splicing, via spliceosome
#> 5                                  adenyl-nucleotide exchange factor activity
#> 6                                                   ATPase activator activity
#>   GeneRatio BgRatio RichFactor FoldEnrichment     zScore       pvalue
#> 1     1/101  1/1279 1.00000000     12.6633663  3.4151671 7.896794e-02
#> 2     1/101  1/1279 1.00000000     12.6633663  3.4151671 7.896794e-02
#> 3     6/101  6/1279 1.00000000     12.6633663  8.3818292 2.109128e-07
#> 4     1/101 14/1279 0.07142857      0.9045262 -0.1051372 6.858207e-01
#> 5     1/101  1/1279 1.00000000     12.6633663  3.4151671 7.896794e-02
#> 6     1/101  1/1279 1.00000000     12.6633663  3.4151671 7.896794e-02
#>       p.adjust       qvalue                                     geneID Count
#> 1 1.110997e-01 9.458955e-02                                    ATP6V1H     1
#> 2 1.110997e-01 9.458955e-02                                    ATP5F1E     1
#> 3 1.075656e-05 9.158058e-06 ATP5MC1/ATP5ME/ATP5MG/ATP5PB/ATP5PD/ATP5PF     6
#> 4 7.363549e-01 6.269275e-01                                      CDC40     1
#> 5 1.110997e-01 9.458955e-02                                       BAG2     1
#> 6 1.110997e-01 9.458955e-02                                     ATP1B1     1

# 4. Set padjust_method = "BH"
res <- go_enrich(gene_go_kegg[,-5], gene_go_kegg[100:200,1], padjust_method = "BH")
head(res)
#>           ID           ontology
#> 1 GO:0000221 cellular component
#> 2 GO:0000275 cellular component
#> 3 GO:0000276 cellular component
#> 4 GO:0000398 biological process
#> 5 GO:0000774 molecular function
#> 6 GO:0001671 molecular function
#>                                                                   Description
#> 1                       vacuolar proton-transporting V-type ATPase, V1 domain
#> 2  mitochondrial proton-transporting ATP synthase complex, catalytic core F(1
#> 3 mitochondrial proton-transporting ATP synthase complex, coupling factor F(o
#> 4                                              mRNA splicing, via spliceosome
#> 5                                  adenyl-nucleotide exchange factor activity
#> 6                                                   ATPase activator activity
#>   GeneRatio BgRatio RichFactor FoldEnrichment     zScore       pvalue
#> 1     1/101  1/1279 1.00000000     12.6633663  3.4151671 7.896794e-02
#> 2     1/101  1/1279 1.00000000     12.6633663  3.4151671 7.896794e-02
#> 3     6/101  6/1279 1.00000000     12.6633663  8.3818292 2.109128e-07
#> 4     1/101 14/1279 0.07142857      0.9045262 -0.1051372 6.858207e-01
#> 5     1/101  1/1279 1.00000000     12.6633663  3.4151671 7.896794e-02
#> 6     1/101  1/1279 1.00000000     12.6633663  3.4151671 7.896794e-02
#>       p.adjust       qvalue                                     geneID Count
#> 1 1.110997e-01 9.458955e-02                                    ATP6V1H     1
#> 2 1.110997e-01 9.458955e-02                                    ATP5F1E     1
#> 3 1.075656e-05 9.158058e-06 ATP5MC1/ATP5ME/ATP5MG/ATP5PB/ATP5PD/ATP5PF     6
#> 4 7.363549e-01 6.269275e-01                                      CDC40     1
#> 5 1.110997e-01 9.458955e-02                                       BAG2     1
#> 6 1.110997e-01 9.458955e-02                                     ATP1B1     1

# 5. Set pvalue_cutoff = 0.10
res <- go_enrich(gene_go_kegg[,-5], gene_go_kegg[100:200,1], pvalue_cutoff = 0.10)
head(res)
#>           ID           ontology
#> 1 GO:0000221 cellular component
#> 2 GO:0000275 cellular component
#> 3 GO:0000276 cellular component
#> 4 GO:0000398 biological process
#> 5 GO:0000774 molecular function
#> 6 GO:0001671 molecular function
#>                                                                   Description
#> 1                       vacuolar proton-transporting V-type ATPase, V1 domain
#> 2  mitochondrial proton-transporting ATP synthase complex, catalytic core F(1
#> 3 mitochondrial proton-transporting ATP synthase complex, coupling factor F(o
#> 4                                              mRNA splicing, via spliceosome
#> 5                                  adenyl-nucleotide exchange factor activity
#> 6                                                   ATPase activator activity
#>   GeneRatio BgRatio RichFactor FoldEnrichment     zScore       pvalue
#> 1     1/101  1/1279 1.00000000     12.6633663  3.4151671 7.896794e-02
#> 2     1/101  1/1279 1.00000000     12.6633663  3.4151671 7.896794e-02
#> 3     6/101  6/1279 1.00000000     12.6633663  8.3818292 2.109128e-07
#> 4     1/101 14/1279 0.07142857      0.9045262 -0.1051372 6.858207e-01
#> 5     1/101  1/1279 1.00000000     12.6633663  3.4151671 7.896794e-02
#> 6     1/101  1/1279 1.00000000     12.6633663  3.4151671 7.896794e-02
#>       p.adjust       qvalue                                     geneID Count
#> 1 1.110997e-01 9.458955e-02                                    ATP6V1H     1
#> 2 1.110997e-01 9.458955e-02                                    ATP5F1E     1
#> 3 1.075656e-05 9.158058e-06 ATP5MC1/ATP5ME/ATP5MG/ATP5PB/ATP5PD/ATP5PF     6
#> 4 7.363549e-01 6.269275e-01                                      CDC40     1
#> 5 1.110997e-01 9.458955e-02                                       BAG2     1
#> 6 1.110997e-01 9.458955e-02                                     ATP1B1     1
```
