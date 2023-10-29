-- create a view without duplicate rows
CREATE OR REPLACE view d_caers_event_product AS
SELECT DISTINCT report_id, created_date, event_date,
       product_type, product, product_code,
       description, patient_age, age_units,
       sex, terms, outcomes
FROM staging_caers_event_product;

-- 1. this query tries to determine whether created_date, event_date, patient_age, age_units, sex, terms, and outcomes are functionally dependent on report_id
SELECT report_id, COUNT(report_id) AS c FROM (
	SELECT DISTINCT report_id, created_date, event_date, patient_age, age_units, sex, terms, outcomes
	FROM d_caers_event_product
) pcd
GROUP BY report_id
ORDER BY c DESC LIMIT 5;
--    report_id    | c
-------------------+---
-- 157417          | 1
-- 2021-CFS-009264 | 1
-- 148146          | 1
-- 125370          | 1
-- 209126          | 1
-- There is no count larger than 1, indicating that those columns mentioned above are all functionally dependent on report_id.

-- 2. this query tries to determine whether product_code is functionally dependent on product
SELECT product, COUNT(product) AS c FROM (
	SELECT DISTINCT product, product_code
	FROM d_caers_event_product
) pcd
GROUP BY product
ORDER BY c DESC LIMIT 5;
--         product          | c
----------------------------+----
-- EXEMPTION 4              | 40
-- SALAD                    |  5
-- LITTLE DEBBIE NUTTY BARS |  4
-- JIF PEANUT BUTTER        |  4
-- TURMERIC                 |  4
-- There are counts larger than 1, indicating that product_code is not functionally dependent on product.

-- 3. this query tries to determine whether description is functionally dependent on product_code
SELECT product_code, COUNT(product_code) AS c FROM(
	SELECT DISTINCT product_code, description
	FROM d_caers_event_product
)pcd
GROUP BY product_code
ORDER BY c DESC LIMIT 5;
-- product_code | c
----------------+---
-- 34           | 1
-- 18           | 1
-- 32           | 1
-- 2            | 1
-- 13           | 1
-- There is no count larger than 1, indicating that description is functionally dependent on product_code.

-- 4. this query tries to determine whether outcomes is functionally dependent on terms
SELECT terms, COUNT(terms) AS c FROM(
	SELECT DISTINCT terms, outcomes
	FROM d_caers_event_product
)pcd
GROUP BY terms
ORDER BY c DESC LIMIT 5;
--         terms         | c
-------------------------+----
-- Hypersensitivity      | 41
-- HYPERSENSITIVITY      | 39
-- CONVULSION            | 29
-- Anaphylactic reaction | 29
-- OVARIAN CANCER        | 28
-- There are counts larger than 1, indicating that outcomes is not functionally dependent on terms.

-- 5 this query tries to determine whether or not report_id together with product is unique
SELECT report_id, product, COUNT(*)
FROM d_caers_event_product
GROUP BY report_id, product
ORDER BY COUNT(*) DESC LIMIT 5;
-- report_id |   product   | count
-------------+-------------+-------
-- 104644    | EXEMPTION 4 |     5
-- 91112     | EXEMPTION 4 |     4
-- 121978    | EXEMPTION 4 |     3
-- 122045    | EXEMPTION 4 |     3
-- 168167    | EXEMPTION 4 |     3
-- There are still rows with the same report_id and product combination (count > 1). Therefore, this combination cannot be the primary key.

-- 6. this query tries to determine whether or not report_id + product + product_code is unique
SELECT report_id, product, product_code, COUNT(*)
FROM d_caers_event_product
GROUP BY report_id, product, product_code
ORDER BY COUNT(*) DESC LIMIT 5;
-- report_id |                     product                     | product_code | count
-------------+-------------------------------------------------+--------------+-------
-- 110468    | PURITAN'S PRIDE Q-SORB CO-Q-10 100MG            | 54           |     2
-- 111782    | GERBERS SINGLE GRAIN CEREALS (OATMEAL AND RICE) | 40           |     2
-- 121717    | TREETOP APPLESAUCE                              | 20           |     2
-- 133074    | EXEMPTION 4                                     | 40           |     2
-- 168167    | EXEMPTION 4                                     | 53           |     2
-- There are still rows with the same report_id and product combination (count > 1). Therefore, this combination cannot be the primary key.

-- 7. this query tries to determine whether or not report_id + product + product_code + product_type is unique
SELECT report_id, product, product_code, product_type, COUNT(*)
FROM d_caers_event_product
GROUP BY report_id, product, product_code, product_type
ORDER BY COUNT(*) DESC LIMIT 5;
-- report_id |                            product                             | product_code | product_type | count
-------------+----------------------------------------------------------------+--------------+--------------+-------
-- 145102    | PHILADELPHIA REGULAR CREAM CHEESE SPREAD SALMON FLAVORED       | 12           | SUSPECT      |     1
-- 155837    | COQ10                                                          | 54           | CONCOMITANT  |     1
-- 141022    | GROUPER                                                        | 16           | SUSPECT      |     1
-- 159198    | PHARMASSURE BALANCED B COMPLEX WITH VITAMIN C ( NO PREF. NAME) | 54           | SUSPECT      |     1
-- 151942    | FLINTSTONES COMPLETE                                           | 54           | SUSPECT      |     1
-- All counts are equal to 1 this time, indicating that this combination is the proper primary key.