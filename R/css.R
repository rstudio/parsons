#' CSS stylesheets.
#'
#' These functions provide cascading style sheets (CSS) for:
#'
#' * `css_parsons()` : [parsons()]
#'
#' @rdname css
#'
#' @return Each of these functions return a character string with valid CSS.
#'
#' @examples
#' cat(
#'   css_parsons()
#' )
#'
#' @importFrom sortable css_rank_list
#' @export
#' @rdname css
css_parsons <- function(){
  css <- css_rank_list()

  ## Insert a magrittr pipe after each list item entry, except the last, and
  ## only in column 2

  additional_css <- "
  .rank-list-container .column_2 {
    padding-bottom: 30px;
  }

  .rank-list-item {
    font-family: monospace, sant-serif;
  }
  "

  after_css <- "
  .column_2 .rank-list-item:not(:last-child):after {
    content: \" %>%\";
  }

  .column_2 .rank-list-item:not(:first-child) {
    margin-left: 30px;
  }
  "

  paste(css, additional_css, after_css, sep = "\n")
}
