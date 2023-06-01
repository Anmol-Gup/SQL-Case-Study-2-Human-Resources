-- SQL Challenge Questions
--1. Find the longest ongoing project for each department.
--Method-1
SELECT name,department_id,MAX(end_date-start_date) AS duration 
FROM projects
GROUP BY department_id,name
ORDER BY duration;

--Method-2
WITH longest_project
AS
(
  	SELECT department_id,MAX(end_date-start_date) AS duration FROM projects
	GROUP BY department_id
)
SELECT name,p.department_id,duration 
FROM longest_project lp
JOIN projects p
ON p.department_id=lp.department_id
WHERE end_date-start_date=duration;

--2. Find all employees who are not managers.
--Method-1
SELECT * FROM employees 
WHERE job_title NOT LIKE '%Manager%';

--Method-2
SELECT * FROM employees 
WHERE id NOT IN (SELECT DISTINCT manager_id FROM departments);

--3. Find all employees who have been hired after the start of a project in their department.
SELECT e.*,p.name,p.start_date FROM employees e JOIN projects p
ON p.id=e.department_id
WHERE hire_date>start_date;

--4. Rank employees within each department based on their hire date (earliest hire gets the highest rank).
SELECT name,hire_date,department_id, 
DENSE_RANK() OVER(PARTITION BY department_id ORDER BY hire_date) AS earlier_date_rank
FROM employees;

--5. Find the duration between the hire date of each employee and the hire date of the next employee hired in the same department.
WITH cte1
AS
(
  SELECT name,department_id,hire_date,
  LEAD(hire_date) OVER(PARTITION BY department_id) AS next_date
  FROM employees
)
SELECT cte1.name,d.name,next_date-hire_date AS hire_date_diff
FROM cte1 JOIN departments d
ON d.id=cte1.department_id
WHERE next_date IS NOT NULL
