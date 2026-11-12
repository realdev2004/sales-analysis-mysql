-- Marketing wants to know which cities our orders come from and which payment methods customers use. Give me each as a separate list.
use shopeasy_db;
select * from orders;
select distinct city from orders;
select distinct payment_mode from orders;

-- The catalogue team needs a clean product list showing the product name, category and price, with proper headings.
select product_name as 'Product Name',category as 'Category',price as 'Price' from products;

-- Finance is auditing the April to June 2026 quarter. Show me all delivered orders from Kochi or Chennai placed in that period.
select * from orders where order_status = 'Delivered' and city in ('Kochi', 'Chennai') and order_date between '2026-04-01' AND '2026-06-30';

-- The payments team is reviewing card and net banking activity. Show me the orders paid by credit card or net banking where more than 2 units were bought and the order was not cancelled.
select * from orders where payment_mode in ('Credit Card', 'Net Banking') and quantity > 2 and order_status <> 'Cancelled';

-- Which products are priced between ₹1,000 and ₹5,000 and are not in the Electronics category?
select * from products where price between 1000.00 and 5000.00 and category <> 'electronics';

-- The website search team is testing premium-sounding product names. Which products have "Pro" or "Max" in their name?
SELECT * FROM products WHERE product_name LIKE '%Pro%' OR product_name LIKE '%Max%';

-- Marketing wants to send a message to customers whose names start with "S". Give me each such customer once.
select distinct customer_name from orders where customer_name like 'S%';

-- Show me all cancelled or returned orders where we gave no discount.
select * from orders where (order_status='cancelled' or order_status='returned')and discount_percent is null;

-- Which products launched in 2026 have not received a customer rating yet?
select * from products where launch_date>'2026-01-01'and rating is null;

-- Who are our 5 most expensive products, and what do they cost?
select * from products where price>=15000.00;

-- Give me the full product list sorted by category from A to Z, and within each category with the most expensive product first.
select * from products order by category asc, price desc;

-- Show me our 10 biggest delivered orders: who ordered, from which city, and how much they paid.
select customer_name , city from orders where order_status='Delivered' order by total_amount desc limit 10;

-- Give management a one-line summary of all orders that were not cancelled: how many orders, total revenue, average order value, smallest order and largest order. Use readable headings.
select count(*) as 'TOTAL ORDERS',sum(total_amount) as 'TOTAL REVENUE',avg(total_amount) as 'AVERAGE ORDER VALUE',max(total_amount) as 'LARGEST ORDER',min(total_amount) as 'SMALLEST ORDER' from orders where order_status <> 'Cancelled';

-- How many orders do we have in total, how many of them had a discount, and how many different customers have ordered?
select count(*) as 'Total Orders', sum(case when discount_percent > 0 then 1 else 0 end) as 'Discounted Orders', count(distinct order_id) as 'Unique Customers' from orders;

-- For delivered orders, show each city with its number of orders and revenue, biggest revenue first.
select city as 'City', count(*) as 'Total Orders', sum(total_amount) as 'Total Revenue' from orders where order_status = 'Delivered' group by city order by sum(total_amount) desc;

-- For orders that were not cancelled, show each payment method with its number of orders and average order value. Only include methods used on more than 12 orders.
select payment_mode as 'Payment Method', count(*) as 'Total Orders', avg(total_amount) as 'Average Order Value' from orders where order_status <> 'Cancelled' group by payment_mode having count(*) > 12;

-- We want to reward loyal customers. Who has placed more than 4 orders (not counting cancelled ones)? Show their name, number of orders and total spend, and give me only the top 5 spenders.
select customer_name as 'Customer Name', count(*) as 'Total Orders', sum(total_amount) as 'Total Spend' from orders where order_status <> 'Cancelled' group by customer_name having count(*) > 4 order by sum(total_amount) desc limit 5;

-- For each product category, show how many products we sell, their average price and the total units in stock. Leave out categories with 3 products or fewer.
select category as 'Category', count(*) as 'Total Products', avg(price) as 'Average Price', sum(stock_qty) as 'Total Stock' from products group by category having count(*) > 3;

-- Operations wants to find slow cities. Among delivered orders, which cities take more than 6 days on average to deliver? Show the average, slowest first.
select city, avg(delivery_days) as 'Average Delivery Days' from orders where order_status = 'Delivered' group by city;

-- Looking only at delivered orders placed on or after 1 April 2026, and leaving out Delhi, show the number of orders and revenue for each payment method. Only include methods with revenue above ₹15,000, and show just the top 2.
select payment_mode as 'Payment Method', count(*) as 'Total Orders', sum(total_amount) as 'Total Revenue' from orders where order_status = 'Delivered' and order_date >= '2026-04-01' and city <> 'Delhi' group by payment_mode having sum(total_amount) > 15000 order by sum(total_amount) desc limit 2;