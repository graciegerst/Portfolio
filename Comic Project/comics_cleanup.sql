-- confirm data imported correctly
SELECT * FROM comics.raw_comics1
LIMIT 5;

SELECT COUNT(*) FROM comics.raw_comics1;

-- delete all blank rows from table
DELETE FROM comics.raw_comics1
WHERE (comic_title IS NULL OR comic_title = '')
AND (issue_number IS NULL OR issue_number = '')
AND (published_year IS NULL OR published_year = '')
AND (number_in_series IS NULL OR number_in_series = '')
AND (main_series IS NULL OR main_series = '')
AND (notes IS NULL OR notes = '');

-- check count for each distinct date in published_year column
-- will need to alter table and make separate columns for month and year 
SELECT published_year, COUNT(published_year) FROM comics.raw_comics1
GROUP BY published_year;

-- isolate the year from the text column published_year
SELECT SUBSTRING(published_year, -4, 4) AS years, COUNT(SUBSTRING(published_year, -4, 4)) FROM comics.raw_comics1
GROUP BY years;

SELECT *, SUBSTRING(published_year, -4, 4) AS years  FROM comics.raw_comics1
WHERE SUBSTRING(published_year, -4, 4) = 'ters';
-- discovered row that imported incorrectly

-- update row with correct information
UPDATE comics.raw_comics1
SET comic_title = 'Superman in "The Computer Masters of Metropolis"', issue_number = NULL, published_year = '1982', number_in_series = NULL, main_series = NULL, notes = NULL
WHERE published_year = 'Masters';

-- check update
SELECT * FROM comics.raw_comics1
WHERE comic_title = 'Superman in "The Computer Masters of Metropolis"'
OR published_year = 'Masters';

-- isolate year again from published_year
SELECT SUBSTRING(published_year, -4, 4) AS years, COUNT(SUBSTRING(published_year, -4, 4)) FROM comics.raw_comics1
GROUP BY years
ORDER BY years;

-- update old column name, add column for year, and insert values
ALTER TABLE comics.raw_comics1 RENAME COLUMN published_year TO published_date; 
ALTER TABLE comics.raw_comics1 ADD published_year INT;

-- unable to add years into column as INT, need to change column to VARCHAR, add data, and change back to INT
ALTER TABLE comics.raw_comics1 CHANGE published_year published_year VARCHAR(20);
UPDATE comics.raw_comics1 SET published_year = SUBSTRING(published_date, -4, 4);

-- check update and change column back to INT
SELECT published_year FROM comics.raw_comics1
GROUP BY published_year;

-- unable to change column until empty strings are NULL
UPDATE comics.raw_comics1 SET published_year = NULL 
WHERE published_year = '';

-- successfully change column to INT
ALTER TABLE comics.raw_comics1 CHANGE published_year published_year INT;

-- selecting the months from published_date since they are not entered consistently
SELECT SUBSTRING(published_date, 1, LENGTH(published_date) - 4), COUNT(published_date) FROM comics.raw_comics1
GROUP BY SUBSTRING(published_date, 1, LENGTH(published_date) - 4);