
import json
import pymysql

# MySQL 데이터베이스에 연결
connection = pymysql.connect(
host='localhost', # MySQL 서버 호스트
user='root', # MySQL 사용자 이름
password='1234', # MySQL 비밀번호
database='movies', # 사용할 데이터베이스 이름
charset='utf8mb4',
cursorclass=pymysql.cursors.DictCursor
)

try:
with connection.cursor() as cursor:
with open('movies-data.json', 'r', encoding='utf-8') as file:
data = json.load(file)

insert_query = """
INSERT INTO movies (
title,
original_title,
original_language,
overview,
release_date,
revenue,
budget,
homepage,
runtime,
rating,
status,
country,
genres,
director,
spoken_languages
) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
"""

for item in data:
try:
cursor.execute(insert_query, (
item['title'],
item['original_title'],
item['original_language'],
item.get('overview', None),
item.get('release_date', None),
item.get('revenue', None),
item.get('budget', None),
item.get('homepage', None),
item.get('runtime', None),
item.get('rating', None),
item['status'],
item.get('country', None),
item.get('genres', None),
item.get('director', None),
item.get('spoken_languages', None)
))
except pymysql.err.OperationalError as e:
print(f"Error inserting {item['title']}: {e}")

connection.commit()

finally:
connection.close()