USE social_network_pro;

-- Truy vấn tìm tất cả User ở Hà Nội (chưa có index)
EXPLAIN ANALYZE
SELECT *
FROM Users
WHERE hometown = 'Hà Nội';

-- Tạo chỉ mục cho cột hometown
CREATE INDEX idx_hometown
ON Users(hometown);

-- Chạy lại truy vấn sau khi có index
EXPLAIN ANALYZE
SELECT *
FROM Users
WHERE hometown = 'Hà Nội';

-- Xóa chỉ mục idx_hometown
DROP INDEX idx_hometown ON Users;
