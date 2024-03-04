-- create database first 

-- create table next
CREATE TABLE public.walmartsales
(
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct NUMERIC(6,4) NOT NULL, -- Changed FLOAT to NUMERIC with precision and scale
    total DECIMAL(12, 4) NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT, -- Removed precision and scale for FLOAT
    gross_income DECIMAL(12, 4),
    rating FLOAT -- Removed precision and scale for FLOAT
);

-- create column for time of day, day name and month name
ALTER TABLE walmartsales 
ADD COLUMN time_name VARCHAR(10),
ADD COLUMN day VARCHAR(10),
ADD COLUMN month VARCHAR(10);

-- set the value for time of day
UPDATE walmartsales 
SET time_name = 
    CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'morning'
        WHEN time BETWEEN '12:00:01' AND '16:00:00' THEN 'afternoon'
        ELSE 'evening'
    END;

-- set the name for day
UPDATE walmartsales
SET day = to_char(date, 'Day');

-- set the name for month 
UPDATE walmartsales
SET month = to_char(date, 'Month');

-------------Sales------------
--What is the total sales revenue for each product line?
SELECT 
	product_line, 
	SUM(total) AS total_sales 
FROM walmartsales
GROUP BY product_line
ORDER BY total_sales DESC;

--How does sales revenue vary across different branches/cities?
SELECT 
	city, 
	SUM(total) AS total_sales 
FROM walmartsales
GROUP BY city
ORDER BY total_sales DESC;

--What are the top-selling products by quantity sold?
SELECT 
	product_line,
	SUM(quantity) AS Total_qty
FROM walmartsales
GROUP BY product_line
ORDER BY Total_qty;

--How does sales performance vary over time (daily, weekly, monthly)?
SELECT time, Date, time_name, day, month,
	   SUM(Total) AS daily_sales_revenue
FROM walmartsales
GROUP BY time, Date, time_name, day, month
ORDER BY Date, time;

--What is the distribution of sales by payment method?
SELECT payment,
	   SUM(Total) AS Total_sales
FROM walmartsales
GROUP BY payment
ORDER BY Total_sales;

--How does sales revenue compare between different customer types (e.g., member vs. non-member)?
SELECT customer_type,
		SUM(Total) AS total_sales
FROM walmartsales
GROUP BY customer_type;

--What is the average transaction value per customer?
SELECT AVG(Total) AS avg_transaction
FROM walmartsales;

------Demographic-----------
--What is the distribution of customers by gender?--
SELECT Gender, Count(*) AS customer_count
FROM walmartsales
GROUP BY Gender;

--How does customer demographics vary between different branches/cities?
SELECT gender, city, count(*) AS customer_count FROM walmartsales
GROUP BY gender, city
ORDER BY gender, city;
--Are there any differences in purchasing behavior between male and female customers?

SELECT 
  gender, payment, 
  COUNT(*) AS customer_count,
  SUM(total) AS total_spent
FROM walmartsales
GROUP BY gender, payment
ORDER BY gender, payment;


SELECT 
	Gender, 
	AVG(Total) AS average_purchase_amount
FROM walmartsales
GROUP BY Gender;

--What is the customer distribution for each product line?
SELECT 
	gender, product_line, 
	COUNT(*) AS customer_count 
FROM walmartsales
GROUP BY gender, product_line
ORDER BY gender, product_line;

--How does customer loyalty vary between different demographic segments?
SELECT 
	gender, customer_type, 
	AVG(rating) AS avg_rating
FROM walmartsales
GROUP BY gender, customer_type
ORDER BY gender, customer_type;

--How does customer lifetime value (CLV) differ between demographic groups
SELECT
    gender,
    customer_type,
    AVG(total) AS average_purchase_amount,
    COUNT(invoice_id) AS total_customers,
    AVG(total) * COUNT(invoice_id) AS clv
FROM walmartsales
GROUP BY gender, customer_type
ORDER BY gender, customer_type;

--when is the most visited time according to gender?
SELECT gender, month, day, time_name,
	   COUNT(*) AS total_visit
FROM walmartsales
GROUP BY gender, month, day, time_name
ORDER BY gender, month, day, time_name;

--------Financial---------
--What is the gross margin percentage for each sale?
SELECT Invoice_ID, (gross_income / Total) * 100 AS gross_margin_percentage
FROM walmartsales;

--How does the cost of goods sold (COGS) vary over time?
SELECT month, SUM(cogs) AS total_cogs FROM walmartsales
GROUP BY month;

--What is the total tax revenue generated?
SELECT SUM(tax_pct) AS total_tax FROM walmartsales;

--What are the operating expenses for each branch/city?
SELECT city,
		SUM(cogs) AS total_expense
FROM walmartsales
GROUP BY city;

--What is the net profit for each sale?
SELECT 
	product_line, 
	SUM(cogs) AS cost, 
	SUM(Total) AS sales,
	SUM(gross_income) AS profit
FROM walmartsales
GROUP BY product_line
ORDER BY profit DESC;

------Customer Response-------
------Customer Response-------
--What is the average customer rating for each product line?
SELECT product_line, AVG(rating) AS avg_rating
FROM walmartsales
GROUP BY product_line;

--How does customer satisfaction vary by branch/city?
SELECT city, AVG(rating) AS avg_rating
FROM walmartsales
GROUP BY city;

--How does customer satisfaction vary by gender?
SELECT gender, AVG(rating) AS avg_rating
FROM walmartsales
GROUP BY gender;

--Are there any trends in customer feedback over time?
SELECT time_name,
	   AVG(rating) AS avg_rating
FROM walmartsales
GROUP BY time_name
ORDER BY avg_rating;

SELECT day,
	   AVG(rating) AS avg_rating
FROM walmartsales
GROUP BY day
ORDER BY avg_rating;

SELECT month,
	   AVG(rating) AS avg_rating
FROM walmartsales
GROUP BY month
ORDER BY avg_rating;

--What is the correlation between customer ratings and sales revenue?
SELECT product_line, AVG(rating) AS avg_rating, SUM(total) as total_sales, SUM(gross_income) As Total_profit
FROM walmartsales
GROUP BY product_line
ORDER BY avg_rating;

SELECT city, AVG(rating) AS avg_rating, SUM(total) as total_sales, SUM(gross_income) As Total_profit
FROM walmartsales
GROUP BY city
ORDER BY avg_rating;