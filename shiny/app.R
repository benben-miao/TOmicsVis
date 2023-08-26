# -> Author Info:
# Author: benben-miao
# Email: benben.miao@outlook.com
# Github: https://github.com/benben-miao
# Date: 2023-08-26
# <- Author Info

options(warn = -1)
# .libPaths(c(getOption("libPathExtra"), .libPaths()))

# install.packages("shiny")
# install.packages("bs4Dash")
# install.packages("DT")
# install.packages("colourpicker")
# BiocManager::install(c("ComplexHeatmap", "EnhancedVolcano", "clusterProfiler", "enrichplot", "impute", "preprocessCore", "Mfuzz"))
# devtools::install_github("benben-miao/TOmicsVis")
#
library(shiny)
library(bs4Dash)
library(igraph)
library(network)
library(networkD3)
library(ggraph)
library(colourpicker)
library(DT)

data_path <- "./network.txt"

ui <- shinyUI(
    #=== 1.bs4DashPage
    bs4DashPage(
        title = "TOmicsVis Cloud",
        skin = NULL,
        freshTheme = NULL,
        preloader = NULL,
        options = NULL,
        fullscreen = TRUE,
        help = TRUE,
        dark = FALSE,
        scrollToTop = TRUE,
        #=== 1.1 bs4DashNavbar
        {header = bs4DashNavbar(
            title = div("TOmicsVis Cloud",
                        style = "
                        width:90%;
                        margin:5px;
                        padding:5px 5px;
                        background-color:#dc3545ee;
                        box-shadow:0px 0px 10px #dc3545;
                        border-radius:10px;
                        color:white;
                        font-size:12px;
                        font-weight:bold"
            ),
            titleWidth = NULL,
            disable = FALSE,
            .list = NULL,
            leftUi = bs4DropdownMenu(
                type = c("messages"),
                badgeStatus = "info",
                icon = icon("envelope"),
                headerText = "【Github】: https://github.com/benben-miao",
                href = "https://github.com/benben-miao"
            ),
            rightUi = bs4DropdownMenu(
                type = c("notifications"),
                badgeStatus = "warning",
                icon = icon("bell"),
                headerText = "【Version】: 1.0.0 |【 Update】: 2022-11-04",
                href = "https://github.com/benben-miao"
            ),
            skin = "light",
            status = "white",
            border = TRUE,
            compact = FALSE,
            sidebarIcon = shiny::icon("bars"),
            controlbarIcon = shiny::icon("bars"),
            fixed = FALSE
        )},
        #=== 1.2 bs4DashSidebar
        {sidebar = bs4DashSidebar(
            disable = FALSE,
            width = NULL,
            skin = "dark",
            status = "warning",
            elevation = 3,
            collapsed = FALSE,
            minified = TRUE,
            expandOnHover = TRUE,
            fixed = TRUE,
            id = NULL,
            customArea = NULL,
            #=== 1.2.1 bs4SidebarMenu
            bs4SidebarMenu(
                id = NULL,
                .list = NULL,
                flat = FALSE,
                compact = FALSE,
                childIndent = FALSE,
                legacy = FALSE,
                #=== 1.2.1.1 bs4SidebarUserPanel
                bs4SidebarUserPanel(
                    name = strong("TOmicsVis Package"),
                    image = "https://benben-miao.github.io/TOmicsVis/logo.png"
                ),
                #=== 1.2.1.2 bs4SidebarHeader
                bs4SidebarHeader(
                    title = strong("App Store 【12】")
                    ),
                #=== 1.2.1.3 bs4SidebarMenuItem
                bs4SidebarMenuItem(
                    text = "Home",
                    tabName = "home",
                    icon = icon("gear"),
                    badgeLabel = "Documents",
                    badgeColor = "danger",
                    href = NULL,
                    newTab = TRUE,
                    selected = NULL,
                    expandedName = NULL,
                    startExpanded = FALSE,
                    condition = NULL
                ),
                hr(),
                bs4SidebarMenuItem(
                    text = "1. Samples Statistics",
                    tabName = NULL,
                    icon = icon("bars"),
                    # badgeLabel = "6",
                    # badgeColor = "warning",
                    href = NULL,
                    newTab = TRUE,
                    selected = NULL,
                    expandedName = NULL,
                    startExpanded = TRUE,
                    condition = NULL,
                    bs4SidebarMenuSubItem(
                        text = "Quantile Plot",
                        tabName = "quantile_plot",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "Box Plot",
                        tabName = "box_plot",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "Violin Plot",
                        tabName = "violin_plot",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "Survival Plot",
                        tabName = "survival_plot",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    )
                ),
                bs4SidebarMenuItem(
                    text = "2. Traits Analysis",
                    tabName = NULL,
                    icon = icon("bars"),
                    # badgeLabel = "6",
                    # badgeColor = "warning",
                    href = NULL,
                    newTab = TRUE,
                    selected = NULL,
                    expandedName = NULL,
                    startExpanded = FALSE,
                    condition = NULL,
                    bs4SidebarMenuSubItem(
                        text = "Corr Heatmap",
                        tabName = "corr_heatmap",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "PCA Analysis",
                        tabName = "pca_analysis",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "PCA Plot",
                        tabName = "pca_plot",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "TSNE Analysis",
                        tabName = "tsne_analysis",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "TSNE Plot",
                        tabName = "tsne_plot",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "UMAP Analysis",
                        tabName = "umap_analysis",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "UMAP Plot",
                        tabName = "umap_plot",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "Dendro Plot",
                        tabName = "dendro_plot",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    )
                ),
                bs4SidebarMenuItem(
                    text = "3. Differential Expression",
                    tabName = NULL,
                    icon = icon("bars"),
                    # badgeLabel = "6",
                    # badgeColor = "warning",
                    href = NULL,
                    newTab = TRUE,
                    selected = NULL,
                    expandedName = NULL,
                    startExpanded = FALSE,
                    condition = NULL,
                    bs4SidebarMenuSubItem(
                        text = "Venn Plot",
                        tabName = "venn_plot",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "UpSetr Plot",
                        tabName = "upsetr_plot",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "Flower Plot",
                        tabName = "flower_plot",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "Volcano Plot",
                        tabName = "volcano_plot",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "MA Plot",
                        tabName = "ma_plot",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "Heatmap Group",
                        tabName = "heatmap_group",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "Circos Heatmap",
                        tabName = "circos_heatmap",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "Chord Plot",
                        tabName = "chord_plot",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    )
                ),
                bs4SidebarMenuItem(
                    text = "4. Advanced Analysis",
                    tabName = NULL,
                    icon = icon("bars"),
                    # badgeLabel = "6",
                    # badgeColor = "warning",
                    href = NULL,
                    newTab = TRUE,
                    selected = NULL,
                    expandedName = NULL,
                    startExpanded = FALSE,
                    condition = NULL,
                    bs4SidebarMenuSubItem(
                        text = "Gene Rank Plot",
                        tabName = "gene_rank_plot",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "Gene Cluster Trend",
                        tabName = "gene_cluster_trend",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "Trend Plot",
                        tabName = "trend_plot",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "Network Plot",
                        tabName = "network_plot",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "Heatmap Cluster",
                        tabName = "heatmap_cluster",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    )
                ),
                bs4SidebarMenuItem(
                    text = "5. GO and KEGG",
                    tabName = NULL,
                    icon = icon("bars"),
                    # badgeLabel = "6",
                    # badgeColor = "warning",
                    href = NULL,
                    newTab = TRUE,
                    selected = NULL,
                    expandedName = NULL,
                    startExpanded = FALSE,
                    condition = NULL,
                    bs4SidebarMenuSubItem(
                        text = "GO Enrich",
                        tabName = "go_enrich",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "GO Enrich Stat",
                        tabName = "go_enrich_stat",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "GO Enrich Bar",
                        tabName = "go_enrich_bar",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "GO Enrich Dot",
                        tabName = "go_enrich_dot",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "GO Enrich Net",
                        tabName = "go_enrich_net",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "KEGG Enrich",
                        tabName = "kegg_enrich",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "KEGG Enrich Bar",
                        tabName = "kegg_enrich_bar",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "KEGG Enrich Dot",
                        tabName = "kegg_enrich_dot",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "KEGG Enrich Net",
                        tabName = "kegg_enrich_net",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    )
                ),
                bs4SidebarMenuItem(
                    text = "6. Tables Operations",
                    tabName = NULL,
                    icon = icon("bars"),
                    # badgeLabel = "6",
                    # badgeColor = "warning",
                    href = NULL,
                    newTab = TRUE,
                    selected = NULL,
                    expandedName = NULL,
                    startExpanded = FALSE,
                    condition = NULL,
                    bs4SidebarMenuSubItem(
                        text = "Table Split",
                        tabName = "table_split",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "Table Merge",
                        tabName = "table_merge",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "Table Filter",
                        tabName = "table_filter",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    ),
                    bs4SidebarMenuSubItem(
                        text = "Table Cross",
                        tabName = "table_cross",
                        href = NULL,
                        newTab = TRUE,
                        icon = icon("angles-right"),
                        selected = NULL
                    )
                ),
                hr(),
                bs4SidebarMenuItem(
                    "About",
                    tabName = "about",
                    icon = icon("trophy"),
                    badgeLabel = "Author&Project",
                    badgeColor = "danger",
                    href = NULL,
                    newTab = TRUE,
                    selected = NULL,
                    expandedName = NULL,
                    startExpanded = FALSE,
                    condition = NULL
                )
            ),
            hr()
        )},
        #=== 1.3 bs4DashControlbar
        {controlbar = bs4DashControlbar(
            style = "padding: 10px;",
            id = NULL,
            disable = FALSE,
            width = 300,
            collapsed = TRUE,
            overlay = TRUE,
            skin = "light",
            pinned = FALSE,

            skinSelector()
            # sliderInput(
            #     inputId = "obs",
            #     label = "Number of observations:",
            #     min = 0,
            #     max = 1000,
            #     value = 500
            # )
        )},
        #=== 1.4 bs4DashFooter
        {footer = bs4DashFooter(
            left = span("Copyright: @benben-miao",
                        style = "font-weight:bold"),
            right = NULL,
            fixed = TRUE
        )},
        #=== 1.5 bs4DashBody
        body = bs4DashBody(
            style = "width: 800px;",
            tags$head(
                tags$link(rel = "stylesheet",
                          type = "text/css",
                          href = "styles.css")
            ),
            #=== 1.5.1 bs4DashPage -> bs4DashBody -> bs4TabItems
            bs4TabItems(
                #=== 1.5.1.1 bs4DashPage home
                {bs4TabItem(
                    tabName = "home",
                    fluidRow(
                        bs4Card( # 1
                            style = "padding: 0px;",
                            inputId = NULL,
                            title = "TOmicsVis API Documents",
                            footer = "",
                            width = 12,
                            height = NULL,
                            status = "danger",
                            elevation = 1,
                            solidHeader = FALSE,
                            headerBorder = FALSE,
                            gradient = FALSE,
                            collapsible = TRUE,
                            collapsed = FALSE,
                            closable = FALSE,
                            maximizable = TRUE,
                            icon = icon("github"),
                            boxToolSize = "sm",
                            label = NULL,
                            dropdownMenu = NULL,
                            sidebar = NULL,
                            tags$iframe(src = "https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf",
                                        width = "100%",
                                        height = "780px",
                                        style = "border-radius: 10px; border-width: 0px;")
                            # htmlOutput("home_markdown")
                        )
                    )
                )},
                #=== 1.5.1.2 bs4TabItem quantile_plot
                {bs4TabItem(
                    tabName = "network",
                    #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow
                    fluidRow(
                        bs4Card( # 1
                            style="padding:7px",
                            id = NULL,
                            title = "Options",
                            footer = NULL,
                            width = 3,
                            height = NULL,
                            status = "danger",
                            elevation = 1,
                            solidHeader = TRUE,
                            headerBorder = TRUE,
                            gradient = FALSE,
                            collapsible = FALSE,
                            collapsed = FALSE,
                            closable = FALSE,
                            maximizable = TRUE,
                            icon = icon("palette"),
                            boxToolSize = "sm",
                            label = NULL,
                            dropdownMenu = NULL,
                            sidebar = NULL,
                            #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow
                            fluidRow(
                                #=== bs4DashPage -> bs4DashBody -> bs4TabItems -> bs4TabItem -> fluidRow -> bs4Card -> fluidRow -> bs4Card
                                bs4Card( # 1
                                    style="padding:3px;font-size:1em;",
                                    inputId = NULL,
                                    title = "1.Upload/Download",
                                    footer = NULL,
                                    width = 12,
                                    height = NULL,
                                    status = "danger",
                                    elevation = 1,
                                    solidHeader = TRUE,
                                    headerBorder = TRUE,
                                    gradient = FALSE,
                                    collapsible = TRUE,
                                    collapsed = TRUE,
                                    closable = FALSE,
                                    maximizable = TRUE,
                                    # icon = icon(""),
                                    boxToolSize = "sm",
                                    label = NULL,
                                    dropdownMenu = NULL,
                                    sidebar = NULL,
                                    column(
                                        width = 12,
                                        fileInput(
                                            inputId = "input_file",
                                            label = "Fasta File",
                                            multiple = F,
                                            accept = NULL,
                                            width = NULL,
                                            buttonLabel = "Browse",
                                            placeholder = "Fasta Format "
                                        ),
                                        downloadButton(
                                            outputId = "download",
                                            label = "Download",
                                            class = NULL
                                        ),
                                        selectInput(
                                            inputId = "image_format",
                                            label = "Class",
                                            choices = c(
                                                "PDF" = "pdf",
                                                "SVG" = "svg",
                                                "PNG" = "png",
                                                "TIFF" = "tiff",
                                                "BMP" = "bmp",
                                                "JPEG" = "jpeg"
                                            ),
                                            selected = "pdf",
                                            multiple = F,
                                            width = NULL
                                        ),
                                    )
                                ),
                                bs4Card( # 1
                                    style="padding:7px",
                                    inputId = NULL,
                                    title = "2.Degree options",
                                    footer = NULL,
                                    width = 12,
                                    height = NULL,
                                    status = "danger",
                                    elevation = 1,
                                    solidHeader = TRUE,
                                    headerBorder = TRUE,
                                    gradient = FALSE,
                                    collapsible = TRUE,
                                    collapsed = TRUE,
                                    closable = FALSE,
                                    maximizable = TRUE,
                                    # icon = icon(""),
                                    boxToolSize = "sm",
                                    label = NULL,
                                    dropdownMenu = NULL,
                                    sidebar = NULL,
                                    column(
                                        width = 12,
                                        checkboxInput(
                                            inputId = "directed",
                                            label = "Directed",
                                            value = F,
                                            width = NULL
                                        ),
                                        selectInput(
                                            inputId = "class",
                                            label = "Class",
                                            choices = c(
                                                "Degree" = "degree",
                                                "Node" = "node"
                                            ),
                                            selected = "degree",
                                            multiple = F,
                                            width = NULL
                                        ),
                                        sliderInput(
                                            inputId = "degree",
                                            label = "Degree",
                                            min = 0,
                                            max = 1,
                                            value = 0.07,
                                            step = 0.01,
                                            round = T,
                                            ticks = T,
                                            animate = T,
                                            width = NULL,
                                            timeFormat = T
                                        )
                                    )
                                ),
                                bs4Card( # 1
                                    style="padding:7px",
                                    inputId = NULL,
                                    title = "3.Node attributions",
                                    footer = NULL,
                                    width = 12,
                                    height = NULL,
                                    status = "danger",
                                    elevation = 1,
                                    solidHeader = TRUE,
                                    headerBorder = TRUE,
                                    gradient = FALSE,
                                    collapsible = TRUE,
                                    collapsed = TRUE,
                                    closable = FALSE,
                                    maximizable = TRUE,
                                    # icon = icon(""),
                                    boxToolSize = "sm",
                                    label = NULL,
                                    dropdownMenu = NULL,
                                    sidebar = NULL,
                                    column(
                                        width = 12,
                                        sliderInput(
                                            inputId = "vertex_size",
                                            label = "Vertex Size",
                                            min = 0,
                                            max = 100,
                                            value = 10,
                                            step = 1,
                                            round = T,
                                            ticks = T,
                                            animate = T,
                                            width = NULL,
                                            timeFormat = T
                                        ),
                                        colourInput(
                                            inputId = "color_normal",
                                            label = "Normal Color",
                                            value = "#FFAE00CC",
                                            showColour = "both",
                                            palette = "square",
                                            allowedCols = NULL,
                                            allowTransparent = T,
                                            returnName = T
                                        ),
                                        colourInput(
                                            inputId = "color_from",
                                            label = "From Color",
                                            value = "#FF0000FE",
                                            showColour = "both",
                                            palette = "square",
                                            allowedCols = NULL,
                                            allowTransparent = T,
                                            returnName = T
                                        ),
                                        colourInput(
                                            inputId = "color_to",
                                            label = "To Color",
                                            value = "#FF00DD",
                                            showColour = "both",
                                            palette = "square",
                                            allowedCols = NULL,
                                            allowTransparent = T,
                                            returnName = T
                                        ),
                                        colourInput(
                                            inputId = "vertex_frame",
                                            label = "Border Color",
                                            value = "#FFFFFF",
                                            showColour = "both",
                                            palette = "square",
                                            allowedCols = NULL,
                                            allowTransparent = T,
                                            returnName = T
                                        ),
                                        selectInput(
                                            inputId = "shape_normal",
                                            label = "Normal Shape",
                                            choices = c(
                                                "circle",
                                                "crectangle",
                                                "csquare",
                                                "none",
                                                "pie",
                                                "raster",
                                                "rectangle",
                                                "sphere",
                                                "square",
                                                "vrectangle"
                                            ),
                                            selected = "circle",
                                            multiple = F,
                                            width = NULL
                                        ),
                                        selectInput(
                                            inputId = "shape_sp",
                                            label = "Center Shape",
                                            choices = c(
                                                "circle",
                                                "crectangle",
                                                "csquare",
                                                "none",
                                                "pie",
                                                "raster",
                                                "rectangle",
                                                "sphere",
                                                "square",
                                                "vrectangle"
                                            ),
                                            selected = "sphere",
                                            multiple = F,
                                            width = NULL
                                        )
                                    )
                                ),
                                bs4Card( # 1
                                    style="padding:7px",
                                    inputId = NULL,
                                    title = "4.Lable options",
                                    footer = NULL,
                                    width = 12,
                                    height = NULL,
                                    status = "danger",
                                    elevation = 1,
                                    solidHeader = TRUE,
                                    headerBorder = TRUE,
                                    gradient = FALSE,
                                    collapsible = TRUE,
                                    collapsed = TRUE,
                                    closable = FALSE,
                                    maximizable = TRUE,
                                    # icon = icon(""),
                                    boxToolSize = "sm",
                                    label = NULL,
                                    dropdownMenu = NULL,
                                    sidebar = NULL,
                                    column(
                                        width = 12,
                                        sliderInput(
                                            inputId = "label_cex",
                                            label = "Label Size",
                                            min = 0,
                                            max = 10,
                                            value = 0.5,
                                            step = 0.1,
                                            round = T,
                                            ticks = T,
                                            animate = T,
                                            width = NULL,
                                            timeFormat = T
                                        ),
                                        colourInput(
                                            inputId = "label_color",
                                            label = "Label Color",
                                            value = "#333333",
                                            showColour = "both",
                                            palette = "square",
                                            allowedCols = NULL,
                                            allowTransparent = T,
                                            returnName = T
                                        ),
                                        selectInput(
                                            inputId = "label_family",
                                            label = "label Family",
                                            choices = c(
                                                "Times",
                                                "Serif"
                                            ),
                                            selected = "Times",
                                            multiple = F,
                                            width = NULL
                                        ),
                                        sliderInput(
                                            inputId = "label_font",
                                            label = "Label Style",
                                            min = 1,
                                            max = 24,
                                            value = 1,
                                            step = 1,
                                            round = T,
                                            ticks = T,
                                            animate = T,
                                            width = NULL,
                                            timeFormat = T
                                        )
                                    )
                                ),
                                bs4Card( # 1
                                    style="padding:7px",
                                    inputId = NULL,
                                    title = "5.Edge attributions",
                                    footer = NULL,
                                    width = 12,
                                    height = NULL,
                                    status = "danger",
                                    elevation = 1,
                                    solidHeader = TRUE,
                                    headerBorder = TRUE,
                                    gradient = FALSE,
                                    collapsible = TRUE,
                                    collapsed = TRUE,
                                    closable = FALSE,
                                    maximizable = TRUE,
                                    # icon = icon(""),
                                    boxToolSize = "sm",
                                    label = NULL,
                                    dropdownMenu = NULL,
                                    sidebar = NULL,
                                    column(
                                        width = 12,
                                        checkboxInput(
                                            inputId = "edge_curved",
                                            label = "Edge Cured",
                                            value = F,
                                            width = NULL
                                        ),
                                        colourInput(
                                            inputId = "edge_color",
                                            label = "Edge Color",
                                            value = "#888888",
                                            showColour = "both",
                                            palette = "square",
                                            allowedCols = NULL,
                                            allowTransparent = T,
                                            returnName = T
                                        ),
                                        sliderInput(
                                            inputId = "edge_arrow_mode",
                                            label = "Arrow Mode",
                                            min = 0,
                                            max = 3,
                                            value = 1,
                                            step = 1,
                                            round = T,
                                            ticks = T,
                                            animate = T,
                                            width = NULL,
                                            timeFormat = T
                                        ),
                                        sliderInput(
                                            inputId = "arrow_size",
                                            label = "Arrow Size",
                                            min = 0,
                                            max = 5,
                                            value = 0,
                                            step = 0.1,
                                            round = T,
                                            ticks = T,
                                            animate = T,
                                            width = NULL,
                                            timeFormat = T
                                        ),
                                        sliderInput(
                                            inputId = "arrow_width",
                                            label = "Arrow Width",
                                            min = 0,
                                            max = 5,
                                            value = 1,
                                            step = 0.1,
                                            round = T,
                                            ticks = T,
                                            animate = T,
                                            width = NULL,
                                            timeFormat = T
                                        ),
                                        sliderInput(
                                            inputId = "edge_width",
                                            label = "Edge Width",
                                            min = 0,
                                            max = 10,
                                            value = 2,
                                            step = 0.1,
                                            round = T,
                                            ticks = T,
                                            animate = T,
                                            width = NULL,
                                            timeFormat = T
                                        ),
                                        sliderInput(
                                            inputId = "dege_lty",
                                            label = "Line Type",
                                            min = 1,
                                            max = 10,
                                            value = 1,
                                            step = 1,
                                            round = T,
                                            ticks = T,
                                            animate = T,
                                            width = NULL,
                                            timeFormat = T
                                        )
                                    )
                                ),
                                bs4Card( # 1
                                    style="padding:7px",
                                    inputId = NULL,
                                    title = "6.Layout choise",
                                    footer = NULL,
                                    width = 12,
                                    height = NULL,
                                    status = "danger",
                                    elevation = 1,
                                    solidHeader = TRUE,
                                    headerBorder = TRUE,
                                    gradient = FALSE,
                                    collapsible = TRUE,
                                    collapsed = FALSE,
                                    closable = FALSE,
                                    maximizable = TRUE,
                                    # icon = icon(""),
                                    boxToolSize = "sm",
                                    label = NULL,
                                    dropdownMenu = NULL,
                                    sidebar = NULL,
                                    column(
                                        width = 12,
                                        selectInput(
                                            inputId = "layout",
                                            label = "Layout",
                                            choices = c(
                                                "layout_as_bipartite",
                                                "layout_as_star",
                                                "layout_as_tree",
                                                "layout_components",
                                                "layout_in_circle",
                                                "layout_nicely",
                                                "layout_on_grid",
                                                "layout_on_sphere",
                                                "layout_randomly",
                                                "layout_with_dh",
                                                "layout_with_drl",
                                                "layout_with_fr",
                                                "layout_with_gem",
                                                "layout_with_graphopt",
                                                "layout_with_kk",
                                                "layout_with_lgl",
                                                "layout_with_mds",
                                                "layout_with_sugiyama"
                                            ),
                                            selected = "layout_on_sphere",
                                            multiple = F,
                                            width = NULL
                                        ),
                                        sliderInput(
                                            inputId = "top",
                                            label = "Margin Top",
                                            min = -10,
                                            max = 10,
                                            value = 0,
                                            step = 0.1,
                                            round = T,
                                            ticks = T,
                                            animate = T,
                                            width = NULL,
                                            timeFormat = T
                                        ),
                                        sliderInput(
                                            inputId = "right",
                                            label = "Margin Right",
                                            min = -10,
                                            max = 10,
                                            value = 0,
                                            step = 0.1,
                                            round = T,
                                            ticks = T,
                                            animate = T,
                                            width = NULL,
                                            timeFormat = T
                                        ),
                                        sliderInput(
                                            inputId = "bottom",
                                            label = "Margin Bottom",
                                            min = -10,
                                            max = 10,
                                            value = 0,
                                            step = 0.1,
                                            round = T,
                                            ticks = T,
                                            animate = T,
                                            width = NULL,
                                            timeFormat = T
                                        ),
                                        sliderInput(
                                            inputId = "left",
                                            label = "Margin Left",
                                            min = -10,
                                            max = 10,
                                            value = 0,
                                            step = 0.1,
                                            round = T,
                                            ticks = T,
                                            animate = T,
                                            width = NULL,
                                            timeFormat = T
                                        )
                                    )
                                )
                            )
                        ),
                        bs4Card( # 1
                            inputId = NULL,
                            title = "Network",
                            footer = "Canvas",
                            width = 9,
                            height = NULL,
                            status = "danger",
                            elevation = 1,
                            solidHeader = TRUE,
                            headerBorder = TRUE,
                            gradient = FALSE,
                            collapsible = TRUE,
                            collapsed = FALSE,
                            closable = FALSE,
                            maximizable = TRUE,
                            icon = icon("image"),
                            boxToolSize = "sm",
                            label = NULL,
                            dropdownMenu = NULL,
                            sidebar = NULL,
                            plotOutput("plot",
                                       height = 720)
                        )

                    )
                )},
                #=== 1.5.1.3 bs4DashPage about
                {bs4TabItem(
                    tabName = "about",
                    fluidRow(
                        bs4Card( # 1
                            style="padding:20px;",
                            inputId = NULL,
                            title = "Author Information",
                            footer = "",
                            width = 12,
                            height = NULL,
                            status = "danger",
                            elevation = 1,
                            solidHeader = TRUE,
                            headerBorder = TRUE,
                            gradient = FALSE,
                            collapsible = TRUE,
                            collapsed = FALSE,
                            closable = FALSE,
                            maximizable = TRUE,
                            icon = icon("github"),
                            boxToolSize = "sm",
                            label = NULL,
                            dropdownMenu = NULL,
                            sidebar = NULL,
                            p("Author: benben-miao",
                              style="font-weight:bold"),
                            p("Email: benben.miao@outlook.com",
                              style="font-weight:bold"),
                            p("Institution: Xiamen University",
                              style="font-weight:bold"),
                            p("Github: ",
                              a("https://github.com/benben-miao", href="https://github.com/benben-miao"),
                              style="font-weight:bold"),
                            p("BioSciTools: ",
                              a("https://github.com/bioscitools", href="https://github.com/bioscitools"),
                              style="font-weight:bold"),
                            p("Researchgate: ",
                              a("https://researchgate.net/profile/Benben-Miao", href="https://researchgate.net/profile/Benben-Miao"),
                              style="font-weight:bold")
                        )
                    )
                )}
            )
        )
    )
)

