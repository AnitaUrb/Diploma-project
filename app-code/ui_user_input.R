list.of.packages <- c("shiny", "ggplot2", "edgeR", "biomaRt", "gplots", "reshape2", "plotly", "cluster", "DT", "shinythemes", "rmarkdown")
lapply(list.of.packages, library, character.only=TRUE)
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) {install.packages(new.packages)}

# UI for the first "Data: user input" tab panel
tabPanel("Data: user input",
         sidebarPanel(
           fileInput("biomart_user_file", "Browse your RNA-seq result file",
                     accept = c(
                       'text/csv',
                       'text/comma-separated-values',
                       'text/tab-separated-values',
                       'text/plain',
                       '.csv',
                       '.tsv'
                       ),
                     )
           ),
         mainPanel(
           textOutput("which_data"),
           DT::dataTableOutput("example_user_data")
           )
         )