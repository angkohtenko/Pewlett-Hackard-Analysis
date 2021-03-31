-- Retirement eligibility
SELECT 
	emp_no,
	first_name,
	last_name
INTO retirement_info
FROM employees
WHERE 
	(birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND
	(hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Joining departments and dept_manager tables
SELECT 
	d.dept_name,
    dm.emp_no,
    dm.from_date,
    dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
	ON d.dept_no = dm.dept_no;
	
-- Joining retirement_info and dept_emp tables
SELECT
	ri.*,
	de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
	on de.emp_no = ri.emp_no
	WHERE de.to_date = ('9999-01-01');


-- Employee count by department number
SELECT 
	COUNT(ce.emp_no), 
	de.dept_no
INTO retirement_by_dept
FROM current_emp as ce
LEFT JOIN dept_emp as de
	ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;


-- Employee information
SELECT
	e.emp_no,
	e.last_name,
	e.first_name,
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM
	employees as e
	INNER JOIN
		salaries as s
		ON s.emp_no = e.emp_no
	INNER JOIN
		dept_emp as de
		ON de.emp_no = e.emp_no
WHERE 
	(birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND
	(hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	AND
	de.to_date = ('9999-01-01');

-- A list of managers for each department
SELECT
	dm.dept_no,
	d.dept_name,
	dm.emp_no,
	e.last_name,
	e.first_name,
	dm.from_date,
	dm.to_date
INTO manager_info
FROM
	dept_manager as dm
	INNER JOIN
		departments as d
		ON d.dept_no = dm.dept_no
	INNER JOIN
		current_emp as e
		ON e.emp_no = dm.emp_no;


-- Department Retirees
SELECT
	ce.emp_no,
	ce.first_name,
	ce.last_name,
	de.dept_no,
	d.dept_name
INTO dept_info
FROM 
	current_emp as ce
	INNER JOIN
		dept_emp as de
		ON de.emp_no = ce.emp_no
	INNER JOIN
		departments as d
		ON d.dept_no = de.dept_no;

-- Retirement info for Sales and Development
SELECT
	ri.*,
	d.dept_name
FROM
	retirement_info ri
	INNER JOIN
		dept_emp as de
		ON de.emp_no = ri.emp_no
	INNER JOIN
		departments as d
		ON d.dept_no = de.dept_no
WHERE d.dept_name in ('Sales','Development');




