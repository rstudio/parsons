## ---- parsons-app -------------------------------------------------------
## Example shiny app with parsons problem

library(shiny)
library(htmltools)
library(parsons)

parsons_generator <- function(initial, problem_type, orientation = "horizontal"){
  fluidRow(
    column(
      width = 12,

      ## This is the parsons problem
      parsons_problem(
        header = paste("This is an example of a Parsons problem using", problem_type),
        orientation = "horizontal",
        initial = initial,
        group_name = paste0("parsons_", problem_type),
        problem_type = problem_type
      )

    ),
    fluidRow(
      column(
        width = 12,
        h2("Result"),
        verbatimTextOutput(paste0("answer_", problem_type))
      )
    )
  )
}


ui <- fluidPage(
  tags$head(
    tags$style(HTML(".bucket-list-container {min-height: 300px;}"))
  ),
  mainPanel(
    fluidRow(
      column(
        width = 12,
        h2("Question")
      )),

    tabsetPanel(
      type = "tabs",

      # base R ---
      tabPanel(
        "base",
        parsons_generator(
          initial = c(
            "x <- 1",
            "y <- 2",
            "sum(x, y)"
          ),
          problem_type = "base"
        )
      ),

      # tidyverse ---
      tabPanel(
        "tidyverse",
        parsons_generator(
          initial = c(
            "iris",
            "mutate(...)",
            "summarize(...)",
            "print()"
          ),
          problem_type = "tidyverse"
        )
      ),

      # ggplot2 ---
      tabPanel(
        "ggplot2",
        parsons_generator(
          initial = c(
            "ggplot(...)",
            "geom_point(...)",
            "geom_smooth(...)",
            "coord_fixed(...)"
          ),
          problem_type = "ggplot2"
        )
      )



    )
  )


)

server <- function(input,output) {
  output$answer_base <-
    renderPrint(
      input$parsons_base
    )

  output$answer_ggplot2 <-
    renderPrint(
      input$parsons_ggplot2
    )

  output$answer_tidyverse <-
    renderPrint(
      input$parsons_tidyverse
    )
}

shinyApp(ui, server)
