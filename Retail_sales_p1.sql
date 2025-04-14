drop table IF EXISTS retail_sales;
create table retail_sales (transactions_id	int primary key,
						    sale_date	date,
                            sale_time	time,
                            customer_id	int,
                            gender	varchar(15),
                            age	int,
                            category Varchar(20),	
                            quantiy	int,
                            price_per_unit float,	
                            cogs	float,
                            total_sale int
                            );

select * from retail_sales;

select Count(*) from retail_sales;

-- Data cleaning 

select * from retail_sales
where transactions_id is null
	  or
      sale_date is null 
      or
      sale_time is null 
      or
      customer_id is null
      or
      gender is null
      or
      category is null 
      or
      quantiy is null
      or
      cogs is null
      or
      total_sale is null ;
      
select * from retail_sales
where transactions_id in (1225,679,746);


delete from retail_sales 
where transactions_id is null
	  or
      sale_date is null 
      or
      sale_time is null 
      or
      customer_id is null
      or
      gender is null
      or
      category is null 
      or
      quantiy is null
      or
      cogs is null
      or
	  total_sale is null ;
      
-- Data Exploration 

-- how many sales we have 
select count(total_sale) As "Total Sales" from retail_sales;
   
-- how many unique customers we have  
select count(distinct(customer_id)) AS "Total Customers" from retail_sales;

-- how many categories we have
select distinct(category) AS "Categories" from retail_sales;



-- Data analysis & Business Key problems & answers


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
    select * 
    from retail_sales
    where 
			sale_date = '2022-11-05';
   
 -- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or eqaul to 4 in the month of Nov-2022
	select * 
    from retail_sales
    where 
		category = "Clothing" and 
			quantiy >= 4 and 
				sale_date >= '2022-11-01' and
					sale_date <= '2022-11-30';
            
            
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

		select category , sum(total_sale) AS "Sales",count(quantiy) AS "Orders" 
        from retail_sales
		group by 
				category ;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
	
		select category,round(avg(age)) AS "AVG AGE" 
        from retail_sales	
        where 
			  category = "Beauty";

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
		select transactions_id ,total_sale 
        from retail_sales
        where 
			 total_sale > 1000 ;
        
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
		select category,gender,count(transactions_id) AS "No Of Transactions" 
        from retail_sales
        group by 
				category,
					gender;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
		select Year,
			   month,
               Avg_sales
						from	(select  year(sale_date) AS 'Year',
									month(sale_date) AS 'month',
									round(avg(total_sale),2) AS 'Avg_sales',
									rank() over(partition by year(sale_date) order by  round(avg(total_sale),2) desc ) AS RANKS
								from retail_sales
							group by year(sale_date),month(sale_date)) AS T1
						where RANKS = 1;
				-- order by year(sale_date),round(avg(total_sale),2) desc ;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
		select customer_id,
			   sum(total_sale) AS "Sales"
        from 
			   retail_sales
        group by 	
				customer_id
        order by 
				sum(total_sale) desc
        limit 5;
    
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
 
		select category,count(distinct(customer_id)) AS Distinct_customers
			from retail_sales
          group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)alter

WITH hourly_sale
				  AS
					(select sale_time ,
							case 
									when hour(sale_time) <=12 then "Morning"
									when hour(sale_time) Between 12 and 17 then "Afternoon"
									else "Evening" 
									end as "Shift"
							from retail_sales)
select shift,
	   count(*) AS total_orders
from hourly_sale
group by 
		shift;

-- END OF PROJECT