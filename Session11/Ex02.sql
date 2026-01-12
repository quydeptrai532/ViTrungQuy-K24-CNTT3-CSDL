use social_network_pro

delimiter //
create procedure calculate_post_like(in p_post_id int , out total_like int)
begin 
select count(*) into total_like from likes l
where post_id = p_post_id;
end //
delimiter ;

CALL calculate_post_like(103, @tong_like);
SELECT @tong_like AS TongLike;

