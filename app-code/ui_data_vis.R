list.of.packages <- c("shiny", "ggplot2", "edgeR", "biomaRt", "gplots", "reshape2", "plotly", "cluster", "DT", "shinythemes", "rmarkdown")
lapply(list.of.packages, library, character.only=TRUE)
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) {install.packages(new.packages)}

# UI for the "User data preview" tab panel
tabPanel("User data preview",
         sidebarPanel(
           selectInput("database", label = h3("Define annotation version"), choices = c(listEnsembl()), selected = "ensembl"),
           uiOutput("dataset_organizm")
         ),
         mainPanel(
           DT::dataTableOutput("data")
         ))