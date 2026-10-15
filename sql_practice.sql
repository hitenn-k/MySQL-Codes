-- Simply print all the movies.
SELECT
	*
FROM movies;


-- Get movie title and industry for all the movies.
SELECT
	title, industry
FROM movies;


-- Print all movies from Hollywood.
SELECT
	*
FROM movies
WHERE industry = 'Bollywood';


-- Get all the unique industries in the movies database.
SELECT
	DISTINCT industry
FROM movies;


-- Select all movies that starts with THOR.
SELECT
	*
FROM movies
WHERE title LIKE 'Thor%';


-- Select all movies that have 'America' word in it. That means to select all captain America movies.
SELECT
	*
FROM movies
WHERE title LIKE '%America%';


-- How many Hollywood movies are present in the database?
SELECT
	COUNT(*) AS movie_count
FROM movies
WHERE industry = 'Hollywood';


SELECT
	industry, COUNT(*) AS movie_count
FROM movies
WHERE industry = 'Hollywood'
GROUP BY industry;


-- Print all movies where we don't know the value of the studio.
SELECT
	*
FROM movies
WHERE studio = '';


-- Which movies had greater than 9 imdb rating?
SELECT
	*
FROM movies
WHERE imdb_rating > 9;


-- Movies with rating between 6 and 8.

SELECT
	*
FROM movies
WHERE imdb_rating BETWEEN 6 AND 8;


-- Select all movies whose release year can be 2018 or 2019 or 2022.
SELECT
	*
FROM movies
WHERE release_year IN (2018,2019,2022);


-- All movies where imdb rating is not available (imagine the movie is just released).
SELECT
	*
FROM movies
WHERE imdb_rating IS NULL;


-- All movies where imdb rating is available.
SELECT
	*
FROM movies
WHERE imdb_rating IS NOT NULL;


-- Print all bollywood movies ordered by their imdb rating.
SELECT
	*
FROM movies
WHERE industry = 'Bollywood'
ORDER BY imdb_rating DESC;


-- Print first 5 bollywood movies with highest rating.
SELECT
	*
FROM movies
WHERE industry = 'Bollywood'
ORDER BY imdb_rating DESC
LIMIT 5;


-- Select movies starting from second highest rating movie till next 5 movies for Bollywood.
SELECT
	*
FROM movies
WHERE industry = 'Bollywood'
ORDER BY imdb_rating DESC
LIMIT 5 OFFSET 1;


-- How many total movies do we have in our movies table?
SELECT
	COUNT(*) AS total_movies
FROM movies;


-- Select highest imdb rating for bollywood movies.
SELECT
	MAX(imdb_rating) AS max_rating
FROM movies
WHERE industry = 'Bollywood';


-- Select lowest imdb rating for bollywood movies.
SELECT
	MIN(imdb_rating) AS min_rating
FROM movies
WHERE industry = 'Bollywood';


-- Print average rating of Marvel Studios movies.
SELECT
	ROUND(AVG(imdb_rating),2) AS avg_rating
FROM movies
WHERE studio = 'Marvel Studios';


-- Print min, max, avg rating of Marvel Studios movies.
SELECT
	MAX(imdb_rating) AS max_rating,
    MIN(imdb_rating) AS min_rating,
    ROUND(AVG(imdb_rating),2) AS avg_rating
FROM movies
WHERE studio = 'Marvel Studios';


-- Print count of movies by industry.
SELECT
	industry, COUNT(*) AS movie_cnt
FROM movies
GROUP BY industry;


-- Same thing but add average rating.
SELECT
	industry, COUNT(*) AS movie_cnt,
    ROUND(AVG(imdb_rating),2) AS avg_rating
FROM movies
GROUP BY industry;


-- Count number of movies released by a given production studio.
SELECT
	studio, COUNT(*) AS movie_count
FROM movies
GROUP BY studio
ORDER BY movie_count DESC;


-- What is the average rating of movies per studio and also order them by average rating in descending format?.
SELECT
	studio, COUNT(*) AS movie_count,
    ROUND(AVG(imdb_rating),2) AS avg_rating
FROM movies
GROUP BY studio
ORDER BY avg_rating DESC;


