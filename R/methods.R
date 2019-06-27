as.parsons <- function(x){
  class(x) <- c("parsons", class(x))
  x
}

#' @export
print.parsons <- function(x, ...){
  htmltools::html_print(x)
}
