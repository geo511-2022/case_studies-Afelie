install.packages("nycflights13")
install.packages("tidyverse")
library(tidyverse)
library(nycflights13)

str(flights)
str(airports)

farthest_airport <- flights %>%
  arrange(desc(distance)) %>%
  slice(1:5)%>% 
  left_join(airports, by = c("origin" = "faa"))%>%
  select(dest)%>%
  as.character()

farthest_airport

