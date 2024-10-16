insert into movies values
('THe Godfather', 1980,'The best movie in the world', 10,'F.F.C',0),
(' 1930', 1980,'The best movie in the world', 10,'F.F.C',20);
                         
              
DELETE FROM MOVIES;

CREATE TABLE movies (
 movie_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
 title TEXT UNIQUE NOT NULL, 
 released INTEGER NOT NULL CHECK (released >0 ),
 overview TEXT NOT NULL CHECK(LENGTH(overview) <=100), 
 rating REAL NOT NULL CHECK (rating BETWEEN 0 AND 10) ,--소수
 director TEXT,
 for_kids INTEGER NOT NULL DEFAULT 0 CHECK (for_kids BETWEEN 0 AND 1)
) STRICT ; --엄격한 컬럼 검사

drop table movies;