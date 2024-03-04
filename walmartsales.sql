-- create table first
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
ADD COLUMN time_of_day VARCHAR(10),
ADD COLUMN day_name VARCHAR(10),
ADD COLUMN month_name VARCHAR(10);

-- set the value for time of day
UPDATE walmartsales 
SET time_of_day = 
    CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'morning'
        WHEN time BETWEEN '12:00:01' AND '16:00:00' THEN 'afternoon'
        ELSE 'evening'
    END;

-- set the value for day name
UPDATE walmartsales
SET day_name = to_char(date, 'Day');

-- set the value for month name
UPDATE walmartsales
SET month_name = to_char(date, 'Month');

