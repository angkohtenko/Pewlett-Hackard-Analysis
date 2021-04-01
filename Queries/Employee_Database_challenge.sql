-- Deliverable 1: The Number of Retiring Employees by Title

SELECT
	e.emp_no,
	e.first_name,
	e.last_name,
	tt.title,
	tt.from_date,
	tt.to_date
INTO retirement_titles
FROM
	employees as e
	INNER JOIN
		titles as tt
		ON tt.emp_no = e.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;



SELECT DISTINCT ON (emp_no)
	emp_no,
	first_name,
	last_name,
	title
INTO unique_titles
FROM
	retirement_titles
-- 	WHERE to_date = '9999-01-01'
ORDER BY emp_no ASC, 
		to_date DESC;



SELECT
	COUNT(title),
	title
INTO retiring_titles	
FROM
	unique_titles
GROUP BY title
ORDER BY COUNT(title) DESC;

-- Deliverable 2: The Employees Eligible for the Mentorship Program
SELECT DISTINCT ON (e.emp_no)
	e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	tt.title
INTO mentorship_eligibilty
FROM
	employees as e
	INNER JOIN
		dept_emp as de
		ON de.emp_no = e.emp_no
	INNER JOIN
		titles as tt
		ON tt.emp_no = e.emp_no
WHERE 
	(e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
	AND
	(de.to_date = '9999-01-01')
ORDER BY e.emp_no;




-- Deliverable 3: additional analysis
-- Create table of employees with status column
SELECT DISTINCT ON (e.emp_no)
	e.emp_no,
	tt.title,
	tt.to_date as hold_title_to_date,
	e.birth_date,
	de.to_date as work_to_date,
	CASE
		WHEN (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31') THEN 'Eligibile for mentorship'
		WHEN (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31') THEN 'Retiring soon'
		ELSE 'Not affected'
	END status
INTO eligibility_status
FROM
	employees as e
	INNER JOIN
		dept_emp as de
		ON de.emp_no = e.emp_no
	INNER JOIN
		titles as tt
		ON tt.emp_no = e.emp_no
WHERE de.to_date = '9999-01-01'
ORDER BY 
	e.emp_no, tt.to_date DESC;

-- Get status by title
SELECT
	COUNT(emp_no),
	title,
	status
FROM
	eligibility_status
GROUP BY
	title,
	status
ORDER BY
	title,
	COUNT(emp_no);







