use ss13;

create table post_history (
    history_id int auto_increment primary key,
    post_id int,
    old_content text,
    new_content text,
    changed_at datetime,
    changed_by_user_id int,

    foreign key (post_id)
        references posts(post_id)
        on delete cascade
);

delimiter //
create trigger trg_history
before update on posts
for each row
begin
insert into post_history(post_id,old_content,new_content,changed_at,changed_by_user_id)
values (old.post_id,old.content,new.content,now(),old.user_id);
end //
delimiter ;