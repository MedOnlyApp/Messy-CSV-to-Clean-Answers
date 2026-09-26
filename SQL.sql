---------------- Customer-focused questions ----------------

-- How many total customers do we have?
SELECT COUNT(*) AS "Number of Costumers" FROM costumers;

-- Which customers have never placed an order?
SELECT * FROM costumers
LEFT JOIN orders ON costumers.customer_id = orders.customer_id
WHERE orders.order_id IS NULL;

-- Who are our top 10 customers by total spend?
SELECT costumers.customer_id,
		SUM(products.price*orders.quantity) AS "Total Spent" 
		FROM costumers
JOIN orders ON costumers.customer_id = orders.customer_id
Join products ON orders.product_id = products.product_id
GROUP BY costumers.customer_id
ORDER BY SUM(products.price*orders.quantity) DESC
LIMIT 10;

-- What's the average order value per customer?
SELECT costumers.customer_id,
		AVG(products.price*orders.quantity) AS "Average Order Value" 
		FROM costumers
JOIN orders ON costumers.customer_id = orders.customer_id
Join products ON orders.product_id = products.product_id
GROUP BY costumers.customer_id;

-- Which customers made a purchase in the last 30/60/90 days? (customer recency)
SELECT customer_id FROM orders
WHERE order_date::DATE >= (SELECT order_date FROM orders ORDER BY order_date DESC LIMIT 1)::Date - INTERVAL '90 days' 
ORDER BY order_date DESC;

-- Which customers haven't ordered in the last 6 months? (churn risk)



-- What's the distribution of customers by signup date, City?
SELECT 
		signup_date AS "SignUp Date",
		COUNT(customer_id) AS "Customer Distribution" 
FROM costumers
GROUP BY signup_date;

SELECT 
		city AS "City",
		COUNT(customer_id) AS "Customer Distribution" 
FROM costumers
GROUP BY city;

-- Who are our one-time buyers vs. repeat buyers?
SELECT 
		c.customer_id, 
		COUNT(o.order_id) 
FROM costumers AS c
LEFT JOIN orders AS o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY COUNT(o.order_id);

-- What's the average number of orders per customer?
SELECT AVG(Order_Count) AS "Average Orders/Customer" FROM (
	SELECT 
			c.customer_id, 
			COUNT(o.order_id) AS Order_Count
	FROM costumers AS c
	LEFT JOIN orders AS o ON c.customer_id = o.customer_id
	GROUP BY c.customer_id
);


---------------- Product-focused questions ----------------

-- What are the top 10 best-selling products by quantity sold?
SELECT 
		o.product_id, 
		p.product_name,
		COUNT(o.quantity) 
FROM orders AS o
LEFT JOIN products AS p ON o.product_id = p.product_id
GROUP BY 1, 2
ORDER BY COUNT(quantity) DESC
LIMIT 10;


-- What are the top 10 products by revenue?
SELECT 
		o.product_id, 
		p.product_name,
		ROUND(SUM(o.quantity * p.price)::numeric, 2) AS "Revenue"
FROM orders AS o
LEFT JOIN products AS p ON o.product_id = p.product_id
GROUP BY 1, 2
ORDER BY SUM(o.quantity * p.price) DESC
LIMIT 10;

-- Which products have never been ordered?
SELECT p.product_id, p.product_name FROM products AS p
LEFT JOIN orders AS o ON p.product_id = o.product_id
WHERE o.order_id IS NULL;

-- What's the average price per product category (if you have categories)?
SELECT
		category,
		ROUND(AVG(price)::numeric, 2)
FROM products
GROUP BY category;

-- Which product categories generate the most revenue?
SELECT 
		category,
		ROUND(SUM(p.price * o.quantity)::numeric, 2) AS "Revenue"
FROM products AS p
LEFT JOIN orders AS o ON p.product_id = o.product_id
GROUP BY category
ORDER BY SUM(p.price * o.quantity) DESC;


---------------- Order-focused questions ----------------

-- How many total orders have been placed?
SELECT COUNT(*) AS "Total Orders" FROM orders;

-- What's the total revenue to date?
SELECT ROUND(SUM(p.price * o.quantity)::numeric, 2) AS "Total Revenue" FROM orders AS o
LEFT JOIN products AS p ON o.product_id = p.product_id;

-- What's the average order value across all orders?
SELECT ROUND(AVG(revenue)::numeric, 2) AS "Average Order Value Across all Orders" FROM (
		SELECT order_id, SUM(p.price * o.quantity) AS revenue FROM orders AS o
		LEFT JOIN products AS p ON o.product_id = p.product_id
		GROUP by order_id
		);

-- What's the monthly/quarterly revenue trend? (time series)


-- What's the order volume by day of week or time of day? (seasonality)
SELECT order_date, COUNT(order_id) FROM orders
GROUP BY order_date
ORDER BY order_date DESC;

-- What's the average number of items per order?
SELECT ROUND(AVG(quantity)::numeric, 2) AS "Average Number of Items per Order" FROM orders;


-- What percentage of orders are above/below a certain value threshold?


-- What's the month-over-month growth rate in orders or revenue?


---------------- Cross-table / relationship questions (the meaty ones) ----------------

-- What is each customer's full order history (customer + order + product join)?
SELECT 
		c.customer_id,
		o.order_id,
		p.product_id,
		p.product_name,
FROM costumers AS c
LEFT JOIN orders AS o ON c.customer_id = o.customer_id
LEFT JOIN products AS p ON o.product_id = p.product_id
ORDER BY 1 ASC;

-- Which customer segment (e.g., by spend tier) buys which product categories most?


-- What's the customer lifetime value (CLV) — total revenue per customer over their whole relationship?


-- What's the revenue contribution of the top 20% of customers? (Pareto/80-20 analysis)


-- Which products drive the most revenue per customer segment?


-- What's the average time between a customer's first and second order? (repeat purchase behavior)


-- Which products are most associated with high-value customers vs. low-value customers?


-- What's the cohort retention rate — of customers who first ordered in month X, what % ordered again in month X+1, X+2, etc.?


-- What's the correlation between order frequency and average order value — do frequent buyers spend less per order or more?

