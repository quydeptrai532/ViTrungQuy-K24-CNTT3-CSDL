USE social_network_pro;
-- Tạo view thống kê tổng số bài viết của mỗi user
CREATE VIEW view_user_post AS
SELECT 
    user_id,
    COUNT(*) AS total_user_post
FROM Posts
GROUP BY user_id;

-- Hiển thị dữ liệu từ view để kiểm chứng
SELECT * FROM view_user_post;

-- Kết hợp view với bảng Users để lấy họ tên và tổng số bài viết
SELECT 
    u.full_name,
    v.total_user_post
FROM Users u
JOIN view_user_post v
    ON u.user_id = v.user_id;
