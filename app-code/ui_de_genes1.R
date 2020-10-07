list.of.packages <- c("shiny", "ggplot2", "edgeR", "biomaRt", "gplots", "reshape2", "plotly", "cluster", "DT", "shinythemes", "rmarkdown")
lapply(list.of.packages, library, character.only=TRUE)
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) {install.packages(new.packages)}

# UI for the "Differently expressed genes" tab panel
tabPanel("Differently expressed genes",
         sidebarPanel(
           sliderInput(inputId = "setPvalue",
                       label = "Set adjusted p-value (FDR) cutoff:",
                       min = 0.001,
                       max = 0.5,
                       value = 0.005),
           conditionalPanel(condition="input.tabselected==1",
                            uiOutput("smallp_button")
                            ),
           conditionalPanel(condition="input.tabselected==2",
                            uiOutput("set_heatmap_size"),
                            sliderInput(inputId = "setHeatmapSize",
                                        label = "Set size of heatmap:",
                                        min = 1,
                                        max = 100,
                                        value = 10)
                            ),
           conditionalPanel(condition="input.tabselected==3",
                            sliderInput(inputId = "setlogFC",
                                        label = "Set logFC cutoff:",
                                        min = 0,
                                        max = 20,
                                        value = 5),
                            downloadButton("volcano_download", "Download volcanoplot"))
           ),
         mainPanel(
           tabsetPanel(
             tabPanel("Top DE genes", value = 1, DT::dataTableOutput("smallp")
                      ),
             tabPanel("Heatmap of z-scores via rows", value = 2, plotlyOutput("heatmap_p"),
                      uiOutput("h_capt"),
                      DT::dataTableOutput("selected"),
                      uiOutput("rem_row_h")),
             tabPanel("Volcano plot", value = 3,
                      plotOutput("volcano", click="plot_click"), 
                      DT::dataTableOutput("clickedPoints"),
                      uiOutput("rem_row_v")
                      ),
             id = "tabselected"
             )
           )
         )
