library(raster)
library(sp)
library(spData)
library(tidyverse)
library(sf)
library(ncdf4)
library(dplyr)
library(gt)
data(world)

download.file("https://crudata.uea.ac.uk/cru/data/temperature/absolute.nc","crudata.nc", method = "curl")
tmean=raster("crudata.nc")

sp_world = world %>%
filter(continent != "Antartica")%>%
as(., "Spatial")

plot(tmean)


tmax_annual <- max(tmean)
names(tmax_annual) <- "tmean"

tmax_country <- raster::extract(tmax_annual, sp_world, fun = max,na.rm=T, small=T, sp=T) %>% st_as_sf()

ggplot(tmax_country, aes(fill = tmean)) +
  geom_sf()+
  scale_fill_viridis_c(name="Annual\nMaximum\nTemperature (C)")+
  theme(legend.position = 'bottom')

