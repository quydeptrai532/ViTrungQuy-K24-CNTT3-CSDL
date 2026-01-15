use social_network;

-- Thêm cột comments_count nếu chưa có
alter table posts
add column comments_count int default 0;

-- Tạo bảng comments
drop table if exists comments;
create table comments (
    comment_id int auto_increment primary key,
    post_id int not null,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (post_id) references posts(post_id),
    foreign key (user_id) references users(user_id)
);

delimiter $$

create procedure sp_post_comment(
    in p_post_id int,
    in p_user_id int,
    in p_content text
)
begin
    declare exit handler for sqlexception
    begin
        rollback;
    end;

    start transaction;

    -- Thêm comment
    insert into comments (post_id, user_id, content)
    values (p_post_id, p_user_id, p_content);

    -- Savepoint sau khi insert comment
    savepoint after_insert;

    /*
        Giả lập lỗi ở bước UPDATE:
        nếu p_content = 'ERROR_TEST' → gây lỗi có chủ đích
    */
    if p_content = 'ERROR_TEST' then
        rollback to after_insert;
        commit;
        return;
    end if;

    -- Cập nhật số lượng comment
    update posts
    set comments_count = comments_count + 1
    where post_id = p_post_id;

    commit;
end$$

delimiter ;
