USE social_network_pro;

--------------------------------------------------
-- 2) Tạo view view_user_activity_status
--------------------------------------------------
CREATE VIEW view_user_activity_status AS
SELECT
    u.user_id,
    u.username,
    u.gender,
    u.created_at,
    CASE
        WHEN COUNT(DISTINCT p.post_id) > 0
          OR COUNT(DISTINCT c.comment_id) > 0
        THEN 'Active'
        ELSE 'Inactive'
    END AS status
FROM Users u
LEFT JOIN Posts p
    ON u.user_id = p.user_id
LEFT JOIN Comments c
    ON u.user_id = c.user_id
GROUP BY
    u.user_id,
    u.username,
    u.gender,
    u.created_at;

--------------------------------------------------
-- 3) Truy vấn view để kiểm tra kết quả
--------------------------------------------------
SELECT *
FROM view_user_activity_status;

--------------------------------------------------
-- 4) Thống kê số lượng user theo từng trạng thái
--------------------------------------------------
SELECT
    status,
    COUNT(*) AS user_count
FROM view_user_
