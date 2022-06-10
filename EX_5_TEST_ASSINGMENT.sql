-- Ex5:
-- Ques1:
CREATE view V_Sale as
SELECT 
   *
FROM
    `account` AS A
WHERE DepartmentID IN (SELECT 
            Departmentid
        FROM
            department AS D
        WHERE
            DepartmentName = 'Sales');
-- Ques2:
CREATE VIEW V_AccinGroup as
-- Subquery:
SELECT 
    A.*,
    COUNT(GA.Accountid) AS `So_Luong_Group_Ma_Nhan_Vien_Tham_Gia`
FROM
    `Account` AS A
        LEFT JOIN
    `group account` AS GA ON A.Accountid = GA.AccountID
GROUP BY GA.AccountID Order by `So_Luong_Group_Ma_Nhan_Vien_Tham_Gia` DESC Limit 1;
-- Offical:
SELECT 
    A.*,
    COUNT(GA.Accountid) AS `So_Luong_Group_Ma_Nhan_Vien_Tham_Gia`
FROM
    `Account` AS A
        LEFT JOIN
    `group account` AS GA ON A.Accountid = GA.AccountID
GROUP BY GA.AccountID Having `So_Luong_Group_Ma_Nhan_Vien_Tham_Gia` = (SELECT 
    COUNT(GA.Accountid) AS `So_Luong_Group_Ma_Nhan_Vien_Tham_Gia`
FROM
    `Account` AS A
        LEFT JOIN
    `group account` AS GA ON A.Accountid = GA.AccountID
GROUP BY GA.AccountID Order by `So_Luong_Group_Ma_Nhan_Vien_Tham_Gia` DESC Limit 1);

-- Ques3: 
CREATE or REPLACE VIEW V_QuesContent as
SELECT 
    *
FROM
    question
WHERE
    LENGTH(Content) > 20;
-- xoa view:
DROP VIEW V_QuesContent;
-- Xoa Question co content qua dai:
DELETE from question where Questionid in (SELECT Questionid from v_quescontent); 
-- Xoa Content cua cau hoi ma content qua dai:
UPDATE Question
set content = NULL WHERE Questionid in (SELECT Questionid from v_quescontent);
-- Ques4:
DROP VIEW IF EXISTS Department_employee_max;
CREATE VIEW Department_employee_max as

SELECT 
    A.DepartmentID, D.DepartmentName, COUNT(A.DepartmentID)
FROM
    department AS D
        JOIN
    `account` AS A ON D.DepartmentID = A.DepartmentID
GROUP BY A.DepartmentID
HAVING COUNT(A.DepartmentID) = (SELECT 
        COUNT(A.DepartmentID)
    FROM
        department AS D
            JOIN
        `account` AS A ON D.DepartmentID = A.DepartmentID
    GROUP BY A.DepartmentID
    ORDER BY COUNT(A.DepartmentID) DESC
    LIMIT 1)
;
SELECT 
    *
FROM
    Department_employee_max;

-- Ques5:
CREATE or REPLACE VIEW V_Nguyen as
SELECT 
    Q.*
FROM
    question AS Q
	JOIN
    `account` AS A ON A.AccountID = Q.CreatorID where A.Fullname like "Nguyen%";