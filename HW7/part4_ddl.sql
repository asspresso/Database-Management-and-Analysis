DROP TABLE IF EXISTS report;
CREATE TABLE report(
    report_id varchar(255),
    created_date date,
    event_date date,
    patient_age numeric,
    age_units varchar(255),
    sex varchar(255),
    terms text,
    outcomes text,
	PRIMARY KEY(report_id)
);

DROP TABLE IF EXISTS code;
CREATE TABLE code(
    product_code text,
    description text,
    PRIMARY KEY (product_code)
);

DROP TABLE IF EXISTS product;
CREATE TABLE product(
    product text,
    product_type text,
    product_code text REFERENCES code (product_code),
    PRIMARY KEY (product, product_type, product_code)
);

DROP TABLE IF EXISTS report_product;
CREATE TABLE report_product(
    product text,
    product_type text,
    product_code text,
    report_id character varying(255) REFERENCES report (report_id), 
	FOREIGN KEY (product, product_type, product_code) REFERENCES product (product, product_type, product_code)
);
