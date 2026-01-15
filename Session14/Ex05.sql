-- ===============================
-- SỬ DỤNG DATABASE
-- ===============================
drop database if exists social_network;
create database social_network;
use social_network;

-- ===============================
-- BẢNG USERS
-- ===============================
create table users (
    user_id int primary key auto_increment,
    username varchar(50) not null,
    posts_count int default 0
);

-- ===============================
-- BẢNG POSTS
-- ===============================
create table posts (
    post_id int primary key auto_increment,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (user_id) references users(user_id)
);

-- ===============================
-- DỮ LIỆU MẪU
-- ===============================
insert into users (username) values
('alice'),
('bob');

-- =====================================================
-- TRƯỜNG HỢP 1: THÀNH CÔNG → COMMIT
-- =====================================================
start transaction;

-- Thêm bài viết mới
insert into posts (user_id, content)
values (1, 'Bài viết đầu tiên của Alice');

-- Cập nhật số lượng bài viết
update users
set posts_count = posts_count + 1
where user_id = 1;

-- Xác nhận giao dịch
commit;

-- Kiểm tra kết quả
select * from users;
select * from posts;

-- =====================================================
-- TRƯỜNG HỢP 2: LỖI CỐ Ý → ROLLBACK
-- user_id = 999 KHÔNG TỒN TẠI (vi phạm khóa ngoại)
-- =====================================================
start transaction;

-- Thao tác này sẽ gây lỗi
insert into posts (user_id, content)
values (999, 'Bài viết lỗi – user không tồn tại');

-- Dòng này sẽ KHÔNG được thực hiện
update users
set posts_count = posts_count + 1
where user_id = 999;

-- Nếu có lỗi → rollback
rollback;

-- Kiểm tra lại dữ liệu (không có thay đổi)
select * from users;
select * from posts;
