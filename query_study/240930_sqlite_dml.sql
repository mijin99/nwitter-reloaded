--DML
INSERT INTO movies
	(title, rating,released, overview)
VALUES
	('The Lord of The Rings' , 0.5, 1, 'Rings and hobbits'),
  ('Dune: Part One', 10,1,'Sand');



UPDATE movies SET rating = rating +10 WHERE title = 'The Lord of The Rings' ;


SELECT REPLACE(title, ': Part One','I') AS title ,
			 rating * 2 AS double_rating,
       UPPER(overview) a
FROM movies;
