list.of.packages <- c("shiny", "ggplot2", "edgeR", "biomaRt", "gplots", "reshape2", "plotly", "cluster", "DT", "shinythemes", "rmarkdown")
lapply(list.of.packages, library, character.only=TRUE)
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) {install.packages(new.packages)}

# Server functions for the "Specific genes visualization" tab panel
de_genes_expr <- function(){
  par(las=2)
  par(mar=c(10,6,2,1)+0.1,mgp=c(4,1,0))
  smalls <- data.matrix(userBase()[rownames(with(reactiveModel()$table, subset(reactiveModel()$table, FDR<setPvalue()))), ][1:10,])
  boxplot(t(smalls), main = "Top genes with lowest adjusted p-value", xlab = "Gene id", ylab = "Expression level")
}

output$exprp <- renderPlot({
  de_genes_expr()
})

outputOptions(output, "exprp", priority = 6)

output$exprp_download <- downloadHandler(
  filename = "exprp_download.png" ,
  content = function(file) {
    png(file = file)
    de_genes_expr()
    dev.off()
  })
