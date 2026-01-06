create database session07;
use session07;

create table customers (
    customers_id int primary key auto_increment,
    full_name varchar(255),
    email varchar(255) unique
);

create table orders (
    orders_id int primary key auto_increment,
    order_date date,
    total_amount decimal(10,2),
    customers_id int,
    foreign key(customers_id) references customers(customers_id)
);

-- Thêm dữ liệu customers
insert into customers (full_name, email) values
('Nguyen Van A', 'a@gmail.com'),
('Tran Thi B', 'b@gmail.com'),
('Le Van C', 'c@gmail.com'),
('Pham Thi D', 'd@gmail.com'),
('Hoang Van E', 'e@gmail.com'),
('Do Thi F', 'f@gmail.com'),
('Bui Van G', 'g@gmail.com');


insert into orders (customers_id, order_date, total_amount) values
(1, '2025-01-01', 1500000),
(1, '2025-01-05', 2300000),
(2, '2025-01-10', 900000),
(3, '2025-01-15', 1200000),
(4, '2025-01-20', 3000000),
(2, '2025-01-22', 1800000),
(5, '2025-01-25', 750000);

select *
from customers
where customers_id in (
    select customers_id
    from orders
);
