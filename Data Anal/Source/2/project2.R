library(readxl)
library(dplyr)
library(stringr)
library(ggplot2)
library(ggmap)
xlsdata <- read_excel("D:/kwh/Rproject data/2/전국주차장정보표준데이터-202204191.xls")
View(xlsdata)
parking_lot1<-xlsdata %>% filter(제공기관명=="경기도 수원시")
parking_lot1<-parking_lot1[,c(2:7)]
names(parking_lot1)<- c("name","state","kind","addr1","addr2","lotN") 
parking_lot1$addr1<-gsub(" ","",parking_lot1$addr1)
parking_lot1$addr1<-substr(parking_lot1$addr1,7,9)

table(parking_lot1$addr1)
barplot(table(parking_lot1$addr1))
parking_lot1 %>% count(addr1)

ggmap_key<-'AIzaSyBzhYkZWSYHj5jWt_Lig1ioUekdtgHGiyg'
register_google(ggmap_key)
parking_lot1<-mutate_geocode(data=parking_lot1,location = addr2,source='google')

parking_lot1_marker<-data.frame(parking_lot1$lon,parking_lot1$lat)
parkinglot_map<- get_googlemap('수원',maptype='roadmap',zoom= 13,markers=parking_lot1_marker)

ggmap(parkinglot_map) +
  geom_point(data= parking_lot1,aes(x=lon,y=lat),size = 3,label= parking_lot1$name )


