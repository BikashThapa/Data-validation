# Data validation - Day 2
 We have created the table for the data storage for each data. Those database schema dessign are listed in the schema section of the project.

## Test case 2
### On table employee
- 1. check if there is any non-manager employee assigned as the manager to other employee.
~~~~ sql
SELECT
COUNT(*) AS impacted_record_count,
CASE
WHEN COUNT(*) > 0 THEN 'failed'
ELSE 'passed'
END AS test_result
FROM (
SELECT manager_employee_id FROM employee
WHERE manager_employee_id IS NOT NULL AND role = 'Manager'
EXCEPT
SELECT client_employee_id FROM employee
) as test_results;
~~~~
| impacted_record_count | test_result |
| -- | -- |
| 0 | passed |

Here, we have checked whether any non-manager employee assigned as the manager to other employee. For this,we have taken  manager_employee_id from employee table whose value is not null and compared to result of client_employee_id from same table. This results 0 because all the employee are assigned to the manager role only.

- 2. check if there is any terminated date before hire date.
~~~~ sql
SELECT
COUNT(*) AS impacted_record_count,
CASE
WHEN COUNT(*) > 0 THEN 'failed'
ELSE 'passed'
END AS test_result
FROM employee
WHERE term_date < hire_date;
~~~~
| impacted_record_count | test_result |
| -- | -- |
| 0 | passed |

Here, we are checking whether there is any employee whose term date comes before even hiring. For this, we have used where condition for term date< hire date.

- 3. check if first_name contains any non text values 
~~~~ sql
SELECT
COUNT(*) AS impacted_record_count,
CASE
WHEN COUNT(*) > 0 THEN 'failed'
ELSE 'passed'
END AS test_result
FROM employee 
WHERE (first_name ~* '[a-z]') is FALSE;
~~~~
| impacted_record_count | test_result |
| -- | -- |
| 0 | passed |

Here, first name field of employee table is checked. ~* matches a regular expression with case insensitive, and [a-z] represent all letters from a to z. If False, gives those employee data whose first_name contsins any other non text values.

- 4. check if any  employees are under the age of 16 or not.
~~~~ sql
SELECT
COUNT(*) AS impacted_record_count,
CASE
WHEN COUNT(*) > 0 THEN 'failed'
ELSE 'passed'
END AS test_result
FROM employee
WHERE AGE(dob) <'16 years';
~~~~
| impacted_record_count | test_result |
| -- | -- |
| 0 | passed |

Here, we are checking the data if there is any employee whose age is less than 16 years. We have used AGE() function of postgreSQL for determing age using dob and comapring with 16 years of age.

### On table timesheet
- 1. check if there are any records whose shift start time and shift end time is present but attendance is marked as FALSE.
~~~~ sql
SELECT
COUNT(*) AS impacted_record_count,
CASE
WHEN COUNT(*) > 0 THEN 'failed'
ELSE 'passed'
END AS test_result
FROM timesheet
WHERE (shift_start_time IS NOT NULL AND shift_end_time IS NOT NULL) 
AND attendence IS FALSE;
~~~~
| impacted_record_count | test_result |
| -- | -- |
| 0 | passed |

Here, we have simply checked the shift start time and shift end time whether they are not null or not and used AND statement with attendence as FALSE to check whether whose working time is registered but there is no attendance record.

- 2. check if there is any employee who have taken more break than hours worked on a specific day.
~~~~ sql
SELECT
COUNT(*) AS impacted_record_count,
CASE
WHEN COUNT(*) > 0 THEN 'failed'
ELSE 'passed'
END AS test_result
FROM(
SELECT count(*) FROM timesheet
WHERE break_hour>hours_worked
GROUP BY employee_id,shift_date
) as test_result;
~~~~
| impacted_record_count | test_result |
| -- | -- |
| 0 | passed |

Here, We have checked the break hours is greater than hours worked by each employee on a specific date which is achieved by using group by statement.

- 3. check if there is any employee id on timesheet that are not present in the employee table
~~~~ sql
SELECT
COUNT(*) AS impacted_record_count,
CASE
WHEN COUNT(*) > 0 THEN 'failed'
ELSE 'passed'
END AS test_result
FROM (
SELECT employee_id FROM timesheet
EXCEPT
SELECT client_employee_id FROM employee
) as test_results;
~~~~
| impacted_record_count | test_result |
| -- | -- |
| 0 | passed |

Here, the employee_id is checked in the employee table whether all employee_id are present there or not.

- 4. check if there is any employee who left the company is recorded in timesheet 
~~~~ sql
SELECT
COUNT(*) AS impacted_record_count,
CASE
WHEN COUNT(*) > 0 THEN 'failed'
ELSE 'passed'
END AS test_result
FROM (
SELECT client_employee_id FROM employee  WHERE is_active IS FALSE
EXCEPT
SELECT employee_id FROM timesheet
) as test_results;
~~~~
| impacted_record_count | test_result |
| -- | -- |
| 0 | passed |

