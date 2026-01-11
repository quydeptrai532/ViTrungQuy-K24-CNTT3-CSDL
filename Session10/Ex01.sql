USE social_network_pro;
-- Tạo view hiển thị người dùng có họ "Nguyễn"
CREATE VIEW view_users_firstname AS
SELECT 
    user_id,
    username,
    full_name,
    email,
    created_at
FROM Users
WHERE full_name LIKE 'Nguyễn%';

-- Hiển thị dữ liệu từ view
SELECT * FROM view_users_firstname;

-- Thêm một người dùng mới có họ "Nguyễn"
INSERT INTO Users (username, full_name, email, created_at)
VALUES ('nguyenvana', 'Nguyễn Văn A', 'nguyenvana@gmail.com', NOW());

-- Kiểm tra lại view sau khi thêm
SELECT * FROM view_users_firstname;

-- Xóa người dùng vừa thêm
DELETE FROM Users
WHERE username = 'nguyenvana';

-- Kiểm tra lại view sau khi xóa
SELECT * FROM view_users_firstname;
