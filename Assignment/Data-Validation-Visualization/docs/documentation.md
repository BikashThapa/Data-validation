# Data validation - Day 1
 We have created the table for the data storage for each data. Those database schema dessign are listed in the schema section of the project.

## Test case 1
 - 1.Check if a single employee is listed twice with multiple ids.
~~~~ sql
SELECT
  COUNT(*) AS impacted_record_count,
  CASE
    WHEN COUNT(*) > 0
     THEN 'failed'
    ELSE 'passed'
  END AS test_result
FROM(
  SELECT 
    COUNT(*)
  FROM employee
  GROUP BY client_employee_id
  HAVING COUNT(*) >1
  ) as test_result;
~~~~
| impacted_record_count | test_result |
| -- | -- |
| 0 | passed |

Here we have checking for the single employee is listed twice with multiple id. We have dealed this approach with first grouping the client_employee_id on its basis and counting those number, if greater than 1. if 2 is present the result gives failed.

- 2. Check if part time employees are assigned other fte_status.
~~~~ sql
SELECT
  COUNT(*) AS impacted_record_count,
  CASE
    WHEN COUNT(*) > 0
     THEN 'failed'
    ELSE 'passed'
 END AS test_result
FROM employee
WHERE fte >= 0.8 
  AND fte_status = 'Part Time';
~~~~
| impacted_record_count | test_result |
| -- | -- |
| 0 | passed |

Here, we have checking if part time employees are assigned other fte_status. We are checking the employee table where fte>= 0.8 and fte_status is Part time. We are assuming that values below 0.8 are assigned as part time.

- 3. Check if termed employees are marked as active.
~~~~ sql
SELECT
  COUNT(*) AS impacted_record_count,
  CASE
    WHEN COUNT(*) > 0
     THEN 'failed'
    ELSE 'passed'
  END AS test_result
FROM employee
WHERE term_date IS  NOT NULL 
  AND is_active IS TRUE;
~~~~
| impacted_record_count | test_result |
| -- | -- |
| 0 | passed |

Here, term_reason is checked whether it is not null or not and is_active status is true. This results those data whose term reason is present and is_active is true

- 4. Check if the same product is listed more than once in a single bill.
~~~~ sql
SELECT
  COUNT(*) AS impacted_record_count,
  CASE
    WHEN COUNT(*) > 0
     THEN 'failed'
    ELSE 'passed'
  END AS test_result
FROM (
  SELECT 
    COUNT(product_id) as count
  FROM sales
  GROUP BY product_id, bill_no
  HAVING COUNT(*) > 1
  ) AS test_results;
~~~~
| impacted_record_count | test_result |
| -- | -- |
| 0 | passed |

Here, we have listed the data using group by product_id and bill_no as a one and couting those. We are using the condition if there is any record having count greater than 1 in data.

- 5. Check if the customer_id in the sales table does not exist in the customer table.
~~~~ sql
SELECT
  COUNT(*) AS impacted_record_count,
  CASE
    WHEN COUNT(*) > 0
     THEN 'failed'
    ELSE 'passed'
  END AS test_result
FROM (
  SELECT DISTINCT customer_id
   FROM sales
  EXCEPT
  SELECT DISTINCT customer_id
   FROM customer
  ) as test_results;
~~~~
| impacted_record_count | test_result |
| -- | -- |
| 0 | passed |

Here, we are using Except keyword returns the distinct rows automatically from sales table on  joining  customer_id.

- 6. Check if there are any records where updated_by is not empty but updated_date is empty.
~~~~ sql
SELECT
  COUNT(*) AS impacted_record_count,
  CASE
    WHEN COUNT(*) > 0
      THEN 'failed'
    ELSE 'passed'
  END AS test_result
FROM sales
WHERE updated_date IS NULL 
  AND updated_by IS NOT NULL;
~~~~
| impacted_record_count | test_result |
| -- | -- |
| 57 | failed |

Here, we are checking the condition where update date field is null and updated by field is not null on sales table.

- 7. Check if there are any hours worked that are greater than 24 hours.
~~~~ sql
SELECT
  COUNT(*) AS impacted_record_count,
  CASE
    WHEN COUNT(*) > 0
     THEN 'failed'
    ELSE 'passed'
  END AS test_result
FROM timesheet
GROUP BY employee_id,shift_date
Having SUM(hours_worked) > 24;
~~~~
| impacted_record_count | test_result |
| -- | -- |
| 0 | passed |

Here, we are assuming that the timesheet table might get duplicate data sometimes so, we are grouping the feild using employee_id and shift_date. Then we are using having condition where sum of hours_worked > 24.

- 8. Check if non on-call employees are set as on-call.
~~~~ sql
SELECT 
  COUNT(*) AS impacted_record_count,
  CASE
    WHEN COUNT(*) > 0
     THEN 'failed'
    ELSE 'passed'
  END AS test_result
FROM timesheet
WHERE was_on_call IS FALSE 
  AND on_call_hour <> 0;
~~~~
| impacted_record_count | test_result |
| -- | -- |
| 0 | passed |

Here, we are checking whether the was_on_call is true and on-call employees's hour is there and if the on-call hour is not qual to 0, then it says there is non on-call employees are set as on-call.

- 9. Check if the break is true for employees who have not taken a break at all.
~~~~ sql
SELECT 
  COUNT(*) AS impacted_record_count,
  CASE
    WHEN COUNT(*) > 0
     THEN 'failed'
    ELSE 'passed'
  END AS test_result
FROM timesheet
WHERE has_taken_break IS TRUE 
AND break_hour = 0;
~~~~
| impacted_record_count | test_result |
| -- | -- |
| 0 | passed |

Here, we are using timesheet table for the data validation, has_taken_break is TRUE and break hour is 0.

- 10. Check if the night shift is not assigned to the employees working on the night shift.
~~~~ sql 
SELECT 
  COUNT(*) AS impacted_record_count,
  CASE
    WHEN COUNT(*) > 0
     THEN 'failed'
    ELSE 'passed'
END AS test_result
FROM timesheet
WHERE shift_start_time BETWEEN '19:00:00' AND '6:00:00'
  AND shift_type <> 'Night';
~~~~
| impacted_record_count | test_result |
| -- | -- |
| 0 | passed |

Here, we are checking the shift_start time that has been provided by extracting from timesheet_raw dataset. If the shift start date is between 17:00:00 and 06:00:00 then we call them as night shift.Then we are followed by shift type check as not Night.

