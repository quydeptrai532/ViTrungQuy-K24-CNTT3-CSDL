-- Xóa database nếu đã tồn tại
drop database if exists ss14;

-- Tạo database
create database ss14;
use ss14;

-- Tạo bảng accounts
create table accounts (
    account_id int auto_increment primary key,
    account_name varchar(100) not null,
    balance decimal(10,2) not null check (balance >= 0)
);

-- Thêm dữ liệu mẫu
insert into accounts (account_name, balance) values
('Nguyễn Văn An', 1000.00),
('Trần Thị Bảy', 500.00);

-- Tạo stored procedure chuyển tiền
delimiter $$

create procedure transfer_money(
    in from_account int,
    in to_account int,
    in amount decimal(10,2)
)
begin
    declare from_balance decimal(10,2);

    -- Bắt lỗi SQL → rollback
    declare exit handler for sqlexception
    begin
        rollback;
    end;

    start transaction;

    -- Lấy số dư tài khoản gửi (khóa dòng)
    select balance into from_balance
    from accounts
    where account_id = from_account
    for update;

    -- Kiểm tra số dư
    if from_balance < amount then
        rollback;
    else
        -- Trừ tiền tài khoản gửi
        update accounts
        set balance = balance - amount
        where account_id = from_account;

        -- Cộng tiền tài khoản nhận
        update accounts
        set balance = balance + amount
        where account_id = to_account;

        commit;
    end if;
end$$

delimiter ;

-- Gọi thử procedure (chuyển 300 từ tài khoản 1 sang 2)
call transfer_money(1, 2, 300.00);

-- Kiểm tra kết quả
select * from accounts;
