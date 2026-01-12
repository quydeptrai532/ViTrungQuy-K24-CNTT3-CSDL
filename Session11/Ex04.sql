use social_network_pro;

delimiter //

create procedure createpostwithvalidation(
    in p_user_id int,
    in p_content text,
    out result_message varchar(255)
)
begin
    if char_length(p_content) < 5 then
        set result_message = 'noi dung qua ngan';
    else
        insert into posts(user_id, content, created_at)
        values (p_user_id, p_content, now());

        set result_message = 'them bai viet thanh cong';
    end if;
end //

delimiter ;

set @msg = '';

call createpostwithvalidation(3, 'hi', @msg);

select @msg as ket_qua;

set @msg = '';

call createpostwithvalidation(3, 'day la bai viet hop le', @msg);

select @msg as ket_qua;