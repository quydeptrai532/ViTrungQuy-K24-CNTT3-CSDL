use social_network_pro;

delimiter //
create procedure caculate_bonus_point (p_user_id int, inout p_bonus_point int)
begin
 declare total_point int ;
 select count(*) into total_point from posts 
 where user_id =p_user_id;
 if total_point>=20 then 
 set p_bonus_point=p_bonus_point+100;
 elseif total_point>10 then 
 set p_bonus_point=p_bonus_point+50;
 end if;
end //
delimiter ;
SET @bonus = 200;
call caculate_bonus_point(3,@bonus);

select @bonus as bonus_point