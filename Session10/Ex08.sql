USE social_network_pro;

--------------------------------------------------
-- 2) Tạo index idx_user_gender trên cột gender
--------------------------------------------------
CREATE INDEX idx_user_gender
ON Users(gender);

--------------------------------------------------
-- 3) Tạo view view_popular_posts
--------------------------------------------------
CREATE VIEW view_popular_posts AS
SELECT
    p.post_id,
    u.username,
    p.content,
    COUNT(DISTINCT l.like_id)    AS total_likes,
    COUNT(DISTINCT c.comment_id) AS total_comments
FROM Posts p
JOIN Users u
    ON p.user_id = u.user_id
LEFT JOIN Likes l
    ON p.post_id = l.post_id
LEFT JOIN Comments c
    ON p.post_id = c.post_id
GROUP BY
    p.post_id,
    u.username,
    p.content;

--------------------------------------------------
-- 4) Truy vấn dữ liệu từ view view_popular_posts
--------------------------------------------------
SELECT *
FROM view_popular_posts;

--------------------------------------------------
-- 5) Liệt kê các bài viết có tổng tương tác > 10
-- (like + comment), sắp xếp giảm dần
--------------------------------------------------
SELECT
    post_id,
    username,
    content,
    total_likes,
    total_comments,
    (total_likes + total_comments) AS total_interactions
FROM view_popular_posts
WHERE (total_likes + total_comments) > 10
ORDER BY total_interactions DESC;
