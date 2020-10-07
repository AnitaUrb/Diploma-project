list.of.packages <- c("shiny", "ggplot2", "edgeR", "biomaRt", "gplots", "reshape2", "plotly", "cluster", "DT", "shinythemes", "rmarkdown")
lapply(list.of.packages, library, character.only=TRUE)
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) {install.packages(new.packages)}

# UI script
ui <- navbarPage(theme = shinytheme("cerulean"), "RNA-seq analysis app",
  source("ui_user_input.R",local=TRUE)$value,
  source("ui_data_vis.R",local=TRUE)$value,
  source("ui_samples_analysis.R",local=TRUE)$value,
  source("ui_de_genes1.R",local=TRUE)$value,
  source("ui_de_genes2.R",local=TRUE)$value,
  source("ui_biomart.R",local=TRUE)$value
  )
