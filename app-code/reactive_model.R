list.of.packages <- c("shiny", "ggplot2", "edgeR", "biomaRt", "gplots", "reshape2", "plotly", "cluster", "DT", "shinythemes", "rmarkdown")
lapply(list.of.packages, library, character.only=TRUE)
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) {install.packages(new.packages)}

# Server function for fitting the model

reactiveModel <- reactive({
  tr <- factor(rep(c("UNT","BMP4"),each=(ncol(userBase())/2)),levels=c("UNT","BMP4"))
  design <- model.matrix(~tr)
  x <- DGEList(counts=userBase())
  x <- estimateDisp(x,design)
  fit <- glmQLFit(x,design)
  res <- topTags(glmQLFTest(fit,coef=2),n=nrow(x))
  return(res)
})
