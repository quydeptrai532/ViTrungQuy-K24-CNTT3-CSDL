use session07;

insert into orders (customers_id, order_date, total_amount) values
(1, '2025-04-01', 1200000),
(1, '2025-04-05', 1800000),
(2, '2025-04-10', 900000),
(3, '2025-04-15', 2500000),
(4, '2025-04-20', 3000000);

select customers_id
from orders
group by customers_id
having sum(total_amount) > (
    select avg(tong_tien)
    from (
        select sum(total_amount) as tong_tien
        from orders
        group by customers_id
    ) as temp
);