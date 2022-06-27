#엑셀로 가설에 필요없는 데이터 삭제 후 작업
library(reshape2)
library(dplyr)
library(ggplot2)


suwon_pop <- read.csv("C:/Users/User/Desktop/빅데이터/kwh/Rproject data/5/suwon_population_gu.csv")
pop_5age_class <-read_excel("C:/Users/User/Desktop/빅데이터/kwh/Rproject data/5/population_5age_class.xls")
soju <- read_excel("C:/Users/User/Desktop/빅데이터/kwh/Rproject data/5/청소년비율.xlsx")

head(suwon_pop)
head(pop_5age_class)
head(soju)
  #데이터 변수명 변경
suwon_pop<- rename(suwon_pop, c(gu="구",
                                dong = "구_동",
                                total_pop="인구_합계"
                                ))
pop_5age_class<- rename(pop_5age_class,c(gu="구분",
                                         나이 ="연령별",
                                         population ="인구",
                                         ratio="구성비율"))
soju<- rename(soju,c(수원시구="구분",
                     청소년나이="연령별",
                     hhh="계",
                     zzz="성별_남",
                     xxx="성별_여"))
  #data 파악하기

head(suwon_pop)
head(pop_5age_class)
dim(suwon_pop)
dim(pop_5age_class)
str(suwon_pop)
str(pop_5age_class)

#suwon 구별 전체 인구 구하기

total_pop_gu<- tapply(suwon_pop$total_pop,suwon_pop$gu,sum)
head(total_pop_gu)

  #suwon 구별 청소년 인구수 추출(15 ~ 19세)
pop_5age<- pop_5age_class[,-c(4)]
  #특정언어 제거
pop_5age$gu<-gsub(" ","",pop_5age$gu)
youth_pop_gu<-pop_5age %>% filter(나이=="15 ∼ 19세"|나이 =="10 ∼ 14세")
youth_pop_gu$gu<-'numeric'
youth_pop_gu1<-group_by(gu %>% summarise(yth_p=sum(population)))
head(youth_pop_gu)

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
head(y_ratio)
  #값을 데이터 프레임 생성
y_ratio<- as.data.frame(y_ratio)
y_ratio$gu<-c("권선구","영통구","장안구","팔달구")
head(y_ratio)      
#그래프 그리기
#구별 청소년 인구비율 그래프
#영통구
yt_pop <- pop_5age_class %>% filter(pop_5age_class$gu == '영 통 구')
bang <- ggplot(yt_pop, aes(x = "", y = ratio/100, fill = 나이)) + geom_bar(width =  1, stat = "identity",color = "white") +
  coord_polar("y") + 
  geom_text(aes(label = paste0(round(ratio,1),"%")),position = position_stack(vjust = 0.5)) +
  theme_void()
bang + ggtitle("수원시 영통구 5세별 인구비율")+theme(plot.title = element_text(size = 20, face = "bold"))
#장안구
yt_pop <- pop_5age_class %>% filter(pop_5age_class$gu == '장 안 구')
godori <- ggplot(yt_pop, aes(x = "", y = ratio/100, fill = 나이)) + geom_bar(width =  1, stat = "identity",color = "white") +
  coord_polar("y") +
  geom_text(aes(label = paste0(round(ratio,1),"%")),position = position_stack(vjust = 0.5)) +
  theme_void()
godori + ggtitle("수원시 장안구 5세별 인구비율")+theme(plot.title = element_text(size = 20, face = "bold"))
#팔달구
yt_pop <- pop_5age_class %>% filter(pop_5age_class$gu == '팔 달 구')
kaka <- ggplot(yt_pop, aes(x = "", y = ratio/100, fill = 나이)) + geom_bar(width =  1, stat = "identity",color = "white") +
  coord_polar("y") +
  geom_text(aes(label = paste0(round(ratio,1),"%")),position = position_stack(vjust = 0.5)) +
  theme_void()
kaka + ggtitle("수원시 팔달구 5세별 인구비율")+theme(plot.title = element_text(size = 20, face = "bold"))
#권선구
yt_pop <- pop_5age_class %>% filter(pop_5age_class$gu == '권 선 구')
namu <- ggplot(yt_pop, aes(x = "", y = ratio/100, fill = 나이)) + geom_bar(width =  1, stat = "identity",color = "white") +
  coord_polar("y") +
  geom_text(aes(label = paste0(round(ratio,1),"%")),position = position_stack(vjust = 0.5)) +
  theme_void()
namu + ggtitle("수원시 권선구 5세별 인구비율")+theme(plot.title = element_text(size = 20, face = "bold"))



#수원시 구별 청소년 인구수
ramr <-ggplot(soju, aes(x = "", y = hhh/100, fill = 수원시구)) + geom_bar(width =  1, stat = "identity",color = "white") +
  coord_polar("y") +
  geom_text(aes(label = paste0(round(hhh,1),"명")),position = position_stack(vjust = 0.5)) +
  theme_void()
ramr + ggtitle("수원시 구별 청소년(10~24세) 인구수") +theme(plot.title = element_text(size = 20, face = "bold"))

#수원시 구별 청소년인구비율





                                         

