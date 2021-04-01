# Analysis of Pewlett Hackard
## Overview of the analysis
I was given 6 .csv files with data related to employees of Pewlett Hackard company. The goal was to create relational database and conduct the analysis of retiring employees.
To complete the project I’ve used pgAdmin 4.

## Results
I've created physical ERD using QuickDBD. Based on it I've uploaded CSV file to pdAdmin and created database of employees.
![](https://github.com/angkohtenko/Pewlett-Hackard-Analysis/blob/main/EmployeeDB.png)

I wrote SQL queries to retrieve data of current employees, managers, employees who are retiring soon, their titles, and saved all of that to csv tables in [Data folder](https://github.com/angkohtenko/Pewlett-Hackard-Analysis/tree/main/Data).

Then I conducted analysis of [retiring employees by title](https://github.com/angkohtenko/Pewlett-Hackard-Analysis/blob/main/Data/retiring_titles.csv) and revealed that the majority of retiring employees have senior position.

During the analysis I revealed:
- Some employees have switched titles over the years that caused duplicate values:

![](https://github.com/angkohtenko/Pewlett-Hackard-Analysis/blob/main/duplicate_values.png)

- 90,398 employees will retire soon.

- The majority of retiring employees have senior position:

![](https://github.com/angkohtenko/Pewlett-Hackard-Analysis/blob/main/Retiring_employees_by_title.png)

- 1,549 employees are eligible for mentorship program.


## Summary

I've done additional analysis related to number of employees who are eligible for membership program and retiring soon. After executing the query:
```
SELECT DISTINCT
	COUNT(e.emp_no),
	CASE
		WHEN (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31') THEN 'Eligibile for mentorship'
		WHEN (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31') THEN 'Retiring soon'
		ELSE 'Not affected'
	END status
FROM
	employees as e
	INNER JOIN
		dept_emp as de
		ON de.emp_no = e.emp_no
WHERE de.to_date = '9999-01-01'
GROUP BY status
ORDER BY COUNT(e.emp_no);
```
I've got the result table:

![](https://github.com/angkohtenko/Pewlett-Hackard-Analysis/blob/main/number_of_employees.png)

That table gave me 2 insights:
- There are enough qualified, retirement-ready employees in the departments to mentor the next generation (72,458 retiring vs 1,549 eligible for mentorship)
- 72,458 roles will need to be filled soon.
However, I noticed that number of retiring employees in this table is less than in the initial analysis - 72,458 vs 90,398 people. During the calculation of retiring employees by title, people, who don't work for the company anymore, were not excluded. It's easy to do by adding where condition to the query for [unique_titles](https://github.com/angkohtenko/Pewlett-Hackard-Analysis/blob/main/Data/unique_titles.csv) table:
```
WHERE to_date = '9999-01-01'
```
So I created a new table that has all current employees with status column:
```
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
```

Then I made a query to group employees by title and status:

```
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
```

The result table proves that it is enough qualified, retirement-ready employees to mentor the next generation in every single department:

![](https://github.com/angkohtenko/Pewlett-Hackard-Analysis/blob/main/status_by_title_summary.png)



