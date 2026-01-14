create database ss13;
use ss13;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at DATE,
    follower_count INT DEFAULT 0,
    post_count INT DEFAULT 0
);

CREATE TABLE posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    content TEXT,
    created_at DATETIME,
    like_count INT DEFAULT 0,

        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);


INSERT INTO users (username, email, created_at) VALUES
('alice', 'alice@example.com', '2025-01-01'),
('bob', 'bob@example.com', '2025-01-02'),
('charlie', 'charlie@example.com', '2025-01-03');

INSERT INTO posts (user_id, content, created_at) VALUES
(1, 'Hello, this is Alice first post', NOW()),
(1, 'Alice second post', NOW()),
(2, 'Bob says hello', NOW());

delimiter //
create trigger trg_add_post 
after insert 
on posts
for each row
begin 
update users
set post_count=post_count+1
where users.user_id=new.user_id;
end //
delimiter ;

delimiter //
create trigger trg_delete_post 
after delete 
on posts
for each row
begin 
update users
set post_count=post_count-1
where users.user_id=old.user_id and post_count >0;
end //
delimiter ;
