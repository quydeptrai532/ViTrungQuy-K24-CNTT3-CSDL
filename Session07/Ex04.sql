use session07;

select 
    full_name,
    (
        select count(*)
        from orders
        where orders.customers_id = customers.customers_id
    ) as so_luong_don_hang
from customers;
