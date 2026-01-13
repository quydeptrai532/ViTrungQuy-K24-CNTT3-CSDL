USE social_network_pro;

CREATE OR REPLACE VIEW v_public_users AS
SELECT user_id, username, full_name, created_at
FROM users;

CREATE OR REPLACE VIEW v_user_activity AS
SELECT 
    u.user_id,
    u.username,
    COUNT(DISTINCT p.post_id) AS total_posts,
    COUNT(DISTINCT c.comment_id) AS total_comments,
    COUNT(DISTINCT l.post_id) AS total_likes
FROM users u
LEFT JOIN posts p ON u.user_id = p.user_id
LEFT JOIN comments c ON u.user_id = c.user_id
LEFT JOIN likes l ON u.user_id = l.user_id
GROUP BY u.user_id, u.username;

CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_posts_user_id ON posts(user_id);
CREATE INDEX idx_comments_post_id ON comments(post_id);
CREATE INDEX idx_likes_post_user ON likes(post_id, user_id);
CREATE INDEX idx_friends_user_friend ON friends(user_id, friend_id);

DELIMITER $$

CREATE PROCEDURE sp_add_user(
    IN p_username VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_password VARCHAR(255),
    IN p_fullname VARCHAR(100)
)
BEGIN
    INSERT INTO users(username, email, password, full_name, created_at)
    VALUES (p_username, p_email, p_password, p_fullname, NOW());
END$$

CREATE PROCEDURE sp_update_user(
    IN p_user_id INT,
    IN p_fullname VARCHAR(100),
    IN p_email VARCHAR(100)
)
BEGIN
    UPDATE users
    SET full_name = p_fullname,
        email = p_email
    WHERE user_id = p_user_id;
END$$

CREATE PROCEDURE sp_create_post(
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    IF p_content IS NOT NULL AND LENGTH(p_content) > 0 THEN
        INSERT INTO posts(user_id, content, created_at)
        VALUES (p_user_id, p_content, NOW());
    END IF;
END$$

CREATE PROCEDURE sp_add_comment(
    IN p_post_id INT,
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    INSERT INTO comments(post_id, user_id, content, created_at)
    VALUES (p_post_id, p_user_id, p_content, NOW());
END$$

CREATE PROCEDURE sp_like_post(
    IN p_post_id INT,
    IN p_user_id INT
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM likes
        WHERE post_id = p_post_id AND user_id = p_user_id
    ) THEN
        INSERT INTO likes(post_id, user_id)
        VALUES (p_post_id, p_user_id);
    END IF;
END$$

CREATE PROCEDURE sp_add_friend(
    IN p_user_id INT,
    IN p_friend_id INT
)
BEGIN
    INSERT INTO friends(user_id, friend_id, status)
    VALUES (p_user_id, p_friend_id, 'pending');
END$$

CREATE PROCEDURE sp_accept_friend(
    IN p_user_id INT,
    IN p_friend_id INT
)
BEGIN
    UPDATE friends
    SET status = 'accepted'
    WHERE user_id = p_friend_id AND friend_id = p_user_id;
END$$

CREATE PROCEDURE sp_count_posts(
    IN p_user_id INT,
    OUT total_posts INT
)
BEGIN
    SELECT COUNT(*) INTO total_posts
    FROM posts
    WHERE user_id = p_user_id;
END$$

CREATE PROCEDURE sp_suggest_friends(
    IN p_user_id INT
)
BEGIN
    SELECT DISTINCT f2.friend_id AS suggested_user
    FROM friends f1
    JOIN friends f2 ON f1.friend_id = f2.user_id
    WHERE f1.user_id = p_user_id
      AND f2.friend_id != p_user_id
      AND f2.friend_id NOT IN (
          SELECT friend_id
          FROM friends
          WHERE user_id = p_user_id
      );
END$$

CREATE PROCEDURE sp_demo_while(
    IN p_limit INT
)
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= p_limit DO
        INSERT INTO posts(user_id, content, created_at)
        VALUES (1, CONCAT('Demo post ', i), NOW());
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

CALL sp_add_user('nam01', 'nam01@gmail.com', '123456', 'Nguyen Van Nam');
CALL sp_add_user('hoa02', 'hoa02@gmail.com', '123456', 'Tran Thi Hoa');

CALL sp_create_post(1, 'Hello World');
CALL sp_create_post(2, 'My first post');

CALL sp_add_comment(1, 2, 'Nice post!');
CALL sp_add_comment(2, 1, 'Welcome!');

CALL sp_like_post(1, 2);
CALL sp_like_post(2, 1);

CALL sp_add_friend(1, 2);
CALL sp_accept_friend(2, 1);

SET @total = 0;
CALL sp_count_posts(1, @total);
SELECT @total AS total_posts_user_1;

SELECT * FROM v_public_users;
SELECT * FROM v_user_activity;

CALL sp_suggest_friends(1);

CALL sp_demo_while(3);