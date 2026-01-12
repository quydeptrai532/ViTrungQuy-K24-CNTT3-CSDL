use social_network_pro;

delimiter //

create procedure calculateuseractivityscore(
    in p_user_id int,
    out activity_score int,
    out activity_level varchar(50)
)
begin
    declare post_count int default 0;
    declare comment_count int default 0;
    declare like_count int default 0;

    -- đếm số bài viết
    select count(*)
    into post_count
    from posts
    where user_id = p_user_id;

    -- đếm số comment của user
    select count(*)
    into comment_count
    from comments
    where user_id = p_user_id;

    -- đếm số like nhận được (like trên post của user)
    select count(*)
    into like_count
    from likes l
    join posts p on l.post_id = p.post_id
    where p.user_id = p_user_id;

    -- tính tổng điểm
    set activity_score = post_count * 10
                        + comment_count * 5
                        + like_count * 3;

    -- phân loại mức độ hoạt động
    set activity_level = case
        when activity_score > 500 then 'rat tich cuc'
        when activity_score between 200 and 500 then 'tich cuc'
        else 'binh thuong'
    end;
end //
delimiter ;

set @score = 0;
set @level = '';

call calculateuseractivityscore(3, @score, @level);

select 
    @score as activity_score,
    @level as activity_level;
