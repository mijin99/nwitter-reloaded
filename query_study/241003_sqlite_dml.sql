SELECT --3
  *
FROM --1
  movies
  --WHERE --2 
LIMIT
  30 --5
OFFSET
  5 --4
;

--1. 각 년도에 개봉된 영화 수 알아내기
SELECT
  release_date,
  COUNT(*) ct
FROM
  movies
WHERE
  release_date IS NOT NULL
GROUP BY
  release_date
ORDER BY
  ct DESC;

--2. 평균 영화 상영 시간이 가장 높은 상위 10년 
SELECT
  release_date,
  ROUND(avg(runtime), 3) ct
FROM
  movies
WHERE
  release_date IS NOT NULL
  and runtime IS NOT NULL
GROUP BY
  release_date
ORDER BY
  ct DESC
LIMIT
  10;

--3. 21세기에 개봉한 영화의 평균 평점 (그룹 없어도됨)
SELECT
  ROUND(avg(rating), 3) ct
FROM
  movies
WHERE
  release_date IS NOT NULL
  and release_date BETWEEN 2001 AND 2100;

--4. 평균 영화 상영 시간이 가장 긴 감독
SELECT
  director,
  avg(runtime) / 60 AS avg_runtime,
  COUNT(*) AS total_movies
FROM
  movies
WHERE
  director IS NOT NULL
  and runtime is not null
GROUP BY
  director
HAVING
  total_movies >= 2
order by
  avg_runtime DESC
limit
  1;

--5. 가장 많은 영화를 작업한 다작 감독 상위 5명
SELECT
  director,
  COUNT(*) as total_count
FROM
  movies
WHERE
  director is not null
  and runtime is not null
  and runtime > 45
GROUP BY
  director
ORDER BY
  total_count DESC
limit
  5;

--6.각 감독의 최고 평점과 최저 평점
SELECT
  director,
  MAX(rating),
  MIN(rating)
FROM
  movies
WHERE
  director is not null
  and rating is not null
GROUP BY
  director
HAVING
  COUNT(*) > 5;

--7. 돈을 가장 많이 벌어들인 감독 (수익-예산)
SELECT
  director,
  sum(revenue) - sum(budget) as income
FROM
  movies
WHERE
  director is not null
  and revenue is not null
  and budget is not null
GROUP BY
  director
order by
  income desc
limit
  1;

--8. 2시간 이상인 영화들의 평균 평점
SELECT
  ROUND(AVG(rating), 2)
FROM
  movies
WHERE
  runtime / 60 >= 2;

--9. 가장 많은 영화가 개봉되 년도
SELECT
  release_date,
  COUNT(*)
FROM
  movies
WHERE
  release_date IS NOT NULL
GROUP BY
  release_date
ORDER BY
  COUNT(*) DESC;

--10. 각 10년동안의 평균 영화 상영 시간
SELECT
  (release_date / 10) * 10 AS DECADE,
  COUNT(*) as total_movies
FROM
  movies
WHERE
  release_date IS NOT NULL
GROUP BY
  DECADE
ORDER BY
  total_movies DESC;

--11. 영화의 최고 평점과 최저 평점의 차이가 큰 상위 5개년
SELECT
  release_date,
  MAX(rating) - MIN(rating) as gap
FROM
  movies
WHERE
  rating is not null
  and release_date is not null
  and rating between 2 and 9.5
GROUP BY
  release_date
order by
  gap desc
limit
  5;

--12. 2시간 미만의 영화를 만들어본 적 없는 감독 나열
SELECT
  director,
  MIN(runtime) as rtime
FROM
  movies
where
  director is not null
GROUP BY
  director
having
  rtime >= 120;

--★13. 평점이 8.0 이상인 영화의 비율
SELECT
  COUNT(
    CASE
      WHEN rating > 8 then 1
    END
  ) * 100.0 / COUNT(*) AS PERCENTAGE
FROM
  movies;