server <- shinyServer(function(input, output) {

    # markdown_content <- readLines("../README.md", warn = FALSE)
    # markdown_text <- paste(markdown_content, collapse = "\n")
    # html_content <- markdown::markdownToHTML(markdown_text)
    # output$home_markdown <- renderUI({
    #     HTML(html_content)
    # })

    output$plot <- renderPlot({
        # 1.data
        if(is.null(input$input_file)){
            data <- read.table(data_path,
                               sep = "\t",
                               header = T)
        }else{
            data <- read.table(input$input_file$datapath,
                               sep = "\t",
                               header = T)
        }
        # head(data)
        data <- as.data.frame(data)
        # 2.net
        net <- graph_from_data_frame(
            data,
            directed = input$directed,
            vertices = NULL
        )
        # 3.node

        # 4.degree
        if (input$class == "degree"){
            deg <- degree(
                net,
                v = V(net),
                mode = c("all"),
                loops = TRUE,
                normalized = T
            )
            # max(deg)
            # degdis <- degree_distribution(net)
            # degdis
            vcolor <- rep(input$color_normal,
                          vcount(net))
            vcolor[deg > input$degree] <- colorRampPalette(c(input$color_from,
                                                             input$color_to))(10)
            vertex_shape <-rep(input$shape_normal,
                               vcount(net))
            vertex_shape[deg > input$degree] <- input$shape_sp
        }else if (input$class == "node"){
            vcolor <- rep(input$color_normal,
                          vcount(net))
            vcolor[V(net)$name %in% data$node1] <- colorRampPalette(c(input$color_from,
                                                                      input$color_to))(10)
            vertex_shape <-rep(input$shape_normal,
                               vcount(net))
            vertex_shape[V(net)$name %in% data$node1] <- input$shape_sp
        }

        plot(
            net,
            main="Networks",
            xlab = "",
            ylab = "",
            axes = F,
            add = F,
            vertex.color = vcolor,
            vertex.size = input$vertex_size,
            vertex.shape = vertex_shape, # "circle","crectangle","csquare","none","pie","raster","rectangle","sphere","square","vrectangle"
            # vertex.size2 = 30,
            vertex.frame.color = input$vertex_frame,
            # vertex.label = NA,
            vertex.label.color = input$label_color,
            vertex.label.family = input$label_family,
            vertex.label.cex = input$label_cex,
            vertex.label.font = input$label_font, # 1 is plain text, 2 is bold face, 3 is italic, 4 is bold and italic and 5 specifies the symbol font.
            vertex.label.dist = 0,
            vertex.label.degree = -pi/4,
            edge.color = input$edge_color,
            edge.label.cex = input$label_cex,
            edge.label.color = input$label_color,
            edge.label.family = input$label_family,
            edge.label.font = input$label_font,
            layout = do.call(input$layout, list(net)), # String to Matrix
            edge.arrow.mode = input$edge_arrow_mode,
            edge.arrow.size = input$arrow_size,
            edge.arrow.width = input$arrow_width,
            edge.width = input$edge_width,
            edge.lty = input$dege_lty,
            edge.curved = input$edge_curved,
            margin = c(input$top,
                       input$right,
                       input$bottom,
                       input$left)
        )
    })
    output$download <- downloadHandler(
        filename = function(){
            paste("networks",input$image_format,sep = ".")
        },
        content = function(file){
            # 1.data
            if(is.null(input$input_file)){
                data <- read.table(data_path,
                                   sep = "\t",
                                   header = T)
            }else{
                data <- read.table(input$input_file$datapath,
                                   sep = "\t",
                                   header = T)
            }
            # head(data)
            data <- as.data.frame(data)
            # 2.net
            net <- graph_from_data_frame(
                data,
                directed = input$directed,
                vertices = NULL
            )
            # 3.node

            # 4.degree
            if (input$class == "degree"){
                deg <- degree(
                    net,
                    v = V(net),
                    mode = c("all"),
                    loops = TRUE,
                    normalized = T
                )
                # max(deg)
                # degdis <- degree_distribution(net)
                # degdis
                vcolor <- rep(input$color_normal,
                              vcount(net))
                vcolor[deg > input$degree] <- colorRampPalette(c(input$color_from,
                                                                 input$color_to))(10)
                vertex_shape <-rep(input$shape_normal,
                                   vcount(net))
                vertex_shape[deg > input$degree] <- input$shape_sp
            }else if (input$class == "node"){
                vcolor <- rep(input$color_normal,
                              vcount(net))
                vcolor[V(net)$name %in% data$node1] <- colorRampPalette(c(input$color_from,
                                                                          input$color_to))(10)
                vertex_shape <-rep(input$shape_normal,
                                   vcount(net))
                vertex_shape[V(net)$name %in% data$node1] <- input$shape_sp
            }

            if (input$image_format == "pdf"){
                pdf(file = file,
                    family = "Times")
            }else if (input$image_format == "svg"){
                svg(file = file,
                    family = "Times")
            }else if (input$image_format == "png"){
                png(file = file,
                    family = "Times")
            }else if (input$image_format == "tiff"){
                tiff(file = file,
                     family = "Times")
            }else if (input$image_format == "bmp"){
                bmp(file = file,
                    family = "Times")
            }else if (input$image_format == "jpeg"){
                jpeg(file = file,
                     family = "Times")
            }


            plot(
                net,
                main="Networks",
                xlab = "",
                ylab = "",
                axes = F,
                add = F,
                vertex.color = vcolor,
                vertex.size = input$vertex_size,
                vertex.shape = vertex_shape, # "circle","crectangle","csquare","none","pie","raster","rectangle","sphere","square","vrectangle"
                # vertex.size2 = 30,
                vertex.frame.color = input$vertex_frame,
                # vertex.label = NA,
                vertex.label.color = input$label_color,
                vertex.label.family = input$label_family,
                vertex.label.cex = input$label_cex,
                vertex.label.font = input$label_font, # 1 is plain text, 2 is bold face, 3 is italic, 4 is bold and italic and 5 specifies the symbol font.
                vertex.label.dist = 0,
                vertex.label.degree = -pi/4,
                edge.color = input$edge_color,
                edge.label.cex = input$label_cex,
                edge.label.color = input$label_color,
                edge.label.family = input$label_family,
                edge.label.font = input$label_font,
                layout = do.call(input$layout, list(net)), # String to Matrix
                edge.arrow.mode = input$edge_arrow_mode,
                edge.arrow.size = input$arrow_size,
                edge.arrow.width = input$arrow_width,
                edge.width = input$edge_width,
                edge.lty = input$dege_lty,
                edge.curved = input$edge_curved,
                margin = c(input$top,
                           input$right,
                           input$bottom,
                           input$left)
            )
            dev.off()
        }
    )

    data_demo <- read.table(data_path,
                            sep = "\t",
                            header = T)
    data_demo <- as.data.frame(data_demo)

    net_demo <- graph_from_data_frame(
        data_demo,
        directed = F,
        vertices = NULL
    )
    deg_demo <- degree(
        net_demo,
        v = V(net_demo),
        mode = c("all"),
        loops = TRUE,
        normalized = T
    )
    # max(deg)
    # degdis <- degree_distribution(net)
    # degdis
    vcolor_demo <- rep("#FFAE00CC",
                                  vcount(net_demo))
    vcolor_demo[deg_demo > 0.07] <- colorRampPalette(c("#FF0000FE", "#FF00DD"))(10)
    shape_demo <-rep("circle",
                     vcount(net_demo))
    shape_demo[deg_demo > 0.07] <- "sphere"

    layouts <- grep("^layout_", ls("package:igraph"), value=TRUE)[-1]

    output$table <- renderDT({
        data_demo
    })
})

