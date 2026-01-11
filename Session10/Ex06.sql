USE social_network_pro;

-- Tạo view thống kê số lượng bài viết của từng người dùng
CREATE VIEW view_users_summary AS
SELECT
    u.user_id,
    u.username,
    COUNT(p.post_id) AS total_posts
FROM Users u
LEFT JOIN Posts p
    ON u.user_id = p.user_id
GROUP BY u.user_id, u.username;

-- Truy vấn view để lấy các user có tổng số bài viết > 5
SELECT
    user_id,
    username,
    total_posts
FROM view_users_summary
WHERE total_posts > 5;
