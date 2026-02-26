show tables;

-- DROPING THE TABLE IS ALREADY EXISTS
DROP TABLE IF EXISTS retail_sales;

-- CREATING TABLES 
CREATE TABLE retail_sales
(
	transactions_id INT,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,	
    gender VARCHAR(50),
	age	INT,
    category VARCHAR(50),	
    quantiy	INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

-- REVIEWING DATA
SELECT 
    *
FROM
    retail_sales
LIMIT 10;

-- COUNTING NUMBER OF ROWS 
select count(*) from retail_sales;

-- CHECKING FOR DUPLICATES 
SELECT COUNT(DISTINCT transactions_id) FROM retail_sales;

