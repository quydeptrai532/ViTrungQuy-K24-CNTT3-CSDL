use social_network;

-- =====================================================
-- THÊM CỘT likes_count VÀO POSTS (NẾU CHƯA CÓ)
-- =====================================================
alter table posts
add column likes_count int default 0;

-- =====================================================
-- TẠO BẢNG LIKES
-- =====================================================
drop table if exists likes;

create table likes (
    like_id int primary key auto_increment,
    post_id int not null,
    user_id int not null,
    unique key unique_like (post_id, user_id),
    foreign key (post_id) references posts(post_id),
    foreign key (user_id) references users(user_id)
);

-- =====================================================
-- TRƯỜNG HỢP 1: LIKE LẦN ĐẦU → COMMIT
-- =====================================================
start transaction;

-- Thêm lượt like
insert into likes (post_id, user_id)
values (1, 2);

-- Tăng số lượt like của bài viết
update posts
set likes_count = likes_count + 1
where post_id = 1;

commit;

-- Kiểm tra kết quả
select * from likes;
select post_id, likes_count from posts;

-- =====================================================
-- TRƯỜNG HỢP 2: LIKE LẦN 2 (TRÙNG post + user) → ROLLBACK
-- =====================================================
start transaction;

-- Gây lỗi UNIQUE (đã like trước đó)
insert into likes (post_id, user_id)
values (1, 2);

-- Dòng này sẽ không được thực hiện
update posts
set likes_count = likes_count + 1
where post_id = 1;

rollback;

-- Kiểm tra lại dữ liệu (không thay đổi)
select * from likes;
select post_id, likes_count from posts;
