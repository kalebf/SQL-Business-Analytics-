/*
1.	Create view is a DDL command (True or False): True
2.	A view is a permanent structure of a schema until dropped (True or False): True
3.	A view stores data (True or False): False
*/

/*
The following queries all use the classic model’s schema. Remember to format your output in a readable fashion. 
Make sure to include all of your code, including the code to create views for the last question. 
*/

-- 4.Using a subquery, find what employees report directly to the VP Sales?  List their name and their job title.  (10 points)
select     
	concat(emp.lastName, ', ', emp.firstName) as 'Employee Name',
    emp.jobTitle as 'Job Title'
from employees as emp
where emp.reportsTo = (
	select employeeNumber
	from employees
	where jobTitle = 'VP Sales');
			
-- 5.Assuming a sales commission of 5% on every order, calculate the sales commission due for all employees. List the employee’s name and the sales commission they are due.(10 points)
select 
	concat(emp.lastName, ', ', emp.firstName) as 'Employee Name',
	format(ifnull(sum(od.quantityOrdered * od.priceEach) * 0.05, 0), 2) as 'Sales Commission'
from employees emp
	left join customers c on emp.employeeNumber = c.salesRepEmployeeNumber
	left join orders o on c.customerNumber = o.customerNumber
	left join orderdetails od on o.orderNumber = od.orderNumber
group by emp.employeeNumber;


/*
6.Create a list of all customers and the amount they currently owe us.  List the customer’s name and the amount due.  
Create views to track the total amount ordered and the total amount paid.  Use these views to create your final query.  
Important – do not format interim numeric results.  If you need to round numbers use the round function. 
Don’t format your numbers until your final query.  Having imbedded commas in numeric fields can cause math problems. 
*/
create or replace view TotalOrdered as
select
    o.customerNumber,
    sum(od.quantityOrdered * od.priceEach) as TotalOrdered
from orders o
    join orderdetails od on o.orderNumber = od.orderNumber
group by o.customerNumber;

create or replace view TotalPaid as
select
    p.customerNumber,
    sum(p.amount) as TotalPaid
from payments p
group by p.customerNumber;

select
    c.customerName as 'Customer Name',
    format(ifnull(t1.TotalOrdered, 0), 2) as 'Total Ordered',
    format(ifnull(t2.TotalPaid, 0), 2) as 'Total Paid',
    format(ifnull(t1.TotalOrdered, 0) - ifnull(t2.TotalPaid, 0), 2) as 'Amount Owed'
from customers c
    left join TotalOrdered t1 on c.customerNumber = t1.customerNumber
    left join TotalPaid t2 on c.customerNumber = t2.customerNumber
order by c.customerName;



