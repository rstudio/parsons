
wrap_labels <- function(labels,
                        class = "rank-list-item-internal",
                        r_type = c("base", "ggplot2", "tidyverse")){
  r_type <- match.arg(r_type)
  lapply(labels, function(x) {
    htmltools::tags$div(
      class = paste(class, r_type),
        x
    )
  })
}

# initial = c(
#   "iris",
#   "mutate(...)",
#   "summarize(...)",
#   "print()"
# )
# wrap_labels(initial)
