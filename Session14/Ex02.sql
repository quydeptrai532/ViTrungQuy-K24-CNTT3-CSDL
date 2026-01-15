-- Sử dụng database ss14
use ss14;

-- Xóa bảng nếu đã tồn tại
drop table if exists orders;
drop table if exists products;

-- Bảng products
create table products (
    product_id int auto_increment primary key,
    product_name varchar(100) not null,
    price decimal(10,2) not null,
    stock int not null check (stock >= 0)
);

-- Bảng orders
create table orders (
    order_id int auto_increment primary key,
    product_id int not null,
    quantity int not null,
    order_date datetime default current_timestamp,
    foreign key (product_id) references products(product_id)
);

-- Dữ liệu mẫu
insert into products (product_name, price, stock) values
('Laptop', 1500.00, 10),
('Chuột không dây', 20.00, 50);

-- Stored Procedure đặt hàng (Transaction)
delimiter $$

create procedure place_order(
    in p_product_id int,
    in p_quantity int
)
begin
    declare current_stock int;

    -- Bắt lỗi SQL → rollback
    declare exit handler for sqlexception
    begin
        rollback;
    end;

    start transaction;

    -- Lấy tồn kho và khóa dòng
    select stock into current_stock
    from products
    where product_id = p_product_id
    for update;

    -- Kiểm tra tồn kho
    if current_stock < p_quantity then
        rollback;
    else
        -- Tạo đơn hàng
        insert into orders (product_id, quantity)
        values (p_product_id, p_quantity);

        -- Giảm tồn kho
        update products
        set stock = stock - p_quantity
        where product_id = p_product_id;

        commit;
    end if;
end$$

delimiter ;

-- Test: mua 3 Laptop
call place_order(1, 3);

-- Kiểm tra
select * from products;
select * from orders;
