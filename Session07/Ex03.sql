use session07;

insert into orders (customers_id, order_date, total_amount) values
(1, '2025-02-01', 1200000),
(2, '2025-02-03', 2500000),
(3, '2025-02-05', 800000),
(4, '2025-02-07', 3200000),
(5, '2025-02-10', 1800000);


select *
from orders
where total_amount > (
    select avg(total_amount)
    from orders
);
