/*
 * DATABASE SETUP - SESSION 15 EXAM
 * Database: StudentManagement
 */

DROP DATABASE IF EXISTS StudentManagement;
CREATE DATABASE StudentManagement;
USE StudentManagement;

-- =============================================
-- 1. TABLE STRUCTURE
-- =============================================

-- Table: Students
CREATE TABLE Students (
    StudentID CHAR(5) PRIMARY KEY,
    FullName VARCHAR(50) NOT NULL,
    TotalDebt DECIMAL(10,2) DEFAULT 0
);

-- Table: Subjects
CREATE TABLE Subjects (
    SubjectID CHAR(5) PRIMARY KEY,
    SubjectName VARCHAR(50) NOT NULL,
    Credits INT CHECK (Credits > 0)
);

-- Table: Grades
CREATE TABLE Grades (
    StudentID CHAR(5),
    SubjectID CHAR(5),
    Score DECIMAL(4,2) CHECK (Score BETWEEN 0 AND 10),
    PRIMARY KEY (StudentID, SubjectID),
    CONSTRAINT FK_Grades_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    CONSTRAINT FK_Grades_Subjects FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);

-- Table: GradeLog
CREATE TABLE GradeLog (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID CHAR(5),
    OldScore DECIMAL(4,2),
    NewScore DECIMAL(4,2),
    ChangeDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- 2. SEED DATA
-- =============================================

-- Insert Students
INSERT INTO Students (StudentID, FullName, TotalDebt) VALUES 
('SV01', 'Ho Khanh Linh', 5000000),
('SV03', 'Tran Thi Khanh Huyen', 0);

-- Insert Subjects
INSERT INTO Subjects (SubjectID, SubjectName, Credits) VALUES 
('SB01', 'Co so du lieu', 3),
('SB02', 'Lap trinh Java', 4),
('SB03', 'Lap trinh C', 3);

-- Insert Grades
INSERT INTO Grades (StudentID, SubjectID, Score) VALUES 
('SV01', 'SB01', 8.5), -- Passed
('SV03', 'SB02', 3.0); -- Failed

-- End of File


/* câu 1: trigger kiểm tra score trước khi insert */
delimiter $$

create trigger tg_checkscore
before insert on grades
for each row
begin
    if new.score < 0 then
        set new.score = 0;
    elseif new.score > 10 then
        set new.score = 10;
    end if;
end$$

delimiter ;

/* câu 2: transaction thêm sinh viên mới */
start transaction;

insert into students (studentid, fullname)
values ('sv02', 'ha bich ngoc');

update students
set totaldebt = 5000000
where studentid = 'sv02';

commit;


/* câu 3: trigger ghi log khi cập nhật điểm */
delimiter $$

create trigger tg_loggradeupdate
after update on grades
for each row
begin
    if old.score <> new.score then
        insert into gradelog (studentid, oldscore, newscore, changedate)
        values (old.studentid, old.score, new.score, now());
    end if;
end$$

delimiter ;

/* câu 4: procedure đóng học phí */
delimiter $$

create procedure sp_paytuition()
begin
    declare v_debt decimal(10,2);

    start transaction;

    update students
    set totaldebt = totaldebt - 2000000
    where studentid = 'sv01';

    select totaldebt into v_debt
    from students
    where studentid = 'sv01';

    if v_debt < 0 then
        rollback;
    else
        commit;
    end if;
end$$

delimiter ;


/* câu 5: chặn sửa điểm nếu đã qua môn */
delimiter $$

create trigger tg_preventpassupdate
before update on grades
for each row
begin
    if old.score >= 4.0 then
        signal sqlstate '45000'
        set message_text = 'sinh vien da qua mon, khong duoc phep sua diem';
    end if;
end$$

delimiter ;

/* câu 6: procedure xóa điểm có transaction */
delimiter $$

create procedure sp_deletestudentgrade(
    in p_studentid char(5),
    in p_subjectid char(5)
)
begin
    declare v_score decimal(4,2);

    start transaction;

    select score into v_score
    from grades
    where studentid = p_studentid
      and subjectid = p_subjectid;

    insert into gradelog (studentid, oldscore, newscore, changedate)
    values (p_studentid, v_score, null, now());

    delete from grades
    where studentid = p_studentid
      and subjectid = p_subjectid;

    if row_count() = 0 then
        rollback;
    else
        commit;
    end if;
end$$

delimiter ;



