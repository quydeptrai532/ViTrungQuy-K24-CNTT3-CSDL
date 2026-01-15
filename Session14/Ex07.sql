use social_network;

-- Thêm cột nếu chưa có
alter table users
add column following_count int default 0,
add column followers_count int default 0;

-- Bảng followers
drop table if exists followers;
create table followers (
    follower_id int not null,
    followed_id int not null,
    primary key (follower_id, followed_id),
    foreign key (follower_id) references users(user_id),
    foreign key (followed_id) references users(user_id)
);

-- Bảng log lỗi
drop table if exists follow_log;
create table follow_log (
    log_id int auto_increment primary key,
    follower_id int,
    followed_id int,
    error_message varchar(255),
    log_time datetime default current_timestamp
);

delimiter $$

create procedure sp_follow_user(
    in p_follower_id int,
    in p_followed_id int
)
begin
    declare v_count int;

    declare exit handler for sqlexception
    begin
        rollback;
        insert into follow_log(follower_id, followed_id, error_message)
        values (p_follower_id, p_followed_id, 'SQL Exception');
    end;

    start transaction;

    -- Kiểm tra follower tồn tại
    select count(*) into v_count
    from users
    where user_id = p_follower_id;

    if v_count = 0 then
        insert into follow_log(follower_id, followed_id, error_message)
        values (p_follower_id, p_followed_id, 'Follower không tồn tại');
        rollback;
        return;
    end if;

    -- Kiểm tra followed tồn tại
    select count(*) into v_count
    from users
    where user_id = p_followed_id;

    if v_count = 0 then
        insert into follow_log(follower_id, followed_id, error_message)
        values (p_follower_id, p_followed_id, 'Followed không tồn tại');
        rollback;
        return;
    end if;

    -- Không được tự follow
    if p_follower_id = p_followed_id then
        insert into follow_log(follower_id, followed_id, error_message)
        values (p_follower_id, p_followed_id, 'Không thể tự follow chính mình');
        rollback;
        return;
    end if;

    -- Kiểm tra đã follow chưa
    select count(*) into v_count
    from followers
    where follower_id = p_follower_id
      and followed_id = p_followed_id;

    if v_count > 0 then
        insert into follow_log(follower_id, followed_id, error_message)
        values (p_follower_id, p_followed_id, 'Đã follow trước đó');
        rollback;
        return;
    end if;

    -- Thực hiện follow
    insert into followers (follower_id, followed_id)
    values (p_follower_id, p_followed_id);

    update users
    set following_count = following_count + 1
    where user_id = p_follower_id;

    update users
    set followers_count = followers_count + 1
    where user_id = p_followed_id;

    commit;
end$$

delimiter ;
