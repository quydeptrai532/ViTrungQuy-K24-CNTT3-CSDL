DROP DATABASE IF EXISTS social_network;
CREATE DATABASE social_network;
USE social_network;

-- Bảng users
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    total_posts INT DEFAULT 0
);

-- Bảng posts
CREATE TABLE posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    content TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Dữ liệu mẫu
INSERT INTO users (username, total_posts) VALUES
('nguyen_van_a', 0),
('le_thi_b', 0);

DELIMITER $$

CREATE PROCEDURE sp_create_post(
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    DECLARE exit handler FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Loi SQL, giao dich da rollback' AS message;
    END;

    -- Validate content
    IF p_content IS NULL OR TRIM(p_content) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Noi dung bai viet khong duoc rong';
    END IF;

    START TRANSACTION;

        -- Insert post
        INSERT INTO posts(user_id, content)
        VALUES (p_user_id, p_content);

        -- Update total_posts
        UPDATE users
        SET total_posts = total_posts + 1
        WHERE user_id = p_user_id;

        -- Neu user_id khong ton tai
        IF ROW_COUNT() = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'User khong ton tai';
        END IF;

    COMMIT;

    SELECT 'Dang bai thanh cong' AS message;

END$$

DELIMITER ;

CALL sp_create_post(1, 'Bai viet dau tien cua Nguyen Van A');

SELECT * FROM posts;
SELECT * FROM users;

CALL sp_create_post(9999, 'Bai viet loi');

SELECT * FROM posts;
SELECT * FROM users;
