use session06;

-- Doanh thu tung ngay
select 
    order_date,
    sum(total_amount) as TongDoanhThu
from orders
group by order_date;

-- Doanh thu tung ngay > 10 triue 

select 
    order_date,
    sum(total_amount) as TongDoanhThu
from orders
group by order_date;