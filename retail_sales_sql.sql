-- crete database.
CREATE DATABASE retrail;

-- create table.
CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

SELECT COUNT(*) FROM retail_sales;

-- Data Cleaning 
SELECT * FROM retail_sales 
WHERE sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
    
SET SQL_SAFE_UPDATES = 0;

DELETE FROM retail_sales 
WHERE sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

-- Data Exploration
SELECT COUNT(*) FROM retail_sales;

SELECT COUNT(DISTINCT customer_id)
FROM retail_sales;

SELECT DISTINCT category 
FROM retail_sales;

-- Data Analysis and Business key problems & answers 

-- Write a SQL query to retrieve all columns for sales made on '2022-11-05'.
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022.
SELECT * FROM retail_sales
WHERE category = 'Clothing' AND quantity >=4 AND MONTH(sale_date) = 11 AND YEAR(sale_date) = 2022;

-- Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category, SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY category
ORDER BY total_sales;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(age),2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale >1000;

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category , gender, COUNT(*) as total_num_of_transactions 
FROM retail_sales
GROUP BY category, gender
ORDER BY total_num_of_transactions DESC;

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year. 
WITH sales as (
SELECT YEAR(sale_date) as year, MONTH(sale_date) as month, ROUND(AVG(total_sale),2) as avg_sales,
RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY ROUND(avg(total_sale),2) DESC) as rnk 
FROM retail_sales 
GROUP BY year, month
)
SELECT year, month, avg_sales, rnk
FROM sales 
WHERE rnk <=1;

-- Write a SQL query to find the top 5 customers based on the highest total sales. 
SELECT customer_id, SUM(total_sale) as total_sales 
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC 
LIMIT 5;

-- Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category, COUNT(DISTINCT customer_id) as count_of_unique_cus
FROM retail_sales
GROUP BY category
ORDER BY count_of_unique_cus DESC;

-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17). 
SELECT 
CASE 
   WHEN HOUR(sale_time) < 12 THEN 'Morning'
   WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
   ELSE 'Evening'
   END AS shift ,
COUNT(quantity) as num_of_orders 
FROM retail_sales
GROUP BY shift 
ORDER BY num_of_orders DESC;

-- End Of Project
