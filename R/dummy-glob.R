##
# global environment for dummy procs
#

m <- modules::module({

e <- globalenv()

auto_load <- function() { TRUE }

})
m$auto_load()


#' dummy global environment
#'
#' @return dmy environment
#' @export
dmy <- function (){
  return(m$e)
}
