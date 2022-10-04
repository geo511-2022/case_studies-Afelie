#group 2 Candace, Zack
install.packages("ggplot2")
library(dplyr)
library(ggplot2)
library(readr)
dataurl="https://data.giss.nasa.gov/tmp/gistemp/STATIONS/tmp_USW00014733_14_0_1/station.txt"
httr::GET("https://data.giss.nasa.gov/cgi-bin/gistemp/stdata_show_v4.cgi?id=USW00014733&ds=14&dt=1")
temp=read_table(dataurl, skip=3, na="999.90", col_names = c("YEAR","JAN","FEB","MAR", "APR","MAY","JUN","JUL",  
                              "AUG","SEP","OCT","NOV",  
                              "DEC","DJF","MAM","JJA",  
                              "SON","metANN"))
summary(temp)

ggplot(temp, aes(x = YEAR, y = JJA)) + geom_line() + 
  geom_smooth(method = "loess", formula = "y ~ x", color = "Orange",)+
  xlab("Year") + ylab("Mean Summer Temperature (C)")+
  ggtitle("Mean Summer Temperature In Buffalo, NY")+
  labs(subtitle = "Summer includes June, July, and August", 
       caption= "Data from the Global Historical Climate Network 
       Red line is a LOESS smooth")

ggsave("casetudy.png")
