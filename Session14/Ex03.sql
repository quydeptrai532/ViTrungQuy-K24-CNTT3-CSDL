-- Sử dụng database ss14
use ss14;

-- Xóa bảng nếu đã tồn tại
drop table if exists payroll;
drop table if exists employees;
drop table if exists company_funds;

-- Bảng employees
create table employees (
    emp_id int auto_increment primary key,
    emp_name varchar(100) not null,
    salary decimal(10,2) not null
);

-- Bảng company_funds
create table company_funds (
    fund_id int auto_increment primary key,
    balance decimal(15,2) not null check (balance >= 0)
);

-- Bảng payroll
create table payroll (
    payroll_id int auto_increment primary key,
    emp_id int not null,
    salary_paid decimal(10,2) not null,
    pay_date datetime default current_timestamp,
    foreign key (emp_id) references employees(emp_id)
);

-- Dữ liệu mẫu
insert into employees (emp_name, salary) values
('Nguyễn Văn A', 5000.00),
('Trần Thị B', 7000.00);

insert into company_funds (balance) values
(20000.00);

-- Stored Procedure trả lương (Transaction)
delimiter $$

create procedure pay_salary(
    in p_emp_id int
)
begin
    declare emp_salary decimal(10,2);
    declare fund_balance decimal(15,2);
    declare bank_status int;

    -- Bắt lỗi SQL → rollback
    declare exit handler for sqlexception
    begin
        rollback;
    end;

    start transaction;

    -- Lấy lương nhân viên
    select salary into emp_salary
    from employees
    where emp_id = p_emp_id;

    -- Lấy số dư quỹ công ty (khóa dòng)
    select balance into fund_balance
    from company_funds
    where fund_id = 1
    for update;

    -- Kiểm tra đủ tiền không
    if fund_balance < emp_salary then
        rollback;
    else
        -- Trừ tiền quỹ công ty
        update company_funds
        set balance = balance - emp_salary
        where fund_id = 1;

        -- Ghi bảng lương
        insert into payroll (emp_id, salary_paid)
        values (p_emp_id, emp_salary);

        -- Giả lập trạng thái ngân hàng (1 = OK, 0 = lỗi)
        set bank_status = 1;

        if bank_status = 0 then
            rollback;
        else
            commit;
        end if;
    end if;
end$$

delimiter ;

-- Gọi thử stored procedure (trả lương cho nhân viên id = 1)
call pay_salary(1);

-- Kiểm tra kết quả
select * from company_funds;
select * from payroll;
