import pymysql


data1, data2, data3, data4 = "", "", "", ""
sql = ''

conn = pymysql.connect(host='127.0.0.1', user='root', password = '0000', db = 'soloDB', charset='uft8')

cur = conn.cursor()

cur.execute("create table userTable (id char(4), userName char(15), email char(20), birthYear int")

cur.execute("insert into userTable values('hong', '홍지윤', 'hong@naver.com', 1996)")
cur.execute("insert into userTable values('kim', '김태연', 'kim@daum.net', 2011)")
cur.execute("insert into userTable values('star', '별사랑', 'star@paran.com', 1990)")
cur.execute("insert into userTable values('yang', '양지은', 'yang@naver.com', 1996)")

while (True):
    data1 = input("사용자 ID == > ")
    if data1 == "":
       break;
    data2 = input("사용자 이름 ==> ")
    data3 = input("이메일 ==> ")
    data4 = input("출생연도 ==> ")
    sql = "insert into userTable values('"+ data1 +"' , '" + data2 + "','" + data3 + "'," + data4 +")"
    cur.execute(sql)
# conn.commit()


cur.execute("select * from userTable")
print("사용자 ID       사용자 이름      이메일    출생연도")
print("---------------------------------------------")

while (True):
    if row == None:
        break
    print(row)
    data1 = row[0]
    data2 = row[1]
    data3 = row[2]
    data4 = row[3]
    print("%5s       %15s        %20s      %d"(data1, data2, data3, data4))

conn.close()


