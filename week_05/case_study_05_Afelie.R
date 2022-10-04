#install.packages("spData")
#install.packages("sf")

library(spData)
library(sf)
library(tidyverse)
library(units)

data(world)
data(us_states)
plot(world)
plot(us_states)

albers="+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs"
Canada1 <- st_transform(world, albers)
world_Canada <- Canada1 %>% filter(name_long == "Canada")
Buffer_Canada <- st_buffer(world_Canada, dist = 10000)
plot(world_Canada)

Trans_US <- st_transform(us_states, albers)
Filter_US <- Trans_US %>% filter(NAME == "New York")
Merge <- st_intersection(Buffer_Canada, Filter_US)

ggplot(Merge)+
  geom_sf(data = Filter_US)+
  geom_sf(data = Merge, fill = "Red" )+
  labs(title = "New York Land Within 10km")+
  theme(plot.title = element_text(hjust = 0.5))

MergeArea<- st_area(Merge)
set_units(MergeArea, km^2)

#Havent fixed plot window issue yet
