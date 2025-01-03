
#rm(list=ls())
devtools::load_all(".") 

library(ggplot2)

#' Dummy alternate (local) hello function
#'
#' @param who String target
#' @param salutation String kind
#' @return A salutation string
#' @export
#' @examples
#' dmy_alter()
#' dmy_alter("Earth")
#' dmy_alter("Moon", "'Night")
dmy_alter <- function(who = "Monde", salutation = "Allô") {
  paste(salutation," ",who,"!",sep="")
}

#' sample plot to pdf
#' see: https://www.datanovia.com/en/blog/how-to-save-a-ggplot/
dmy_sepal_plot <- function(fn="dmy_sepal_plot.pdf", dir=".") {

    of <- paste(dir,fn,sep="/")
    myplot1 <- ggplot(iris, aes(Sepal.Length, Sepal.Width)) + 
        geom_point()
    myplot2 <- ggplot(iris, aes(Species, Sepal.Length)) + 
        geom_boxplot()

    # Print plots to a pdf file
    pdf(of)
    print(myplot1)     # Plot 1 --> in the first page of PDF
    print(myplot2)     # Plot 2 ---> in the second page of the PDF
    dev.off()
    of
}

