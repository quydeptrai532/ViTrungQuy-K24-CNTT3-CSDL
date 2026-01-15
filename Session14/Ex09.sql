use social_network;

-- ===============================
-- BẢNG LOG XÓA BÀI VIẾT
-- ===============================
drop table if exists delete_log;
create table delete_log (
    log_id int auto_increment primary key,
    post_id int not null,
    deleted_by int not null,
    deleted_at datetime default current_timestamp
);

delimiter $$

create procedure sp_delete_post(
    in p_post_id int,
    in p_user_id int
)
begin
    declare v_owner_id int;

    -- Bắt lỗi SQL → rollback
    declare exit handler for sqlexception
    begin
        rollback;
    end;

    start transaction;

    -- Kiểm tra bài viết tồn tại và thuộc về user
    select user_id into v_owner_id
    from posts
    where post_id = p_post_id;

    if v_owner_id is null or v_owner_id <> p_user_id then
        rollback;
        return;
    end if;

    -- Xóa likes của bài viết
    delete from likes
    where post_id = p_post_id;

    -- Xóa comments của bài viết
    delete from comments
    where post_id = p_post_id;

    -- Xóa bài viết
    delete from posts
    where post_id = p_post_id;

    -- Giảm posts_count của user
    update users
    set posts_count = posts_count - 1
    where user_id = p_user_id
      and posts_count > 0;

    -- Ghi log xóa bài
    insert into delete_log (post_id, deleted_by)
    values (p_post_id, p_user_id);

    commit;
end$$

delimiter ;
