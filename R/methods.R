is_parsons_problem <- function(x) {
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




is_bucket_problem <- function(x) {
  inherits(x, "bucket_problem")
}

as.bucket_problem <- function(x){
  class(x) <- c("bucket_problem", class(x))
  x
}

#' @export
print.bucket <- function(x, ...){
  htmltools::html_print(x)
}
