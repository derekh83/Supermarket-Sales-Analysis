CREATE TABLE sales (
	invoice_id VARCHAR(20),
	branch VARCHAR(50),
	city VARCHAR(50),
	customer_type VARCHAR(20),
	gender VARCHAR(10),
	product_line VARCHAR(50),
	unit_price DECIMAL(10,2),
	quantity INT,
	tax DECIMAL(10, 4),
	sales DECIMAL(10,4),
	date DATE,
	time TIME,
	payment VARCHAR(20),
	cogs DECIMAL(10,2),
	gross_margin_percentage DECIMAL(10, 9),
	gross_income DECIMAL(10,4),
	rating DECIMAL(3,1)
);

SElECT *
FROM sales
LIMIT 10;

-- Data Cleaning

-- 1. Check for duplicates

SELECT invoice_id, COUNT(*)
FROM sales
GROUP BY invoice_id
HAVING COUNT(*) > 1;

-- invoice_id should be unique, so since it returned nothing there should be no duplicates

-- just to double-check and make sure the invoice id's were different but everything else
-- was the same (this shouldn't happen but just another way to check... also if there
-- wasn't a primary key this is how you could check for duplicates)

SELECT branch, city, customer_type, gender, product_line, unit_price, quantity, tax, 
		sales, date, time, payment, cogs, gross_margin_percentage, gross_income, rating,
		COUNT(*) AS duplicate_count
FROM sales
GROUP BY branch, city, customer_type, gender, product_line, unit_price, quantity, tax, 
		sales, date, time, payment, cogs, gross_margin_percentage, gross_income, rating
HAVING COUNT(*) > 1;

-- 2. Standardize the Data

-- checking for inconsistent values(ewallet vs. Ewallet, fake nulls ' ', etc.)

SELECT COUNT(*)
FROM sales;

SELECT DISTINCT branch
FROM sales;

SELECT DISTINCT city
FROM sales;

SELECT DISTINCT customer_type
FROM sales;

SELECT DISTINCT gender
FROM sales;

SELECT DISTINCT product_line
FROM sales;

SELECT DISTINCT payment
FROM sales;

-- 3. Check for nulls

SELECT
    COUNT(*) - COUNT(branch) AS branch_nulls,
    COUNT(*) - COUNT(city) AS city_nulls,
    COUNT(*) - COUNT(customer_type) AS customer_type_nulls,
    COUNT(*) - COUNT(gender) AS gender_nulls,
    COUNT(*) - COUNT(product_line) AS product_line_nulls,
    COUNT(*) - COUNT(unit_price) AS unit_price_nulls,
    COUNT(*) - COUNT(quantity) AS quantity_nulls,
    COUNT(*) - COUNT(tax) AS tax_nulls,
    COUNT(*) - COUNT(sales) AS sales_nulls,
    COUNT(*) - COUNT(date) AS date_nulls,
    COUNT(*) - COUNT(time) AS time_nulls,
    COUNT(*) - COUNT(cogs) AS cogs_nulls,
    COUNT(*) - COUNT(gross_margin_percentage) AS gross_margin_nulls,
    COUNT(*) - COUNT(gross_income) AS gross_income_nulls,
    COUNT(*) - COUNT(rating) AS rating_nulls
FROM sales;

-- date range (does date range in data make sense?)

SELECT MIN(date), MAX(date) 
FROM sales;

-- 01/01/2019 to 03/30/2019 (3 months of sales data)

-- check for negatives or 0 in columns that should be positive

SELECT COUNT(*)
FROM sales
WHERE unit_price <= 0
OR quantity <= 0
OR sales <= 0;

-- Data is clean, can move onto analysis

-- Sales Performance

-- Which branch generates most revenue? 
SELECT branch, ROUND(SUM(sales), 2) AS total_revenue
FROM sales
GROUP BY branch
ORDER BY total_revenue DESC;

-- Giza makes the most money by branch at $110,568.71, with Alex and Cairo very similar at $106,200.37 and $106,197.67,
-- respectively.

-- Which city generates most revenue?
SELECT city, ROUND(SUM(sales), 2) AS total_revenue
FROM sales
GROUP BY city
ORDER BY total_revenue DESC;

-- Since there are only 3 branches, one per city, this just shows that Giza is located in Naypyitaw, Alex is in Yangon,
-- and Cairo is in Mandalay. This would be more useful if there were multiple branches per city.

-- Do members or regular customers spend more?
SELECT 
	customer_type, 
	ROUND(SUM(sales), 2) AS total_revenue, 
	ROUND(AVG(sales), 2) AS avg_revenue, 
	COUNT(*)
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- Members spend about $56,422.77 more than normal customers. Members make up 56.5% of transactions and spend an average
-- of $29.37 more for each transaction. How can we convert more normal customers to members?

-- Do male or female customers spend more?
SELECT 
	gender, 
	ROUND(SUM(sales), 2) AS total_revenue,
	ROUND(AVG(sales), 2) AS avg_revenue, 
	COUNT(*)
FROM sales
GROUP BY gender
ORDER BY total_revenue DESC;

-- Females make up 57.1% of customers. On average they spend $41.87 more per transaction and overall, they spend $66,376.93
-- more. How can we attract more males and get them to spend more?

-- Which product line sells the most?
SELECT product_line, ROUND(SUM(sales), 2) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- Food and beverage products make the most money, with health and beauty making the least.

-- Which product line has highest margins?
SELECT product_line, ROUND(AVG(gross_margin_percentage), 2) AS avg_margin
FROM sales
GROUP BY product_line
ORDER BY avg_margin DESC;
-- (seems like gross_margin_percentage was fixed at 4.76, not meaningful here but could be in real dataset.)
-- let's check for total gross income instead

-- Which product line has highest gross income
SELECT product_line, ROUND(SUM(gross_income), 2) AS total_gross_income
FROM sales
GROUP BY product_line
ORDER BY total_gross_income DESC;

-- Food and beverages have the highest gross income with health and beauty having the lowest.

-- Which proudct line makes most profit on average?
SELECT product_line, ROUND(AVG(gross_income), 2) AS avg_gross_income
FROM sales
GROUP BY product_line
ORDER BY avg_gross_income DESC;

-- On average, home and lifestyle products make the most profit on average. Fashion accessories make the least on average.

-- What's the most popular payment method?
SELECT payment, COUNT(*) AS total_count
FROM sales
GROUP BY payment
ORDER BY total_count DESC;

-- Ewallet and cash are almost identical in terms of number of transactions being paid this way. Ewallet accounted for 
-- 345 transactions, with cash being 344. 

-- Time analysis

-- What are the busiest / least busiest months?
SELECT 
	EXTRACT(MONTH FROM date) AS month, 
	AVG(sales) AS avg_sales_per
FROM sales
GROUP BY EXTRACT(MONTH FROM date)
ORDER BY avg_sales_per DESC;

-- In this dataset, it was just sales for the first quarter (Janaury-March). In terms of average sales, January is the 
-- busiest and March is the least busy.

-- What days of the week are busiest?
SELECT
	TO_CHAR(date, 'Day') AS day_of_week,
	ROUND(AVG(sales), 2) AS avg_sales
FROM sales
GROUP BY TO_CHAR(date, 'Day')
ORDER BY avg_sales DESC;

-- In average sales, Saturday and Sunday are the top 2. This makes sense as most people do shopping on the weekend. 
-- Monday and Wednesday are the 2 least busy days of the week.

-- Total profit by days of week
SELECT
	TO_CHAR(date, 'Day') AS day_of_week,
	ROUND(SUM(gross_income), 2) AS total_profit
FROM sales
GROUP BY TO_CHAR(date, 'Day')
ORDER BY total_profit DESC;

-- In terms of total profit, Saturdays and Tuesdays are the top 2. Wednesday and Monday are once again the 2 least profitable
-- days.

-- Average profit by days of week
SELECT
	TO_CHAR(date, 'Day') AS day_of_week,
	ROUND(AVG(gross_income), 2) AS avg_pofit
FROM sales
GROUP BY TO_CHAR(date, 'Day')
ORDER BY avg_pofit DESC;

-- Notice that Sunday has 2nd highest sales and average profit but 4th in total profit.
-- When a sale on Sunday is made, it's most likely higher transaction total, but there are less transactions overall.

-- Let's check for total number of transactions per day to confirm this.

SELECT
	TO_CHAR(date, 'Day') AS day_of_week,
	COUNT(*) AS number_of_transactions
FROM sales
GROUP BY TO_CHAR(date, 'Day')
ORDER BY number_of_transactions DESC;

-- Sunday's are 6th in number of transactions. This confirms it.

-- Sales by time of day

-- hourly breakdown
SELECT 
	EXTRACT(HOUR FROM time) AS hour,
	COUNT(*) AS num_transactions,
	ROUND(AVG(sales), 2) AS avg_sales,
	ROUND(SUM(sales), 2) AS total_sales
FROM sales
GROUP BY hour
ORDER BY hour;

-- There are 4 different hours in which the number of transactions is greater than 100, the average of each sale is greater
-- than $300 and the total sales for the hour is greater than $30000. These can be considered our busy hours, which are
-- 10am, 1pm, 3pm, and 7pm. The slowest hours in terms of number of customers are 4pm, 5pm, and 8pm. There is a big rush
-- when the store first opens at 10am, with business being pretty constant until 4pm, with peaks at 1pm and 3pm. Business
-- slows down then for a bit, until 7pm. At this time there is a huge rush before close, with total sales being highest
-- in this hour. Business is then slowest in terms of total sales for the last hour of being open.

-- breaking down time into bins

SELECT
	CASE
		WHEN EXTRACT(HOUR FROM time) BETWEEN 10 and 11
			THEN 'Morning (10am-12pm)'
		WHEN EXTRACT(HOUR FROM time) BETWEEN 12 and 16
			THEN 'Afternoon (12pm-5pm)'
		WHEN EXTRACT(HOUR FROM time) BETWEEN 17 and 20
			THEN 'Evening (5pm-9pm)'
	END AS time_bin,
	COUNT(*) AS num_transactions,
	ROUND(AVG(sales), 2) AS avg_sales,
	ROUND(SUM(sales), 2) AS total_sales
FROM sales
GROUP BY time_bin
ORDER BY total_sales DESC;

-- The times are broken up into bins based on the time of the day. Morning is considered 10am-12pm, afternoon is 12pm-5pm,
-- and evening is 5pm-9pm. Note that afternoon is 5 hours long, evening is 4 hours, and morning is only 2. For this reason,
-- the number of transactions and total sales are highest for the afternoon and lowest for the morning. More importantly,
-- though, the average of each sale is actually very similar for all time periods. These numbers are $323.55, $326.04,
-- and $318.72 for morning, afternoon, and evening, respectively.

-- Let's create bins for time based on every 2 hours

SELECT
	CASE
		WHEN EXTRACT(HOUR FROM time) BETWEEN 10 and 11
			THEN '10am-12pm'
		WHEN EXTRACT(HOUR FROM time) BETWEEN 12 AND 13
			THEN '12pm-2pm'
		WHEN EXTRACT(HOUR FROM time) BETWEEN 14 AND 15
			THEN '2pm-4pm'
		WHEN EXTRACT(HOUR FROM time) BETWEEN 16 AND 17
			THEN '4pm-6pm'
		WHEN EXTRACT(HOUR FROM time) BETWEEN 18 AND 19
			THEN '6pm-8pm'
		WHEN EXTRACT(HOUR FROM time) = 20
			THEN '8pm-9pm'
	END AS time_bin,
	COUNT(*) AS num_transactions,
	ROUND(AVG(sales), 2) AS avg_sales,
	ROUND(SUM(sales), 2) AS total_sales
FROM sales
GROUP BY time_bin
ORDER BY total_sales DESC;

-- To create a more even comparison, I split the time into bins for every 2 hours. I started with 10am-12pm, 12pm-2pm,
-- and so on. The last bin is only an hour, from 8pm-9pm, as the business is open an uneven number of hours. Interestingly
-- enough, the later bin at 6pm-8pm led in number of transactions and total sales. The time slot of 2pm-4pm was second 
-- highest in sales but led in average cost of sales. When looking at the 2 hour intervals and ignoring the single hour
-- bin (8pm-9pm), the top 4 time bins are pretty similar in total sales, with a gap of just $4940.74 from the 
-- highest bin to the 4th highest bin. The drop-off from the 4th bin to the 5th bin, though, is pretty significant
-- at $11,117.57. This is from 4pm-6pm, which is the lowest selling 2 hour bin. During this time, they do have the second
-- largest average price per sale, meaning the orders are pretty expensive but the number of transactions is small.

-- Cross-dimensional analysis

-- Product line performance by branch

SELECT
	branch,
	product_line,
	ROUND(SUM(sales), 2) AS total_sales,
	RANK() OVER (PARTITION BY branch ORDER BY SUM(sales) DESC)
	AS rank
FROM sales
GROUP BY branch, product_line
ORDER BY branch, rank;

-- At the Alex branch, home and lifestyle products were leading in sales, with health and beauty products the lowest 
-- category in sales. The gap between these two product lines is $9819.45. It's interesting to note that health and beauty
-- products are the second biggest seller at the Cairo branch. Sports and travel products led this branch, with food and
-- beverages being the lowest. The gap between these product lines is $4773.31, much more balanced than Alex. The Giza branch
-- highest selling category is food and beverages, with home and lifestyle products the worst seller. The gap between these
-- products is $9871.31, very similar to the Alex branch. It's interesting how different each product line sells at each
-- branch. There doesn't seem to be a specific pattern. Spending at Cairo is much more similar and balanced in terms of 
-- product line compared to the other 2 branches.

-- Gender preference by product line

SELECT
	product_line,
	gender,
	ROUND(SUM(sales), 2) AS total_sales,
	ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY product_line), 2) AS pct_of_product_line
