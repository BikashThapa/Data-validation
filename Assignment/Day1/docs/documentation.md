# Data validation - Day 1
 We have created the table for the data storage for each data. Those database schema dessign are listed in the schema section of the project.

## Test case 1
 - 1.Check if a single employee is listed twice with multiple ids.

>SELECT
>COUNT(*) AS impacted_record_count,
>CASE
>WHEN COUNT(*) > 0 THEN 'failed'
>ELSE 'passed'
>END AS test_result
>FROM(
>SELECT COUNT(*)
>FROM employee
>GROUP BY client_employee_id
>HAVING COUNT(*) >1
>) as test_result;


Here we have checking for the single employee is listed twice with multiple id. We have dealed this approach with first grouping the client_employee_id on its basis and counting those number, if greater than 1. if 2 is present the result gives failed.
