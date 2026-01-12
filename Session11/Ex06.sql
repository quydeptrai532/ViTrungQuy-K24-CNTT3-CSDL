use social_network_pro;

delimiter //
create procedure notifyfriendsonnewpost(
    in p_user_id int,
    in p_content text
)
begin
    declare done int default 0;
    declare v_friend_id int;
    declare v_full_name varchar(255);
    declare v_post_id int;

    -- cursor lấy danh sách bạn bè accepted (hai chiều)
    declare friend_cursor cursor for
        select friend_id
        from friends
        where user_id = p_user_id and status = 'accepted'
        union
        select user_id
        from friends
        where friend_id = p_user_id and status = 'accepted';

    declare continue handler for not found set done = 1;

    -- lấy full_name của người đăng
    select full_name
    into v_full_name
    from users
    where user_id = p_user_id;

    -- thêm bài viết mới
    insert into posts(user_id, content, created_at)
    values (p_user_id, p_content, now());

    set v_post_id = last_insert_id();

    -- duyệt danh sách bạn bè để gửi thông báo
    open friend_cursor;

    read_loop: loop
        fetch friend_cursor into v_friend_id;

        if done = 1 then
            leave read_loop;
        end if;

        -- tránh gửi cho chính mình
        if v_friend_id <> p_user_id then
            insert into notifications(user_id, type, content, created_at)
            values (
                v_friend_id,
                'new_post',
                concat(v_full_name, ' da dang mot bai viet moi'),
                now()
            );
        end if;
    end loop;

    close friend_cursor;

    -- trả về post_id vừa tạo để tiện kiểm tra
    select v_post_id as new_post_id;
end //

delimiter ;

call notifyfriendsonnewpost(3, 'hom nay toi vua dang bai viet moi');

select n.notification_id,
       n.user_id,
       n.type,
       n.content,
       n.created_at
from notifications n
where n.type = 'new_post'
order by n.created_at desc;

