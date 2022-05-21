-- Part 1: Filters

-- 1.1
-- Select all columns from the categories table.
-- Use an ORDER BY clause to sort the results by category_id.
SELECT *
FROM categories
ORDER BY category_id;

-- 1.2
-- Select each city from the employees table without any duplicates
-- and sort in descending order.
SELECT DISTINCT city
FROM employees
ORDER BY city DESC;

-- 1.3
-- Select product_id and product_name of all discontinued products
-- and sort by product_id.
--
-- Hint: only include products for which the discontinued column is true.
SELECT product_id, product_name
FROM products
WHERE discontinued is true
ORDER BY product_id;

-- 1.4
-- Select the first_name and last_name of employees who do not have anyone to report to
-- (i.e. their reports_to field is blank).
-- Sort by employee_id.
SELECT first_name, last_name
FROM employees
WHERE reports_to IS null
ORDER BY employee_id;

-- 1.5
-- Select the product_name of each product where the units_in_stock is less than
-- or equal to the reorder_level.
-- You only need the products that are not discontinued and only include
-- products that have more than 0 units_on_order.
-- Sort the results by product_id.
--
-- Hint: start simple, do the select without any restrictions and confirm you're
-- getting the data you expect. Then add each of the restrictions one by one.
SELECT product_name
FROM products
WHERE discontinued is false AND units_in_stock <= reorder_level AND units_on_order > 0
ORDER BY product_id;

-- Part 2: Functions, Grouping
-- Here are some real queries you might be asked on a day-to-day basis.
-- Sometimes SQL is the fastest and most elegant way to get this data.

-- 2.1
-- How many orders have been made?
SELECT COUNT (*) 
FROM orders ;

-- 2.2
-- How many orders has each customer made?
-- For each customer, select customer_id and the count of their orders.
-- Sort first by the order-count (greatest to least), then customer_id (alphabetically)
SELECT customer_id, COUNT(order_id) AS order_count
FROM orders GROUP BY customer_id
ORDER BY order_count DESC, customer_id;

-- 2.3
-- Where are we shipping a lot of orders to?
-- Select the ship_address and the count of orders for the ship_address that
-- has received the most orders.
--
-- Note: consider how we might extend this query, applying it to each customer. 
-- Combined with a location-based mapping service, you could easily see where you're selling a lot of products,
-- and where you might want to focus more advertising - a great data science application!
-- We will take a closer look at data science and data visualizations in a future lesson.
SELECT ship_address, COUNT (*) AS address_count
FROM orders GROUP BY ship_address
ORDER BY address_count DESC LIMIT 1;

-- 2.4
-- Who could we offer our new freight discount campaign to?
-- For each customer, select customer_id and the total amount spent on freight
-- across all of their orders. Only include those who have spent more than $500.
-- Sort by customer_id.
SELECT customer_id, SUM(freight) AS freight_count
FROM orders GROUP BY customer_id
HAVING(SUM(freight)) > 500
ORDER BY customer_id;

-- 2.5
-- We want to offer white glove shipping to our best customers.
-- But first, do we need to consolidate the shippers we use? How many different
-- shippers do our customers normally deal with?
-- For each customer, count how many different shippers have ever sent them an order.
-- Then, select the average of those counts.
--
-- Hint: ship_via is a foreign key column in orders that references shippers.
WITH shippers_per_customer AS 
(SELECT customer_id, COUNT(DISTINCT ship_via)
FROM orders
GROUP BY customer_id)
SELECT AVG(COUNT) 
FROM shippers_per_customer;



-- Part 3: Mix and Match

-- 3.1
-- Let's review our product categories.
-- List each product_name and its corresponding category_name.
-- Do not include products that have a null category_id
-- Sort by product_id.
--
-- Hint: check which join type you should use in this situation.
SELECT pn.product_name AS product_name,
c.category_name AS category_name
FROM products pn
JOIN categories c
ON pn.category_id = c.category_id
ORDER BY product_id
-- 3.2
-- HR wants to do a staff audit across the regions.
-- List region_description, territory_description, employee last_name,
-- and employee first_name for each territory and region an employee works in.
--
-- To make it easier for them, remove duplicate results and also sort first by
-- region_description, then territory_description, then last_name, and finally first_name.
--
-- Hint: joins can only take two tables at a time, but you use multiple joins in
-- one query by listing each after the other.
-- Try an inner join on employees -> employees_territories -> territories -> regions
SELECT DISTINCT r.region_description, t.territory_description, e.last_name, e.first_name
FROM employees e
JOIN employees_territories et ON e.employee_id = et.employee_id
JOIN territories t ON t.territory_id = et.territory_id
JOIN regions r ON r.region_id = t.region_id
ORDER BY region_description, territory_description, last_name, first_name;
-- 3.3
-- Finance wants to audit the sales tax rates we've applied and needs a list of
-- each customer in the different states.
-- List state_name, state_abbr, and company_name for all customers in the U.S.
-- If a state has no customers, still include it in the result with a NULL
-- placeholder for the company_name.
-- Sort by state_name.
--
-- Hint: match the customer's region on the state's abbreviation.
SELECT state_name, state_abbr,
c.company_name
FROM us_states u 
LEFT JOIN customers c 
ON u.state_abbr  = c.region
ORDER BY u.state_name;

-- 3.4
-- The Talent Acquisition team is looking to fill some open positions.
-- Select the territory_description and region_description for territories
-- that do not have any employees.
-- Sort by territory_id.
SELECT 
t.territory_description,
r.region_description
FROM territories t 
JOIN region r 
ON t.region_id = r.region_id
WHERE t.territory_id NOT IN (SELECT employees_territories.territory_id FROM employees_territories)
ORDER BY territory_id;

-- 3.5
-- Management needs a list of all suppliers' and customers' contact information 
-- for the holiday greeting cards!
-- Select company_name, address, city, region, postal_code, and country 
-- for all suppliers and all customers.
-- Sort by company_name.
SELECT company_name, address, city, region, postal_code, country FROM suppliers
UNION
SELECT company_name, address, city, region, postal_code, country FROM customers
ORDER BY company_name;


-- 3.6
-- And of course, our famous holiday gift baskets go out to our best customers.
-- Get customer company_name and the total quantity of products ever ordered by
-- said customer. Only select those that have ordered a total quantity of at
-- least 500.
-- Sort by total quantity in descending order.

SELECT
c.company_name SUM(od.quantity) AS Quantity
FROM order_details od
INNER JOIN
orders o 
ON od.order_id = o.order_id
JOIN customers c 
ON c.customer_id = o.customer_id
HAVING SUM(od.quantity) >= 500
ORDER BY DESC;