list.of.packages <- c("shiny", "ggplot2", "edgeR", "biomaRt", "gplots", "reshape2", "plotly", "cluster", "DT", "shinythemes", "rmarkdown")
lapply(list.of.packages, library, character.only=TRUE)
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) {install.packages(new.packages)}

# Server functions for the "Biomart data" tab panel

# Button for loading annotations
output$is_query_ok <- renderUI({
  actionButton("query_ok", label = "Load annotations")
})

# Status of query
output$status <- renderUI({
  req(input$dataset)
  if (input$query_ok == TRUE) {
    h5("Started connection to ensemble biomart database. Head of results is shown below: ")
  } else {
    paste("There will be displayed your result table.")
  }
})

# Shows what is already selected from 'data visualization'
output$query <- renderUI({
  req(input$dataset)
  paste("You have already selected: ", input$database, ", ", input$dataset)
})

# Field for enetering genes ids
output$query_ids <- renderUI({
  req(input$dataset)
  textInput("gene_values", HTML(paste(h3("Put gene ids of interest"), h4("(separated by comma)"))))
})

# Field to choose (several) attributes
output$attrs <- renderUI({
  req(input$dataset)
  ensembl<-useEnsembl(biomart=input$database, dataset=input$dataset)
  ch<-listAttributes(ensembl)
  selectInput("attr", label = h3("Define attributes"), choices = c(ch), selected = 'ensembl_gene_id', multiple = TRUE)
})

# Field for choosing filter (one; type of id)
output$filters <- renderUI({
  req(input$dataset)
  ensembl<-useEnsembl(biomart=input$database, dataset=input$dataset)
  ch<-listAttributes(ensembl)
  selectInput("fltrs", label = h3("Select type of your gene ids"), choices = c(ch), selected = 'ensembl_gene_id')
})

# Checkbox for selected Top DE genes values (filteredTable())
output$ss_check <- renderUI({
  if (nrow(filteredTable())>0) {
    checkboxInput("ss_box", "Load annotations?")
    }else{
    return(NULL)
  }
})

# Checkbox for selected Heatmap values(x$df)
output$heatmap_s <- renderUI({
  if (!is.null(x$df)){
    checkboxInput("heat_box", "Load annotations?")
  }else{
    return(NULL)
  }
})

# Checkbox for selected Volcano plot values(values$DT)
output$volcano_s <- renderUI({
  if (!is.null(values$DT)) {
    checkboxInput("volc_box", "Load annotations?")
  }else{
    return(NULL)
  }
})

# Volcano plot : display of selected genes ids
output$hh <- renderDT({
  req(input$dataset)
  if (!is.null(values$DT)){
    values$DT
  }else{return(NULL)}
})

# Heatmap : display of selected gene ids
output$vv <- renderDT({
  req(input$dataset)
  if (!is.null(x$df)){
    x$df
  }else{return(NULL)}
})

# Top DE genes table : display of selected gene ids
output$ss <- renderDT({
  req(input$dataset)
  if (nrow(filteredTable())>0)
  {return(filteredTable())}
  else{return(NULL)}
})

# Variable for storage selected by the user gene ids for connection with bases
did_select <- reactive({
  vals = c()
  if (!is.null(input$volc_box)&&(as.character(input$volc_box)=="TRUE")) {
    vals <- c(vals, c(levels(values$DT[,1])))
  }
    if (!is.null(input$gene_values)) {
    vals <- c(vals, input$gene_values)
  }
    if (!is.null(input$heat_box) && (as.character(input$heat_box)=="TRUE")) {
    vals <- c(vals, c(x$df[,1]))
  }
    if (!is.null(input$ss_box)&&(as.character(input$ss_box)=="TRUE")) {
    vals <- c(vals, c(rownames(filteredTable())))
  }
  return(vals)
})

# Variable used for creating report
do_raportu <- reactiveValues(BM=NULL)

# Reactive connection to biomart database
reactive_biomart_annotations <- eventReactive(input$query_ok, {
  ensembl<-useEnsembl(biomart=input$database, dataset=input$dataset)
  f <- c(input$fltrs)
  v <- as.list(na.omit(did_select()))
  bm<-getBM(attributes = c(input$attr), filters = f, values = did_select(), mart = ensembl)
  bm=as.data.frame(bm)
  do_raportu$BM<-data.frame(bm)
  return(bm)
})

# Display of loaded annotations
observe({
  output$downloaded_annotations <- renderTable({
    withProgress(message = "Downloading data from ensembl, please wait",
                 {
                   if (names(dev.cur()) != "null device") dev.off()
                   pdf(NULL)
                   reactive_biomart_annotations()
                 })
  })

  outputOptions(output, "downloaded_annotations", priority = 7, suspendWhenHidden = FALSE)
  
# Annotations download button (UI)
  output$bio_button <- renderUI({
    req(reactive_biomart_annotations())
    downloadButton("biomart_connect", "Download table")
  })
  
# Annotations download button (Server)
  output$biomart_connect <- downloadHandler(
    filename = function() {
      paste("biomart_data", ".csv", sep = "")
    },
    content = function(file) {
      write.table(reactive_biomart_annotations(), file, sep="\t", row.names = FALSE)
    })
})

outputOptions(output, "filters", priority = 8, suspendWhenHidden = FALSE)

outputOptions(output, "attrs", priority = 9, suspendWhenHidden = FALSE)

outputOptions(output, "dataset_organizm", priority = 10, suspendWhenHidden = FALSE)
