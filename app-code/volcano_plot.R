list.of.packages <- c("shiny", "ggplot2", "edgeR", "biomaRt", "gplots", "reshape2", "plotly", "cluster", "DT", "shinythemes", "rmarkdown")
lapply(list.of.packages, library, character.only=TRUE)
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) {install.packages(new.packages)}

# Server functions for the "Volcano plot" tab from the "Differently expressed genes" tab panel

# Function for storing data for the plot
dataFilter <- function(){
  volcanodata <- data.frame(cbind(reactiveModel()$table$logFC, -log10(reactiveModel()$table$FDR)))
  colnames(volcanodata) <- c("logFC", "-log10(FDR)")
  return(volcanodata)
}

# logFC user-defined value
setlogFC <- function(){
  return(input$setlogFC)
}

# Volcano plot
volcano_plot <- function(){
  volcanodata <- cbind(reactiveModel()$table$logFC, -log10(reactiveModel()$table$FDR))
  colnames(volcanodata) <- c("logFC", "-log10(FDR)")
  plot(volcanodata, pch=20, main="Volcano plot")
  points(volcanodata[reactiveModel()$table$FDR<setPvalue() & abs(reactiveModel()$table$logFC)>setlogFC(),], col="blue")
}

output$volcano <- renderPlot({
  withProgress(message = 'Making plot',{
  })
  volcano_plot()
})

# Table of selected values
values <- reactiveValues(DT=NULL)
observeEvent(input$plot_click, {
  add_row <- data.frame(nearPoints(dataFilter(), input$plot_click, xvar = "logFC", yvar = "-log10(FDR)"))
  geneId <- rownames(reactiveModel()[reactiveModel()$table$logFC==add_row$logFC,])
  addrow <- cbind(geneId, add_row)
  colnames(addrow) <- c("Gene ids", "logFC", "-log10(FDR)")
  values$DT <- rbind(values$DT, addrow)
  colnames(values$DT) <- colnames(addrow) 
})

output$clickedPoints <- renderDT(values$DT)

# Button to delete the last added row (UI)
observeEvent(input$plot_click,{
output$rem_row_v <- renderUI({
    actionButton("rem_point", "Remove Last Point")
  })
})

# Button to delete the last added row (Server)
observeEvent(input$rem_point, {
  rem_row <- values$DT[-nrow(values$DT), ]
  values$DT <- rem_row
})

# Download plot as png
output$volcano_download <- downloadHandler(
  filename = "volcano_download.png" ,
  content = function(file) {
    png(file = file)
    volcano_plot()
    dev.off()
  })
