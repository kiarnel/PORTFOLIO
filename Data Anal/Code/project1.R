#데아터 전처리 (정민)
library(readxl)
library(dplyr)
library(stringr)
#인구현황황
data_ex1 <- read.csv("D:/kwh/Rproject data/1/Suwon_Population Status_20210531.csv") #파일 경로 바꿔주세요
head(data_ex1)
names(data_ex1)
names(data_ex1)

names(data_ex1)[names(data_ex1)=="구"]="Gu"
#내국인 외국인 총 인구 합계계
names(data_ex1)[names(data_ex1)=="인구_합계"]="population_Sum"

my_df1 <- data_ex1 %>% group_by(Gu) %>% summarise(population_Sum = sum(population_Sum))
head(my_df1)

write.csv(my_df1,"D:/kwh/Rproject data/1/New_Suwon_Population Status_2010531.csv",row.names = FALSE)#파일 경로 수정정

#주차창 시작
data_ex2 <- read_xls("D:/kwh/Rproject data/1/National parking lot information standard data-20220419.xls") #파일 경로를 바꿔주세요
head(data_ex2)

names(data_ex2)[names(data_ex2)=="제공기관명"]="Jegong"
names(data_ex2)[names(data_ex2)=="주차구획수"]="Seat"
names(data_ex2)[names(data_ex2)=="소재지지번주소"]="Gu"
my_df2 <- data_ex2 %>% filter(`Jegong` == "경기도 수원시")
head(my_df2)

my_df2 <- my_df2 %>% select(Gu,Seat,`Jegong`)

my_df2$Gu<-gsub(" ","",my_df2$Gu)
my_df2$Gu<-substr(my_df2$Gu,7,9)
my_df2$su = 1
head(my_df2)

mode(my_df2$Seat) <- "numeric"

my_df2 <- my_df2 %>% group_by(Gu) %>% summarise(parking_sum = sum(su),Seat = sum(Seat))
head(my_df2)
write.csv(my_df2,"D:/kwh/Rproject data/1/New_parking Status_20220419.csv",row.names = FALSE)#파일 경로 수정

#데이터분석 및 시각화(김원호)

# 가설 인구수와 주차장의 상관관계
 #결측값 확인 
str(my_df1) #각 데이터 구조 분석
str(my_df2)    
colSums(is.na(my_df1)) #각 데이터 열 결측값 개수 측정 0
colSums(is.na(my_df2))

#두 데이터 결합
pop_parking<- merge(my_df1,my_df2,by ="Gu") #merge(data,data, by= 'key') 값이 같은 key를 기준으로 두 데이터 합성 
head(pop_parking)
#1.산점도로 두데이터 간 관련성 확인
attach(pop_parking)
plot(parking_sum~population_Sum, main="인구별 주차장 수",xlab="지역별 인구", ylab="지역별 공영주차장 수",cex=2,pch=0,col='blue')
ggsave('산점도(인구,주차장).png')
#main =  제목, xlab = x축 이름 , ylab= y축 이름 ,  cex = 점 크기 , pch= 점 모양 , col= 점 색)

#산점도 이용 두 변수간 직선적인 관계 개략적 파악 가능
#But 두 변수 사이의 관계를 정확히 숫자로 표현 불가 그래서 공분산, 상관계수 이용

#2.공분산; 2개의 확률변수의 상관정도를 나타내는 값
#       상관관계의 상승, 하강 경향 파악 가능 ,  But  절대적인 정도 파악 x , 어느정도 양의 상관관계 인지 가늠 x
cov(parking_sum,population_Sum)

#3.상관계수; 공분산의 표준화, -1 ~ 1의 값, 0일 경우 두 변수 간 선형관계 없다는 것 뜻함.

cor(parking_sum,population_Sum,use='complete.obs',method = 'pearson')
# cor 함수 : 선형관계의 강도 , use='complete.obs' 결측값 모두 제거된 상태에서 계산, method= 상관관계 구하는 방식 'pearson' = 피어슨 상관계수

#4. 상관계수의 검정;
cor.test(parking_sum,population_Sum)

#그외 , 다른 변수들간의 상관관계

plot(pop_parking[,2:4])
ggsave('상관관계 분석도(인구,주차장,주차이용대수).png')
library(corrplot)
cor(pop_parking[,2:4])

X<- cor(pop_parking[,2:4])
corrplot(X)
ggsave('상관관계 분석도(인구,주차장,주차이용대수)2.png')
