use ss13;

-- 1. tao bang friendships
create table friendships (
    follower_id int,
    followee_id int,
    status enum('pending','accepted') default 'accepted',

    primary key (follower_id, followee_id),

    foreign key (follower_id)
        references users(user_id)
        on delete cascade,

    foreign key (followee_id)
        references users(user_id)
        on delete cascade
);

-- 2. trigger cap nhat follower_count
delimiter //

create trigger trg_friendship_after_insert
after insert on friendships
for each row
begin
    if new.status = 'accepted' then
        update users
        set follower_count = follower_count + 1
        where user_id = new.followee_id;
    end if;
end//

create trigger trg_friendship_after_delete
after delete on friendships
for each row
begin
    if old.status = 'accepted' then
        update users
        set follower_count = follower_count - 1
        where user_id = old.followee_id
          and follower_count > 0;
    end if;
end//

delimiter ;

-- ============================================
-- 3. procedure follow / unfollow
-- ============================================
delimiter //

create procedure follow_user(
    in p_follower_id int,
    in p_followee_id int,
    in p_status enum('pending','accepted')
)
begin
    declare cnt int;

    -- khong duoc tu follow
    if p_follower_id = p_followee_id then
        signal sqlstate '45000'
        set message_text = 'khong duoc tu follow chinh minh';
    end if;

    -- kiem tra trung
    select count(*)
    into cnt
    from friendships
    where follower_id = p_follower_id
      and followee_id = p_followee_id;

    if cnt > 0 then
        signal sqlstate '45000'
        set message_text = 'da ton tai quan he follow';
    end if;

    -- them follow
    insert into friendships(follower_id, followee_id, status)
    values (p_follower_id, p_followee_id, p_status);
end//

create procedure unfollow_user(
    in p_follower_id int,
    in p_followee_id int
)
begin
    delete from friendships
    where follower_id = p_follower_id
      and followee_id = p_followee_id;
end//

delimiter ;

-- 4. view profile chi tiet user
create or replace view user_profile as
select 
    u.user_id,
    u.username,
    u.follower_count,
    u.post_count,
    ifnull(sum(p.like_count),0) as total_likes,
    group_concat(p.content order by p.created_at desc separator ' | ') as recent_posts
from users u
left join posts p on u.user_id = p.user_id
group by u.user_id, u.username, u.follower_count, u.post_count;

-- follow hop le
call follow_user(2, 1, 'accepted');
call follow_user(3, 1, 'accepted');

-- xem follower_count
select user_id, username, follower_count from users;

-- unfollow
call unfollow_user(2, 1);

-- kiem tra lai
select user_id, username, follower_count from users;

-- xem profile chi tiet
select * from user_profile;