FROM sales
GROUP BY product_line, gender
ORDER BY product_line, gender;

-- Females spend more in every product line except health and beauty. This gap is particularly large in food and beverage 
-- products, with females spending $16,786.75 more. For sports and travel products, this gap is also quite large at
-- $16,717.94. For health and beauty products, men actually spend $2356.28 more which is the only category they led in.
-- In all product lines, females accounted for the larger percentage of purchases. This gap was large with sports and travel
-- products, as females accounted for 62.05% of purchases. While for health and beauty products, the percentage of purchases
-- were very close, with 50.66% of items being purchased by females.

-- Customer type spending by branch

SELECT
    customer_type,
    branch,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(AVG(sales), 2) AS avg_sale_per_transaction,
    COUNT(*) AS num_transactions
FROM sales
GROUP BY branch, customer_type
ORDER BY branch, customer_type;

-- Note that members spend more money than normal customers on average and total. The average spending gap between normal
-- customers and members at Alex branch is $42.33. This gap is only $23.41 at Cairo and $19.90 at Giza. This may suggest 
-- that the membership incentives differ by location. Members also account for a larger number of transactions than normal
-- customers. This may be due to a variety of reasons, like members getting access to exclusive coupons or sales. 
-- It's important to use this information to convert  more normal customers to members.

