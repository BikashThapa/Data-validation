CREATE TABLE product (
product_id  SERIAL,
product_name VARCHAR(250) NOT NULL,
description  VARCHAR(250) NOT NULL,
price NUMERIC(10,2) NOT NULL,
mrp NUMERIC(10,2) NOT NULL,
pieces_per_case NUMERIC(10,2) NOT NULL,
weight_per_piece NUMERIC(10,2) NOT NULL,
uom VARCHAR(100) NOT NULL,
brand   VARCHAR(100) NOT NULL,
category    VARCHAR(100) NOT NULL,
tax_percent NUMERIC(2)  DEFAULT 13 NOT NULL,
active  BOOLEAN NOT NULL,
created_by  VARCHAR(50) NOT NULL,
created_date TIMESTAMP NOT NULL DEFAULT NOW(),
updated_by  VARCHAR(50) NOT NULL,
updated_date TIMESTAMP NOT NULL DEFAULT NOW(),
CONSTRAINT pk_product_id PRIMARY KEY (product_id),
CONSTRAINT check_tax_percent CHECK(tax_percent = 13)

);