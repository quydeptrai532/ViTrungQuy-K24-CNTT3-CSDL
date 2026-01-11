USE social_network_pro;

--------------------------------------------------
-- Truy vấn CHƯA có index idx_hometown
--------------------------------------------------
EXPLAIN ANALYZE
SELECT 
    u.user_id,
    u.username,
    p.post_id,
    p.content
FROM Users u
JOIN Posts p
    ON u.user_id = p.user_id
WHERE u.hometown = 'Hà Nội'
ORDER BY u.username DESC
LIMIT 10;

--------------------------------------------------
-- Tạo chỉ mục idx_hometown trên cột hometown
--------------------------------------------------
CREATE INDEX idx_hometown
ON Users(hometown);

--------------------------------------------------
-- Truy vấn SAU khi có index idx_hometown
--------------------------------------------------
EXPLAIN ANALYZE
SELECT 
    u.user_id,
    u.username,
    p.post_id,
    p.content
FROM Users u
JOIN Posts p
    ON u.user_id = p.user_id
WHERE u.hometown = 'Hà Nội'
ORDER BY u.username DESC
LIMIT 10;
