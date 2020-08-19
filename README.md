# Transcriptomic data analysis app

Goal of this project was to create for users without computational background a convenient and helpful tool for effective RNA-Seq data analysis, 
visualization and storing information about experimental results. Interactive web application was created using R language with its specialized packages, 
R Shiny package as a framework for web application, and Bioconductor packages as toolkits for genomic data manipulation.

Technical requirements:
Due to the requirements of packages:
R version: 3.6.1 (2019-07-05)
RStudio version (if using): >= 1.2.1335

To start the application:
  from RStudio: run command from the console
    shiny::runApp(path_to_app)
  from terminal: run command 
    R -e "shiny::runApp('path_to_app’)"


The input from user is the first step of the analysis. 
However, there is an example data loaded automatically, that is convenient for starting of using app. Supported input data formats are tsv and csv.
# ![Alt text](/home/anita/Licentiate/img.jpg?raw=true "Optional Title")

The next steps can be taken in any order.
Downstream analysis in the application enables analysis:
- Analysis of user’s set of genes
- Finding the DE (differentially expressed) genes
- Data manipulation (including saving report)

More detailed instructions are available upon request. :)
