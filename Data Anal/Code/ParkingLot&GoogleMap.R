library(readxl)
library(dplyr)
library(stringr)
library(ggplot2)
library(ggmap)
xlsdata <- read_excel("D:/kwh/Rproject data/2/전국주차장정보표준데이터-202204191.xls")
head(xlsdata)
#데이터 수원시 필터링
parking_lot1<-xlsdata %>% filter(제공기관명=="경기도 수원시")
#필요한 데이터만 추출
parking_lot1<-parking_lot1[,c(2:7)]
#데이터 변수명 변경
names(parking_lot1)<- c("name","state","kind","addr1","addr2","lotN") 
#데이터 값 필요한 데이터 추출
parking_lot1$addr1<-gsub(" ","",parking_lot1$addr1)
parking_lot1$addr1<-substr(parking_lot1$addr1,7,9)
head(parking_lot1)
#그룹화
table(parking_lot1$addr1)
barplot(table(parking_lot1$addr1))
parking_lot1 %>% count(addr1)
#goolgle맵 이용 시각화
ggmap_key<-'AIzaSXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
register_google(ggmap_key)
parking_lot1<-mutate_geocode(data=parking_lot1,location = addr2,source='google')

parking_lot1_marker<-data.frame(parking_lot1$lon,parking_lot1$lat)
head(parking_lot1)
parkinglot_map<- get_googlemap('수원',maptype='roadmap',zoom= 13,markers=parking_lot1_marker)

ggmap(parkinglot_map) +
  geom_point(data= parking_lot1,aes(x=lon,y=lat),size = 3,label= parking_lot1$name )