-- Print all the years where more than 2 movies were released.
SELECT
	release_year, COUNT(*) AS movie_cnt
FROM movies
GROUP BY release_year
HAVING movie_cnt > 2;


-- Print actor name, their birth_year and age.
SELECT
	name, birth_year,
    YEAR(curdate()) - birth_year AS age
FROM actors;

SELECT
	name, birth_year,
    YEAR('2020/12/26') - birth_year AS age
FROM actors;


-- Print profit for every movie.
SELECT
	*,
    (revenue - budget) AS profit
FROM financials;


-- Print revenue of all movies in INR currency.
SELECT
	*,
    IF(currency = 'USD', revenue*100, revenue) AS rev_inr
FROM financials;


-- Get all the unique units from financial table.
SELECT
	DISTINCT unit
FROM financials;


-- Print revenue in millions.
SELECT
	*,
    CASE
		WHEN unit = 'Billions' THEN revenue*1000
        WHEN unit = 'Thousands' THEN revenue/1000
        ELSE revenue
    END rev_mln
FROM financials;

-- -----------------------------------------------------------------------------------------

-- Print all movies along with their title, budget, revenue, currency and unit. [INNER JOIN].
SELECT
	m.movie_id, m.title,
    f.budget, f.revenue, f.unit, f.currency
FROM financials f
INNER JOIN movies m
	ON f.movie_id = m.movie_id;
    

-- Perform LEFT JOIN on above discussed scenario.
SELECT
	f.movie_id, m.title,
    f.budget, f.revenue, f.unit, f.currency
FROM financials f
LEFT JOIN movies m
	ON f.movie_id = m.movie_id;
    

-- Perform RIGHT JOIN on above discussed scenario.
SELECT
	m.movie_id, m.title,
    f.budget, f.revenue, f.unit, f.currency
FROM financials f
RIGHT JOIN movies m
	ON f.movie_id = m.movie_id;


-- Perform FULL JOIN using 'Union' on above two tables [movies, financials].
SELECT
	f.movie_id, m.title,
    f.budget, f.revenue, f.unit, f.currency
FROM financials f
LEFT JOIN movies m
	ON f.movie_id = m.movie_id
UNION
SELECT
	m.movie_id, m.title,
    f.budget, f.revenue, f.unit, f.currency
FROM financials f
RIGHT JOIN movies m
	ON f.movie_id = m.movie_id;


-- Interchanging the position of Left and Right Tables.
SELECT
	m.movie_id, m.title,
    f.budget, f.revenue, f.unit, f.currency
FROM financials f
RIGHT JOIN movies m
	ON f.movie_id = m.movie_id
UNION
SELECT
	f.movie_id, m.title,
    f.budget, f.revenue, f.unit, f.currency
FROM financials f
LEFT JOIN movies m
	ON f.movie_id = m.movie_id;


-- Replacing 'ON' with 'USING' while joining conditions.
SELECT
	m.movie_id, m.title,
    f.budget, f.revenue, f.unit, f.currency
FROM financials f
RIGHT JOIN movies m
	USING (movie_id)
UNION
SELECT
	f.movie_id, m.title,
    f.budget, f.revenue, f.unit, f.currency
FROM financials f
LEFT JOIN movies m
	USING (movie_id);


-- Print a list of final menu items along with their price for a restaurant.
USE food_db;

SELECT
	*,
    CONCAT(variant_name, ' - ', name) AS full_name,
    (price + variant_price) AS full_price
FROM items
CROSS JOIN variants;


-- Find profit for all movies.
USE moviesdb;

SELECT
	*,
    (revenue - budget) AS profit
FROM financials;


-- Find profit for all movies in Bollywood.
SELECT
	f.*,
    (revenue - budget) AS profit
FROM financials f
INNER JOIN movies m
	ON f.movie_id = m.movie_id
WHERE industry = 'Bollywood';


-- Find profit of all Bollywood movies and sort them by profit amount (Make sure the profit be in millions for better comparisons).
SELECT
	f.*,
    CASE
		WHEN unit = 'Billions' THEN (revenue - budget)*1000
        WHEN unit = 'Thousands' THEN (revenue - budget)/1000
        ELSE (revenue - budget)
    END profit_mln
