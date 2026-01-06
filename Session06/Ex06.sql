use session06;
select
    p.product_name,
    sum(oi.quantity) as TongSoLuongBan,
    sum(oi.quantity * p.price) as TongDoanhThu,
    sum(oi.quantity * p.price) / sum(oi.quantity) as GiaBanTrungBinh
from products p
join order_items oi
    on p.product_id = oi.product_id
group by p.product_id, p.product_name
having sum(oi.quantity) >=10
order by TongDoanhThu desc
limit 5;
