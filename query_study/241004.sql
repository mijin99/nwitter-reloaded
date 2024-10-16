 --subquery, CTE
--★1. 평점이나 수익이 평균보다 높은 영화의 리스트
WITH
  avg_revenue_cte AS (
    select
      avg(revenue) as avg_revenue
    from
      movies
  ),
  avg_rating_cte AS (
    select
      avg(rating) as avg_rating
    from
      movies
  )
SELECT
  title,
  rating,
  revenue,
  round(
    (
      select
        avg_revenue
      from
        avg_revenue_cte
    ),
    0
  ) as avg_revenue,
  round(
    (
      select
        avg_rating
      from
        avg_rating_cte
    ),
    0
  ) as avg_rating
FROM
  movies
WHERE
  revenue > (
    select
      *
    from
      avg_revenue_cte
  )
  AND rating > (
    select
      *
    from
      avg_rating_cte
  );

--correlated subquery
--★같은 해에 개봉된 영화의 평균 평점보다 높은 평점을 가진 영화
SELECT
  m1.title,
  m1.director,
  m1.rating,
  m1.release_date
FROM
  movies m1
WHERE
	m1.release_date >2022  --이게 더 적은 실행비용이 들어서 먼저 실행됨
AND
  rating > (
    SELECT
      AVG(m2.rating)
    FROM
      movies m2
    WHERE
      m2.release_date = m1.release_date
  )
  ;
  
--★cte로 변경
WITH movie_avg_per_year AS (
SELECT
   AVG(m2.rating)
FROM
 	 movies m2
WHERE
  			--main 별칭사용 sqlite에서만 가능, correlated subquery
 	 m2.release_date = m1.release_date
 )
SELECT
  m1.title,
  m1.director,
  m1.rating,
  m1.release_date,
  ( SELECT *  FROM  movie_avg_per_year ) as year_average
FROM
  movies m1
WHERE
	m1.release_date >2022  --이게 더 적은 실행비용이 들어서 먼저 실행됨
AND
  m1.rating > ( SELECT *  FROM  movie_avg_per_year )
  ;
  
  
  --문제1. 감독의 career revenue가 평균보다 높은 감독 찾기
  WITH avg_revenue_cte AS (
    SELECT 
    		sum(revenue) as sum_revenue
    FROM movies  
  	WHERE director is not null 
 	 	AND revenue is not null
    GROUP BY director
    ), avg_director_career_revenue as (
      select 
      	avg(sum_revenue) 
      from avg_revenue_cte
      
      )
  SELECT 
  	director ,
    sum(revenue) as total_revenue,
    (select * from avg_director_career_revenue) as avg_revenue
  FROM movies
  WHERE director is not null 
  AND revenue is not null
  GROUP BY director 
  having total_revenue > avg_revenue 
  ;
  
  

  
WITH
  director_stats AS (
    SELECT
      director,
      COUNT(*) as total_movies,
      AVG(rating) as avg_rating,
      MAX(rating) as best_rating,
      MIN(rating) as worst_rating,
      MAX(budget) AS highest_budget,
      MIN(budget) as lowest_budget
    FROM
      movies
    WHERE
      director is not null
      and budget is not null
      and rating is not null
    GROUP BY
      director
  )
SELECT
    director,
    total_movies,
    avg_rating,
    best_rating,
    worst_rating,
    highest_budget,
    lowest_budget,
  (
    SELECT
      title
    FROM
      movies
    WHERE
      rating is not null
      and budget is not null
      and director = ds.director
    order by
      rating DESC
    LIMIT
      1
  ) AS best_rated_movie,
  (
    SELECT
      title
    FROM
      movies
    WHERE
      rating is not null
      and budget is not null
      and director = ds.director
    order by
      rating ASC
    LIMIT
      1
  ) AS worst_rated_movie,
  (
    SELECT
      title
    FROM
      movies
    WHERE
      rating is not null
      and budget is not null
      and director = ds.director
    order by
      rating DESC
    LIMIT
      1
  ) AS best_rated_movie,
  (
    SELECT
      title
    FROM
      movies
    WHERE
      rating is not null
      and budget is not null
      and director = ds.director
    order by
      budget DESC
    LIMIT
      1
  ) AS most_expensive_movie,
  (
    SELECT
      title
    FROM
      movies
    WHERE
      rating is not null
      and budget is not null
      and director = ds.director
    order by
      budget ASC
    LIMIT
      1
  ) AS leaset_expensive_movie
FROM
  director_stats ds
  ;
  
  --갯수 제약 안걸어도 짱빠름!
 CREATE INDEX idx_director ON movies (director);

  
  
  
  
  
  
  
  
  
  
  
  
  
