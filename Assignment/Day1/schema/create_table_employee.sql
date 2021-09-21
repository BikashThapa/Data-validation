CREATE TABLE employee(
client_employee_id VARCHAR(255) NOT NULL,
department_id VARCHAR(255) NOT NULL,
first_name VARCHAR(255) NOT NULL,
last_name VARCHAR(255) NOT NULL,
manager_employee_id VARCHAR(255),
salary FLOAT NOT NULL,
hire_date TIMESTAMP NOT NULL,
term_date VARCHAR(255),
term_reason VARCHAR(255),
dob TIMESTAMP NOT NULL,
fte FLOAT NOT NULL,
fte_status VARCHAR(255) NOT NULL,
weekly_hours smallint NOT NULL,
role VARCHAR(255) NOT NULL,
is_active BOOLEAN NOT NULL
);
