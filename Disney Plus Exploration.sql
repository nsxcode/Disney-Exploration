/*
Dataset used: Disney+ Movies and TV Shows by SHIVAM BANSAL.

This was done using PostgreSQL and DataGrip IDE.

Skills used: Converting Data Types, Aggregate Functions, Where clauses, Update syntax, Alter table
*/

/* In the duration column remove the word 'min' */
UPDATE natalie.public.disney_plus SET duration = REPLACE(duration, 'min', '');

/*Create new column duration_seasons*/
ALTER TABLE natalie.public.disney_plus
ADD duration_seasons VARCHAR;

/*Copy duration values that are "seasons" to the duration_seasons column */
UPDATE natalie.public.disney_plus
SET duration_seasons = REPLACE(duration, '%Season%', '')
WHERE duration LIKE '%Season%'
OR duration LIKE '%Seasons%';

/*In the duration column change the value to 0 if the duration is in seasons */
UPDATE natalie.public.disney_plus
SET duration = '0'
WHERE duration LIKE '%Season%'
OR duration LIKE '%Seasons%';

/* Change all the NULL values in duration_seasons to 0 */
UPDATE natalie.public.disney_plus
SET duration_seasons = '0'
WHERE duration_seasons is NULL;

/*Change duration column name to duration_mins */
ALTER TABLE natalie.public.disney_plus
RENAME COLUMN duration TO duration_mins;

/*Change duration_seasons to just be the number of seasons*/
UPDATE natalie.public.disney_plus SET duration_seasons = REPLACE(disney_plus.duration_seasons, 'Season', '');
UPDATE natalie.public.disney_plus SET duration_seasons = REPLACE(disney_plus.duration_seasons, 's', '');

/*Changing data type of duration_mins and duration_ seasons to integer*/
ALTER TABLE natalie.public.disney_plus
ALTER COLUMN duration_mins TYPE INTEGER USING duration_mins::integer;

ALTER TABLE natalie.public.disney_plus
ALTER COLUMN duration_seasons TYPE INTEGER USING duration_seasons::integer ;

/* Selecting the data that i'll be working with  */
SELECT type, title, director, country, date_added, release_year, rating, duration_mins, listed_in, duration_seasons
FROM natalie.public.disney_plus
WHERE (country) is not NULL;

/* Disney Plus TV Shows that had more than 3 seasons */
SELECT type, title
FROM natalie.public.disney_plus
WHERE duration_seasons > 3;

/* How many movies were added in 2020*/
SELECT COUNT(*) FROM natalie.public.disney_plus
WHERE (date_added BETWEEN '2020-01-01' AND '2020-12-31' AND type = 'Movie');

/*How many TV shows were added in 2020 */
SELECT COUNT(*) FROM natalie.public.disney_plus
WHERE (date_added BETWEEN '2020-01-01' AND '2020-12-31' AND type = 'TV Show') ;

/* Total duration minutes for movies on Disney Plus  in this dataset*/
SELECT SUM(duration_mins) as total_mins FROM natalie.public.disney_plus WHERE type = 'Movie';

/*Ratings used for Disney Plus */
SELECT DISTINCT (rating) FROM natalie.public.disney_plus WHERE (rating) IS NOT NULL;

/* Titles that were added to Disney Plus in 2019 which is rated as PG */
SELECT title FROM natalie.public.disney_plus
WHERE (date_added BETWEEN '2019-01-01' AND '2019-12-31'
AND rating = 'PG');
