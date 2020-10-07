library(tools)
list.of.packages <- c("tools", "shiny", "ggplot2", "edgeR", "biomaRt", "gplots", "reshape2", "plotly", "cluster", "DT", "shinythemes", "rmarkdown")
lapply(list.of.packages, library, character.only=TRUE)
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) {install.packages(new.packages)}

# Text
output$which_data <- renderText({
  if (is.null(input$biomart_user_file)) {
    paste("Table with example data is shown below. This is how it have to look like.")  
  }else{
    paste("Your file: ")
  }
  })

# Load example data from the user
our_example_data_R <- function(){
  e = new.env()
  name <- load(paste0(working_dir,"/data.RData"), envir = e)
  fil <- e[[name]]
}

# Parameters for potential Biomart query
output$dataset_organizm <- renderUI({
  ensembl<-useEnsembl(biomart=input$database)
  ch<-listDatasets(ensembl)
    selectInput("dataset", label = h3("Define organism"), choices = c(ch), selected = "hsapiens_gene_ensembl")
})

# User file (loading)
dataframe<-function(){
  if (!file_ext(input$"biomart_user_file"$datapath)=="RData"){
    fil <- read.table(input$"biomart_user_file"$datapath)
  }else{
  e = new.env()
  name <- load(input$"biomart_user_file"$datapath, envir = e)
  fil <- e[[name]]
  }
  return(fil)
}

# Making a matrix from a file
userBase <- function(){
  if (!is.null(input$biomart_user_file)) {
    fil <- dataframe()
    if (!class(fil) == 'matrix') {
      fil <- data.matrix(fil)
    }
    return(fil)
  } else {
    return(our_example_data_R())
  }
}

# Display on the 'User data preview' tab panel
output$data <- renderDT({
  DT::datatable(userBase(), options = list(pageLength = 5))
})

# Display on the first "Data: user input" tab panel as example data
observe({
  output$example_user_data <- renderDT({
  withProgress(message = "Loading...",
               {
                 if (names(dev.cur()) != "null device") dev.off()
                 pdf(NULL)
  if (is.null(input$biomart_user_file)) {
    rr <- data.frame(our_example_data_R())
  }else{
    rr <- data.frame(userBase())
  }
  return(rr)
               })
})

outputOptions(output, "data", priority = 11, suspendWhenHidden = FALSE)
})
