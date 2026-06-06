-- CREATING NEW DATABASE/ TABLE.

CREATE DATABASE IF NOT EXISTS Sample1;
DROP DATABASE Sample1;

CREATE DATABASE IF NOT EXISTS sample1;

USE d1;

CREATE TABLE IF NOT EXISTS t1
	(id INT PRIMARY KEY NOT NULL,
    name VARCHAR(45),
    AGE TINYINT);

DROP TABLE IF EXISTS t1;

CREATE TABLE IF NOT EXISTS t1
	(id INT PRIMARY KEY NOT NULL,
    name VARCHAR(45),
    age TINYINT);
    
ALTER TABLE t1
RENAME COLUMN name TO cust_name;
    
SELECT * FROM t1;

INSERT INTO	t1
	(id, cust_name, age)
VALUES
	(101, 'Kalyan', 56),
    (102, 'John Dyre', 63),
    (103, 'Betty', 28);
    
UPDATE t1
	SET
		cust_name = 'Kalyani',
        age = 31
WHERE id = 101;

DELETE FROM t1
WHERE id = 102 AND cust_name = 'John Dyre';