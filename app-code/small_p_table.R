list.of.packages <- c("shiny", "ggplot2", "edgeR", "biomaRt", "gplots", "reshape2", "plotly", "cluster", "DT", "shinythemes", "rmarkdown")
lapply(list.of.packages, library, character.only=TRUE)
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) {install.packages(new.packages)}

# Server functions for the "Top DE genes" tab from the "Differently expressed genes" tab panel

# PValue user-defined value
setPvalue <- function(){
  return(input$setPvalue)
}

# Top DE genes table
smallp_table <- reactive({
  sm <- reactiveModel()[reactiveModel()$table$FDR<setPvalue(),]
  res <- data.frame(sm)
  return(as.data.frame(res))
})

observe({
output$smallp <- renderDT(
  withProgress(message = "Parsing data, please wait",
               {
                 if (names(dev.cur()) != "null device") dev.off()
                 pdf(NULL)
                 DT::datatable(smallp_table(),selection = list(mode = "multiple"), options = list(pageLength = 5))
               })
)

outputOptions(output, "smallp", priority = 6)
})

# Table of selected values
filteredTable <- reactive({
  ids <- input$smallp_rows_selected
  data.frame(smallp_table()[ids,])
})

output$ss <- renderDT({
  if (nrow(filteredTable())>0)
    {return(filteredTable())}
  else{return(NULL)}
})

# Button to download table (UI)
output$smallp_button <- renderUI({
  req(smallp_table())
  downloadButton("downloadData", "Download table")
})

# Button to download table (Server)
output$downloadData <- downloadHandler(
  filename = function() {
    paste("small", ".csv", sep = "")},
  content = function(file) {
    write.table(smallp_table(), file, sep="\t", row.names = FALSE)}
  )
