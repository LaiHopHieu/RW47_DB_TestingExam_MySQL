

-- Ques2:
SELECT 
    *
FROM
    department;
    
-- Ques3:
Select
	departmentid
from
	Department
    where DepartmentName = "Sales";
    
-- Ques4:
SELECT 
    Fullname
FROM
    `Account`
WHERE LENGTH(fullname) = (SELECT MAX(LENGTH(fullname)) from `account`)
ORDER BY Fullname DESC;

-- Ques5:
SELECT 
DepartmentID,
MAX(LENGTH(fullname)) as MaxFullnameLength
FROM
    `ACCOUNT`
WHERE
	DepartmentID =3;
    
SELECT 
    *
FROM
    `ACCOUNT`
WHERE
    DepartmenID = 3
        AND LENGTH(fullname) = 16;
    
-- Ques6:
SELECT 
    Groupname
FROM
    `group`
WHERE
    CreateDate < '2019-12-20';
    
-- Ques7:
SELECT 
    QuestionID, count(*) as answer_count
FROM
    `answer`
GROUP BY QuestionID having answer_count >= 4;

-- Ques8:
SELECT 
    `Code`
FROM
    Exam
WHERE
    Duration >= 60 AND CreateDate < '2019-12-20';
    
-- Ques9:
SELECT 
    *
FROM
    `Group`
ORDER BY CreateDate DESC
LIMIT 5;

-- Ques10:
SELECT 
    DepartmentID, COUNT(AccountID)
FROM
    `account`
WHERE
    DepartmentID = 2