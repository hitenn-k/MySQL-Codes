-- Select a movie with highest imdb_rating. (Subqueries)

SELECT
	*
FROM movies
ORDER BY imdb_rating DESC
LIMIT 1;

-- OR --

SELECT
	*
FROM movies
WHERE imdb_rating = (SELECT MAX(imdb_rating) FROM movies);


-- Select a movie with highest and lowest imdb_rating.(Subqueries)

SELECT
	*
FROM movies
WHERE imdb_rating IN (
			(SELECT MAX(imdb_rating) FROM movies),
            (SELECT MIN(imdb_rating) FROM movies));


-- Select all the actors whose age is greater than 70 and less than 85.

WITH x AS (
		SELECT
		*,
		YEAR(CURDATE()) - birth_year AS age
		FROM actors)
SELECT * FROM x
WHERE age > 70 AND age < 85;

-- OR --

SELECT
	*
FROM (
	SELECT
	*,
	YEAR(CURDATE()) - birth_year AS age
	FROM actors) AS x
WHERE age > 70 AND age < 85;


-- select actors who acted in any of these movies (101,110, 121).

SELECT
	ma.movie_id,
    a.actor_id, a.name, a.birth_year
FROM movie_actor ma
INNER JOIN actors a
	ON a.actor_id = ma.actor_id
WHERE ma.movie_id IN (101,110,121);

-- OR --

SELECT
	*
FROM actors
WHERE actor_id IN (
					SELECT actor_id FROM movie_actor
                    WHERE movie_id IN (101,110,121));

-- OR --

SELECT
	*
FROM actors
WHERE actor_id = ANY (
					SELECT actor_id FROM movie_actor
                    WHERE movie_id IN (101,110,121));
                    

-- Select all movies whose rating is greater than *all* of the marvel movies rating.

SELECT
	*
FROM movies
WHERE imdb_rating > ALL (
			SELECT
				imdb_rating
			FROM movies
			WHERE studio = 'Marvel Studios');
            

-- Select all movies whose rating is greater than *any* of the marvel movies rating.

SELECT
	*
FROM movies
WHERE imdb_rating = ANY (
			SELECT
				imdb_rating
			FROM movies
			WHERE studio = 'Marvel Studios');

-- OR

SELECT
	*
FROM movies
WHERE imdb_rating > (
			SELECT
				MAX(imdb_rating)
			FROM movies
			WHERE studio = 'Marvel Studios');
            

-- Get the actor id, actor name and the total number of movies they acted in.

SELECT
	a.*,
    COUNT(*) AS cnt
FROM actors a
INNER JOIN movie_actor ma
	ON a.actor_id = ma.actor_id
GROUP BY a.actor_id
ORDER BY cnt DESC;

-- OR

SELECT
	actor_id,
    name,
    (SELECT COUNT(*) FROM movie_actor
    WHERE actor_id = actors.actor_id) AS movies_count
FROM actors
ORDER BY movies_count DESC;


-- Movies that produced 500% profit and their rating was less than average rating for all movies.

WITH x AS
		(SELECT
			*,
			ROUND((revenue-budget)*100/budget,2) AS pct_profit
		FROM financials),
	y AS
		(SELECT
			*
		FROM movies
        WHERE imdb_rating < (
							SELECT AVG(imdb_rating) FROM movies))
SELECT
	x.movie_id, x.pct_profit,
    y.title, y.imdb_rating
FROM x
INNER JOIN y
ON x.movie_id = y.movie_id
WHERE x.pct_profit > 500;