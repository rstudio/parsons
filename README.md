
<!-- README.md is generated from README.Rmd. Please edit that file -->

# parsons <img src='man/figures/parsons-logo.png' align="right" height="139" />

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/rstudio/parsons.svg?branch=master)](https://travis-ci.org/rstudio/parsons)
[![CRAN
version](http://www.r-pkg.org/badges/version/parsons)](https://cran.r-project.org/package=parsons)
[![parsons downloads per
month](http://cranlogs.r-pkg.org/badges/parsons)](http://www.rpackages.io/package/parsons)
[![Codecov test
coverage](https://codecov.io/gh/rstudio/parsons/branch/master/graph/badge.svg)](https://codecov.io/gh/rstudio/parsons?branch=master)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

Use the `parsons` package to create Parsons problems for teaching
progamming. You can create custom questions in your `learnr` tutorials.

## Installation

~~You can install the released version of parsons from
[CRAN](https://CRAN.R-project.org) with:~~

``` r
~~install.packages("parsons")~~
```

And the development version from
[GitHub](https://github.com/rstudio/parsons) with:

``` r
# install.packages("remotes")
remotes::install_github("rstudio/parsons")
```

## Examples

### Parsons problems

A Parsons problem is a specific type of question, useful for teaching
programming, where all the lines of code are given, but the student must
provide the correct order.

The `parsons()` function has experimental support for parsons problems.

``` r
## Example shiny app with parsons problem

library(shiny)
library(parsons)

ui <- fluidPage(
  fluidRow(
    column(
      width = 12,
      tags$h2("This shiny app contains a parsons problem."),

      ## This is the parsons problem
      parsons_problem(
        header = "This is an example of a Parsons problem",
        initial = c(
          "iris",
          "mutate(...)",
          "summarize(...)",
          "print()"
        ),
        input_id = "parsons_unique_id"
      )

    )
  ),
  fluidRow(
    column(
      width = 12,
      tags$h2("You provided the answer"),
      verbatimTextOutput("answer")
    )
  )
)

server <- function(input,output) {
  output$answer <-
    renderPrint(
      input$parsons_unique_id # This matches the input_id of the parsons problem
    )
}


shinyApp(ui, server)
```

<center>

<img src="man/figures/parsons_app.gif" style = 'width:600px;'></img>

</center>
