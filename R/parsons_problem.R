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



#' Create a parsons problem (experimental).
#'
#' This function implements the parsons problem, as exposed by
#' [question_parsons()]. Most users will only use this function inside a
#' `learnr` tutorial, so please see the documentation at [question_parsons()]
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
#' @param problem_type One of `base`, `ggplot2` or `tidyverse`, indicating the type of
#'   problem statement.  For `tidyverse`, the resulting answer will
#'   automatically append a ` %>% ` at the end of each answer, and for `ggplot2`
#'   every line will be followed by a ` + `.
#'
#' @inheritParams sortable::bucket_list
#'
#' @export
#' @example inst/examples/example_parsons.R
#'
#' @references https://js-parsons.github.io/
#'
#'
#' @examples
#' ## Example of a shiny app
#' if (interactive()) {
#'   app <- system.file("shiny-examples/parsons_app.R", package = "parsons")
#'   shiny::runApp(app)
#' }
parsons_problem <- function(
  initial,
  text = c("Drag from here", "Construct your solution here"),
  header = NULL,
  input_id,
  group_name,
  problem_type = c("base", "ggplot2", "tidyverse"),
  class = "default-sortable default-parsons",
  options = sortable_options(
    # emptyInsertThreshold = 150
  ),
  orientation = c("horizontal", "vertical")
) {
  if (is.character(initial)) initial <- list(initial, NULL)
  assert_that(is_sortable_options(options))
  if (missing(group_name) || is.null(group_name)) {
    group_name <- increment_parsons_group()
  }
  if (missing(input_id) || is.null(input_id)) {
    input_id <- paste0(group_name, c("_1", "_2"))
  }

  if (length(input_id) == 1) {
    input_id <- list(paste0(input_id, "_1"), input_id)
  }
  orientation <- match.arg(orientation)
  problem_type <- match.arg(problem_type)

  z <- bucket_list(
    header = header,
    class = class,
    add_rank_list(text = text[1],
                  labels = wrap_labels(initial[[1]], r_type = problem_type),
                  input_id = input_id[[1]],
                  options = options
    ),
    add_rank_list(text = text[2],
                  labels = wrap_labels(initial[[2]], r_type = problem_type),
                  input_id = input_id[[2]],
                  options = options
    ),
    group_name = group_name,
    orientation = orientation
  )

  min_height <- 50 * (length(initial[[1]]) + 1)
  z <- htmltools::tagList(
    z,
    parsons_dependencies(),
    htmltools::tags$style(
      sprintf(
        htmltools::HTML(".rank-list-container {min-height: %spx;}"),
        min_height
      )
    )
    )
  as.parsons_problem(z)
}

