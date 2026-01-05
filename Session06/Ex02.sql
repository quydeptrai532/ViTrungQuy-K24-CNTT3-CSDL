use session06;

alter table orders
add total_amount decimal(10,2);

truncate table orders;

insert into orders (customer_id, order_date, order_status, total_amount) values
(1, '2025-01-01', 'completed', 1500000),
(1, '2025-01-03', 'pending',   2300000),
(2, '2025-01-05', 'completed', 1800000),
(3, '2025-01-07', 'cancelled', 900000),
(4, '2025-01-10', 'pending',   1200000);

-- Hien thi tong tien khach hang da chi tieu

select c.full_name,sum(o.total_amount) as tongtien
from customers c
join orders o on c.customer_id=o.customer_id
group  by c.customer_id;

-- Hien thi don hang cao nhat
select c.full_name,max(o.total_amount) as DonCaoNhat
from customers c
join orders o on c.customer_id=o.customer_id
group  by c.customer_id;

select c.full_name,max(o.total_amount) as DonCaoNhat
from customers c
join orders o on c.customer_id=o.customer_id
group  by c.customer_id
order by DonCaoNhat desc