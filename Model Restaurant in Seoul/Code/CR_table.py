import pymysql
import pandas as pd
import numpy as np


#변수 설정
conn, cur = None,None


conn = pymysql.connect(host='127.0.0.1', user='root', password ='1234',db='teamPrj',charset='utf8')
cur= conn.cursor()
cur.execute("SELECT * FROM good_food")
cur.execute("CREATE Table IF NOT EXISTS good_menus  as ( select code, likeCount, mainMenu, price from good_food )")
sql='''CREATE Table IF NOT EXISTS good_typeName(
	            type INT NOT NULL,
                typeName VARCHAR(100) NOT NULL,
                PRIMARY KEY (type)) 
                as ( select type, typeName from good_food group by type order by type )
                '''
cur.execute(sql)
sql1='''CREATE TABLE IF NOT EXISTS good_address(
	        code INT NOT NUll,
            name VARCHAR(255),
            type VARCHAR(255),
            address VARCHAR(255),
            phone VARCHAR(255),
            lat VARCHAR(255),
            lon VARCHAR(255),
            PRIMARY KEY(code))
            as ( select code,name,type,address,phone,lat,lon from good_food GROUP BY code order by code )'''
cur.execute(sql1)
conn.commit()