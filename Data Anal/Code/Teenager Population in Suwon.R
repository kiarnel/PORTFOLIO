#엑셀로 가설에 필요없는 데이터 삭제 후 작업
suwon_pop <- read.csv("D:/kwh/Rproject/source/데이터/5/suwon_population_gu.csv")
pop_5age_class<-read_excel("D:/kwh/Rproject/source/데이터/5/population_5age_class.xls")

View(suwon_pop)
View(pop_5age_class)

library(reshape2)
library(dplyr)
  #데이터 변수명 변경
suwon_pop<- rename(suwon_pop, c(gu="구",
                                dong = "구_동",
                                total_pop="인구_합계"
                                ))
pop_5age_class<- rename(pop_5age_class,c(gu="구분",
                                         age ="연령별",
                                         population ="인구",
                                         ratio="구성비율"))
  #data 파악하기

head(suwon_pop)
head(pop_5age_class)
dim(suwon_pop)
dim(pop_5age_class)
str(suwon_pop)
str(pop_5age_class)

#suwon 구별 전체 인구 구하기

total_pop_gu<- tapply(suwon_pop$total_pop,suwon_pop$gu,sum)
View(total_pop_gu)

  #suwon 구별 청소년 인구수 추출(15 ~ 19세)
pop_5age<- pop_5age_class[,-c(4)]
  #특정언어 제거
pop_5age$gu<-gsub(" ","",pop_5age$gu)
youth_pop_gu<-pop_5age %>% filter(age=="15 ∼ 19세")
View(youth_pop_gu)

# 각 구별 청소년 비율 구하기
  #구/청소년 인구 수 데이터 
youth_pop<-youth_pop_gu[,-c(2)]
  #전체 인구 수 데이터 
gu<-c("장안구","권선구","팔달구","영통구")
pop<- c(total_pop_gu)
total_pop<- data.frame(gu,pop)
#각 구별 청소년 비율 = 구별 15~19세 청소년 인구수/ 구별 전체 인구수
  #데이터 합치기
pop<-merge(total_pop,youth_pop,by="gu",all=T)
  #데이터 변수명 변경
pop<- rename(pop,c(y_pop="population"))
  #구별 청소년인구 비율 값 계산
y_ratio<- pop$y_pop/pop$pop *100
View(y_ratio)
  #값을 데이터 프레임 생성
y_ratio<- as.data.frame(y_ratio)
y_ratio$gu<-c("권선구","영통구","장안구","팔달구")




                                         

