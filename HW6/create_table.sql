-- write your table creation sql here!
DROP TABLE IF EXISTS chocolate;
CREATE TABLE chocolate (
	bar_num serial primary key,
	id varchar NOT NULL,
	manufacturer text NOT NULL,
	company_location text NOT NULL,
	year_reviewed numeric NOT NULL,
	bean_origin text NOT NULL,
	bar_name text,
	cocoa_percent numeric NOT NULL,
	num_ingredients numeric,
	ingredients text,
	review text NOT NULL,
	rating numeric NOT NULL
);