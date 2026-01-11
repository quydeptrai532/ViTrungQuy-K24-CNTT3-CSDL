USE social_network_pro;

--------------------------------------------------
-- 2) Tạo index trên cột username của bảng users
--------------------------------------------------
CREATE INDEX idx_user_username
ON Users(username);

--------------------------------------------------
-- 3) Tạo view view_user_activity_2
-- Thống kê tổng số bài viết và tổng số bạn bè (status = 'accepted')
--------------------------------------------------
CREATE VIEW view_user_activity_2 AS
SELECT
    u.user_id,
    COUNT(DISTINCT p.post_id) AS total_posts,
    COUNT(DISTINCT 
        CASE 
            WHEN f.status = 'accepted' 
            THEN f.friend_id 
        END
    ) AS total_friends
FROM Users u
LEFT JOIN Posts p
    ON u.user_id = p.user_id
LEFT JOIN Friends f
    ON u.user_id = f.user_id
GROUP BY
    u.user_id;

--------------------------------------------------
-- 4) Hiển thị lại view
--------------------------------------------------
SELECT *
FROM view_user_activity_2;

--------------------------------------------------
-- 5) Kết hợp view_user_activity_2 với bảng users
--------------------------------------------------
SELECT
    u.full_name,
    v.total_posts,
    v.total_friends,

    -- Mô tả số bạn bè
    CASE
        WHEN v.total_friends > 5 THEN 'Nhiều bạn bè'
        WHEN v.total_friends BETWEEN 2 AND 5 THEN 'Vừa đủ bạn bè'
        ELSE 'Ít bạn bè'
    END AS friend_description,

    -- Điểm hoạt động bài viết
    CASE
        WHEN v.total_posts > 10 THEN v.total_posts * 1.1
        WHEN v.total_posts BETWEEN 5 AND 10 THEN v.total_posts
        ELSE v.total_posts * 0.9
    END AS post_activity_score

FROM Users u
JOIN view_user_activity_2 v
    ON u.user_id = v.user_id
WHERE v.total_posts > 0
ORDER BY v.total_posts DESC;
