import pymysql
import pandas as pd
import numpy as np


#변수 설정
conn, cur = None,None


conn = pymysql.connect(host='127.0.0.1', user='root', password ='1234',db='teamPrj',charset='utf8')
cur= conn.cursor()
#--------------------------------------------DB data 정제------------------------------------------
cur.execute("SELECT * FROM good")

#phone column에 -,-2 제거 
cur.execute("UPDATE good SET phone = SUBSTRING_INDEX(phone, '-',-2) WHERE phone LIKE '02-%'")

cur.execute("UPDATE good SET phone = concat('02-',phone)")
cur.execute("UPDATE good SET address = substring_index(address, '(',1)")
cur.execute("SELECT * FROM good WHERE typeName LIKE '%'")
conn.commit()

