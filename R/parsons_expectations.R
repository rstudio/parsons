is.answer <- function(x){
  inherits(x, "tutorial_question_answer")
}

is.expectation <- function(x) {
  inherits(x, "parsons_expectation")
}


#' Add expectations to a parsons problem.
#'
#' @param fun A function of x that should evaluate to TRUE or FALSE
#' @param msg Message to display if `fun` evaluates to TRUE
#'
#' @export
#'
expectation <- function (fun, msg = "failure") {
  structure(
    class = c("parsons_expectation", "list"),
    list(fun = fun, msg = msg)
  )
}


