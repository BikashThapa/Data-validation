CREATE TABLE customer(
customer_id SERIAL,
username VARCHAR(100) NOT NULL UNIQUE,
first_name VARCHAR(100) NOT NULL,
last_name VARCHAR(100) NOT NULL,
country VARCHAR(50) NOT NULL,
town VARCHAR(50) NOT NULL,
is_active BOOLEAN NOT NULL,
CONSTRAINT pk_customer_id PRIMARY KEY(customer_id)
);
