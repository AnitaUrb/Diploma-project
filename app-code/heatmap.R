list.of.packages <- c("shiny", "ggplot2", "edgeR", "biomaRt", "gplots", "reshape2", "plotly", "cluster", "DT", "shinythemes", "rmarkdown")
lapply(list.of.packages, library, character.only=TRUE)
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) {install.packages(new.packages)}

# Server functions for the "Heatmap of z-scores via rows" tab from the "Differently expressed genes" tab panel

# User-defined size of heatmap value
setSizeOfHeatmap <- reactive({
  return(input$setHeatmapSize)
})

# Function for storing data for the plot
differentialExpressionResults <-reactive({
  self <- rownames(with(reactiveModel()$table, subset(reactiveModel()$table, FDR<setPvalue())))[1:setSizeOfHeatmap()]
  nams <- rownames(userBase()[self, ])
  date <- userBase()[self, ]
  dat = t(date)
  z_date <- scale(dat)
  t(z_date)
})

# Heatmap
heatmap_reactiv <- function(){
  library(plotly)
  p <- plot_ly(x=colnames(differentialExpressionResults()), y=rownames(differentialExpressionResults()), 
          z = differentialExpressionResults(), type = "heatmap", source = "select")
  return(p)
}

output$heatmap_p <- renderPlotly({
  withProgress(message = 'Making plot',{
  })
  heatmap_reactiv()
})

# Table of selected values
x = reactiveValues(df = NULL)
output$selected <- renderDT(x$df)
observeEvent(event_data("plotly_click", "select"),{
  k <- event_data("plotly_click", "select")
  x$df <- rbind(x$df, c(k$y, userBase()[k$y, ]))
})

observeEvent(event_data("plotly_click", "select"), {
  output$h_capt <- renderUI({
    paste("Table shows selected genes from user file:")
  })
})

# Button to delete the last added row (Server)
observeEvent(input$rem_point_h, {
  rem_row <- x$df[-nrow(x$df), ]
  x$df <- rem_row
})

# Button to delete the last added row (UI)
observeEvent(event_data("plotly_click", "select"),{
output$rem_row_h <- renderUI({
  actionButton("rem_point_h", "Remove Last Row")
  })
})
