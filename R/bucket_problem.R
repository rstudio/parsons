#' @importFrom sortable sortable_options is_sortable_options
#' @importFrom sortable add_rank_list bucket_list
#'
#' @importFrom learnr question_ui_initialize
#' @importFrom learnr question_ui_completed
#' @importFrom learnr question_is_valid
#' @importFrom learnr question_is_correct
#'
#' @importFrom learnr question_ui_try_again
#'
#' @importFrom learnr mark_as
#' @importFrom learnr disable_all_tags
NULL



#' Create a bucket problem (experimental).
#'
#' This function implements the bucket problem, as exposed by
#' [question_bucket()]. Most users will only use this function inside a
#' `learnr` tutorial, so please see the documentation at [question_bucket()]
#'
#'
#' @inheritParams sortable::rank_list
#' @inheritParams sortable::bucket_list
#'
#' @param initial Vector with initial values for problem (to appear in left
#'   column).  Note: this must be a super-set of all answers.
#'
#' @param text Vector of headings for each column.
#'
#' @param input_id Character vector of `input_id` to pass (individually) to
#'   [rank_list()].
#'
#'
#' @inheritParams sortable::bucket_list
#'
#' @export
# @example inst/examples/example_bucket.R
#'
#'
# @examples
# ## Example of a shiny app
# if (interactive()) {
#   app <- system.file("shiny-examples/bucket_app.R", package = "parsons")
#   shiny::runApp(app)
# }
bucket_problem <- function(
  initial,
  text = c("Drag from here", "Construct your solution here"),
  header = NULL,
  input_id,
  group_name,
  class = "default-sortable default-bucket",
  options = sortable_options(
    # emptyInsertThreshold = 150
  ),
  orientation = c("horizontal", "vertical")
) {
  if (is.character(initial)) initial <- list(initial, NULL)
  assert_that(is_sortable_options(options))
  if (missing(group_name) || is.null(group_name)) {
    group_name <- increment_bucket_group()
  }
  if (missing(input_id) || is.null(input_id)) {
    input_id <- paste0(group_name, c("_1", "_2"))
  }

  if (length(input_id) == 1) {
    input_id <- list(paste0(input_id, "_1"), input_id)
  }
  orientation <- match.arg(orientation)

  z <- bucket_list(
    header = header,
    class = class,
    add_rank_list(text = text[1],
                  labels = initial[[1]],
                  input_id = input_id[[1]],
                  options = options
    ),
    add_rank_list(text = text[2],
                  labels = initial[[2]],
                  input_id = input_id[[2]],
                  options = options
    ),
    group_name = group_name,
    orientation = orientation
  )

  min_height <- 50 * (length(initial[[1]]) + 1)
  z <- htmltools::tagList(
    z,
    bucket_dependencies(),
    htmltools::tags$style(
      sprintf(
        htmltools::HTML(".rank-list-container {min-height: %spx;}"),
        min_height
      )
    )
    )
  as.bucket_problem(z)
}

