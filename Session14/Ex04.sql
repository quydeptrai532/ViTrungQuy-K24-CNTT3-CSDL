-- Sử dụng database ss14
use ss14;

-- Xóa bảng nếu đã tồn tại
drop table if exists enrollments;
drop table if exists courses;
drop table if exists students;

-- Bảng students
create table students (
    student_id int auto_increment primary key,
    student_name varchar(50) not null
);

-- Bảng courses
create table courses (
    course_id int auto_increment primary key,
    course_name varchar(100) not null,
    available_seats int not null check (available_seats >= 0)
);

-- Bảng enrollments
create table enrollments (
    enrollment_id int auto_increment primary key,
    student_id int not null,
    course_id int not null,
    enroll_date datetime default current_timestamp,
    foreign key (student_id) references students(student_id),
    foreign key (course_id) references courses(course_id)
);

-- Dữ liệu mẫu
insert into students (student_name) values
('Nguyễn Văn An'),
('Trần Thị Bình');

insert into courses (course_name, available_seats) values
('Cơ sở dữ liệu', 2),
('Lập trình C', 1);

-- Stored Procedure đăng ký học phần (Transaction)
delimiter $$

create procedure enroll_course(
    in p_student_name varchar(50),
    in p_course_name varchar(100)
)
begin
    declare v_student_id int;
    declare v_course_id int;
    declare v_seats int;

    -- Bắt lỗi SQL → rollback
    declare exit handler for sqlexception
    begin
        rollback;
    end;

    start transaction;

    -- Lấy student_id
    select student_id into v_student_id
    from students
    where student_name = p_student_name;

    -- Lấy course_id và số chỗ trống (khóa dòng)
    select course_id, available_seats
    into v_course_id, v_seats
    from courses
    where course_name = p_course_name
    for update;

    -- Kiểm tra còn chỗ không
    if v_seats > 0 then
        -- Thêm đăng ký học phần
        insert into enrollments (student_id, course_id)
        values (v_student_id, v_course_id);

        -- Giảm số chỗ trống
        update courses
        set available_seats = available_seats - 1
        where course_id = v_course_id;

        commit;
    else
        rollback;
    end if;
end$$

delimiter ;

-- Gọi thử stored procedure
call enroll_course('Nguyễn Văn An', 'Cơ sở dữ liệu');

-- Kiểm tra kết quả
select * from courses;
select * from enrollments;
