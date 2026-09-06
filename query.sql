--sql retail sales project.
create database sql_project_p1;

use sql_project_p1;

Drop table if exists retail_sales;
create table retail_sales
		(
			transactions_id	int primary key,
			sale_date date,
			sale_time time,
			customer_id int,
			gender varchar(15),
			age INT,
			category varchar(15),
			quantiy int,
			price_per_unit float,
			cogs float,
			total_sale float
		);

select * from retail_sales;

select count (*) from retail_sales;

Select * from retail_sales
where transactions_id is null

Select * from retail_sales
where
sale_time is null
or
transactions_id is null
or
sale_date is null
or
customer_id is null
or
gender is null
or
age is null
or
category is null
or 
quantiy is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null;

--data cleaning
delete from retail_sales
where
sale_time is null
or
transactions_id is null
or
sale_date is null
or
customer_id is null
or
gender is null
or
age is null
or
category is null
or 
quantiy is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null;

--data exploration

--how many sales we have?
select count (*)as total_sale from retail_sales;

--how many unique customers we have?
select count (distinct customer_id)as total_sale from retail_sales;

--how many unique category we have?
select count (distinct category)as total_sale from retail_sales;
--distinct category with name!
select distinct category as total_sale from retail_sales;

--Data analysis/business key prooblems & answers.
-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT 
* from retail_sales
where
sale_date='2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov 2022
select 
* from retail_sales
where 
	category='Clothing'
	and
	sale_date>='2022-11-01'
	and
	sale_date<='2022-12-01'
	and
	quantiy>=3;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select 
category,
	sum(total_sale) as net_sale,
	count (*) as total_sale
from retail_sales
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select 
	avg(age) as average_age
from retail_sales
where category='Beauty';
	
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select
* from retail_sales
	where total_sale>=1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select 
	category,
	gender,
	count(*) as total_trans
from retail_sales
group by
	category,
	gender;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
with monthly_sales as 
(
select 
	year(sale_date)as sale_year,
	month(sale_date)as sale_month,
	avg (total_sale) as average_sale
from retail_sales
group by
	year(sale_date),
	month(sale_date)
),  ranked_months as 
(
	select 
		sale_year,
		sale_month,
		average_sale,
		row_number() over
		(
			partition by sale_year
			order by average_sale desc
		)as rank_no
	from monthly_sales
)
select 
	sale_year,
	sale_month,
	average_sale
from ranked_months
where rank_no=1
order by sale_year;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
SELECT TOP 5
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
	category,
	count(distinct customer_id) as cmt_unique_cs
from retail_sales
group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <= 12, Afternoon Between 12 & 17, Evening >17)
SELECT
    CASE
        WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
        WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS number_of_orders
FROM retail_sales
GROUP BY
    CASE
        WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
        WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END
ORDER BY number_of_orders DESC;

