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


