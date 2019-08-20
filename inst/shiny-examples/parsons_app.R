## ---- parsons-app -------------------------------------------------------
## Example shiny app with parsons problem

library(shiny)
library(parsons)

ui <- fluidPage(
  fluidRow(
    column(
      width = 12,
      tags$h2("Question"),

      ## This is the parsons problem
      parsons_problem(
        header = "This is an example of a Parsons problem",
        orientation = "vertical",
        initial = c(
          "iris",
          "mutate(...)",
          "summarize(...)",
          "print()"
        ),
        group_name = "parsons_unique_id"
      )

    )
  ),
  fluidRow(
    column(
      width = 12,
      tags$h2("Result"),
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
