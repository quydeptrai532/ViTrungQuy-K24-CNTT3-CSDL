use ss13;

CREATE TABLE likes (
    like_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    post_id INT,
    liked_at DATETIME DEFAULT CURRENT_TIMESTAMP,

        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,

        FOREIGN KEY (post_id)
        REFERENCES posts(post_id)
        ON DELETE CASCADE
);

INSERT INTO likes (user_id, post_id, liked_at) VALUES
(2, 1, '2025-01-10 11:00:00'),
(3, 1, '2025-01-10 13:00:00'),
(1, 3, '2025-01-11 10:00:00'),
(3, 3, '2025-01-12 16:00:00');


delimiter //
create trigger trg_add_like 
after insert 
on likes
for each row
begin 
update posts
set like_count=like_count+1
where posts.post_id=new.post_id;
end //
delimiter ;

delimiter //
create trigger trg_delete_like
after delete 
on likes
for each row
begin 
update posts
set like_count=like_count-1
where posts.post_id=old.post_id and like_count >0;
end //
delimiter ;

create or replace view user_statistics as
select u.user_id,u.username,post_count,sum(like_count)
from users u join posts p on u.user_id=p.user_id
group by u.user_id,u.username,u.post_count;


INSERT INTO likes (user_id, post_id, liked_at) VALUES (2, 3, NOW());

SELECT * FROM posts WHERE post_id = 3;

SELECT * FROM user_statistics;
 