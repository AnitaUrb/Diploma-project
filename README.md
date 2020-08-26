# Transcriptomic data analysis app

Goal of this project was to create for users without computational background a convenient and helpful tool for effective [RNA-Seq](https://en.wikipedia.org/wiki/RNA-Seq) data analysis, 
visualization and storing information about experimental results. Interactive web application was created using R language with its specialized packages, 
[R Shiny](https://shiny.rstudio.com/) package as a framework for web application, and [Bioconductor](https://www.bioconductor.org/) packages as toolkits for genomic data manipulation.

Technical requirements:<br />
Due to the requirements of packages:
- *R version: 3.6.1 (2019-07-05)*
- *RStudio version (if using): >= 1.2.1335*<br />

To start the application:
 - from RStudio: run command from the console
    - *shiny::runApp(path_to_app)*
 - from terminal: run command 
    - *R -e "shiny::runApp('path_to_app’)"*


Usage of the app:<br />
The input from user is the first step of the analysis. Supported input data formats are *tsv* and *csv*.<br />
If there is no input data from user, an example data is loaded automatically. 

![alt text](https://github.com/AnitaUrb/Licentiate/blob/master/browse.jpg?raw=true "Optional Title")

The next steps can be taken in any order.<br />

Downstream analysis in the application enables:
- Analysis of user’s set of genes
- Finding the DE ([differentially expressed](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4827276/)) genes
- Data manipulation (including saving report)

Example results:

![alt text](https://github.com/AnitaUrb/Licentiate/blob/master/heat1.jpg?raw=true "Optional Title")

![alt text](https://github.com/AnitaUrb/Licentiate/blob/master/volcano.png?raw=true "Optional Title")

![alt text](https://github.com/AnitaUrb/Licentiate/blob/master/exprp.jpg?raw=true "Optional Title")

![alt text](https://github.com/AnitaUrb/Licentiate/blob/master/biomart.jpg?raw=true "Optional Title")


More information is available upon request.
