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



-- CHECKING FOR NULL VALUES FOR ALL COLUMNS 
SELECT 
    *
FROM
    retail_sales
WHERE
    transactions_id IS NULL
        OR sale_date IS NULL
        OR sale_time IS NULL
        OR customer_id IS NULL
        OR gender IS NULL
        OR age IS NULL
        OR category IS NULL
        OR quantiy IS NULL
        OR price_per_unit IS NULL
        OR cogs IS NULL
        OR total_sale IS NULL;
   
   
-- DELETING THE NULL VALUES
DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
        OR sale_date IS NULL
        OR sale_time IS NULL
        OR customer_id IS NULL
        OR gender IS NULL
        OR age IS NULL
        OR category IS NULL
        OR quantiy IS NULL
        OR price_per_unit IS NULL
        OR cogs IS NULL
        OR total_sale IS NULL;
    
    
-- DATA EXPLORATION 

-
-- HOW MANY SALES WE HAVE?
SELECT COUNT(*) AS TOTAL_SALE FROM retail_sales;

-- HOW MANY CUSTOMERS WE HAVE?
SELECT COUNT(distinct customer_id) as TOTAL_CUSTOMER FROM retail_sales;

-- how many categories we have 
SELECT DISTINCT category from retail_sales;



-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
 SELECT * 
 FROM retail_sales
 WHERE sale_date = '2022-11-05';
 
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE category = "Clothing"
and quantiy >= 4
and year(sale_date)=2022
and month(sale_date)=11;


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
	category,
    SUM(total_sale) as net_sale,
    count(*) as total_orders
 FROM retail_sales
 group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select
	avg(age) as average_age
from 
	retail_sales
where category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select
	*
from
	retail_sales
where
	total_sale > 1000;
    

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
    gender, category, COUNT(*) AS total_transaction
FROM
    retail_sales
GROUP BY gender , category
order by category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select year,month,average_sale from (
SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    ROUND(AVG(total_sale), 2) AS average_Sale,
    
    rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as best_month
FROM
    retail_sales
GROUP BY 1 , 2
) as t1
where best_month = 1;

-- ORDER BY 1 , 3 DESC;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
    customer_id, SUM(total_sale) AS total_sale
FROM
    retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
    category, COUNT(DISTINCT customer_id) AS count_unique_customer
FROM
    retail_sales
GROUP BY category;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

with hourly_sale as 
(
SELECT 
    *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'afternoon'
        ELSE 'evening'
    END AS shift
FROM
    retail_sales
 )
SELECT 
    shift, COUNT(*)
FROM
    hourly_Sale
GROUP BY shift;


                                  -- END OF PROJECT --




