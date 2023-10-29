-- write your queries underneath each number:
 
-- 1. the total number of rows in the database
SELECT COUNT(*) FROM chocolate;
-- 2. show the first 15 rows, but only display 3 columns (id, manufacturer, and rating)
SELECT "id", "manufacturer", "rating" FROM chocolate LIMIT 15;
-- 3. do the same as above, but chose a column (rating) to sort on, and sort in descending order
SELECT "id", "manufacturer", "rating" FROM chocolate ORDER BY "rating" desc LIMIT 15;
-- 4. add a new column called description without a default value
ALTER TABLE chocolate ADD COLUMN description text;
-- 5. set the value of that new column as 'data from kaggle'
UPDATE chocolate SET description = 'data from Kaggle';
-- 6. show only the unique (non duplicates) of the rating column
SELECT DISTINCT rating FROM chocolate;
-- 7. group rows together by the rating column and use an aggregate function to calculate the count
SELECT rating, COUNT(*) AS rating_counts FROM chocolate GROUP BY rating;
-- 8. now, using the same grouping query, filter the query results by only selecting ratings with more than 100 counts
SELECT rating, COUNT(*) AS rating_counts FROM chocolate GROUP BY rating HAVING COUNT(*) > 100;
-- 9. show all company locations that have average chocolate bar ratings higher than 3.2
SELECT company_location, AVG(rating) AS location_rating_avg FROM chocolate GROUP BY company_location HAVING AVG(rating)>3.2;
-- 10. show the id and names of all chocolate bars having a rating of 4.0 reviewed by 2021
SELECT "id", "bar_name" FROM chocolate WHERE rating = 4.0 AND year_reviewed = 2021;
-- 11. show in descending order the average rating of chocolate bars with different number of ingredients
SELECT num_ingredients, AVG(rating) AS avg_rating FROM chocolate GROUP BY num_ingredients ORDER BY AVG(rating) desc;
-- 12. show the average rating of chocolate bars with cocoa_percent between 70 and 75 inclusive
SELECT cocoa_percent, AVG(rating) AS avg_rating FROM chocolate GROUP BY cocoa_percent HAVING cocoa_percent > 69 AND cocoa_percent < 76 ORDER BY cocoa_percent;