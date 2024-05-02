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

write_csv(df, 'shiny/daily_counts.csv')
