
<!-- README.md is generated from README.Rmd. Please edit that file -->

# parsons <img src='man/figures/parsons-logo.png' align="right" height="139" />

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/rstudio/sortable.svg?branch=master)](https://travis-ci.org/rstudio/sortable)
[![CRAN
version](http://www.r-pkg.org/badges/version/sortable)](https://cran.r-project.org/package=sortable)
[![sortable downloads per
month](http://cranlogs.r-pkg.org/badges/sortable)](http://www.rpackages.io/package/sortable)
[![Codecov test
coverage](https://codecov.io/gh/rstudio/sortable/branch/master/graph/badge.svg)](https://codecov.io/gh/rstudio/sortable?branch=master)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The `sortable` package enables drag-and-drop behaviour in your Shiny
apps. It does this by exposing the functionality of the
[sortable.js](https://sortablejs.github.io/Sortable/) JavaScript library
as an [htmlwidget](https://htmlwidgets.org) in R, so you can use this in
Shiny apps and widgets, `learnr` tutorials as well as R Markdown.

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

    #> Warning in file(con, "r"): file("") only supports open = "w+" and open =
    #> "w+b": using the former
    #> Warning in knitr::read_chunk(system.file("shiny-examples/parsons_app.R", :
    #> code is empty

<center>

<img src="man/figures/parsons_app.gif" style = 'width:600px;'></img>

</center>
