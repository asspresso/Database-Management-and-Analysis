-- 1. Show the possible values of the year column in the country_stats table sorted by most recent year first
SELECT DISTINCT year FROM country_stats ORDER BY year DESC

-- 2. Show the names of the first 5 countries in the database when sorted in alphabetical order by name
SELECT name FROM countries ORDER BY name LIMIT 5

-- 3. Adjust the previous query to show both the country name and the gdp from 2018, but this time show the top 5 countries by gdp
SELECT name, gdp FROM countries 
	INNER JOIN country_stats ON countries.country_id = country_stats.country_id 
	WHERE year = 2018 ORDER BY gdp DESC LIMIT 5
	
-- 4. How many countries are associated with each region id?
SELECT countries.region_id, count(countries.region_id) AS country_count FROM countries
	INNER JOIN regions on countries.region_id = regions.region_id
	GROUP BY countries.region_id ORDER BY country_count DESC

-- 5. What is the average area of countries in each region id?
SELECT countries.region_id, ROUND(AVG(countries.area)) AS avg_area FROM regions
	INNER JOIN countries on countries.region_id = regions.region_id
	INNER JOIN region_areas on regions.name = region_areas.region_name
	GROUP BY countries.region_id ORDER BY avg_area
	
-- 6. Use the same query as above, but only show the groups with an average country area less than 1000
SELECT countries.region_id, ROUND(AVG(countries.area)) AS avg_area FROM regions
	INNER JOIN countries on countries.region_id = regions.region_id
	INNER JOIN region_areas on regions.name = region_areas.region_name
	GROUP BY countries.region_id HAVING ROUND(AVG(countries.area)) < 1000 ORDER BY avg_area

-- 7. Create a report displaying the name and population of every continent in the database from the year 2018 in millions
SELECT continents.name, ROUND(SUM(country_stats.population)/1000000.0, 2) AS tot_pop FROM countries
	INNER JOIN country_stats on countries.country_id = country_stats.country_id
	INNER JOIN regions on countries.region_id = regions.region_id
	INNER JOIN continents on regions.continent_id = continents.continent_id
	WHERE country_stats.year = 2018 GROUP BY continents.name ORDER BY tot_pop DESC

-- 8. List the names of all of the countries that do not have a language
SELECT countries.name FROM countries
	LEFT OUTER JOIN country_languages ON countries.country_id = country_languages.country_id
	WHERE country_languages.language_id IS NULL

-- 9. Show the country name and number of associated languages of the top 10 countries with most languages
SELECT countries.name, COUNT(country_languages) AS lang_count FROM countries
	LEFT OUTER JOIN country_languages ON countries.country_id = country_languages.country_id
	GROUP BY countries.name ORDER BY lang_count DESC, countries.name LIMIT 10

-- 10. Repeat your previous query, but display a comma separated list of spoken languages rather than a count
SELECT countries.name, string_agg(languages.language, ',') FROM countries
	LEFT OUTER JOIN country_languages ON countries.country_id = country_languages.country_id
	INNER JOIN languages ON country_languages.language_id = languages.language_id
	GROUP BY countries.name ORDER BY COUNT(country_languages) DESC, countries.name LIMIT 10

-- 11. What's the average number of languages in every country in a region in the dataset? 
WITH language_counts AS(
	SELECT countries.name, COUNT(country_languages) AS lang_count FROM countries
	LEFT OUTER JOIN country_languages ON countries.country_id = country_languages.country_id
	GROUP BY countries.name)
SELECT regions.name, ROUND(AVG(language_counts.lang_count), 1) AS avg_lang_count_per_country FROM language_counts
	INNER JOIN countries ON language_counts.name = countries.name
	INNER JOIN regions ON countries.region_id = regions.region_id
	GROUP BY regions.name ORDER BY avg_lang_count_per_country DESC

-- 12. Show the country name and its "national day" for the country with the most recent national day and the country with the oldest national day
SELECT name, national_day FROM countries WHERE national_day = (SELECT MAX(national_day) FROM countries) UNION
SELECT name, national_day FROM countries WHERE national_day = (SELECT MIN(national_day) FROM countries)
	