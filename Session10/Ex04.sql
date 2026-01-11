USE social_network_pro;

--------------------------------------------------
-- 2) COMPOSITE INDEX: created_at + user_id
--------------------------------------------------

-- Truy vấn tìm các bài viết năm 2026 của user_id = 1 (CHƯA có index)
EXPLAIN ANALYZE
SELECT 
    post_id,
    content,
    created_at
FROM Posts
WHERE user_id = 1
  AND created_at >= '2026-01-01'
  AND created_at < '2027-01-01';

-- Tạo chỉ mục phức hợp
CREATE INDEX idx_created_at_user_id
ON Posts(created_at, user_id);

-- Chạy lại truy vấn sau khi có composite index
EXPLAIN ANALYZE
SELECT 
    post_id,
    content,
    created_at
FROM Posts
WHERE user_id = 1
  AND created_at >= '2026-01-01'
  AND created_at < '2027-01-01';

--------------------------------------------------
-- 3) UNIQUE INDEX: email
--------------------------------------------------

-- Truy vấn tìm user có email cụ thể (CHƯA có index)
EXPLAIN ANALYZE
SELECT 
    user_id,
    username,
    email
FROM Users
WHERE email = 'an@gmail.com';

-- Tạo chỉ mục duy nhất trên email
CREATE UNIQUE INDEX idx_email
ON Users(email);

-- Chạy lại truy vấn sau khi có unique index
EXPLAIN ANALYZE
SELECT 
    user_id,
    username,
    email
FROM Users
WHERE email = 'an@gmail.com';

--------------------------------------------------
-- 4) XÓA CHỈ MỤC
--------------------------------------------------

DROP INDEX idx_created_at_user_id ON Posts;
DROP INDEX idx_email ON Users;
