library(readxl)
library(dplyr)
library(stringr)
road <- read_excel("D:/kwh/Rproject data/2/경기도 수원시_인구현황_20210531.xlsx")
asdf <- road%>%select(구,내국인인구수계)
asdf <- asdf %>% group_by(구) %>%
summarise(내국인인구수계 = sum(내국인인구수계))
View(asdf)
