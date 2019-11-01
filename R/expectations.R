is_answer <- function(x){
  inherits(x, "tutorial_question_answer")
}

is.expectation_pass <- function(x) {
  inherits(x, "parsons_expectation_pass")
}

is.expectation_fail <- function(x) {
  inherits(x, "parsons_expectation_fail")
}


expectation_pass <- function (fun, message = "failure") {
  structure(
    class = c("parsons_expectation_pass", "list"),
    list(fun = fun, message = message)
  )
}

expectation_fail <- function (fun, message = "failure") {
  structure(
    class = c("parsons_expectation_fail", "list"),
    list(fun = fun, message = message)
  )
}


eval_expectation <- function(exp, answer_list) {
  isTRUE(exp$fun(answer_list))
}



# pass_if -----------------------------------------------------------------

#' Add expectations to a parsons problem.
#'
#' @param f One of:
#'   * A character vector, indicating an exact match
#'   * A function of the function `function(x){...}` that evaluates to TRUE or FALSE
#'   * A function of the form `~ .`, as used by the tidy evaluation, e.g. in [purrr::map]
#' @param message Message to display if `fun` evaluates to TRUE
#'
#' @rdname expectations
#'
#' @export
pass_if <- function(f, message = NULL){
  UseMethod("pass_if", f)
}

#' @export
pass_if.character <- function(f, message = NULL) {
  learnr::answer(f, correct = TRUE, message = message)
}



#' @export
pass_if.default <- function(f, message = NULL) {
  expectation_pass(
    fun = rlang::as_function(f),
    message = message
  )
}

#' @export
pass_if.function <- function(f, message = NULL) {
  expectation_pass(
    fun = rlang::as_function(f),
    message = message
  )
}


# fail_if -----------------------------------------------------------------

#' @rdname expectations
#' @export
fail_if <- function(f, message = "Incorrect"){
  UseMethod("fail_if", f)
}

#' @export
fail_if.character <- function(f, message = "Incorrect") {
  learnr::answer(f, correct = FALSE, message = message)
}

#' @export
fail_if.default <- function(f, message = "Incorrect") {
  expectation_fail(
    fun = rlang::as_function(f),
    message = message
  )
}

#' @export
fail_if.function <- function(f, message = "Incorrect") {
  expectation_fail(
    fun = rlang::as_function(f),
    message = message
  )
}



# message_if --------------------------------------------------------------


#' @export
#' @rdname expectations
message_if <- function(f) {
  f
}

eval_message <- function(f, answer_list) {
  UseMethod("eval_message", f)
}

eval_message.character <- function(f, answer_list){
  f
}

eval_message.default <- function(f, answer_list) {
  # browser()
  idx <- rlang::as_function(f)(answer_list)
  paste(answer_list[idx], collapse = ", ")
}


# -------------------------------------------------------------------------

# all_of <- function(.x){
#   force(.x)
#   input <- .x
#   function(x)length(input) == length(x) && all(sort(input) == sort(x))
# }

# pass_if_all_of <- function(zz, message = NULL) {
#   f <- function(x)~identical(sort(x), sort(zz))
#   expectation_pass(
#     fun = rlang::as_function(f),
#     message = message
#   )
# }

#' @rdname expectations
#' @param ... Combined into an answer list
#' @param x Answer to test
#' @export
contains_all <- function(x, ...){
  y <- unlist(rlang::list2(...))
  identical(sort(x), sort(y))
}

#' @rdname expectations
#' @export
contains_any <- function(x, ...){
  y <- unlist(rlang::list2(...))
  any(x %in% y)
}

