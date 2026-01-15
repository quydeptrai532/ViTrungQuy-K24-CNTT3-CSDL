use social_network;

-- Thêm cột friends_count nếu chưa có
alter table users
add column friends_count int default 0;

-- Bảng friend_requests
drop table if exists friend_requests;
create table friend_requests (
    request_id int primary key auto_increment,
    from_user_id int not null,
    to_user_id int not null,
    status enum('pending','accepted','rejected') default 'pending',
    foreign key (from_user_id) references users(user_id),
    foreign key (to_user_id) references users(user_id)
);

-- Bảng friends
drop table if exists friends;
create table friends (
    user_id int not null,
    friend_id int not null,
    primary key (user_id, friend_id),
    foreign key (user_id) references users(user_id),
    foreign key (friend_id) references users(user_id)
);

delimiter $$

create procedure sp_accept_friend_request(
    in p_request_id int,
    in p_to_user_id int
)
begin
    declare v_from_user_id int;
    declare v_status varchar(20);
    declare v_count int;

    -- Bắt lỗi SQL → rollback
    declare exit handler for sqlexception
    begin
        rollback;
    end;

    -- Isolation level theo yêu cầu
    set transaction isolation level repeatable read;
    start transaction;

    -- Lấy thông tin request và khóa dòng
    select from_user_id, status
    into v_from_user_id, v_status
    from friend_requests
    where request_id = p_request_id
      and to_user_id = p_to_user_id
    for update;

    -- Kiểm tra request hợp lệ
    if v_from_user_id is null or v_status <> 'pending' then
        rollback;
        return;
    end if;

    -- Kiểm tra đã là bạn trước đó chưa
    select count(*) into v_count
    from friends
    where user_id = p_to_user_id
      and friend_id = v_from_user_id;

    if v_count > 0 then
        rollback;
        return;
    end if;

    -- Thêm quan hệ bạn bè 2 chiều
    insert into friends (user_id, friend_id)
    values (p_to_user_id, v_from_user_id);

    insert into friends (user_id, friend_id)
    values (v_from_user_id, p_to_user_id);

    -- Cập nhật friends_count
    update users
    set friends_count = friends_count + 1
    where user_id in (p_to_user_id, v_from_user_id);

    -- Cập nhật trạng thái request
    update friend_requests
    set status = 'accepted'
    where request_id = p_request_id;

    commit;
end$$

delimiter ;

call sp_accept_friend_request(1, 2);

call sp_accept_friend_request(1, 2);

select * from friends;
select user_id, friends_count from users;
select * from friend_requests;

call sp_accept_friend_request(1, 2);
call sp_accept_friend_request(1, 2);
