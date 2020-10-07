list.of.packages <- c("shiny", "ggplot2", "edgeR", "biomaRt", "gplots", "reshape2", "plotly", "cluster", "DT", "shinythemes", "rmarkdown")
lapply(list.of.packages, library, character.only=TRUE)
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) {install.packages(new.packages)}

# UI for "Samples analysis" tab panel
tabPanel("Samples analysis",
         mainPanel(
           plotOutput("expr"),    
           uiOutput("download_expr"),
           plotOutput("dens"),    
           uiOutput("download_dens")
           )
         )