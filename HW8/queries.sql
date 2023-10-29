-- TODO: write the task number and description followed by the query

-- 1. write a view
DROP view olympic_view;
CREATE OR REPLACE view olympic_view AS
SELECT COALESCE(region, 'Singapore') AS region, a.event, a.medal, a.year, a.height FROM athlete_event AS a
LEFT OUTER JOIN noc_region ON a.noc = noc_region.noc
WHERE medal IS NOT NULL;

-- 2. use the window function, rank()
WITH top_event AS(
	SELECT region, event, count(*) AS gold_medals,
	rank() over (PARTITION BY event ORDER BY count(*) desc) AS rank
	FROM olympic_view
WHERE medal = 'Gold' AND event LIKE 'Fencing%'
GROUP BY region, event)
SELECT region, event, gold_medals, rank FROM top_event
WHERE rank <= 3
ORDER BY event, rank;

-- 3. Using Aggregate Functions as Window Functions
SELECT region, year, medal, count(*) AS c,
sum(count(*)) over (partition by region, medal ORDER BY year)
FROM olympic_view
GROUP BY region, year, medal
ORDER BY region, year, medal;

-- 4. Use the Window Function, lag()
SELECT event, year, height, 
lag(height, 1) over (PARTITION BY event ORDER BY year) AS previous_height
FROM olympic_view
WHERE medal = 'Gold' AND event LIKE '%Pole Vault' AND height IS NOT NULL
GROUP BY event, year, height
ORDER BY event, year, height DESC;

