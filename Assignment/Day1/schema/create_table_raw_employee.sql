CREATE TABLE employee_raw(
employee_id VARCHAR(255),
first_name VARCHAR(255),
last_name VARCHAR(255),
department_id VARCHAR(255),
department_name VARCHAR(255),
manager_employee_id VARCHAR(255),
employee_role VARCHAR(255),
salary FLOAT,
hire_date TIMESTAMP,
terminated_date VARCHAR(255),
terminated_reason VARCHAR(255),
dob TIMESTAMP,
fte FLOAT,
locations VARCHAR(255),
CONSTRAINT pk_employee_id PRIMARY KEY(employee_id)
);
