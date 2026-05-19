# Movies Database SQL Queries 🎬

This repository contains a collection of SQL queries for exploring and analyzing a sample "moviesdb" database.  
The queries cover basic selection, filtering, aggregation, and analytical operations.

---

## 📂 Table of Contents
1. [Basic Selection](#basic-selection)
2. [Filtering Data](#filtering-data)
3. [Aggregations](#aggregations)
4. [Ordering & Limiting](#ordering--limiting)
5. [Grouping & Aggregates](#grouping--aggregates)
6. [Joins & Calculations](#joins--calculations)
7. [Advanced Queries](#advanced-queries)

__________________________________________________________________________________________________________________


USE moviesdb;

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
WHERE industry = 'Hollywood';

-- Print all movies from Bollywood.
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
	industry,
    COUNT(*) movie_cnt
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
WHERE imdb_rating >= 6
	AND imdb_rating <= 8;
    
-- OR --

SELECT
	*
FROM movies
WHERE imdb_rating BETWEEN 6 AND 8;

-- Select all movies whose release year can be 2018 or 2019 or 2022.
SELECT
	*
FROM movies
WHERE release_year IN (2018,2019,2022);

-- OR --

SELECT
	*
FROM movies
WHERE release_year = 2018 OR
	release_year = 2019 OR
    release_year = 2022;
    
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

-- How many total movies do we have in our movies table?
SELECT
	COUNT(*)
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
	ROUND(AVG(imdb_rating),1) AS avg_rating
FROM movies
WHERE studio = 'Marvel Studios';

-- Print min, max, avg rating of Marvel Studios movies.
SELECT
	MAX(imdb_rating) AS max_rating,
    MIN(imdb_rating) AS min_rating,
	ROUND(AVG(imdb_rating),1) AS avg_rating
FROM movies
WHERE studio = 'Marvel Studios';

-- Print count of movies by industry.
SELECT
	industry,
    COUNT(*) AS cnt
FROM movies
GROUP BY industry;

-- Same thing but add average rating.
SELECT
	industry,
    COUNT(*) AS cnt,
    ROUND(AVG(imdb_rating),1) AS avg_rat
FROM movies
GROUP BY industry;

-- Count number of movies released by a given production studio.
SELECT
	studio,
    COUNT(*) AS cnt
FROM movies
GROUP BY studio
ORDER BY cnt DESC;

-- AND --

SELECT
	studio,
    COUNT(*) AS cnt
FROM movies
WHERE studio <>''
GROUP BY studio;

-- What is the average rating of movies per studio and also order them by average rating in descending format?.
SELECT
	studio,
    COUNT(*) AS cnt,
    ROUND(AVG(imdb_rating),2) AS avg_rat
FROM movies
WHERE studio !=''
GROUP BY studio
ORDER BY avg_rat DESC;

-- Print all the years where more than 2 movies were released.
SELECT
	release_year,
    COUNT(*) AS movie_cnt
FROM movies
GROUP BY release_year
HAVING movie_cnt > 2;

-- OR --

WITH x AS (
	SELECT
		release_year,
        COUNT(*) AS cnt
	FROM movies
    GROUP BY release_year)
SELECT * FROM x
WHERE cnt > 2;

-- Print actor name, their birth_year and age.
SELECT
	*,
    YEAR(CURDATE()) - birth_year AS age
FROM actors;

-- Print profit for every movie.
SELECT
	*,
    (revenue - budget) AS profit
FROM financials;

-- Print revenue of all movies in INR currency.
SELECT
	*,
    IF(currency = 'USD', revenue*95, revenue) AS rev_inr
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
    END rev_inr
FROM financials;

__________________________________________________________________________________________________________________________
# MySQL Joins

-- Print all movies along with their title, budget, revenue, currency and unit. [INNER JOIN].

SELECT
    f.movie_id, m.title,
    budget, revenue, unit, currency
FROM financials f
INNER JOIN movies m
	ON f.movie_id = m.movie_id;
    
-- Perform LEFT JOIN on above discussed scenario.
SELECT
    f.movie_id, m.title,
    budget, revenue, unit, currency
FROM financials f
LEFT JOIN movies m
	ON f.movie_id = m.movie_id;
    
-- Perform RIGHT JOIN on above discussed scenario.
SELECT
    m.movie_id, m.title,
    budget, revenue, unit, currency
FROM financials f
RIGHT JOIN movies m
	ON f.movie_id = m.movie_id;


-- Perform FULL JOIN using 'Union' on above two tables [movies, financials].
SELECT
    f.movie_id, m.title,
    budget, revenue, unit, currency
FROM financials f
LEFT JOIN movies m
	USING (movie_id)
UNION
SELECT
    m.movie_id, m.title,
    budget, revenue, unit, currency
FROM financials f
RIGHT JOIN movies m
	ON f.movie_id = m.movie_id;
    
-- EXCLUSIVE JOIN
SELECT
    f.movie_id, m.title,
    budget, revenue, unit, currency
FROM financials f
LEFT JOIN movies m
	ON f.movie_id = m.movie_id
WHERE m.movie_id IS NULL
UNION
SELECT
    m.movie_id, m.title,
    budget, revenue, unit, currency
FROM financials f
RIGHT JOIN movies m
	ON f.movie_id = m.movie_id
WHERE f.movie_id IS NULL;


-- Interchanging the position of Left and Right Tables.
-- Replacing 'ON' with 'USING' while joining conditions.
SELECT
    m.movie_id, m.title,
    budget, revenue, unit, currency
FROM financials f
RIGHT JOIN movies m
	USING (movie_id)
UNION
SELECT
    f.movie_id, m.title,
    budget, revenue, unit, currency
FROM financials f
LEFT JOIN movies m
	ON f.movie_id = m.movie_id;

-- --------------------------------------------------------------------------------------

# CROSS JOIN

-- Print a list of final menu items along with their price for a restaurant.
USE food_db;

SELECT
	*
FROM items
CROSS JOIN variants;

SELECT
	*,
    CONCAT(variant_name, ' - ', name) AS full_name,
    CONCAT(price+variant_price) AS full_price
FROM items
CROSS JOIN variants;
------------------------------------------------------------------------------------------
USE moviesdb;

-- Find profit for all movies.
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
WHERE m.industry = 'Bollywood';

-- Find profit of all Bollywood movies and sort them by profit amount (Make sure the profit be in millions for better comparisons).

SELECT
	f.*,
    CASE
		WHEN unit = 'Billions' THEN ROUND((revenue-budget)*1000,2)
        WHEN unit = 'Thousands' THEN ROUND((revenue-budget)/1000,2)
        ELSE ROUND((revenue-budget),2)
    END profit_mln
FROM financials f
INNER JOIN movies m
	ON f.movie_id = m.movie_id
WHERE industry = 'Bollywood'
ORDER BY profit_mln DESC;

-- Show comma separated actor names for each movie

SELECT
	m.title,
    GROUP_CONCAT(a.name SEPARATOR ' | ') AS actor_name
FROM actors a
INNER JOIN movie_actor ma
	ON a.actor_id = ma.actor_id
INNER JOIN movies m
	ON m.movie_id = ma.movie_id
GROUP BY m.title;

-- Print actor name and all the movies they are part of.

SELECT
	a.name,
    GROUP_CONCAT(m.title SEPARATOR ' | ') AS actor_name
FROM actors a
INNER JOIN movie_actor ma
	ON a.actor_id = ma.actor_id
INNER JOIN movies m
	ON m.movie_id = ma.movie_id
GROUP BY a.name;

-- Print actor name and how many movies they acted in.

SELECT
	a.name,
    GROUP_CONCAT(m.title SEPARATOR ' | ') AS actor_name,
    COUNT(*) AS movie_count
FROM actors a
INNER JOIN movie_actor ma
	ON a.actor_id = ma.actor_id
INNER JOIN movies m
	ON m.movie_id = ma.movie_id
GROUP BY a.name
ORDER BY movie_count DESC;
