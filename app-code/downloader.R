list.of.packages <- c("shiny", "ggplot2", "edgeR", "biomaRt", "gplots", "reshape2", "plotly", "cluster", "DT", "shinythemes", "rmarkdown")
lapply(list.of.packages, library, character.only=TRUE)
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) {install.packages(new.packages)}

# Server functions for generating full report in HTML

output$report <- downloadHandler(
  filename = "report.html",
  content = function(file) {
    src <- normalizePath('./Report.Rmd')
    owd <- setwd(tempdir())
    on.exit(setwd(owd))
    file.copy(src, 'Report.Rmd', overwrite = TRUE)
    out <- render('Report.Rmd'
    )
    file.rename(out, file)
  }
)