-- Sales per hour by branch
SELECT
	branch,
	EXTRACT(HOUR FROM time) AS hour,
	ROUND(SUM(sales), 2) AS total_sales
FROM sales
GROUP BY branch, EXTRACT(HOUR FROM time)
ORDER BY hour;

-- At 4pm, sales at Giza and Alex stay pretty similar to previous hours. At Cairo, though, there is a massive drop-off during
-- this hour. At 3pm, Cairo made $10,241 in sales, more than Giza and just about $1,000 less than Alex. At 4pm, Cairo's
-- sales drop all the way down to $4,124, while Giza is at $10,233 and Alex $10,870. Then at 7pm, Cairo does $16,262
-- in sales, while Giza does $13,107 and Alex does $10,330. What is causing these two massive spikes, one negative and
-- one positive at Cairo?


-- Top Business Recommendations

-- 1. Convert normal customers to members
-- Members spent $56,422.77 more than normal customers in these 3 months. Members make up 56.5% of transactions and spend 
-- an average of $29.37 more for each transaction. Members outspend normal customers at all 3 branches, with the gap largest
-- at Alex ($42.33 avg difference). Creating promotions or incentives aimed at normal customers, specifically at Alex,
-- could help increase revenue. 

-- 2. Investigate the 4pm-6pm slump
-- Business is pretty steady throughout the entire day, with the exception of the last hour of business (8pm-9pm). For some
-- reason, there is a massive drop-off in total sales during this 2 hour period compared to the other 2 hour periods during
-- the day. There's an $11,000 drop off from the next lowest bin. When analyzing the data, it reveals that the average sale
-- value during this time period is actually the second highest during the day. So, spending intent of the customers is not
-- the issue. Instead, it's the lack of foot traffic. Total transactions for a two hour period range from 185-206 for all
-- of the other 2-hour periods in the day, but fall all the way down to 151 from 4pm-6pm. So, how can we get more customers
-- in the door during this time? A time-limited discount or something similar could get more people in the door.

