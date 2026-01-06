use session06;
create table products (
    product_id int primary key auto_increment,
    product_name varchar(255),
    price decimal(10,2)
);

create table order_items (
    order_id int,
    product_id int,
    quantity int,
    primary key (order_id, product_id),
    foreign key (product_id) references products(product_id)
);

insert into products (product_name, price) values
('Laptop Dell', 20000000),
('iPhone 15', 25000000),
('Tai nghe Sony', 3500000),
('Ban phim co', 2800000),
('Chuot Logitech', 1500000);

insert into order_items (order_id, product_id, quantity) values
(1, 1, 2),  -- Laptop Dell
(1, 3, 3),  -- Tai nghe
(2, 2, 1),  -- iPhone
(3, 1, 1),  -- Laptop Dell
(3, 4, 4),  -- Ban phim
(4, 5, 5),  -- Chuot
(5, 2, 2);  -- iPhone

select 
    p.product_name,
    sum(oi.quantity) as TongSoLuongBan
from products p
join order_items oi
    on p.product_id = oi.product_id
group by p.product_id, p.product_name;

select 
    p.product_name,
    sum(oi.quantity * p.price) as DoanhThu
from products p
join order_items oi
    on p.product_id = oi.product_id
group by p.product_id, p.product_name;

select 
    p.product_name,
    sum(oi.quantity * p.price) as DoanhThu
from products p
join order_items oi
    on p.product_id = oi.product_id
group by p.product_id, p.product_name
having sum(oi.quantity * p.price) > 5000000;
