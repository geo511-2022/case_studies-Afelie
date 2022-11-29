library(tidyverse)
library(spData)
library(sf)
install.packages("mapview")
library(mapview) # new package that makes easy leaflet maps
install.packages("foreach")
library(foreach)
install.packages("doParallel")
library(doParallel)
install.packages("tidycensus")

library(tidycensus)
census_api_key("2a690a25998415a524b1404fbe7cb453772b143f")
racevars <- c(White = "P005003", 
              Black = "P005004", 
              Asian = "P005006", 
              Hispanic = "P004003")

options(tigris_use_cache = TRUE)
erie <- get_decennial(geography = "block", variables = racevars, 
                      state = "NY", county = "Erie County", geometry = TRUE,
                      summary_var = "P001001", cache_table=T)

eriecrop <- st_crop(erie, c(xmin=-78.9,xmax=-78.85,ymin=42.888,ymax=42.92))
eriecrop

erieforeach = foreach(i = unique(eriecrop$variable), .combine = rbind) %do% 
  filter(eriecrop,variable==i) %>%
    st_sample(size=.$value) %>%
    st_as_sf() %>%
    mutate(variable = i)


mapview(erieforeach, zcol = 'variable', alpha = 0, cex = 0.1)

