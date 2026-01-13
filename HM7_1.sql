-- Roles: Angle: Manager, Kyle : Spokesperson, Ridge : Quality Assurance, Kaleb : Process Analyst

/*
Easily readable column names
Numbers should be formatted as ‘##,###.##’.  
Employee names should be returned in one column as Last Name, First Name.  
Any null values should be replaced with a 0 if it’s a numeric field or a space if it’s a character field
*/

/*1.Find the total dollar amount ordered for all products in our product line of Planes. 
Display the product code, product description, and total amount ordered for that product.
*/
select 
	products.productCode as 'Product Code',
	products.productName as 'Product Name',
	ifnull(products.productDescription, ' ') as 'Description',
	format(sum(orderdetails.quantityOrdered * orderdetails.priceEach), 2) as 'Total Dollar Amount Ordered'
from products
	join orderdetails on products.productCode = orderdetails.productCode
where products.productLine = 'Planes'
group by products.productCode, products.productName, products.productDescription;

/*
2.Find all the orders from customers managed by the London office. 
Display the employee’s name, customer name, order number, total dollar amount for the order. 
Order by customer name in alphabetical order (ascending). 
*/
select 
	concat(employees.lastName, ', ', employees.firstName) as 'Employee Name',
	customers.customerName as 'Customer Name',
	orders.orderNumber as 'Order Number',
	format(sum(orderdetails.quantityOrdered * orderdetails.priceEach), 2) as 'Total Dollar Amount'
from offices
	join employees on offices.officeCode = employees.officeCode
	join customers on employees.employeeNumber = customers.salesRepEmployeeNumber
	join orders on customers.customerNumber = orders.customerNumber
	join orderdetails on orders.orderNumber = orderdetails.orderNumber
where offices.city = 'London'
group by employees.lastName, employees.firstName, customers.customerName, orders.orderNumber
order by customers.customerName asc;

-- 3.Find all the products that haven’t been ordered by anyone. Display the product code, name, and description.
select 
	products.productCode as 'Product Code',
	products.productName as 'Product Name',
	ifnull(products.productDescription, ' ') as 'Description'
from products
	left join orderdetails on products.productCode = orderdetails.productCode
where orderdetails.productCode is null;


/*
4.Find the total dollar amount ordered per customer for ALL customers.  
Display the customer’s name and the total dollar amount ordered.  
Order by total amount in descending order and customer name in alpha order (ascending). 
NOTE – payments are not equal to orders. Several of our customers have orders that have not been paid yet.
*/
select 
	customers.customerName as 'Customer Name',
	format(ifnull(sum(orderdetails.quantityOrdered * orderdetails.priceEach), 0), 2) as 'Total Dollar Amount Ordered'
from customers
	left join orders on customers.customerNumber = orders.customerNumber
	left join orderdetails on orders.orderNumber = orderdetails.orderNumber
group by customers.customerName
order by sum(orderdetails.quantityOrdered * orderdetails.priceEach) desc, customers.customerName asc;

/*
5.Find the total dollar amount paid per customer for ALL customers. 
Display the customer’s name and the total dollar amount paid.  
Order by total amount in descending order and customer name in alpha order (ascending). 
*/
select 
	customers.customerName as 'Customer Name',
	format(ifnull(sum(payments.amount), 0), 2) as 'Total Dollar Amount Paid'
from customers
	left join payments on customers.customerNumber = payments.customerNumber
group by customers.customerName
order by sum(payments.amount) desc, customers.customerName asc;
