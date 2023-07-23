const data = {
  name: 'TOmicsVis',
  children: [
    {
      name: 'Functions',
      children: [
        {
          name: '1.Samples Statistics',
          children: [
            { name: 'quantile_plot' },
            { name: 'corr_heatmap' },
            { name: 'pca_plot' },
            { name: 'dendro_plot' }
          ]
        },
        {
          name: '2.Traits Analysis',
          children: [
            { name: 'box_plot' },
            { name: 'violin_plot' },
            { name: 'survival_plot' },
            { name: 'tsne_plot' }
          ]
        },
        {
          name: '3.Differential Expression',
          children: [
            { name: 'venn_plot' },
            { name: 'flower_plot' },
            { name: 'circos_heatmap' },
            { name: 'volcano_plot' },
            { name: 'ma_plot' },
            { name: 'heatmap_group' }
          ]
        },
        {
          name: '4.Advanced Analysis',
          children: [
            { name: 'trend_plot' },
            { name: 'gene_cluster_trend' },
            { name: 'gene_rank_plot' },
            { name: 'network_plot' },
            { name: 'wgcna_pipeline' },
            { name: 'heatmap_cluster' }
          ]
        },
        {
          name: '5.GO&KEGG Enrichment',
          children: [
            { name: 'chord_plot' },
            { name: 'go_enrich' },
            { name: 'go_enrich_stat' },
            { name: 'go_enrich_bar' },
            { name: 'go_enrich_dot' },
            { name: 'go_enrich_net' },
            { name: 'kegg_enrich' },
            { name: 'kegg_enrich_bar' },
            { name: 'kegg_enrich_dot' },
            { name: 'kegg_enrich_net' }
          ]
        },
        {
          name: '6.Tables Operations',
          children: [
            { name: 'table_split' },
            { name: 'table_merge' },
            { name: 'table_filter' },
            { name: 'table_cross' }
          ]
        },
      ]
    },
    {
      name: 'Datasets',
      children: [
        { name: 'gene_exp' },
        { name: 'gene_exp2' },
        { name: 'pca_sample_gene' },
        { name: 'pca_group_sample' },
        { name: 'box_data' },
        { name: 'quantile_data' },
        { name: 'venn_data' },
        { name: 'chord_data' },
        { name: 'circos_heatmap_data' },
        { name: 'deg_data' },
        { name: 'deg_data2' },
        { name: 'trend_data' },
        { name: 'gene_cluster_data' },
        { name: 'survival_data' },
        { name: 'tsne_data' },
        { name: 'go_anno' },
        { name: 'go_deg_fc' },
        { name: 'kegg_anno' },
        { name: 'kegg_deg_fc' },
        { name: 'network_data' },
        { name: 'wgcna_gene_exp' },
        { name: 'wgcna_sample_group' },
        { name: 'heatmap_group_data' },
        { name: 'table_split_data' },
        { name: 'table_merge_data' },
        { name: 'table_filter_data' },
        { name: 'table_cross_data1' },
        { name: 'table_cross_data2' }
      ]
    },
    {
      name: 'Dependences',
      children: [
        { name: 'stats' },
        { name: 'utils' },
        { name: 'grid' },
        { name: 'graphics' },
        { name: 'grDevices' },
        { name: 'ggplot2' },
        { name: 'ggsci' },
        { name: 'reshape2' },
        { name: 'ggpubr' },
        { name: 'ggcorrplot' },
        { name: 'ggforce' },
        { name: 'vegan' },
        { name: 'venn' },
        { name: 'circlize' },
        { name: 'randomcoloR' },
        { name: 'ComplexHeatmap' },
        { name: 'EnhancedVolcano' },
        { name: 'GGally' },
        { name: 'survival' },
        { name: 'survminer' },
        { name: 'Rtsne' },
        { name: 'dplyr' },
        { name: 'tidyr' },
        { name: 'clusterProfiler' },
        { name: 'enrichplot' },
        { name: 'ggnewscale' },
        { name: 'igraph' },
        { name: 'WGCNA' },
        { name: 'stringr' },
        { name: 'pheatmap' },
        { name: 'RColorBrewer' },
        { name: 'ggpolypath' },
        { name: 'factoextra' },
        { name: 'ggrepel' },
        { name: 'cowplot' },
        { name: 'ggplotify' },
        { name: 'plotrix' },
        { name: 'Mfuzz' }
      ]
    }
  ]
};

myChart.setOption(
  (option = {
    tooltip: {
      trigger: 'item',
      triggerOn: 'mousemove'
    },
    textStyle: {
      fontFamily: "Times New Roman"
    },
    series: [
      {
        type: 'tree',
        data: [data],
        top: '18%',
        bottom: '14%',
        layout: 'radial',
        symbol: 'emptyCircle',
        symbolSize: 7,
        initialTreeDepth: 3,
        animationDurationUpdate: 750,
        emphasis: {
          focus: 'descendant'
        }
      }
    ]
  })
);
