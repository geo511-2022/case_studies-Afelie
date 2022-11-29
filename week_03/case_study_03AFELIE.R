library(dplyr)
library(ggplot2)
install.packages("gapminder")
library(gapminder)

filter_gap <- gapminder %>%
  filter(country != "Kuwait")
filter_gap

plot1 <- ggplot(filter_gap, aes(x = lifeExp, y = gdpPercap, color = continent, size = pop/100000))+
  geom_point()+
  scale_y_continuous(trans = "sqrt")+
  facet_wrap(~year,nrow=1)+
  theme_bw()+
  labs(x = "Life Expectancy", y = "GDP per capita", size ="Population 100k", color = "continent")
plot1

ggsave("plot_1.png", width = 15)

group_gap <- filter_gap %>% group_by(continent, year) %>% summarize(gdpPercapweighted = weighted.mean(x = gdpPercap, w = pop), pop = sum(as.numeric(pop)))

plot2 <- ggplot(filter_gap, aes(x = year, y = gdpPercap, color = continent))+
  geom_line(aes(group = country)) + geom_point() +
  geom_line(data = group_gap, aes(x = year, y = gdpPercapweighted), color = "green") + 
  geom_point(data = group_gap, aes(x = year, y = gdpPercapweighted, size = pop/100000), colour = "green") +
  facet_wrap(~continent, nrow=1) + theme_bw() + guides(size= guide_legend(title = "Population (100k)")) +
  labs(y = "GDP per capita",x  = "Year") 

plot2

ggsave("plot_2.png", width = 15)