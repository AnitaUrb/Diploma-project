list.of.packages <- c("shiny", "ggplot2", "edgeR", "biomaRt", "gplots", "reshape2", "plotly", "cluster", "DT", "shinythemes", "rmarkdown")
lapply(list.of.packages, library, character.only=TRUE)
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) {install.packages(new.packages)}

# UI for the "Biomart data" tab panel
tabPanel("BioMart data",
         sidebarPanel(
           uiOutput("query"),
           uiOutput("attrs"),
           uiOutput("query_ids"),
           uiOutput("filters"),
           uiOutput("is_query_ok"),
           downloadLink('report', "Download full report")
         ),
         mainPanel(
           uiOutput("status"),
           tableOutput("downloaded_annotations"),
           uiOutput("bio_button"),
           uiOutput("ss_check"),
           DT::dataTableOutput("ss"),
           uiOutput("heatmap_s"),
           DT::dataTableOutput("vv"),
           uiOutput("volcano_s"),
           DT::dataTableOutput("hh")
           )
         )
