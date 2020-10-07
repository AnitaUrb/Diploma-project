list.of.packages <- c("shiny", "ggplot2", "edgeR", "biomaRt", "gplots", "reshape2", "plotly", "cluster", "DT", "shinythemes", "rmarkdown")
lapply(list.of.packages, library, character.only=TRUE)
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) {install.packages(new.packages)}

# Server functions for the "Samples analysis" tab panel
# Expression in groups
expr_via_samples <- function(){
  par(las=2)
  par(mar=c(7,6,2,1)+0.1,mgp=c(4,1,0))
  rna <- data.matrix(userBase())
  rna <- rna[apply(rna[,-1], 1, function(x) !all(x==0)),]
  boxplot(log(rna+1), main = "Box plots of expression", xlab = "Samples", ylab = "log(expression+1)",cex.axis=0.9)
}

output$expr <- renderPlot({
  withProgress(message = 'Making plot',{
  })
  expr_via_samples()
})

outputOptions(output, "expr", priority = 4)

output$download_expr <- renderUI({
  req(expr_via_samples())
  downloadButton("report_expr", "Download expression plot")
})

output$report_expr<- downloadHandler(
  filename = "expr_samples.png" ,
  content = function(file) {
    png(file = file)
    expr_via_samples()
    dev.off()
  })

# Density in groups
density_via_samples <- function(){
  par(las=1)
  par(mar=c(5,5,2,1)+0.1,mgp=c(3,1,0))
  rna <- data.matrix(userBase())
  p <- lapply(1:ncol(rna), function(i) density(log10(rna[, i]+1)))
  rx <- range(sapply(p,function(a) range(a$x)))
  ry <- range(sapply(p,function(a) range(a$y)))
  plot(rx,ry, xlab = "Samples", ylab = "log10(expression+1)", type="n", main="Density of expression")
  for(colmn in 1:length(p)){
    lines(p[[colmn]]$x,p[[colmn]]$y, col=rainbow(ncol(rna))[colmn])
  }
}

output$dens <- renderPlot({
  withProgress(message = 'Making plot',{
  })
  density_via_samples()
})

outputOptions(output, "dens", priority = 5)

output$download_dens <- renderUI({
    req(expr_via_samples())
    downloadButton("report_dens", "Download density plot")
})

output$report_dens <- downloadHandler(
  filename = "dens_samples.png" ,
  content = function(file) {
    png(file = file)
    density_via_samples()
    dev.off()
  })
