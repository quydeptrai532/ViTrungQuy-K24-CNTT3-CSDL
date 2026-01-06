use session07;

create table products (
    id int primary key auto_increment,
    name varchar(255),
    price decimal(10,2)
);

create table order_items (
    order_id int,
    product_id int,
    quantity int
);

insert into products (name, price) values
('Ao polo', 280000),
('Quan jean', 450000),
('Giay sneaker', 950000),
('Mu luoi trai', 150000),
('That lung', 200000),
('Balo', 600000),
('Tat chan', 50000);

insert into order_items (order_id, product_id, quantity) values
(1, 1, 2),
(1, 3, 1),
(2, 2, 1),
(2, 5, 2),
(3, 1, 1),
(3, 4, 3),
(4, 6, 1);

select *
from products
where id in (
    select product_id
    from order_items
);
