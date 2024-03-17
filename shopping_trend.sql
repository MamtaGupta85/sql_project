use consumer_shopping;

select * from shopping_trends;

-- the percentage of the male and female consumers 
select
(select concat(round(sum(gender='male')/count(customer_ID),2)*100, '%'))as  male_percent,
(select concat(round(sum(gender='female')/count(customer_ID),2)*100, '%')) as  female_percent
from shopping_trends;

-- the range of maximum and minimum purchase amount for each category
select category, concat(min(purchase_amount), '-', max(purchase_amount)) as range_amount, avg(purchase_amount) as average_amount
from shopping_trends
group by category;

-- most popular item purchased in the each of the categories
select category, item_purchased
from(select category, item_purchased,count(*) as count_items
from shopping_trends
group by category, item_purchased) as subquery
where (category, count_items) IN (select category, max(count_items)
from (select category, item_purchased,count(*) as count_items
from shopping_trends
group by category, item_purchased) as subquery_inner
group by category );

-- no of customers  in the different age range
select category,
sum( case when age between 18 and 30 then 1 else 0 end) as '18-30',
sum(case when age between 31 and 50 then 1 else 0 end) as  '31-50',
sum(case when age between 51 and 70 then 1 else 0 end) as '51-70'
from shopping_trends
group by category;

-- most popular item purchased in oregon
select item_purchased
from (select item_purchased, count(item_purchased) as total_items 
from shopping_trends
where location= 'oregon'
group by item_purchased
order by total_items desc
limit 1) as temp_table;

-- the top five locations for the purchase of sneakers
select location as preferred_location_sneakers
from (select location, count(location) as total_locations
from shopping_trends
where item_purchased = 'sneakers'
group by location) as temp_table
group by location 
limit 5;

-- extract the maximum revenue generated in the diferent sizes of each category
select category, size, sum(purchase_amount) as revenue_generated
from shopping_trends
group by category, size
having category = 'footwear'
order by revenue_generated desc
limit 1;

-- extract the information of customers with the third highest in the database consumer_shopping wihtout using limit/top
select * from shopping_trends s1
where 2= (select count(distinct purchase_amount) from shopping_trends s2 where s2.purchase_amount> s1.purchase_amount);

-- most purchased colors in the winter season
select season, color as preferred_color
from (select season, color, count(color) as count_no
from shopping_trends
group by season, color
order by count_no) as temp_table
group by season, color
having season = 'winter'
order by count_no desc
limit 1;

-- extract the most popular item purchased for each location
select location, item_purchased
from (select location, item_purchased, count(*) as total_items
from shopping_trends
group by location, item_purchased) as subquery
where (location, total_items) IN (select location, max(total_items)
from (select location, item_purchased, count(*) as total_items
from shopping_trends
group by location, item_purchased) as subquery_inner
group by location );


-- extract the subscription status percentage.
select (select concat(round( sum(subscription_status = 'yes')/ count(customer_id),2)*100,'%'))as  yes_percent,
(select concat(round( sum(subscription_status = 'no')/ count(customer_id),2)*100,'%'))as no_percent
from shopping_trends;

-- extract the average ratings for each of the category according to the seasons.
select category, 
round(avg(case when season = 'winter' then review_rating else 0 end),2) as winter_avg_rating,
round(avg(case when season = 'summer' then review_rating else 0 end),2)as summer_avg_rating,
round(avg(case when season = 'spring' then review_rating else 0 end),2) as spring_avg_rating,
round(avg(case when season = 'fall' then review_rating else 0 end),2) as fall_avg_rating
from shopping_trends
group by category;

-- show the total purchases by the different modes in the different age brackets and find the popular ones in each age category.
select payment_method,
sum( case when age between 18 and 30 then purchase_amount else 0 end) as '18-30',
sum(case when age between 31 and 50 then purchase_amount else 0 end) as  '31-50',
sum(case when age between 51 and 70 then purchase_amount else 0 end) as '51-70'
from shopping_trends
group by payment_method;


-- extract the category wise growth in sales
select category, CONCAT(round((sum(Purchase_Amount)-sum(Previous_Purchases))/sum(Previous_Purchases),2)*100, '%') AS 
growth_percentage
from shopping_trends
group by Category;

-- top three colors in the summer season
select color
from (select season, color, count(*) as  total_count
from shopping_trends
group by season, color) as temp_table
where season = 'summer'
order by total_count desc
limit 3;

-- retreive all those customer iD, cactegory, item_purchased where the preferred pay and the payment method are same.alter
select Customer_ID, Category, Item_Purchased
from shopping_trends
where Payment_Method= Preferred_pay;

-- retreive all the amount of the payments made through different payment modes.
select category, 
sum(case when Payment_Method= 'credit card' then Purchase_Amount else 0 end) as 'credit card',
sum(case when Payment_Method= 'bank transfer' then Purchase_Amount else 0 end) as 'bank transfer',
sum(case when Payment_Method= 'cash' then Purchase_Amount else 0 end) as 'cash',
sum(case when Payment_Method= 'paypal' then Purchase_Amount else 0 end) as 'paypal',
sum(case when Payment_Method= 'venmo' then Purchase_Amount else 0 end) as 'venmo',
sum(case when Payment_Method= 'debit card' then Purchase_Amount else 0 end) as 'debit card'
from shopping_trends
group by category;



