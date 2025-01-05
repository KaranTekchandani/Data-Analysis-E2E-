
/*
--find top 5 highest selling products in each region
select product_id,profit,region 
from
(select product_id,sum(profit) as profit,region,rank() over(partition by region order by sum(profit) desc) as ranks
from sales
group by product_id,region
)
where ranks<6
order by 2 desc

select * from sales
----find top 10 highest reveue generating products 
select product_id,sum(profit), rank() over(order by sum(profit) desc)
from sales
group by product_id
order by 2 desc
limit 10
--find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023
with orders as( 
select extract(month from S.order_date) as order_month,extract(year from S.order_date) as order_year,sum(profit) as pft
from sales S
group by 1,2
order by 1,2)

select A.order_month month_2022,A.order_year year_2022,A.pft as profit_2022,B.order_year year_2023,B.order_month month_2023, B.pft as profit_2023,(A.pft-B.pft) as growth,(A.pft-B.pft)*100/A.pft as proft_perc
from orders A
join orders B
on A.order_month=B.order_month
where A.order_year=2022 and B.order_year=2023
order by 1

--for each category which month had highest sales 
with rankin as(
select category,extract(month from order_date) as monthh, extract(year from order_date) as yearr,sum(profit),rank() over(partition by category order by sum(profit) desc) as ranked
from sales
group by category,monthh,yearr
)
select * 
from rankin
where ranked=1
order by category,monthh,yearr


--which sub category had highest growth by profit in 2023 compare to 2022
with cte1 as(
select sub_category,sum(profit) as pft, extract(year from order_date)
from sales
group by 1,3
),
cte2 as(
select c1.sub_category,c1.pft as pft2022,c2.pft as pft2023,(c2.pft-c1.pft)as grwth
from cte1 as c1
join cte1 as c2
on c1.sub_category=c2.sub_category
)
select sub_category,grwth
from cte2
order by 2 desc
limit 1

--Top 3 Profitable Products by Sub-Category
select sub_category,pft
from (select product_id,sub_category,sum(profit) as pft,rank()over(partition by sub_category order by sum(profit) desc) as rank
from sales
group by 1,2)
where rank<4
order by sub_category,pft desc

--Monthly Revenue Growth Comparison Between 2022 and 2023
with cte1 as
(select extract(month from order_date) as months,extract(year from order_date) as years,sum(profit) as profit
from sales
group by 1,2
order by 1)
select c1.years, c1.months,c1.profit,c2.profit,(c2.profit-c1.profit) as grwth
from cte1 as c1
join cte1 as c2
on c1.months=c2.months
where c1.years=2022 and c2.years=2023
order by 2 asc
*/