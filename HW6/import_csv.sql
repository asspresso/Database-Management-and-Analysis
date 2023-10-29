-- write your COPY statement to import a csv here
COPY chocolate (id, manufacturer, company_location, year_reviewed, bean_origin, bar_name, cocoa_percent, 
num_ingredients, ingredients, review, rating)
FROM 'C:\chocolate_bars.csv'
csv 
header 
delimiter as ','
null AS '';