import tkinter
import pymysql
from tkinter import *
import tkintermapview
import tkinter.font as tkFont
import time
#TK인터로 UI구현
root = Tk()
root.title('Codemy.com - Tkinter MapView')
width= root.winfo_screenwidth()
height= root.winfo_screenheight()  
root.geometry("%dx%d" % (width, height))
#mysql 접속
connect = pymysql.connect(host = '127.0.0.1', user = 'root', password = '1234', db = 'teamprj', charset='utf8')
cur = connect.cursor(pymysql.cursors.DictCursor)
datas = None
#Frame 생성
FrameT = tkinter.Frame(root, bd=2, padx=2, pady=2)
FrameT.pack(side = 'top', fill='x')
FrameB = tkinter.Frame(root, bd=2, padx=2, pady=2)
FrameB.pack(side = 'bottom', fill="both", expand=True)
#listbox 생성
listbox = Listbox(FrameT, width=26,height = 6, bd=2)
listbox.pack(side='left')
for i in ['전체보기', '한식','중식','경양식, 일식','기타 외식업(다방, 패스트푸드 등)']:
  listbox.insert(END, i)
#FrameT에 label 생성
fontStyle = tkFont.Font(family="Lucida Grande", size=16)
label1 = tkinter.Label(FrameT, fg = 'black', bg = 'white',relief="groove",font= fontStyle,justify='left', anchor='w',  text = '원하시는 음식점을 골라주세요')
label1.pack(side='right', fill="both", expand=True)  
#FrameB에 맵 위젯 생성
map_widget = tkintermapview.TkinterMapView(FrameB, corner_radius=100)
#실행 시 초기값 설정
map_widget.set_position(37.5560837, 126.9860765)
map_widget.set_zoom(12)
map_widget.pack(fill='both',expand=True)

def event_for_listbox(item):
  global connect, cur, datas, listbox
  query = 'select * from good_address'
  cur.execute(query)
  datas = cur.fetchall() 
  #클릭 시 마크 초기화
  for marker in map_widget.canvas_marker_list.copy():
    marker.delete()
  #같은 건물일 시 살짝 거리 벌려줘서 안겹치게 표시
  for i in range(len(datas)):
    for j in range(len(datas)):
      if i == j:
        continue
      if (datas[i]["lat"] == datas[j]['lat']) and (datas[i]['lon'] == datas[j]['lon']):
        datas[j]['lat']=str(float(datas[j]['lat']) - 0.00005)
        datas[j]['lon']=str(float(datas[j]['lon']) + 0.00005)
  #한식, 중식, 양식, 기타외식업 색깔표시
  for i in range(len(datas)):
    icon = ''
    if datas[i]['type'] == '1':
      icon = '#137FF2'      
    elif datas[i]['type'] == '2' :
      icon = '#37EA27'  
    elif datas[i]['type'] == '3':
      icon = '#F4F13D'
    elif datas[i]['type'] == '4':
      icon = '#8418F8' 
    #위도경도값을 기준으로 마커 생성
    lat = float(datas[i]['lat'])
    lon = float(datas[i]['lon']) 
    selects = listbox.curselection()
    if int(datas[i]['type']) in selects:
      map_widget.set_marker(lat, lon, command=click_marker_event,marker_color_outside = icon, marker_color_circle = '#F9F2F2')       
    elif 0 in selects:
      map_widget.set_marker(lat, lon, command=click_marker_event,marker_color_outside = icon, marker_color_circle = '#F9F2F2')
#listbox 클릭 이벤트 호출 함수
listbox.bind('<<ListboxSelect>>', event_for_listbox)
#마커클릭 이벤트
def click_marker_event(marker):
  global label1
  for row in datas:
    if float(row['lat']) == marker.position[0] and float(row['lon']) == marker.position[1]:
      label1['text'] = "가게이름 : " + row['name'] +  "\n\n주소 : " +row['address'] + "\n\n전화번호 : " +row['phone']
#Tkinter 실행
root.mainloop()