### On table product

- 1. check if there is any record in product whose values is in 0 or negative.
~~~~ sql
SELECT
COUNT(*) AS impacted_record_count,
CASE
WHEN COUNT(*) > 0 THEN 'failed'
ELSE 'passed'
END AS test_result
FROM product
WHERE weight_per_piece <= 0;
~~~~
| impacted_record_count | test_result |
| -- | -- |
| 0 | passed |

Here, the weight_per_piece is checked using conditional opeartor whether there is any record in product whose values is in 0 or negative. 

- 2. check if there is any records whose Tax percent is not 13.
~~~~ sql
SELECT
COUNT(*) AS impacted_record_count,
CASE
WHEN COUNT(*) > 0 THEN 'failed'
ELSE 'passed'
END AS test_result
FROM product
WHERE tax_percent != 13;
~~~~
| impacted_record_count | test_result |
| -- | -- |
| 0 | passed |

Here, the tax percent is simply checked whether it is 13 or not. It must be 13 as government makes the rules abou tax and may change according to the law.

- 3. check if there is any missing prices of a product.
~~~~ sql
SELECT
COUNT(*) AS impacted_record_count,
CASE
WHEN COUNT(*) > 0 THEN 'failed'
ELSE 'passed'
END AS test_status
FROM product
WHERE mrp IS  NULL AND price IS  NULL OR pieces_per_case IS  NULL;
~~~~
| impacted_record_count | test_result |
| -- | -- |
| 0 | passed |

Here, OR condition is used in different statement while checking different fields.

- 4. check if there is any records whose billing date preceds the products created date.
~~~~ sql
SELECT
COUNT(*) AS impacted_record_count,
CASE
WHEN COUNT(*) > 0 THEN 'failed'
ELSE 'passed'
END AS test_result
FROM product p
JOIN sales s
ON p.product_id = s.product_id
WHERE p.created_date > s.created_date;
~~~~
| impacted_record_count | test_result |
| -- | -- |
| 356 | failed |

Here, there is the fault in the system as product is first added then it is sold. 356 records have been created at sales before even defining a product in a product table.

### On table sales

- 1. check whether the net bill amount is correct or not
~~~~ sql
SELECT
COUNT(*) AS impacted_record_count,
CASE
WHEN COUNT(*) > 0 THEN 'failed'
ELSE 'passed'
END AS test_result
FROM(SELECT
CASE  WHEN (((price*qty)::NUMERIC(8,3) + tax_amt::NUMERIC(8,3))) = (net_bill_amt::NUMERIC(8,3)) THEN 'YES'
ELSE 'NO'
END as test_result
FROM sales) as result;
~~~~
| impacted_record_count | test_result |
| -- | -- |
| 915 | failed |

Here, all the columns are changed to same precision for comparing and formula is generated for finding net bill. The net bill is the total sum of gross price and tax_amount. The gross amount is calculated by price * quantity.

- 2. check if there is any records in the sales table made by same customer on same update timestamp and of same product.
~~~~ sql
SELECT
COUNT(*) AS impacted_record_count,
CASE
WHEN COUNT(*) > 0 THEN 'failed'
ELSE 'passed'
END AS test_result
FROM(
SELECT count(*) FROM sales s
JOIN product p using(product_id)
GROUP BY s.customer_id,s.product_id, s.created_date
) as result;
~~~~
| impacted_record_count | test_result |
| -- | -- |
| 632 | failed |

Here, we assume that there is a duplicate data in sales table as the customer buys same product at exact same timestamp on a given day. Here, the created date of sales table must be different as it is in timestamp format. So the time should be a little bit different to be a valid distinct record in our sales db.

- 3. check for the entries in the sales tables which doesnot have either customer id or product id or both.
~~~~ sql
SELECT
COUNT(*) AS impacted_record_count,
CASE
WHEN COUNT(*) > 0 THEN 'failed'
ELSE 'passed'
END AS test_result
FROM
sales 
WHERE (customer_id IS  NULL AND product_id IS NULL)
OR customer_id IS  NULL
OR product_id IS  NULL;
~~~~
| impacted_record_count | test_result |
| -- | -- |
| 0 | passed |

Here, we have checked each colum is either null or not and combination of both( customer_id and product_id)

- 4. check if there is any bill date that precds todays date.
~~~~ sql
SELECT
COUNT(*) AS impacted_record_count,
CASE
WHEN COUNT(*) > 0 THEN 'failed'
ELSE 'passed'
END AS test_result
FROM sales
WHERE bill_date > NOW();
~~~~
| impacted_record_count | test_result |
| -- | -- |
| 0 | passed |

Here, we have checked the bill date is either greater than today's date or not. NOW() function gives the exact timestamp of current time.