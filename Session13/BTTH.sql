create database BTTHSS13;
use BTTHSS13;

create table users (
    user_id int auto_increment primary key,
    username varchar(50) not null,
    total_posts int default 0
);

create table posts (
    post_id int auto_increment primary key,
    user_id int not null,
    content text,
    created_at datetime default current_timestamp,
    constraint fk_posts_users
        foreign key (user_id)
        references users(user_id)
        on delete cascade
);

create table post_audits (
    audit_id int auto_increment primary key,
    post_id int not null,
    old_content text,
    new_content text,
    changed_at datetime default current_timestamp
);

insert into users (username) values
('alice'),
('bob'),
('charlie');

drop trigger if exists tg_checkpostcontent;
delimiter //
create trigger tg_checkpostcontent
before insert on posts
for each row
begin
    if new.content is null or trim(new.content) = '' then
        signal sqlstate '45000'
        set message_text = 'noi dung bai viet khong duoc de trong';
    end if;
end//
delimiter ;

drop trigger if exists tg_updatepostcountafterinsert;
delimiter //
create trigger tg_updatepostcountafterinsert
after insert on posts
for each row
begin
    update users
    set total_posts = total_posts + 1
    where user_id = new.user_id;
end//
delimiter ;

drop trigger if exists tg_logpostchanges;
delimiter //
create trigger tg_logpostchanges
after update on posts
for each row
begin
    if new.content <> old.content then
        insert into post_audits (
            post_id,
            old_content,
            new_content,
            changed_at
        )
        values (
            old.post_id,
            old.content,
            new.content,
            now()
        );
    end if;
end//
delimiter ;

drop trigger if exists tg_updatepostcountafterdelete;
delimiter //
create trigger tg_updatepostcountafterdelete
after delete on posts
for each row
begin
    update users
    set total_posts = total_posts - 1
    where user_id = old.user_id
      and total_posts > 0;
end//
delimiter ;

insert into posts(user_id, content) values (1, 'bai viet dau tien');
insert into posts(user_id, content) values (1, 'bai viet thu hai');

update posts
set content = 'noi dung da chinh sua'
where post_id = 1;

delete from posts where post_id = 2;

select * from users;
select * from post_audits;
