-- TODO: use explain / analyze, create an index

-- 1. Drop an existing index
DROP index IF exists athlete_event_name_idx;

-- 2. Write a simple query
SELECT * FROM athlete_event WHERE name = 'Michael Fred Phelps, II';

-- 3. Using EXPLAIN ANALYZE
EXPLAIN ANALYZE SELECT * FROM athlete_event WHERE name = 'Michael Fred Phelps, II';
--                                                          QUERY PLAN
--------------------------------------------------------------------------------------------------------------------------------
-- Gather  (cost=1000.00..8213.36 rows=3 width=137) (actual time=38.722..72.190 rows=30 loops=1)
--   Workers Planned: 2
--   Workers Launched: 2
--   ->  Parallel Seq Scan on athlete_event  (cost=0.00..7213.06 rows=1 width=137) (actual time=12.703..15.158 rows=10 loops=3)
--         Filter: (name = 'Michael Fred Phelps, II'::text)
--         Rows Removed by Filter: 90362
-- Planning Time: 0.068 ms
-- Execution Time: 72.223 ms

-- 4. Add an index
CREATE INDEX athlete_event_name_idx ON athlete_event (name);

-- 5. Verifying improved performance
EXPLAIN ANALYZE SELECT * FROM athlete_event WHERE name = 'Michael Fred Phelps, II';
--                                                                QUERY PLAN
--------------------------------------------------------------------------------------------------------------------------------------------
-- Index Scan using athlete_event_name_idx on athlete_event  (cost=0.42..16.44 rows=3 width=137) (actual time=0.060..0.065 rows=30 loops=1)
--   Index Cond: (name = 'Michael Fred Phelps, II'::text)
-- Planning Time: 0.997 ms
-- Execution Time: 0.077 ms

-- 6. Ignoring an index
SELECT * FROM athlete_event WHERE name ILIKE 'Lionel%Messi%';