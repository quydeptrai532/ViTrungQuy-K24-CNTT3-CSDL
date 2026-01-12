-- tao database va bang
create database if not exists sociallab;
use sociallab;

create table if not exists posts (
    post_id int primary key auto_increment,
    content text,
    author varchar(255),
    likes_count int default 0
);

delimiter //

-- task 1: create post
create procedure sp_createpost(
    in p_content text,
    in p_author varchar(255),
    out p_post_id int
)
begin
    insert into posts(content, author)
    values (p_content, p_author);

    set p_post_id = last_insert_id();
end //

-- task 2: search post
create procedure sp_searchpost(
    in p_keyword varchar(255)
)
begin
    select post_id, content, author, likes_count
    from posts
    where content like concat('%', p_keyword, '%');
end //

-- task 3: increase like
create procedure sp_increaselike(
    in p_post_id int,
    inout p_likes int
)
begin
    update posts
    set likes_count = likes_count + 1
    where post_id = p_post_id;

    select likes_count
    into p_likes
    from posts
    where post_id = p_post_id;
end //

-- task 4: delete post
create procedure sp_deletepost(
    in p_post_id int
)
begin
    delete from posts
    where post_id = p_post_id;
end //

delimiter ;

-- kiem tra logic

-- tao 2 bai viet
set @id1 = 0;
call sp_createpost('hello world', 'quy', @id1);
select @id1 as post_id_1;

set @id2 = 0;
call sp_createpost('hello mysql stored procedure', 'quy', @id2);
select @id2 as post_id_2;

-- search bai viet co chu hello
call sp_searchpost('hello');

-- tang like cho bai viet
set @likes = 0;
call sp_increaselike(@id1, @likes);
select @likes as new_like_count;

-- xoa 1 bai viet
call sp_deletepost(@id2);

-- xem bang posts sau khi thao tac
select * from posts;

-- drop tat ca stored procedure
drop procedure if exists sp_createpost;
drop procedure if exists sp_searchpost;
drop procedure if exists sp_increaselike;
drop procedure if exists sp_deletepost;
