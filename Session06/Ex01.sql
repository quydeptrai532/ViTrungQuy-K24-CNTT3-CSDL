create database session06;
use session06;

create table customers(
customer_id int primary key auto_increment,
full_name varchar(255),
city varchar (255)
);

create table orders(
order_id int primary key auto_increment,
customer_id int,
foreign key(customer_id) references customers(customer_id),
order_date date,
order_status enum('pending','completed','cancelled')
);

insert into customers (full_name, city) values
('Nguyen Van A', 'Ha Noi'),
('Tran Thi B', 'Hai Phong'),
('Le Van C', 'Da Nang'),
('Pham Thi D', 'Ho Chi Minh'),
('Hoang Van E', 'Can Tho');


insert into orders (customer_id, order_date, order_status) values
(1, '2025-01-01', 'completed'),
(1, '2025-01-03', 'pending'),
(2, '2025-01-05', 'completed'),
(3, '2025-01-07', 'cancelled'),
(4, '2025-01-10', 'pending');

-- Hien thi danh sach don hang kem ten khach hang
select 
    o.order_id,
    o.order_date,
    o.order_status,
    c.full_name
from orders o
join customers c
    on o.customer_id = c.customer_id;

-- Hien thi moi khach hang da dat bao nhieu don hang 
select c.full_name as Ten,count(o.customer_id)
from orders o
join customers c on o.customer_id=c.customer_id
group by o.customer_id
