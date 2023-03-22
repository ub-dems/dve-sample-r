#' Dummy hello function
#'
#' @param who String target
#' @param salutation String kind
#' @return A salutation string
#' @export
#' @examples
#' dummy_hello()
#' dummy_hello("Earth")
#' dummy_hello("Moon", "'Night")
dummy_hello <- function(who = "World", salutation = "Hello") {
  paste(salutation," ",who,"!",sep="")
}
