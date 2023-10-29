set datestyle to MDY;
COPY staging_caers_event_product (
	created_date, report_id, event_date,
	product_type, product, product_code,
	description, patient_age, age_units,
	sex, terms, outcomes)
    FROM 'C:\CAERS-Quarterly-20220630-CSV.csv'
    (format csv, HEADER, ENCODING 'LATIN1');