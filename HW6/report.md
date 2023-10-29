# Overview
Name / Title: chocolate_bars.csv
Link to Data: https://www.kaggle.com/datasets/evangower/chocolate-bar-ratings

Author or Creator: EVAN GOWER
Publication Date: 2022/9/7
Publisher: Kaggle
Version or Data Accessed: 2022/9/29
License: Open Database License
Format: .csv
Size: 66kb
Number of Records: 2,531 rows (with header)

Field/Column 1: id, str
Field/Column 2: manufacturer, str
Field/Column 3: company_location, str
Field/Column 4: year_reviewed, str
Field/Column 5: bean_origin, str
Field/Column 6: bar_name, str
Field/Column 7: cocoa_percent, float
Field/Column 8: num_ingredients, float
Field/Column 9: ingredients, str
Field/Column 10: review, str
Field/Column 11: rating, float

# Table Design
bar_num: serial primary key (this is s surrogate primary key, as there is no candidate for primary key in the original dataset)
id: varchar (this looks like a primary key but it has dupliates)
manufacturer: text
company_location: text
year_reviewed: numeric
bean_origin: text
bar_name: text (this looks like a primary key as well, but again it has dupliates)
cocoa_percent: numeric
num_ingredients: numeric (allow null values because there are missing data in the original dataset)
ingredients: text (allow null values because there are missing data in the original dataset)
review: text
rating: numeric

# Import
The import succeeded without error.

# Database Information
-- show all databases
postgres=# \l
                                                                     List of databases
    Name    |  Owner   | Encoding |            Collate             |             Ctype              | ICU Locale | Locale Provider |   Access privileges
------------+----------+----------+--------------------------------+--------------------------------+------------+-----------------+-----------------------
 homework06 | postgres | UTF8     | Chinese (Simplified)_China.936 | Chinese (Simplified)_China.936 |            | libc            |
 postgres   | postgres | UTF8     | Chinese (Simplified)_China.936 | Chinese (Simplified)_China.936 |            | libc            |
 template0  | postgres | UTF8     | Chinese (Simplified)_China.936 | Chinese (Simplified)_China.936 |            | libc            | =c/postgres          +
            |          |          |                                |                                |            |                 | postgres=CTc/postgres
 template1  | postgres | UTF8     | Chinese (Simplified)_China.936 | Chinese (Simplified)_China.936 |            | libc            | =c/postgres          +
            |          |          |                                |                                |            |                 | postgres=CTc/postgres
(4 rows)

-- show all tables in homework06 database
homework06=# \dt
           List of relations
 Schema |   Name    | Type  |  Owner
--------+-----------+-------+----------
 public | chocolate | table | postgres
(1 row)

-- describe the table chocolate
homework06=# \d chocolate
                                         Table "public.chocolate"
      Column      |       Type        | Collation | Nullable |                  Default
------------------+-------------------+-----------+----------+--------------------------------------------
 bar_num          | integer           |           | not null | nextval('chocolate_bar_num_seq'::regclass)
 id               | character varying |           | not null |
 manufacturer     | text              |           | not null |
 company_location | text              |           | not null |
 year_reviewed    | numeric           |           | not null |
 bean_origin      | text              |           | not null |
 bar_name         | text              |           |          |
 cocoa_percent    | numeric           |           | not null |
 num_ingredients  | numeric           |           |          |
 ingredients      | text              |           |          |
 review           | text              |           | not null |
 rating           | numeric           |           | not null |
Indexes:
    "chocolate_pkey" PRIMARY KEY, btree (bar_num)

# Query Results
```
### 1. the total number of rows in the database
 count
-------
  2530
(1 row)
```

```
### 2. show the first 15 rows, but only display 3 columns (id, manufacturer, and rating)
  id  | manufacturer | rating
------+--------------+--------
 2454 | 5150         |   3.25
 2458 | 5150         |    3.5
 2454 | 5150         |   3.75
 2542 | 5150         |    3.0
 2546 | 5150         |    3.0
 2546 | 5150         |   3.25
 2542 | 5150         |    3.5
 797  | A. Morin     |    3.5
 797  | A. Morin     |   3.75
 1011 | A. Morin     |   2.75
 1015 | A. Morin     |   2.75
 1011 | A. Morin     |    3.0
 1015 | A. Morin     |    3.0
 1011 | A. Morin     |   3.25
 1015 | A. Morin     |   3.25
(15 rows)
```

