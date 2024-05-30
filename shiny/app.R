library(shiny)
library(bslib)
library(readr)
library(dplyr)
library(janitor)
library(lubridate)
library(tidyr)
library(ggplot2)

df <- read_csv("daily_counts.csv")

locations <- unique(df$monitoring_location)

ui <- bslib::page_sidebar(
  title = "YYC Daily Bike Count",
  sidebar = sidebar(
    # Dropdown menu
    selectInput(
      'location_dropdown',  # Input ID
      'Select location', # Input label
      choices = locations
    ),
    actionButton('button', 'Reload Plot')
  ),
  card(
    # Bike Count Plot
    full_screen = TRUE,
    plotOutput('bike_count_plot')
  )
)

server <- function(input, output, session) {
  output$bike_count_plot <- renderPlot({
    req(input$button >= 1)
    df %>%
      filter(monitoring_location == input$location_dropdown) %>%
      ggplot(aes(x = date, y = daily_total)) +
      geom_point() +
      scale_y_continuous(expand = c(0,0)) +
      theme_classic() +
      labs(
        colour = NULL,
        x = "",
        y = "Daily Bike Count",
        title = input$location_dropdown
      ) +
      theme(
        legend.position = "bottom",
        text = element_text(size = 20)
      )
  }) |> bindEvent(input$button)
}

shinyApp(ui, server)