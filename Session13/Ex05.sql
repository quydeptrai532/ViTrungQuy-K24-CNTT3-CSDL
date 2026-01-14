use ss13;

delimiter //

create procedure add_user(
    in p_username varchar(50),
    in p_email varchar(100),
    in p_created_at date
)
begin
    insert into users(username, email, created_at)
    values (p_username, p_email, p_created_at);
end//

create trigger trg_users_before_insert
before insert on users
for each row
begin
    -- kiểm tra email có @ và .
    if new.email not like '%@%.%' then
        signal sqlstate '45000'
        set message_text = 'email khong hop le';
    end if;

    -- kiểm tra username chỉ chứa chữ, số, underscore
    if new.username not regexp '^[a-za-z0-9_]+$' then
        signal sqlstate '45000'
        set message_text = 'username chi duoc chua chu, so va underscore';
    end if;
end//

delimiter ;

-- gọi procedure với dữ liệu hợp lệ
call add_user('valid_user_1', 'valid@email.com', '2025-01-20');

-- gọi procedure với email không hợp lệ
call add_user('user2', 'invalidemail', '2025-01-21');

-- gọi procedure với username không hợp lệ
call add_user('user@@@', 'user3@email.com', '2025-01-22');

-- xem kết quả
select * from users;
