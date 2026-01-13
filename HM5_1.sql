-- Roles: Kyle : Manager, Ridge : Spokesperson, Kaleb: Quality Assurance, Angle : Process Analyst
/*
Write queries to return the appropriate data. For the queries below, remember that a “current”
record is defined as one having ‘9999-01-01’ in the to_date field. (50 points)
*/
-- 1. How many employees are older than 40? Don’t worry about only limiting to current employees. Check all employee records for anyone over 40.
select
	format(count(*),0)  as "Number of Employees over 40"
from employees
where timestampdiff(year,birth_date,curdate()) > 40;

-- 2. How many female employees were hired in 2006?
select
	format(count(*),0)  as "Number of female employees were hired in 2006"
from employees
where gender = 'F' and date_format(hire_date,'%Y') = 2006;

-- 3. How many employees were hired per year by gender? Columns should include the year, the gender and the number hired that year. Order by the number hired in descending order.
select
	date_format(hire_date,'%Y') as 'Year Hired',
		(case gender
			when 'M' then 'Male'
			when 'F' then 'Female'
		end) as 'Gender',
    format(count(*),0) as 'Number Hired'
    from employees
group by gender, date_format(hire_date,'%Y') -- group by gender and year
order by count(*) desc; 

-- 4. How many years did we hire more than 12,000 male employees? List the year and the total number hired that year?
select
	date_format(hire_date,'%Y') as 'Year Hired',
    format(count(*),0) as 'Number Hired'
    from employees
    where gender = 'M' #Only look at males
group by date_format(hire_date,'%Y') # group by year
having count(*) > 12000; #more than 12,000

-- 5. What is the average age of our employees by gender?
select #Does this want specific difference from day and month or just looking at years? Should it be an integer average or a decimal?
	(case gender
			when 'M' then 'Male'
			when 'F' then 'Female'
		end) as 'Gender',
	avg(timestampdiff(year,birth_date,curdate())) as 'Average Age'
	#round(avg(datediff(curdate(), birth_date) / 365.25), 2) as 'Average Age 2'
from employees
group by gender;

-- 6. How many unique first names do we have in our employee’s data?
select 
	format(count(distinct first_name),0) as 'Unique Fisrst Names' 
from employees;

-- 7. How many departments do we have that have more than 20,000 employees? List the department number, and the number of employees.

select 
	dept_no as 'Department Number',
	format(count(emp_no),0) as Departments
from dept_emp
where to_date = '9999-01-01'
group by dept_no
having count(emp_no) > 20000;

-- 8. List the unique current titles.
select distinct title as Titles
from titles
where to_date = '9999-01-01';


-- 9. How many salaries do we have ranging from 40,000 to 50,000 annually?
select 
	format(count(salary),0)
from salaries
where salary >= 40000
and salary <=50000;

-- 10. What are the current minimum, maximum, and average salaries?
select
	min(salary) as 'Min Salary',
	max(salary) as 'Max Salary',
	avg(salary) as 'Average Salary'
from salaries
where to_date = '9999-01-01';

