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


-- ----------------------------------------------------------    

-- CROSS JOIN
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

-- ----------------------------------------------------------

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