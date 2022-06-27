library(reshape2)
library(dplyr)
library(ggplot2)
library(ggmap)
library(readxl)
#1.청소년(10~19세) 인구 구하기
total_5age_pop<- read_excel("C:/Users/User/Desktop/빅데이터/kwh/Rproject data/5/5age_total_pop.xls")
str(total_5age_pop)
head(total_5age_pop)

  #필요없는 데이터 삭제
total_5age_pop<-total_5age_pop[,-c(4:6)]
total_5age_pop<-total_5age_pop[-c(1:18),]

  #데이터 변수명 변경
total_5age_pop<-rename(total_5age_pop,c(gu="구분",age="연령별",pop="계"))
head(total_5age_pop)  
#10~19세 인구 데이터 추출
yth_pop_gu<-total_5age_pop %>% filter(age == "15 ∼ 19세"|age == '10 ∼ 14세') #
  #10~19세 인원수로 합산
total_yth_gu<-tapply(yth_pop_gu$pop,yth_pop_gu$gu,sum) 
head(total_yth_gu)
  #구별 10~19세 인구 데이터 프레임
total_yth_gu<-as.data.frame(total_yth_gu) 
head(total_yth_gu)
#2.구별 공부방 현황
  #원본데이터 가져오기
suwon_studyroom <- read.csv("C:/Users/User/Desktop/빅데이터/kwh/Rproject data/5/suwon_studyroom.csv")
  #원본데이터 구조 및 데이터 확인
str(suwon_studyroom)
head(suwon_studyroom)
  #필요없는 데이터 삭제
suwon_studyroom<-suwon_studyroom[,-c(1,5:13)] 
  #변수명 변경
suwon_studyroom<-rename(suwon_studyroom,c(name="공부방명",addr="소재지지번주소",addr2="소재지도로명주소"))
  #특정 문자열 일부추출
    #공백 없애기
suwon_studyroom$addr<-gsub(" ","",suwon_studyroom$addr)
    #데이터 addr 열에서 7~9번째 문자열만 추출
suwon_studyroom$addr<-substr(suwon_studyroom$addr,7,9)
head(suwon_studyroom)
#strsplit(as.character(suwon_studyroom$addr[]),split = " ")

  #구별 공부방 개수 구하기
    #결측값 측정
is.na(suwon_studyroom$addr)
sum(is.na(suwon_studyroom$addr)) # 결측값=0

# 각 구별 공부방 개수 측정
#sty_num <- c(length(which(suwon_studyroom$addr == "권선구")), length(which(suwon_studyroom$addr == "영통구")), length(which(suwon_studyroom$addr == "장안구")), length(which(suwon_studyroom$addr == "팔달구")) )

#데이터 추가
total_yth_gu$sty_num<- c(length(which(suwon_studyroom$addr == "권선구")), length(which(suwon_studyroom$addr == "영통구")), length(which(suwon_studyroom$addr == "장안구")), length(which(suwon_studyroom$addr == "팔달구")) )
head(total_yth_gu)
#청소년 인구와 공부방 개수는 상관없다.

ggmap_key <- "AIzaSyBzhYkZWSYHj5jWt_Lig1ioUekdtgHGiyg"
register_google(ggmap_key) 
  suwon_studyroom <- mutate_geocode(data = suwon_studyroom,location=addr2,source='google' )

suwon_studyroom_marker<-data.frame(suwon_studyroom$lon,suwon_studyroom$lat)
head(suwon_studyroom)
suwon_studyroom_map<- get_googlemap('수원',maptype='roadmap',zoom= 12,markers=suwon_studyroom_marker)

ggmap(suwon_studyroom_map) +
  geom_point(data= suwon_studyroom,aes(x=lon,y=lat),size = 3,label= suwon_studyroom$name )

#지역별 청소년 인구와 공부방 개수 
#지역별 공부방수
total_yth_gu$gu<-c("권선구","영통구","장안구","팔달구")
total_yth_gu<- rename(total_yth_gu, c(yth_po="total_yth_gu"))
p3<-ggplot(data = total_yth_gu, aes(x=gu, y=sty_num)) + geom_bar(stat='identity',fill='#5CBED2') + coord_flip()
p3<-p3+labs(x='지역',y='공부방 수',title='지역별 공부방수')+theme(plot.title = element_text(size=18))
p3

#지역별 청소년 인구
p4<-ggplot(data= total_yth_gu,aes(x=gu, y=yth_po)) +geom_bar(stat='identity',fill='#F08080')
p4<-p4+labs(x='지역',y='청소년 인구', title='지역별 청소년 인구 수')+theme(plot.title = element_text(size=18))
p4

#청소년 인구와 공부방수\
attach(total_yth_gu)
#산점도
plot(sty_num~yth_po,main='청소년 인구와 공부방 수의 관계',xlab='지역별 청소년 인구 ',ylab='지역별 공부방 수',cex=1,pch=1,col='blue')

#공분산
cov(sty_num,yth_po)

#상관관계수
cor.test(sty_num,yth_po)
