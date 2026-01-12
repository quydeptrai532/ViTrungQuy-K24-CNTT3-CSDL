use social_network_pro

delimiter //
create procedure get_user_info(in p_user_id int)
begin
    select post_id as PostId,
    content as Noidung,
    created_at AS ThoiGianTao
    from posts
    where user_id=p_user_id;
end //
delimiter ;

call get_user_info(3);