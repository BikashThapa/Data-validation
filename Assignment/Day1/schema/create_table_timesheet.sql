CREATE TABLE timesheet(
employee_id VARCHAR(255) NOT NULL,
department_id VARCHAR(255) NOT NULL,
shift_start_time VARCHAR(255),
shift_end_time VARCHAR(255),
shift_date DATE NOT NULL,
shift_type VARCHAR(255),
hours_worked FLOAT NOT NULL,
attendence BOOLEAN NOT NULL,
has_taken_break BOOLEAN NOT NULL,
break_hour FLOAT NOT NULL,
was_charge BOOLEAN NOT NULL,
charge_hour FLOAT NOT NULL,
was_on_call BOOLEAN NOT NULL,
on_call_hour FLOAT NOT NULL,
num_teammates_absent SMALLINT NOT NULL
);