# Run the application
# shinyApp(ui = ui, server = server)
runApp(list(ui = ui, server = server), port = 6767)

# -> 1. Components
# fileInput(
#     inputId = "input_file",
#     label = "File",
#     multiple = FALSE,
#     accept = NULL,
#     width = NULL,
#     buttonLabel = "Browse",
#     placeholder = "Format: TXT"
# ),
# downloadButton(
#     outputId = "download",
#     label = "Download",
#     class = NULL,
#     icon = shiny::icon("download")
# ),
# textInput(
#     inputId = "text_input",
#     label = "Text Input",
#     value = "",
#     width = "100",
#     placeholder = NULL
# ),
# textAreaInput(
#     inputId = "text_input",
#     label = "Text Input",
#     value = "",
#     width = "100%",
#     height = "100%",
#     cols = NULL,
#     rows = 10,
#     placeholder = NULL,
#     resize = "vertical"
# ),
# selectInput(
#     inputId = "image_format",
#     label = "Image Format",
#     choices = c(
#         "PDF" = "pdf",
#         "JPEG" = "jpeg"
#     ),
#     selected = "pdf",
#     multiple = FALSE,
#     width = NULL
# ),
# checkboxInput(
#     inputId = "show",
#     label = "Show",
#     value = FALSE,
#     width = NULL
# ),
# sliderInput(
#     inputId = "alpha",
#     label = "Alpha",
#     min = 0.00,
#     max = 1.00,
#     value = 0.50,
#     step = 0.01,
#     round = TRUE,
#     ticks = TRUE,
#     animate = TRUE,
#     width = NULL,
#     pre = NULL,
#     post = NULL,
#     timeFormat = TRUE,
#     timezone = NULL,
#     dragRange = TRUE
# ),
# colourInput(
#     inputId = "color_normal",
#     label = "Normal Color",
#     value = "#FFAE00CC",
#     showColour = "both",
#     palette = "square",
#     allowedCols = NULL,
#     allowTransparent = TRUE,
#     returnName = TRUE,
#     closeOnClick = FALSE,
#     width = NULL
# ),

