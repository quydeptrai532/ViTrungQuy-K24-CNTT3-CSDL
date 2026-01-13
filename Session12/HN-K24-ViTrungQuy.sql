CREATE DATABASE StudentDB;
USE StudentDB;
-- 1. Bảng Khoa
CREATE TABLE Department (
    DeptID CHAR(5) PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL
);

-- 2. Bảng SinhVien
CREATE TABLE Student (
    StudentID CHAR(6) PRIMARY KEY,
    FullName VARCHAR(50),
    Gender VARCHAR(10),
    BirthDate DATE,
    DeptID CHAR(5),
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

-- 3. Bảng MonHoc
CREATE TABLE Course (
    CourseID CHAR(6) PRIMARY KEY,
    CourseName VARCHAR(50),
    Credits INT
);

-- 4. Bảng DangKy
CREATE TABLE Enrollment (
    StudentID CHAR(6),
    CourseID CHAR(6),
    Score FLOAT,
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);
INSERT INTO Department VALUES
('IT','Information Technology'),
('BA','Business Administration'),
('ACC','Accounting');

INSERT INTO Student VALUES
('S00001','Nguyen An','Male','2003-05-10','IT'),
('S00002','Tran Binh','Male','2003-06-15','IT'),
('S00003','Le Hoa','Female','2003-08-20','BA'),
('S00004','Pham Minh','Male','2002-12-12','ACC'),
('S00005','Vo Lan','Female','2003-03-01','IT'),
('S00006','Do Hung','Male','2002-11-11','BA'),
('S00007','Nguyen Mai','Female','2003-07-07','ACC'),
('S00008','Tran Phuc','Male','2003-09-09','IT');

INSERT INTO Course VALUES
('C00001','Database Systems',3),
('C00002','C Programming',3),
('C00003','Microeconomics',2),
('C00004','Financial Accounting',3);

INSERT INTO Enrollment VALUES
('S00001','C00001',8.5),
('S00001','C00002',7.0),
('S00002','C00001',6.5),
('S00003','C00003',7.5),
('S00004','C00004',8.0),
('S00005','C00001',9.0),
('S00006','C00003',6.0),
('S00007','C00004',7.0),
('S00008','C00001',5.5),
('S00008','C00002',6.5);

create  or replace view  View_StudentBasic as
select s.StudentID,s.FullName,d.DeptName from student s join Department d on s.deptid=d.deptid;

select * from  View_StudentBasic;

create index idx_users_name on student(fullname);

delimiter //
create procedure GetStudentsIT()
begin
   select s.StudentID,s.FullName,d.DeptName from student s join Department d on s.deptid=d.deptid
   where d.deptname like 'Information Technology';
end //
delimiter ;

call  GetStudentsIT();

create or replace view View_StudentCountByDept as 
select d.DeptName,count(d.deptid) as total_students from student s join Department d on s.deptid=d.deptid
group by d.deptid;

select * from View_StudentCountByDept;

-- tim khoa co nhieu sinh vien nhat
create or replace view View_Max_StudentCountByDept as 
select d.DeptName,count(d.deptid) as total_students from student s join Department d on s.deptid=d.deptid
group by d.deptid
order by total_students desc;

select * from View_Max_StudentCountByDept
limit 1;


delimiter //
create  procedure  GetTopScoreStudent(in p_course_id char(6))
begin 
select s.studentid,s.fullname,e.score
from enrollment e join student s  on s.studentid = e.studentid 
where e.courseid=p_course_id
order by e.score desc
limit 1;
end //
delimiter ;

call GetTopScoreStudent('C00001');


select c.coursename, max(e.score)
from student s join enrollment e  on s.studentid = e.studentid join course c on e.courseid = c.courseid 
where c.courseid='C00001'
group by c.coursename ;

create view View_IT_Enrollment_DB as
select e.StudentID, e.CourseID, e.Score, s.FullName, d.DeptName
from Enrollment e
join Student s on e.StudentID = s.StudentID
join Department d on s.DeptID = d.DeptID
where d.DeptName = 'Information Technology' and e.CourseID = 'C00001'
with check option;


DELIMITER //
create procedure UpdateScore_IT_DB(in p_StudentID char(6), inout p_NewScore float)
begin
    if p_NewScore > 10 then
        set p_NewScore = 10;
    end if;
    update View_IT_Enrollment_DB
    set Score = p_NewScore
    where StudentID = p_StudentID;
end //
DELIMITER ;


set @new_score = 11;
call UpdateScore_IT_DB('S00001', @new_score);
select @new_score as NewScore;
select * from View_IT_Enrollment_DB;

