use customer_behavior;
select * from data;
-- male and female revenue--
select gender , Sum(purchase_amount) as revenue 
from data
group by gender;

select category , round(avg(review_rating),2) as avg_review
from data
group by category
order by avg(review_rating) DESC;


-- paid more than average amount even after applying discount
select customer_id , purchase_amount 
from data 
where discount_applied= 'Yes' and purchase_amount >= (select avg(purchase_amount) from data);

-- highest rated item
select item_purchased, round(Avg(review_rating),2) as "average product rating"
from data 
group by item_purchased
order by avg(review_rating) DESC
limit 5;


-- avg amount between standard and express shipping
select shipping_type,round(avg(purchase_amount),2) as Average_amount
from data 
where shipping_type in ("Express","Standard")
group by shipping_type;

-- comaprison of amount spend by a subscribed and non subscribed customer
select 
subscription_status,
count(customer_id) as total_csutomers,
sum(purchase_amount) as total_amount_spent ,
round(avg(purchase_amount),2) as average_amount 
from data 
group by subscription_status;

-- product having highest percentage of purchases with discount applied

select item_purchased,
round(100* sum(case when discount_applied='Yes' then 1 else 0 end)/count(*),2) as discount_rate
from data
group by item_purchased
order by discount_rate desc
limit 5;

-- segment customer into new, returning and loyal based on their total number of purchases and tell the count of each segment

WITH customer_type as (
select customer_id , previous_purchases,
case 
when previous_purchases = 1 then 'New'
when previous_purchases  between 2 and 10 then 'Returning'
else 'Loyal'
end as customer_segment
from data)
select customer_segment, count(*) as "number_of_customer"
from customer_type 
group by customer_segment;


-- top 3 products in each category
WITH item_counts AS (
    SELECT
        category,
        item_purchased,
        COUNT(customer_id) AS total_orders,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY COUNT(customer_id) DESC
        ) AS item_rank
    FROM data
    GROUP BY category, item_purchased
)
SELECT
    item_rank,
    category,
    item_purchased,
    total_orders
FROM item_counts
WHERE item_rank <= 3;

-- ARE loyal buyers also subscribers?

select subscription_status,
count(customer_id) as repeat_buyers
from data
where previous_purchases >= '5'
group by subscription_status;

-- revenue by age group

select 
age_groups ,sum(purchase_amount) as total_revenue
from data
group by age_groups
order by sum(purchase_amount) asc;