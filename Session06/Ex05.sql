create database session06_2;
use session06_2;

create table customers (
    customer_id int primary key auto_increment,
    full_name varchar(255),
    city varchar(255)
);

create table orders (
    order_id int primary key auto_increment,
    customer_id int,
    order_date date,
    order_status enum('pending','completed','cancelled'),
    total_amount decimal(10,2),
    foreign key (customer_id) references customers(customer_id)
);

insert into customers (full_name, city) values
('Nguyen Van A', 'Ha Noi'),
('Tran Thi B', 'Hai Phong'),
('Le Van C', 'Da Nang'),
('Pham Thi D', 'Ho Chi Minh'),
('Hoang Van E', 'Can Tho');

insert into orders (customer_id, order_date, order_status, total_amount) values
(1, '2025-01-01', 'completed', 3500000),
(2, '2025-01-01', 'completed', 4200000),
(3, '2025-01-01', 'pending',   3800000),
(1, '2025-01-02', 'completed', 5000000),
(4, '2025-01-02', 'completed', 6200000),
(2, '2025-01-03', 'completed', 3000000),
(5, '2025-01-03', 'pending',   2500000),
(3, '2025-01-04', 'completed', 7200000),
(4, '2025-01-04', 'completed', 4100000),
(1, '2025-01-05', 'completed', 9000000),
(5, '2025-01-05', 'completed', 2500000),
(2, '2025-01-06', 'cancelled', 2000000),
(3, '2025-01-06', 'completed', 3500000),
(4, '2025-01-07', 'completed', 6800000),
(5, '2025-01-07', 'completed', 4200000);

select 
    c.full_name as TenKhachHang,
    count(o.order_id) as TongSoDonHang,
    sum(o.total_amount) as TongTienDaChi,
    avg(o.total_amount) as GiaTriDonHangTrungBinh
from customers c
join orders o 
    on c.customer_id = o.customer_id
group by c.customer_id, c.full_name
having 
    count(o.order_id) >= 3
    and sum(o.total_amount) > 10000000
order by TongTienDaChi desc;