```
### 3. do the same as above, but chose a column (rating) to sort on, and sort in descending order
  id  |    manufacturer     | rating
------+---------------------+--------
 1924 | Arete               |    4.0
 729  | Artisan du Chocolat |    4.0
 572  | AMMA                |    4.0
 1908 | Arete               |    4.0
 2024 | Arete               |    4.0
 2254 | Arete               |    4.0
 470  | Amano               |    4.0
 725  | Amano               |    4.0
 2648 | A. Morin            |    4.0
 1598 | Arete               |    4.0
 1019 | A. Morin            |    4.0
 1015 | A. Morin            |    4.0
 1319 | A. Morin            |    4.0
 2028 | Arete               |    4.0
 1295 | Bar Au Chocolat     |    4.0
(15 rows)
```

```
### 4. add a new column called description without a default value
ALTER TABLE
```

```
### 5. set the value of that new column as 'data from kaggle'
UPDATE 2530
```

```
### 6. show only the unique (non duplicates) of the rating column
 rating
--------
   2.25
   3.75
    3.5
    2.0
    3.0
   3.25
    1.5
   2.75
   1.75
    2.5
    1.0
    4.0
(12 rows)
```

```
### 7. group rows together by the rating column and use an aggregate function to calculate the count
 rating | rating_counts
--------+---------------
   2.25 |            17
   3.75 |           300
    3.5 |           565
    2.0 |            33
    3.0 |           523
   3.25 |           464
    1.5 |            10
   2.75 |           333
   1.75 |             3
    2.5 |           166
    1.0 |             4
    4.0 |           112
(12 rows) 
```

```
### 8. now, using the same grouping query, filter the query results by only selecting ratings with more than 100 counts
 rating | rating_counts
--------+---------------
   3.75 |           300
    3.5 |           565
    3.0 |           523
   3.25 |           464
   2.75 |           333
    2.5 |           166
    4.0 |           112
(7 rows) 
```

```
### 9. show all company locations that have average chocolate bar ratings higher than 3.2
 company_location | location_rating_avg
------------------+---------------------
 Italy            |  3.2307692307692308
 Fiji             |  3.2500000000000000
 Germany          |  3.2083333333333333
 Canada           |  3.3036723163841808
 Finland          |  3.2500000000000000
 Argentina        |  3.3055555555555556
 Chile            |  3.7500000000000000
 France           |  3.2585227272727273
 Vietnam          |  3.3593750000000000
 Israel           |  3.2500000000000000
 Suriname         |  3.2500000000000000
 Iceland          |  3.3125000000000000
 Denmark          |  3.3387096774193548
 Switzerland      |  3.3181818181818182
 New Zealand      |  3.2129629629629630
 Hungary          |  3.2211538461538462
 Russia           |  3.2500000000000000
 Honduras         |  3.2083333333333333
 Norway           |  3.3333333333333333
 Scotland         |  3.2727272727272727
 Brazil           |  3.2800000000000000
 Austria          |  3.2583333333333333
 Australia        |  3.3584905660377358
 Guatemala        |  3.3500000000000000
 Bolivia          |  3.2500000000000000
 Amsterdam        |  3.3125000000000000
 Spain            |  3.2638888888888889
 U.A.E.           |  3.4000000000000000
 Poland           |  3.3750000000000000
 Thailand         |  3.3000000000000000
(30 rows)
```

```
### 10. show the id and names of all chocolate bars having a rating of 4.0 reviewed by 2021
  id  |                 bar_name
------+-------------------------------------------
 2648 | La Joya
 2610 | Piura Select
 2554 | Valle de Los Rios, batch 990
 2688 | Chuao, batch 1089
 2546 | Vale Potumuju, 2019 h., batch 1
 2656 | Soconusco, Rayen Cacao Co-op, batch 21154
 2644 | Chuao Village, BR-SC, batch 21-437
 2700 | Ben Tre, batch BEN210924 8983
(8 rows)
```

```
### 11. show in descending order the average rating of chocolate bars with different number of ingredients (note: the last row reflects chocolate bars with null values in the column of num_ingredients)
 num_ingredients |     avg_rating
-----------------+--------------------
             3.0 | 3.2688172043010753
             2.0 | 3.2180000000000000
             4.0 | 3.1279317697228145
             5.0 | 3.0798429319371728
             1.0 | 2.9583333333333333
             6.0 | 2.9375000000000000
                 | 2.8103448275862069
(7 rows)
```

```
### 12. show the average rating of chocolate bars with cocoa_percent between 70 and 75 (inclusive)
 cocoa_percent |     avg_rating
---------------+--------------------
          70.0 | 3.2633843212237094
          71.0 | 3.0639534883720930
          71.5 | 3.1250000000000000
          72.0 | 3.2101694915254237
          72.5 | 2.7500000000000000
          73.0 | 3.1931818181818182
          73.5 | 3.1250000000000000
          74.0 | 3.2238805970149254
          75.0 | 3.1653225806451613
(9 rows)
```