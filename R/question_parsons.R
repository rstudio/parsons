#' @importFrom utils modifyList
NULL

#' Parsons problem question for learnr tutorials (experimental).
#'
#' @template question_parsons_description
#'
#' @param initial Initial value of answer options. This must be a character vector.
#'
#' @param ... One or more answers.  Passed to [learnr::question()].
#' @inheritParams learnr::question
#' @inheritParams parsons
#'
# @param type Must be "parsons_question"
#' @param correct Text to print for a correct answer (defaults to "Correct!")
#'
#' @export
#' @examples
#' ## Example of parsons problem inside a learn tutorial
#' if (interactive()) {
#'   learnr::run_tutorial("parsons", package = "parsons")
#' }
question_parsons <- function(
  initial,
  ...,
  # type = c("parsons_question"),
  correct = "Correct!",
  incorrect = "Incorrect",
  try_again = incorrect,
  message = NULL,
  post_message = NULL,
  loading = c("Loading: "),
  submit_button = "Give feedback",
  try_again_button = "Try Again",
  allow_retry = TRUE,
  random_answer_order = TRUE,
  options = sortable_options()


) {
  dots <- list(...)
  answers <- dots[vapply(dots, is_answer, FUN.VALUE = logical(1))]
  pass <- dots[vapply(dots, is.expectation_pass, FUN.VALUE = logical(1))]
  fail <- dots[vapply(dots, is.expectation_fail, FUN.VALUE = logical(1))]

  z <- do.call(
    learnr::question,
    append(
      answers,
      list(
        text = NULL,
        type = "parsons_question",
        correct =  correct,
        incorrect =  incorrect,
        try_again = try_again,
        message = message,
        post_message = post_message,
        loading = loading,
        submit_button =  submit_button,
        try_again_button =  try_again_button,
        allow_retry = allow_retry,
        random_answer_order = random_answer_order,
        options = list(
          initial = initial,
          pass = pass,
          fail = fail,
          sortable_options = options
        )
      )
    )
  )
  z
}


#' @export
question_initialize_input.parsons_question <- function(question, answer_input, ...) {

  labels <- question$options$initial
  if (isTRUE(question$random_answer_order)) { # and we should randomize the order
    shuffle <- shiny::repeatable(sample, question$seed)
    labels <- shuffle(labels)
  }


  # return the parsons htmlwidget
  z <- parsons_problem(
    input_id = c(question$ids$question, question$ids$answer),
    initial = list(
      setdiff(labels, answer_input),
      answer_input
    ),
    options = question$options$sortable_options,
    ...
  )
  z
}



#' @export
question_completed_input.parsons_question <- function(question, answer_input, ...) {
  # TODO display correct values with X or √ compared to best match
  # TODO DON'T display correct values (listen to an option?)

  labels <- question$options$initial
  if (isTRUE(question$random_answer_order)) { # and we should randomize the order
    shuffle <- shiny::repeatable(sample, question$seed)
    labels <- shuffle(labels)
  }

  new_options <- modifyList(
    question$options$sortable_options,
    sortable_options(disabled = TRUE)
  )

  parsons_problem(
    input_id = c(question$ids$question, question$ids$answer),
    initial = list(
      setdiff(labels, answer_input),
      answer_input
    ),
    options = new_options,
    ...
  )
}


#' Disable input after student submitted answer.
#'
#' @inheritParams learnr::question_disable_input
#'
#' @param question Question object
#' @param answer_input user input value
#' @param ... not used
#'
#' @export
question_try_again_input.parsons_question <- function(question, answer_input, ...) {
 # TODO display correct values with X or √ compared to best match
 # TODO DON'T display correct values (listen to an option?)
 labels <- question$options$initial
 if (isTRUE(question$random_answer_order)) { # and we should randomize the order
   shuffle <- shiny::repeatable(sample, question$seed)
   labels <- shuffle(labels)
 }
 new_options <- modifyList(
   question$options$sortable_options,
   sortable_options(disabled = TRUE)
 )
 parsons_problem(
   input_id = c(question$ids$question, question$ids$answer),
   initial = list(
     setdiff(labels, answer_input),
     answer_input
   ),
   options = new_options,
   ...
 )
}



#' @export
question_is_valid.parsons_question <- function(question, answer_input, ...) {
  !is.null(answer_input)
}


#' @export
question_is_correct.parsons_question <- function(question, answer_input, ...) {
  # for each possible answer, check if it matches
  for (answer in question$answers) {
    if (identical(answer$option, answer_input)) {
      # if it matches, return the correct-ness and its message
      return(question_is_correct_value(answer$is_correct, answer$message))
    }
  }

  # for each possible expectation, check if it matches
  pass_expectations <- question$options$pass

  for (exp in pass_expectations) {
    if (eval_expectation(exp, answer_input)) {
      # if it matches, return the correct-ness and its message
      return(question_is_correct_value(TRUE, messages = exp$message))
    }
  }

  # for each possible expectation, check if it matches
  fail_expectations <- question$options$fail

  for (exp in fail_expectations) {
    if (eval_expectation(exp, answer_input)) {
      # if it matches, return the correct-ness and its message
      return(question_is_correct_value(FALSE, messages = exp$message))
    }
  }


  # no match found. not correct
  return(question_is_correct_value(FALSE, NULL))
}
