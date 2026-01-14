use ss13;
drop trigger if exists trg_check_like;
delimiter //
create  trigger trg_check_like
before insert
on likes
for each row
begin
declare post_owner int;
select user_id into post_owner
from posts 
where post_id=new.post_id;
if user_id=new.user_id then 
signal sqlstate '45000'
set message_text ='chim be';
end if;
end //
delimiter ;

delimiter //

create trigger trg_check_like_before_insert
before insert on likes
for each row
begin
    declare post_owner int;

    select user_id
    into post_owner
    from posts
    where post_id = new.post_id;

    if post_owner = new.user_id then
        signal sqlstate '45000'
        set message_text = 'user khong duoc tu like bai viet cua minh';
    end if;
end//

create trigger trg_like_after_insert
after insert on likes
for each row
begin
    update posts
    set like_count = like_count + 1
    where post_id = new.post_id;
end//

create trigger trg_like_after_delete
after delete on likes
for each row
begin
    update posts
    set like_count = like_count - 1
    where post_id = old.post_id
      and like_count > 0;
end//

create trigger trg_like_after_update
after update on likes
for each row
begin
    if old.post_id <> new.post_id then
        update posts
        set like_count = like_count - 1
        where post_id = old.post_id
          and like_count > 0;

        update posts
        set like_count = like_count + 1
        where post_id = new.post_id;
    end if;
end//

delimiter ;
