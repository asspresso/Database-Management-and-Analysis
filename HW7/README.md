## Part 1: Create an ER Diagram by inspecting tables
Countries has a one to many relationship with country_stats. This relationship exists because of a foreign key (country_id) in country_stats that references countries.

Countries has a many to many relationship with languages. This relationship exists because of a join table (country_languages) that has foreign keys (country_id and language_id) that refer to both countries and languages.

Regions has a one to many relationship with countries. This relationship exists because of a foreign key (region_id) in countries that references regions.

Continents has a one to many relationship with regions. This relationship exists because of a foreign key (continent_id) in regions that references continents.

## Part 3: Exploring the Data
```
Query 1
--    report_id    | c
-------------------+---
-- 157417          | 1
-- 2021-CFS-009264 | 1
-- 148146          | 1
-- 125370          | 1
-- 209126          | 1
-- There is no count larger than 1, indicating that those columns mentioned above are all functionally dependent on report_id.
```

```
Query 2
--         product          | c
----------------------------+----
-- EXEMPTION 4              | 40
-- SALAD                    |  5
-- LITTLE DEBBIE NUTTY BARS |  4
-- JIF PEANUT BUTTER        |  4
-- TURMERIC                 |  4
-- There are counts larger than 1, indicating that product_code is not functionally dependent on product.
```

```
Query 3
-- product_code | c
----------------+---
-- 34           | 1
-- 18           | 1
-- 32           | 1
-- 2            | 1
-- 13           | 1
-- There is no count larger than 1, indicating that description is functionally dependent on product_code.
```

```
Query 4
--         terms         | c
-------------------------+----
-- Hypersensitivity      | 41
-- HYPERSENSITIVITY      | 39
-- CONVULSION            | 29
-- Anaphylactic reaction | 29
-- OVARIAN CANCER        | 28
-- There are counts larger than 1, indicating that outcomes is not functionally dependent on terms.
```

```
Query 5
-- report_id |   product   | count
-------------+-------------+-------
-- 104644    | EXEMPTION 4 |     5
-- 91112     | EXEMPTION 4 |     4
-- 121978    | EXEMPTION 4 |     3
-- 122045    | EXEMPTION 4 |     3
-- 168167    | EXEMPTION 4 |     3
-- There are still rows with the same report_id and product combination (count > 1). Therefore, the report_id + product combination cannot be the primary key.
```

```
Query 6
-- report_id |                     product                     | product_code | count
-------------+-------------------------------------------------+--------------+-------
-- 110468    | PURITAN'S PRIDE Q-SORB CO-Q-10 100MG            | 54           |     2
-- 111782    | GERBERS SINGLE GRAIN CEREALS (OATMEAL AND RICE) | 40           |     2
-- 121717    | TREETOP APPLESAUCE                              | 20           |     2
-- 133074    | EXEMPTION 4                                     | 40           |     2
-- 168167    | EXEMPTION 4                                     | 53           |     2
-- There are still rows with the same report_id and product combination (count > 1). Therefore, the report_id + product + product_code combination cannot be the primary key.
```

```
Query 7
-- report_id |                            product                             | product_code | product_type | count
-------------+----------------------------------------------------------------+--------------+--------------+-------
-- 145102    | PHILADELPHIA REGULAR CREAM CHEESE SPREAD SALMON FLAVORED       | 12           | SUSPECT      |     1
-- 155837    | COQ10                                                          | 54           | CONCOMITANT  |     1
-- 141022    | GROUPER                                                        | 16           | SUSPECT      |     1
-- 159198    | PHARMASSURE BALANCED B COMPLEX WITH VITAMIN C ( NO PREF. NAME) | 54           | SUSPECT      |     1
-- 151942    | FLINTSTONES COMPLETE                                           | 54           | SUSPECT      |     1
-- All counts are equal to 1 this time, indicating that the report_id + product + product_code + product_type combination is the proper primary key.
```

## Part 3: Examine a data set and create a normalized data model to store the data
![ER DIAGRAM](https://github.com/nyu-csci-ua-0479-001-fall-2022/homework07-asspresso/blob/master/img/part3_03_caers_er_diagram.png)

```
Design Decisions:
As the composite key is report_id + product + product_code + product_type, the 4 columns should not stay in the same table;
According to my exploration, these columns are functionally dependent on report_id: created_date, event_date, patient_age, age_units, sex, terms, and outcomes. Therefore, they could stay with report_id in a table called report;
Now, product + product_code + product_type could stay in a same table called product;
Because a report has many products and a product may appear in many reports, they have many-to-many relationship;
Finally, description is functionally dependent on product_code. Therefore, these two columns could stay in another table called code.
```