is.parsons_problem <- function(x) {
  inherits(x, "parsons_problem")
}

as.parsons_problem <- function(x){
  class(x) <- c("parsons_problem", class(x))
  x
}

#' @export
print.parsons <- function(x, ...){
  htmltools::html_print(x)
}