-- 3. Double down on food & beverages at Giza
-- The food & beverage category leads in both total revenue and gross income for the 3 months of data. However, this
-- category is driven by Giza. Food & beverages is the 4th product line at Alex and last at Cairo. It is so dominant at
-- Giza, though, with $23,766.86 in sales that it is still the top product line overall. Every branch has a different 
-- category that leads. Pushing the same strategy for each store would probably not be the best business move. At Giza,
-- investing more in this category by increasing inventory, promotions, or offering more products could help drive sales
-- even higher.

-- 4. Target male customers
-- Females spend more in every product line except health and beauty. This gap is particularly large in food and beverage 
-- products, with females spending $16,786.75 more. For sports and travel products, this gap is also quite large at
-- $16,717.94. Marketing campaigns or product-specific promotions targeted towards men could attract more men to the store.

-- 5. Identify why Cairo is most balanced across product lines
-- All 3 stores are close in terms of total revenue for the 3 months. Giza is leading with $110,568.71, but Alex and Cairo
-- are not too far behind with $106,200.37 and $106,197.67, respectively. At Alex, the gap between the highest category
-- in sales and the lowest category in sales is $9,819.45. At Giza, this gap is $9,871.31. The gap at Cairo is only
-- $4,773.31, about half of Alex and Giza. The Cairo store is much more balanced and evenly distributed. Identifying 
-- why this is happening could provide a model for the other branches to follow. Some possible reasons could be customer
-- demographics, management, or store layout.

SELECT * FROM sales;