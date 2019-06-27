#' Parsons problem question for learnr tutorials (experimental).
#'
#' @template question_parsons_description
#'
#' @param ... One or more answers.  Passed to [learnr::question()].
#' @inheritParams learnr::question
#' @inheritParams parsons
#'
#' @param type Must be "parsons_q"
#' @param correct Text to print for a correct answer (defaults to "Correct!")
#'
#' @export
#' @example inst/examples/example_question_parsons.R
#' @examples
#' ## Example of a shiny app
#' if (interactive()) {
#'   app <- system.file("shiny-examples/parsons_app.R", package = "parsons")
#'   shiny::runApp(app)
#' }
question_parsons <- function(
  initial,
  ...,
  type = c("parsons_q"),
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
  answers <- dots[vapply(dots, is.answer, FUN.VALUE = logical(1))]
  expectations <- dots[vapply(dots, is.expectation, FUN.VALUE = logical(1))]
  # browser()
  z <- do.call(
    learnr::question,
    append(
      answers,
      list(
        text = NULL,
        type = "parsons_q",
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
          expectations = expectations,
          sortable_options = options
        )
      )
    )
  )
  z
}


#' @export
question_initialize_input.parsons_q <- function(question, answer_input, ...) {

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
question_completed_input.parsons_q <- function(question, answer_input, ...) {
  # TODO display correct values with X or √ compared to best match
  # TODO DON'T display correct values (listen to an option?)

  labels <- question$options$initial
  if (isTRUE(question$random_answer_order)) { # and we should randomize the order
    shuffle <- shiny::repeatable(sample, question$seed)
    labels <- shuffle(labels)
  }

  parsons_problem(
    input_id = c(question$ids$question, question$ids$answer),
    initial = list(
      setdiff(labels, answer_input),
      answer_input
    ),
    options = modifyList(
      question$options$sortable_options,
      sortable_options(disabled = TRUE)
    ),
    ...
  )
}

#' @export
question_is_valid.parsons_q <- function(question, answer_input, ...) {
  !is.null(answer_input)
}


#' @export
question_is_correct.parsons_q <- function(question, answer_input, ...) {
  # for each possible answer, check if it matches
  for (answer in question$answers) {
    if (identical(answer$option, answer_input)) {
      # if it matches, return the correct-ness and its message
      return(question_is_correct_value(answer$is_correct, answer$message))
    }
  }
  # no match found. not correct
  return(question_is_correct_value(FALSE, NULL))
}