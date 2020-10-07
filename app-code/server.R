list.of.packages <- c("tools", "shiny", "ggplot2", "gplots", "reshape2", "plotly", "cluster", "DT", "shinythemes", "rmarkdown", "knitr")
lapply(list.of.packages, library, character.only=TRUE)
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) {install.packages(new.packages)}
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
bio <- c("edgeR", "biomaRt")
if(!(bio%in% installed.packages())) {
BiocManager::install("edgeR")
BiocManager::install("biomaRt")}

working_dir <- getwd()

# Server script 

server <- function(input, output){
  
  list.of.packages <- c("shiny", "ggplot2", "edgeR", "biomaRt", "gplots", "reshape2", "plotly", "cluster", "DT", "shinythemes", "rmarkdown")
  lapply(list.of.packages, library, character.only=TRUE)
  new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
  if(length(new.packages)) {install.packages(new.packages)}
  
  source("downloader.R",local = TRUE)
  source("user_base.R",local = TRUE)
  source("biomart_loads.R",local = TRUE)
  source("samples_analysis.R", local=TRUE)
  source("reactive_model.R", local=TRUE)
  source("small_p_table.R", local = TRUE)
  source("heatmap.R", local = TRUE)
  source("volcano_plot.R", local = TRUE)
  source("exprp.R", local = TRUE)
  
}
