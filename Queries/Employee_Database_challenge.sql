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





