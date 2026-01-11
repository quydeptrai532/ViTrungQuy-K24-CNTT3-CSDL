USE social_network_pro;

--------------------------------------------------
-- 2) Tạo index idx_user_gender trên cột gender
--------------------------------------------------
CREATE INDEX idx_user_gender
ON Users(gender);

--------------------------------------------------
-- 3) Tạo view view_user_activity
--------------------------------------------------
CREATE VIEW view_user_activity AS
SELECT
    u.user_id,
    COUNT(DISTINCT p.post_id)    AS total_posts,
    COUNT(DISTINCT c.comment_id) AS total_comments
FROM Users u
LEFT JOIN Posts p
    ON u.user_id = p.user_id
LEFT JOIN Comments c
    ON u.user_id = c.user_id
GROUP BY
    u.user_id;

--------------------------------------------------
-- 4) Hiển thị dữ liệu từ view
--------------------------------------------------
SELECT *
FROM view_user_activity;

--------------------------------------------------
-- 5) Kết hợp view với bảng Users theo yêu cầu
--------------------------------------------------
SELECT
    u.user_id,
    u.username,
    v.total_posts,
    v.total_comments
FROM Users u
JOIN view_user_activity v
    ON u.user_id = v.user_id
WHERE v.total_posts > 5
  AND v.total_comments > 20
ORDER BY v.total_comments DESC
LIMIT 5;
