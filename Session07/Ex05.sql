use session07;

select *
from customers
where customers_id = (
    select customers_id
    from orders
    group by customers_id
    having sum(total_amount) = (
        select max(tong_tien)
        from (
            select sum(total_amount) as tong_tien
            from orders
            group by customers_id
        ) as temp
    )
);