# -> 2. Plot
# output$plot <- renderPlot({
#     # 1.data
#     if(is.null(input$input_file)) {
#         data <- read.table(data_path,
#                            sep = "\t",
#                            header = T)
#     }else{
#         data <- read.table(input$input_file$datapath,
#                            sep = "\t",
#                            header = T)
#     }
# })

# -> 3. Download
# output$download <- downloadHandler(
#     filename = function(){
#         paste("networks",input$image_format,sep = ".")
#     },
#     content = function(file){
#         pdf(file = file)
#         dev.off()
#     }
# )

# -> 4. Table
# output$table <- renderDT({
#     data_demo
# }, options = list(scrollX = TRUE))
# DTOutput()

# -> 5. Control
# actionButton(
#     inputId = "start",
#     label = "Start",
#     icon = icon('play-circle'),
#     width = NULL
# )
#
# input$start
#
# progress <- Progress$new(session, min=1, max=100)
# on.exit(progress$close())
# progress$set(value = 50)
# progress$set(message = 'Running Prediction of Result-Data!',
#              detail = 'This may take a while...')
#
# output$mirna_gene_ui <- renderUI({
#     textAreaInput(
#         inputId = "text_input",
#         label = "Text Input",
#         value = "",
#         width = "100%",
#         height = "100px",
#         cols = NULL,
#         rows = 10,
#         placeholder = "",
#         resize = "vertical"
#     )
# })
