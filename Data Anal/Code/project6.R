#1.청소년(10~19세) 인구 구하기
total_5age_pop<- read_excel("D:/kwh/Rproject/source/데이터/5/5age_total_pop.xls")
str(total_5age_pop)
View(total_5age_pop)

  #필요없는 데이터 삭제
total_5age_pop<-total_5age_pop[,-c(4:6)]
total_5age_pop<-total_5age_pop[-c(1:18),]

  #데이터 변수명 변경
total_5age_pop<-rename(total_5age_pop,c(age="연령별",pop="계"))
  #10~19세 인구 데이터 추출
yth_pop_gu<-total_5age_pop %>% filter(age == "15 ∼ 19세"|age == '10 ∼ 14세') #
  #10~19세 인원수로 합산
total_yth_gu<-tapply(yth_pop_gu$pop,yth_pop_gu$gu,sum) 
View(total_yth_gu)
  #구별 10~19세 인구 데이터 프레임
total_yth_gu<-as.data.frame(total_yth_gu) 

#2.구별 공부방 현황
  #원본데이터 가져오기
suwon_studyroom <- read.csv("D:/kwh/Rproject/source/데이터/5/suwon_studyroom.csv")
  #원본데이터 구조 및 데이터 확인
str(suwon_studyroom)
View(suwon_studyroom)
  #필요없는 데이터 삭제
suwon_studyroom<-suwon_studyroom[,-c(1,3,5:13)] 
  #변수명 변경
suwon_studyroom<-rename(suwon_studyroom,c(name="공부방명",addr="소재지지번주소"))
  #특정 문자열 일부추출
    #공백 없애기
suwon_studyroom$addr<-gsub(" ","",suwon_studyroom$addr)
    #데이터 addr 열에서 7~9번째 문자열만 추출
suwon_studyroom$addr<-substr(suwon_studyroom$addr,7,9)
View(suwon_studyroom)
#strsplit(as.character(suwon_studyroom$addr[]),split = " ")

  #구별 공부방 개수 구하기
    #결측값 측정
is.na(suwon_studyroom$addr)
sum(is.na(suwon_studyroom$addr)) # 결측값=0

# 각 구별 공부방 개수 측정
sty_num <- c(length(which(suwon_studyroom$addr == "권선구")), length(which(suwon_studyroom$addr == "영통구")), length(which(suwon_studyroom$addr == "장안구")), length(which(suwon_studyroom$addr == "팔달구")) )

#데이터 추가
total_yth_gu$sty_num<-c(length(which(suwon_studyroom$addr == "권선구")), length(which(suwon_studyroom$addr == "영통구")), length(which(suwon_studyroom$addr == "장안구")), length(which(suwon_studyroom$addr == "팔달구")) )
View(total_yth_gu)
#청소년 인구와 공부방 개수는 상관없다.

