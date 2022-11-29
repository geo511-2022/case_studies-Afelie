library(sf)
library(tidyverse)
library(ggmap)
library(rnoaa)
library(spData)
data(world)
data(us_states)

dataurl="https://www.ncei.noaa.gov/data/international-best-track-archive-for-climate-stewardship-ibtracs/v04r00/access/shapefile/IBTrACS.NA.list.v04r00.points.zip"
tdir=tempdir()
download.file(dataurl,destfile=file.path(tdir,"temp.zip"))
unzip(file.path(tdir,"temp.zip"),exdir = tdir) #unzip the compressed folder
storm_data <- read_sf(list.files(tdir,pattern=".shp",full.names = T))

storm_data

storm_data_refined <- filter(storm_data, SEASON >= 1950) %>%
  mutate_if(is.numeric, function(x) ifelse(x==-999.0,NA,x))%>%
  mutate(decade=(floor(year/10)*10))
storm_data_refined

region <- st_bbox(c(xmin = -128.5, xmax = 63, ymin = 6,2, ymax = 83.01))

world_refined <- ggplot(world)+
  facet_wrap(~decade)+
  geom_sf()+
  stat_bin2d(data=storm_data_refined, aes(y=st_coordinates(storm_data_refined)[,2], x=st_coordinates(storm_data_refined)[,1]),bins=100)+
  scale_fill_distiller(palette="YlOrRd", trans="log", direction=-1, breaks = c(1,10,100,1000))+
  coord_sf(ylim=region[c(2,4)], xlim=region[c(1,3)])
world_refined

top5state <- st_transform(us_states, st_crs(storm_data_refined))%>%
select(state=NAME)

  storm_states <- st_join(storm_data_refined, top5state, join = st_intersects,left = F)%>%
    group_by(state)%>%
    summarize(storms=length(unique(NAME)))%>%
                arrange(desc(storms))%>%
    slice(1:5)
storm_states  
