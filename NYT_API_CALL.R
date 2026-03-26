library(httr)
library(tidyverse)
library(rvest)
library(jsonlite)
library(dplyr)
library(ggplot2)

api_key <- Sys.getenv("NYT_API_KEY")
api_key

url <- paste0("https://api.nytimes.com/svc/books/v3/lists/current/hardcover-fiction.json?api-key=", api_key)

response <- GET(url)
response
data <- fromJSON(content(response, "text"))

data
class(data$results)
books <- as_tibble(data$results$books)
books |>
  select(title, author, publisher, rank, description)

books_clean <- books |>
  select(rank, title, author, publisher, weeks_on_list) |>
  arrange(rank)
  
ggplot(books_clean, aes(x = reorder(title, -rank), y = weeks_on_list)) +
  geom_col() +
  coord_flip() +
  labs(title = "Weeks on List for Current NYT Hardcover Fiction Best Sellers",
       x = "Book Title",
       y = "Weeks on List")
