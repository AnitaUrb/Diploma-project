list.of.packages <- c("shiny", "ggplot2", "edgeR", "biomaRt", "gplots", "reshape2", "plotly", "cluster", "DT", "shinythemes", "rmarkdown")
lapply(list.of.packages, library, character.only=TRUE)
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) {install.packages(new.packages)}

# UI for "Specific genes visualization" tab panel
tabPanel("Specific genes visualization",
         mainPanel(
           plotOutput("exprp"),    
           downloadButton("exprp_download", "Download plot")
           )
         )