FROM financials f
INNER JOIN movies m
	ON f.movie_id = m.movie_id
WHERE industry = 'Bollywood';


-- Show comma separated actor names for each movie.
SELECT
	m.title, 
    GROUP_CONCAT(a.name SEPARATOR ' | ') AS actor_name
FROM actors a
INNER JOIN movie_actor ma
	ON a.actor_id = ma.actor_id
INNER JOIN movies m
	ON ma.movie_id = m.movie_id
GROUP BY m.title;


-- Print actor name and all the movies they are part of.
SELECT
	a.name, 
    GROUP_CONCAT(m.title SEPARATOR ' | ') AS actor_name
FROM actors a
INNER JOIN movie_actor ma
	ON a.actor_id = ma.actor_id
INNER JOIN movies m
	ON ma.movie_id = m.movie_id
GROUP BY a.name;


-- Print actor name and how many movies they acted in.
SELECT
	a.name, 
    GROUP_CONCAT(m.title SEPARATOR ' | ') AS actor_name,
    COUNT(*) AS movie_cnt
FROM actors a
INNER JOIN movie_actor ma
	ON a.actor_id = ma.actor_id
INNER JOIN movies m
	ON ma.movie_id = m.movie_id
GROUP BY a.name
ORDER BY movie_cnt DESC;

-- -----------------------------------------------------------------------------------------

-- Select a movie with highest imdb_rating. (Subqueries)
SELECT MAX(imdb_rating) FROM MOVIES;

SELECT
	*
FROM movies
WHERE imdb_rating = (SELECT MAX(imdb_rating) FROM MOVIES);


-- Select a movie with highest and lowest imdb_rating. (Subqueries)
SELECT MAX(imdb_rating) FROM MOVIES;
SELECT MIN(imdb_rating) FROM MOVIES;

SELECT
	*
FROM movies
WHERE imdb_rating IN (
						(SELECT MAX(imdb_rating) FROM MOVIES),
						(SELECT MIN(imdb_rating) FROM MOVIES));
                        

-- Select all the actors whose age is greater than 70 and less than 85.
SELECT
	*
FROM (SELECT
		*,
    YEAR(CURDATE()) - birth_year AS age
	FROM actors) actor_age
WHERE age > 70 AND age < 85;

	-- OR -- 

WITH
	x AS (
		SELECT
				*,
		YEAR(CURDATE()) - birth_year AS age
		FROM actors)
SELECT * FROM x
WHERE age > 70 AND age < 85;


-- select actors who acted in any of these movies (101,110, 121).
SELECT
	a.name
FROM actors a
INNER JOIN movie_actor ma
	ON a.actor_id = ma.actor_id
WHERE ma.movie_id IN (101,110,121);

	-- OR -- 

SELECT
	name
FROM actors
WHERE actor_id IN (SELECT actor_id FROM movie_actor WHERE movie_id IN (101,110,121));


-- select all movies whose rating is greater than *any* of the marvel movies rating.
SELECT
	*
FROM movies
WHERE studio = 'Marvel Studios';

SELECT
	*
FROM movies
WHERE imdb_rating = ANY (
						SELECT
							imdb_rating
						FROM movies
						WHERE studio = 'Marvel Studios');
                        
SELECT
	*
FROM movies
WHERE imdb_rating > ANY (
						SELECT
							imdb_rating
						FROM movies
						WHERE studio = 'Marvel Studios');
                        
SELECT
	*
FROM movies
WHERE imdb_rating > ALL (
						SELECT
							imdb_rating
						FROM movies
						WHERE studio = 'Marvel Studios');
                        
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
	a.actor_id, a.name,
    COUNT(*) AS movie_count
FROM actors a
INNER JOIN movie_actor ma
	ON a.actor_id = ma.actor_id
GROUP BY a.actor_id, a.name
ORDER BY movie_count DESC;


SELECT
	actor_id, name,
    (SELECT COUNT(*) FROM movie_actor WHERE actor_id = actors.actor_id) AS movie_count
FROM actors
GROUP BY actor_id, name
ORDER BY movie_count DESC;

