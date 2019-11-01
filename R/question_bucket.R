#' @importFrom utils modifyList
NULL

# is element a list of answers
is_answer_list <- function(x){
  all(vapply(x, function(x)inherits(x, "tutorial_question_answer"), FUN.VALUE = logical(1)))
}


# promotes embedded list of answers to one level higher
promote_answerlist <- function(x){
  z <- list()
  for (i in seq_along(x)){
    if (length(x[[i]]) == 1) {
      z <- append(z, x[i])
    } else {
      y <- x[[i]]
      if (is_answer_list(y)) {
        for (j in seq_along(y))
          z <- append(z, y[j])
      } else {
        z <- append(z, y)
      }
    }
  }
  z
}


#' bucket problem question for learnr tutorials (experimental).
#'
#'
#' @param initial Initial value of answer options. This must be a character vector.
#'
#' @param ... One or more answers.  Passed to [learnr::question()].
#' @inheritParams learnr::question
#' @inheritParams bucket_problem
#'
# @param type Must be "bucket_question"
#' @param correct Text to print for a correct answer (defaults to "Correct!")
#'
#' @export
#' @examples
#' ## Example of bucket problem inside a learn tutorial
#' if (interactive()) {
#'   learnr::run_tutorial("bucket", package = "parsons")
#' }
question_bucket <- function(
  initial,
  ...,
  text = c("Drag from here", "Construct your solution here"),
  orientation = c("horizontal", "vertical"),
  correct = "Correct!",
  incorrect = "Incorrect",
  try_again = incorrect,
  message = NULL,
  post_message = NULL,
  loading = c("Loading: "),
  submit_button = "Submit Answer",
  try_again_button = "Try Again",
  allow_retry = TRUE,
  random_answer_order = TRUE,
  options = sortable_options()


) {
  dots <- list2(...)

  # initialize answers with a dummy that can never appear
  answers <- list(learnr::answer(paste(initial, sep = ""), correct = TRUE))

  # append any other provided answers
  answers <- append(
    answers,
    dots[vapply(dots, is_answer, FUN.VALUE = logical(1))]
  )
  pass <- dots[vapply(dots, is.expectation_pass, FUN.VALUE = logical(1))]
  fail <- dots[vapply(dots, is.expectation_fail, FUN.VALUE = logical(1))]

  orientation <- match.arg(orientation)

  z <- do.call(
    learnr::question,
    append(
      answers,
      list(
        text = NULL,
        type = "bucket_question",
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
          text = text,
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
question_ui_initialize.bucket_question <- function(question, answer_input, ...) {

  labels <- question$options$initial
  if (isTRUE(question$random_answer_order)) { # and we should randomize the order
    shuffle <- shiny::repeatable(sample, question$seed)
    labels <- shuffle(labels)
  }


  # return the bucket htmlwidget
  z <- bucket_problem(
    input_id = c(question$ids$question, question$ids$answer),
    initial = list(
      setdiff(labels, answer_input),
      answer_input
    ),
    text        = question$options$text,
    orientation = question$options$orientation,
    options     = question$options$sortable_options,
    ...
  )
  z
}



#' @export
question_ui_completed.bucket_question <- function(question, answer_input, ...) {
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

  disable_all_tags(
    bucket_problem(
      input_id = c(question$ids$question, question$ids$answer),
      initial = list(
        setdiff(labels, answer_input),
        answer_input
      ),
      text        = question$options$text,
      orientation = question$options$orientation,
      options     = new_options,
      ...
    )
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
question_ui_try_again.bucket_question <- function(question, answer_input, ...) {
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

  disable_all_tags(
    bucket_problem(
      input_id = c(question$ids$question, question$ids$answer),
      initial = list(
        setdiff(labels, answer_input),
        answer_input
      ),
      text        = question$options$text,
      orientation = question$options$orientation,
      options     = new_options,
      ...
    )
  )
}


#' @inheritParams learnr::question_disable_input
#' @export
question_is_correct.bucket_question <- function(question, answer_input, ...) {
  # for each possible answer, check if it matches
  for (answer in question$answers) {
    if (identical(answer$option, answer_input)) {
      # if it matches, return the correct-ness and its message
      return(mark_as(answer$correct, answer$message))
    }
  }

  # for each possible expectation, check if it matches
  pass_expectations <- question$options$pass

  for (exp in pass_expectations) {
    if (eval_expectation(exp, answer_input)) {
      # if it matches, return the correct-ness and its message
      return(mark_as(TRUE, messages = exp$message))
    }
  }

  # for each possible expectation, check if it matches
  fail_expectations <- question$options$fail

  # browser()

  for (exp in fail_expectations) {
    if (eval_expectation(exp, answer_input)) {
      # if it matches, return the correct-ness and its message
      return(mark_as(FALSE, eval_message(exp$message, answer_input)))
    }
  }


  # no match found. not correct
  mark_as(FALSE, NULL)
}
