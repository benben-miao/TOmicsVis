# Package index

## Package Utilities

Core package functions for loading and launching applications

- [`load_TOmicsVis()`](https://benben-miao.github.io/TOmicsVis/reference/load_TOmicsVis.md)
  : Load TOmicsVis package without display warnings
- [`tomicsvis()`](https://benben-miao.github.io/TOmicsVis/reference/tomicsvis.md)
  : TOmicsVis shiny app start function.

## ① Samples Statistics

Statistical sample outliers, correlation among samples, distance among
samples, etc.

- [`quantile_plot()`](https://benben-miao.github.io/TOmicsVis/reference/quantile_plot.md)
  : Quantile plot for visualizing data distribution.
- [`box_plot()`](https://benben-miao.github.io/TOmicsVis/reference/box_plot.md)
  : Box plot support two levels and multiple groups with P value.
- [`violin_plot()`](https://benben-miao.github.io/TOmicsVis/reference/violin_plot.md)
  : Violin plot support two levels and multiple groups with P value.
- [`survival_plot()`](https://benben-miao.github.io/TOmicsVis/reference/survival_plot.md)
  : Survival plot for analyzing and visualizing survival data.

## ② Traits Analysis

Statistical analysis of traits, such as adding R and P values to box
plots and violin plots, and more dimensionality reduction analysis.

- [`corr_heatmap()`](https://benben-miao.github.io/TOmicsVis/reference/corr_heatmap.md)
  : Correlation Heatmap for samples/groups based on Pearson algorithm.
- [`pca_analysis()`](https://benben-miao.github.io/TOmicsVis/reference/pca_analysis.md)
  : PCA dimensional reduction analysis for RNA-Seq.
- [`pca_plot()`](https://benben-miao.github.io/TOmicsVis/reference/pca_plot.md)
  : PCA dimensional reduction visualization for RNA-Seq.
- [`tsne_analysis()`](https://benben-miao.github.io/TOmicsVis/reference/tsne_analysis.md)
  : TSNE analysis for analyzing and visualizing TSNE algorithm.
- [`tsne_plot()`](https://benben-miao.github.io/TOmicsVis/reference/tsne_plot.md)
  : TSNE plot for analyzing and visualizing TSNE algorithm.
- [`umap_analysis()`](https://benben-miao.github.io/TOmicsVis/reference/umap_analysis.md)
  : UMAP analysis for analyzing RNA-Seq data.
- [`umap_plot()`](https://benben-miao.github.io/TOmicsVis/reference/umap_plot.md)
  : UMAP plot for analyzing and visualizing UMAP algorithm.
- [`dendro_plot()`](https://benben-miao.github.io/TOmicsVis/reference/dendro_plot.md)
  : Dendrograms for multiple samples/groups clustering.

## ③ Differential Expression Analysis

Analysis and visualization based on gene expression data and
differentially expressed genes.

- [`venn_plot()`](https://benben-miao.github.io/TOmicsVis/reference/venn_plot.md)
  : Venn plot for stat common and unique gene among multiple sets.
- [`upsetr_plot()`](https://benben-miao.github.io/TOmicsVis/reference/upsetr_plot.md)
  : UpSet plot for stat common and unique gene among multiple sets.
- [`flower_plot()`](https://benben-miao.github.io/TOmicsVis/reference/flower_plot.md)
  : Flower plot for stat common and unique gene among multiple sets.
- [`volcano_plot()`](https://benben-miao.github.io/TOmicsVis/reference/volcano_plot.md)
  : Volcano plot for visualizing differentailly expressed genes.
- [`ma_plot()`](https://benben-miao.github.io/TOmicsVis/reference/ma_plot.md)
  : MversusA plot for visualizing differentially expressed genes.
- [`heatmap_group()`](https://benben-miao.github.io/TOmicsVis/reference/heatmap_group.md)
  : Heatmap group for visualizing grouped gene expression data.
- [`circos_heatmap()`](https://benben-miao.github.io/TOmicsVis/reference/circos_heatmap.md)
  : Circos heatmap plot for visualizing gene expressing in multiple
  samples.
- [`chord_plot()`](https://benben-miao.github.io/TOmicsVis/reference/chord_plot.md)
  : Chord plot for visualizing the relationships of pathways and genes.

## ④ Advanced Analysis

Advanced analysis of Transcriptome includes exploring gene expression
trends of multiple groups of samples, constructing co-expression modules
for genes, and exploring genes related to traits in expression modules.

- [`gene_rank_plot()`](https://benben-miao.github.io/TOmicsVis/reference/gene_rank_plot.md)
  : Gene ranking dotplot for visualizing differentailly expressed genes.
- [`gene_cluster_trend()`](https://benben-miao.github.io/TOmicsVis/reference/gene_cluster_trend.md)
  : Gene cluster trend plot for visualizing gene expression trend
  profile in multiple samples.
- [`trend_plot()`](https://benben-miao.github.io/TOmicsVis/reference/trend_plot.md)
  : Trend plot for visualizing gene expression trend profile in multiple
  traits.
- [`wgcna_pipeline()`](https://benben-miao.github.io/TOmicsVis/reference/wgcna_pipeline.md)
  : WGCNA analysis pipeline for RNA-Seq.
- [`network_plot()`](https://benben-miao.github.io/TOmicsVis/reference/network_plot.md)
  : Network plot for analyzing and visualizing relationship of genes.
- [`heatmap_cluster()`](https://benben-miao.github.io/TOmicsVis/reference/heatmap_cluster.md)
  : Heatmap cluster for visualizing clustered gene expression data.

## ⑤ GO and KEGG Enrichment

GO and KEGG enrichment analysis and visualization.

- [`go_enrich()`](https://benben-miao.github.io/TOmicsVis/reference/go_enrich.md)
  : GO enrichment analysis based on GO annotation results (None/Exist
  Reference Genome).
- [`go_enrich_stat()`](https://benben-miao.github.io/TOmicsVis/reference/go_enrich_stat.md)
  : GO enrichment analysis and stat plot (None/Exist Reference Genome).
- [`go_enrich_bar()`](https://benben-miao.github.io/TOmicsVis/reference/go_enrich_bar.md)
  : GO enrichment analysis and bar plot (None/Exist Reference Genome).
- [`go_enrich_dot()`](https://benben-miao.github.io/TOmicsVis/reference/go_enrich_dot.md)
  : GO enrichment analysis and dot plot (None/Exist Reference Genome).
- [`go_enrich_net()`](https://benben-miao.github.io/TOmicsVis/reference/go_enrich_net.md)
  : GO enrichment analysis and net plot (None/Exist Reference Genome).
- [`kegg_enrich()`](https://benben-miao.github.io/TOmicsVis/reference/kegg_enrich.md)
  : KEGG enrichment analysis based on KEGG annotation results
  (None/Exist Reference Genome).
- [`kegg_enrich_bar()`](https://benben-miao.github.io/TOmicsVis/reference/kegg_enrich_bar.md)
  : KEGG enrichment analysis and bar plot (None/Exist Reference Genome).
- [`kegg_enrich_dot()`](https://benben-miao.github.io/TOmicsVis/reference/kegg_enrich_dot.md)
  : KEGG enrichment analysis and dot plot (None/Exist Reference Genome).
- [`kegg_enrich_net()`](https://benben-miao.github.io/TOmicsVis/reference/kegg_enrich_net.md)
  : KEGG enrichment analysis and net plot (None/Exist Reference Genome).

## ⑥ Tables Operations

Quickly manipulate specific Transcriptome data structures.

- [`table_split()`](https://benben-miao.github.io/TOmicsVis/reference/table_split.md)
  : Table split used for splitting a grouped column to multiple columns.
- [`table_merge()`](https://benben-miao.github.io/TOmicsVis/reference/table_merge.md)
  : Table merge used to merge multiple variables to on variable.
- [`table_filter()`](https://benben-miao.github.io/TOmicsVis/reference/table_filter.md)
  : Table filter used to filter row by column condition.
- [`table_cross()`](https://benben-miao.github.io/TOmicsVis/reference/table_cross.md)
  : Table cross used to cross search and merge results in two tables.

## Example datasets in TOmicsVis

Example datasets included in TOmicsVis for testing and demonstration.

- [`weight_sex`](https://benben-miao.github.io/TOmicsVis/reference/weight_sex.md)
  : Weight and Sex traits dataframe.
- [`traits_sex`](https://benben-miao.github.io/TOmicsVis/reference/traits_sex.md)
  : Length, Width, Weight, and Sex traits dataframe.
- [`survival_data`](https://benben-miao.github.io/TOmicsVis/reference/survival_data.md)
  : Survival data as example data for survival_plot function.
- [`gene_expression`](https://benben-miao.github.io/TOmicsVis/reference/gene_expression.md)
  : All genes in all samples expression dataframe of RNA-Seq.
- [`gene_expression2`](https://benben-miao.github.io/TOmicsVis/reference/gene_expression2.md)
  : Shared DEGs of all paired comparisons in all samples expression
  dataframe of RNA-Seq.
- [`gene_expression3`](https://benben-miao.github.io/TOmicsVis/reference/gene_expression3.md)
  : Shared DEGs of all paired comparisons in all groups expression
  dataframe of RNA-Seq.
- [`samples_groups`](https://benben-miao.github.io/TOmicsVis/reference/samples_groups.md)
  : Samples and groups for gene expression.
- [`degs_lists`](https://benben-miao.github.io/TOmicsVis/reference/degs_lists.md)
  : Paired comparisons differentially expressed genes (degs) among
  groups.
- [`degs_stats`](https://benben-miao.github.io/TOmicsVis/reference/degs_stats.md)
  : All DEGs of paired comparison CT-vs-LT12 stats dataframe.
- [`degs_stats2`](https://benben-miao.github.io/TOmicsVis/reference/degs_stats2.md)
  : All DEGs of paired comparison CT-vs-LT12 stats2 dataframe.
- [`network_data`](https://benben-miao.github.io/TOmicsVis/reference/network_data.md)
  : Network data from WGCNA tan module top-200 dataframe.
- [`gene_go_kegg`](https://benben-miao.github.io/TOmicsVis/reference/gene_go_kegg.md)
  : GO and KEGG annotation of background genes.
- [`gene_go_kegg2`](https://benben-miao.github.io/TOmicsVis/reference/gene_go_kegg2.md)
  : GO and KEGG annotation of background genes.