--14. 평점이 7.0보다 높은 영화가 차지하는 비율이 가장 높은 감독 찾기
SELECT
  director,
  COUNT(
    CASE
      WHEN rating > 7.0 then 1.0
    END
  ) * 100.0 / COUNT(*) AS PERCENTAGE
FROM
  movies
GROUP BY
  director
HAVING
  COUNT(*) >= 5
order by
  PERCENTAGE desc;

--★15. 길이별로 영화를 분류 그룹화
SELECT
  CASE
    WHEN runtime < 90 THEN 'Short'
    WHEN runtime between 90 and 120  then 'Normal'
    WHEN runtime > 120 THEN 'Long'
  END AS runtime_category,
  COUNT(*) as total_movies
FROM
  movies
GROUP BY
  runtime_category
having
  runtime_category is not null
ORDER BY
  total_movies DESC;

--16. flop 여부에 따라 영화를 분류 및 그룹화 (수익<비용)
SELECT
  count(*) as total_movies,
  CASE
    WHEN revenue < budget then 'flop'
    ELSE 'Sucess'
  END AS flopyn
FROM
  movies
WHERE
  budget is not null
  and revenue is not null
GROUP BY
  flopyn;

--뷰생성
create view
  v_flop_or_not as
SELECT
  count(*) as total_movies,
  CASE
    WHEN revenue < budget then 'flop'
    ELSE 'Sucess'
  END AS flopyn
FROM
  movies
WHERE
  budget is not null
  and revenue is not null
GROUP BY
  flopyn;

select
  *
from
  v_flop_or_not;

drop
  view v_flop_or_not;


  SELECT --3
  *
FROM --1
  movies
  --WHERE --2 
  --ORDER BY  --4
LIMIT
  30 --6
OFFSET
  5 --5
;

SELECT --4
  director,
  SUM(revenue) as total_revenue,
  COUNT(*)
FROM
  movies --1
WHERE
  director IS NOT NULL --2
  AND revenue IS NOT NULL
GROUP BY
  director --3
ORDER BY
  total_revenue DESC;

 --5
--연도별 평점
SELECT --5
  release_date,
  ROUND(AVG(rating), 2) AS avg_rating
FROM
  movies --1
WHERE
  rating is not null --2
  and release_date is not null
group by
  release_date --3
HAVING
  avg_rating > 6 --4
order by
  avg_rating DESC;

 --6
/*
The reason HAVING can reference columns or expressions from the SELECT clause is that the SQL engine performs a pass to identify all columns and expressions used in the query before actual execution. This allows HAVING to "see" what will be in the SELECT, even though SELECT hasn't been fully processed yet.
It's worth noting that while HAVING can reference SELECT columns, it's generally considered good practice to only use HAVING with aggregated values or columns that appear in the GROUP BY clause, as this aligns better with its intended purpose of filtering groups.
 */
--챌린지 1 감독의 평균 rating 
SELECT
  director,
  ROUND(avg(rating), 2) as avg_rating
FROM
  movies
WHERE
  director IS NOT NULL
  AND rating is not null
GROUP BY
  director
HAVING
  COUNT(*) >= 5 -- having 절 집계함수는 select에 없어도 됨...
ORDER BY
  avg_rating DESC;

--각 장르에 몇 편의 영화가 있는지
SELECT
  genres,
  COUNT(*) AS count_mv
FROM
  movies
WHERE
  genres IS NOT NULL
GROUP BY
  genres
HAVING
  count_mv > 0
ORDER BY
  count_mv DESC;

--평점이 6보다 높은 영화는 몇편인지
SELECT
  rating,
  COUNT(*) AS ct
FROM
  movies
WHERE
  rating IS NOT NULL
GROUP BY
  rating
having
  rating >= 6;

SELECT
  rating,
  COUNT(*) ct
FROM
  movies
WHERE
  rating IS NOT NULL
  AND rating >= 6
GROUP BY
  rating;

--1. 각 년도에 개봉된 영화 수 알아내기
SELECT
  release_date,
  COUNT(*) ct
FROM
  movies
WHERE
  release_date IS NOT NULL
GROUP BY
  release_date
ORDER BY
  ct DESC;