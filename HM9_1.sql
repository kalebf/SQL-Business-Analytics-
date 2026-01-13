drop schema if exists sandbox;
create schema sandbox;
use sandbox;

create table currentSalaries as
select 
	employees.emp_no as emp_no, 
	employees.last_name as last_name,
	employees.first_name as first_name,
    employees.gender as gender,
    departments.dept_no as dept_no,
    departments.dept_name as dept_name,
	dept_emp.from_date as start_date, -- Current department start date
    case dept_manager.to_date -- Current department start date
		when '9999-01-01' then 'Yes'
        else null
	end as current_manager,
	salaries.salary as current_salary,
    (
    select ss.salary -- ss for starting salary
	from CS3100.salaries as ss
	where ss.emp_no = employees.emp_no
	and ss.from_date = (
        select max(ss2.from_date)
		from CS3100.salaries ss2
		where ss2.emp_no = employees.emp_no
		and ss2.from_date <= dept_emp.from_date
		)) as starting_salary -- Starting salary for their current department
        
from CS3100.employees
	join CS3100.dept_emp on employees.emp_no = dept_emp.emp_no
	join CS3100.departments on dept_emp.dept_no = departments.dept_no
	left join CS3100.dept_manager on employees.emp_no = dept_manager.emp_no
	join CS3100.salaries on employees.emp_no = salaries.emp_no
where salaries.to_date = '9999-01-01'
and dept_emp.to_date = '9999-01-01';

