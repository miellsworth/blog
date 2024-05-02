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
  ),
  card(
    # Bike Count Plot
    full_screen = TRUE,
    plotOutput('bike_count_plot')
  )
)

server <- function(input, output, session) {
  output$bike_count_plot <- renderPlot({
    df %>%
      filter(monitoring_location == input$location_dropdown) %>%
      ggplot(aes(x = date, y = daily_total)) +
      geom_point() +
      theme_classic() +
      labs(
        colour = NULL,
        x = "",
        y = "Daily Bike Count"
      ) +
      theme(
        legend.position = "bottom",
        text = element_text(size = 20)
      )
  })
}

shinyApp(ui, server)