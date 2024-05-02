library(shiny)
library(bslib)
library(readr)
library(dplyr)
library(janitor)
library(lubridate)
library(tidyr)

url <- "https://data.calgary.ca/api/views/pede-tz7g/rows.csv?date=20240501&accessType=DOWNLOAD"
df <- read_csv(url) %>% 
  janitor::clean_names() %>%
  filter(user_type == "Bikes") %>%
  pivot_longer(
    cols = c(x0000:x2345), 
    names_to = "time", 
    values_to = "count"
  ) %>%
  mutate(date_time = ymd_hm(paste0(date, time))) %>%
  mutate(count = replace_na(count, 0)) %>%
  group_by(date, monitoring_location) %>%
  summarise(daily_total = sum(count)) %>%
  ungroup()

locations <- unique(df$monitoring_location)

ui <- bslib::page_fluid(
  # Dropdown menu
  selectInput(
    'location_dropdown',  # Input ID
    'Select location', # Input label
    choices = locations
  )
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)