#데이터 전처리 (정민)
library(readxl)
library(dplyr)
library(stringr)
library(tidyr)
library(ggplot2)
#주자창데이터터
#데이터 읽어오기
data_ex2 <- read_xls("C:/Users/User/Desktop/빅데이터/kwh/Rproject data/6/National parking lot information standard data-20220419.xls") #파일 경로를 바꿔주세요
#데이터 변수명 재설정
names(data_ex2)[names(data_ex2)=="제공기관명"]="Jegong"
names(data_ex2)[names(data_ex2)=="주차구획수"]="Seat"
names(data_ex2)[names(data_ex2)=="소재지지번주소"]="Gu"
#데이터 수원 소재지 분류 추출
my_df4 <- data_ex2 %>% filter(`Jegong` == "경기도 수원시")
#엑셀로 결측값 데이터 전처리
#데이터 필요한 변수만 추출
my_df4 <- my_df4 %>% select(Gu,Seat)
#---------------------------위 데이터 동일----------------------------
#----------------------------추가작업------------------------------
#소재지 주소 중 '동'만 추출
#Gu의 주소 ' ' 으로 문자열 분리
split_Gu<-strsplit(my_df4$Gu, split=' ')
#구조 파악
str(split_Gu) #51 list


split_Gu_df<- as.data.frame(split_Gu) #데이터 프레임화
split_Gu_df<- split_Gu_df[-c(1,2,3,5),] # 데이터프레임에서 '동'을 제외한 모든 값 삭제
split_Gu_df1<-as.list(split_Gu_df) #데이터 프레임 다시 리스트화
my_df4$Gu<-split_Gu_df1 #기존 구 데이터 에서 추출된 리스트값 덮어 쓰기 
mode(my_df4$Seat) <- "numeric"
my_df4 <- my_df4 %>% group_by(Gu) %>% summarise(sum = sum(Seat))
my_df4$Gu<- as.character(my_df4$Gu)
head(my_df4)


my_df4<-rename(my_df4,seat_sum=sum)
#write.csv(my_df4,"D:/kwh/Rproject data/6//New_parking Status_20220419.csv",row.names = FALSE) #파일 경로 수정
#주정차단속
data_ex3 <- read.csv("C:/Users/User/Desktop/빅데이터/kwh/Rproject data/6/Suwon_Parking Blocking_20220328.csv") #파일 경로를 바꿔주세요
head(data_ex3)

names(data_ex3)[names(data_ex3)=="단속구분"]="A"
names(data_ex3)[names(data_ex3)=="단속동"]="Gu"
names(data_ex3)[names(data_ex3)=="단속건수"]="su"
my_df3 <- data_ex3 %>% filter(A == "고정형")

my_df3 <- my_df3 %>% select(Gu,su)
my_df3 <- my_df3 %>% group_by(Gu) %>% summarise(sum = sum(su))
head(my_df3)

#write.csv(my_df3,"D:/kwh/Rproject data/6/New_Suwon_Parking Blocking_20220328.csv",row.names = FALSE)#파일 경로 수정


#데이터 합치기 
block_parking<- merge(my_df3, my_df4, by='Gu',all=TRUE)
block_parking<- rename(block_parking,crackdown_sum=sum)
head(block_parking)
#error Error in order(list(`NA` = "고색동", `NA` = "곡반정동", `NA` = "교동",  : unimplemented type 'list' in 'orderVector1'
#
typeof(my_df4)
typeof(my_df4$Gu)
typeof(my_df3)
typeof(my_df3$Gu)
#my_df4$Gu 데이터 변환 캐릭터 -> 해결
# my_df3,my_df4 의 Gu 데이터 타입이 다르다 . df_3$Gu 의 타입을 변환해야된다.


#데이터 분석 
block_parking<-block_parking %>% arrange(Gu) #오름차순 정렬
str(block_parking)
#결측값 개수 측정
colSums(is.na(block_parking))
#결측치 제거 
block_parking1<-na.omit(block_parking)
head(block_parking1)
#그래프 
#그래프 그리기 
#1.동 별 단속 수 그래프
#데이터 바형태, x축, y 축 설정, 오름차순 정렬(단속 수),bar안 색변화, 그래프 90도 변경
p1<-ggplot(data=block_parking1,aes(x=reorder(Gu,-block_parking1$crackdown_sum),y=crackdown_sum)) + geom_bar(stat='identity',fill='#5CBED2') + coord_flip()
#x,y, 제목 이름 변경 및 제목 크기 설정
p1<-p1+labs(x='지역',y='단속 수',title='지역별 단속')+theme(plot.title = element_text(size=18))
#단속 수 평균값 그리기
p1<-p1 + geom_hline(yintercept = mean(block_parking1$crackdown_sum),linetype='dashed')
p1
#ggsave('지역별 단속 수.png')
#2.동 별 주차장 그래프
#데이터 바형태, x축, y 축 설정, 오름차순 정렬(주차장이용가능대수),bar안 색변화, 그래프 90도 변경
p2<-ggplot(data=block_parking1,aes(x=reorder(Gu,-block_parking1$seat_sum),y=seat_sum)) +
  geom_bar(stat='identity',fill='#F08080') +
  coord_flip()
#x,y, 제목 이름 변경 및 제목 크기 설정
p2<-p2+labs(x='지역',y='공용 주차장 가능 차량 대수',title='지역별 공영주차장 이용 가능 차량 수')+theme(plot.title = element_text(size=18))
#공영주차장 차량이용 수 평균값 그리기
p2<-p2+geom_hline(yintercept = mean(block_parking1$seat_sum),linetype='dashed')                                                                        
p2
#ggsave('지역별 공영주차장 이용가능 차량 수.png')
#상관관계 분석
attach(block_parking1)
#산점도
plot(crackdown_sum~seat_sum,main='공영주차장 이용가능 수와 주차단속 수의 관계',xlab='지역별 공영주차장 이용가능 수',ylab='지역별 주차단속 수',cex=1,pch=1,col='blue')
#ggsave('공영주차장 이용가능 수와 주차단속 수의 산점도.png')
#공분산
cov(crackdown_sum,seat_sum)

#상관관계수
cor(crackdown_sum,seat_sum,use = 'complete.obs',method = 'pearson')

#상관관계 검정
cor.test(crackdown_sum,seat_sum)

