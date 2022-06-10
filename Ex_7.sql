-- Câu 1:
DROP TRIGGER IF EXISTS Check_Insert_Group;
DELIMITER //
CREATE TRIGGER Check_Insert_Group
BEFORE INSERT ON `Group`
FOR EACH ROW
BEGIN
DECLARE v_CreateDate DATETIME;
SET v_CreateDate = DATE_SUB(NOW(), INTERVAL 1 YEAR);
IF (NEW.CreateDate <= v_CreateDate) THEN
SIGNAL SQLSTATE '12345'
SET MESSAGE_TEXT = "Can't create this group";
END IF;
END //
DELIMITER ;

-- Câu 2:
DROP TRIGGER IF EXISTS Check_User_Department;
DELIMITER //
CREATE TRIGGER Check_User_Department
BEFORE INSERT ON `account`
FOR EACH ROW
BEGIN
IF (NEW.DepartmentID IN (Select DepartmentID from Department WHERE DepartmentName = "Sales")) THEN
SIGNAL SQLSTATE '12345'
SET MESSAGE_TEXT = 'Department "Sales" cannot add more user';
END IF;
END //
DELIMITER ;

-- Câu 3:
DROP TRIGGER IF EXISTS Check_User_Morethan5;
DELIMITER //
CREATE TRIGGER Check_User_Morethan5
BEFORE INSERT ON `group account`
FOR EACH ROW
BEGIN
IF((SELECT A.COUNT FROM 
(SELECT COUNT(1) COUNT, GroupID FROM `group account` WHERE GroupID = NEW.GroupID GROUP BY groupid) A) >= 5) THEN
SIGNAL SQLSTATE '12345'
SET MESSAGE_TEXT = "Can't Create this Account (More than 5 Account in Group)";
END IF;
END //
DELIMITER ;

-- Câu 4:
DROP TRIGGER IF EXISTS Check_Exam_Morethan10Quest;
DELIMITER //
CREATE TRIGGER Check_Exam_Morethan10Quest
BEFORE INSERT ON `exam question`
FOR EACH ROW
BEGIN
IF((SELECT A.COUNT from (SELECT count(1) COUNT, ExamID FROM `exam question` where NEW.ExamID = ExamId GROUP BY ExamId) A) >=10) THEN
SIGNAL SQLSTATE '12345'
SET MESSAGE_TEXT = "Can't Insert this Exam (More than 10 Question in Exam)";
END IF;
END //
DELIMITER ;

-- Câu 5:
DROP TRIGGER IF EXISTS Check_DeleteEmail;
DELIMITER //
CREATE TRIGGER Check_DeleteEmail
BEFORE DELETE ON `Account`
FOR EACH ROW
BEGIN
IF((SELECT A.Email from `Account` A WHERE OLD.Email = A.Email) = 'admin@gmail.com') THEN
SIGNAL SQLSTATE '12345'
SET MESSAGE_TEXT = "(Đây là tài khoản admin, không cho phép user xóa";
ELSE 
	DELETE FROM `Group Account` WHERE OLD.AccountID = AccountID;
END IF;
END //
DELIMITER ;
-- DELETE FROM `Account` WHERE Email = 'admin@gmail.com';

-- Câu 6:
DROP TRIGGER IF EXISTS Check_CreateAccount_WthoutDepID;
DELIMITER //
CREATE TRIGGER Check_CreateAccount_WthoutDepID
BEFORE INSERT ON `account`
FOR EACH ROW
BEGIN
DECLARE V_CheckDepID INT;
SET V_CheckDepID = (select DepartmentID from Department Where DepartmentName = 'Phòng Chờ');
IF(NEW.departmentID is NULL) THEN 
SET NEW.DepartmentID = V_CheckDepID;
END IF;
END //
DELIMITER ;
-- INSERT INTO `Account` VALUES (998, 'testing@gmail.com', 'Hiệp', 'Hiệp Hổ Báo', NULL, 50, '2022-04-06');

-- Câu 7:
DROP TRIGGER IF EXISTS SetMaxAnswer_ForQues;
DELIMITER $$
CREATE TRIGGER SetMaxAnswer_ForQues
BEFORE INSERT ON `answer`
FOR EACH ROW
BEGIN
DECLARE v_CountAnsInQUes INT;
DECLARE v_CountAnsIsCorrects INT;

SELECT count(A.QuestionID) INTO v_CountAnsInQUes FROM answer A WHERE
A.QuestionID = NEW.QuestionID;
SELECT count(1) INTO v_CountAnsIsCorrects FROM answer A WHERE A.QuestionID =
NEW.QuestionID AND A.isCorrect = NEW.isCorrect;
IF (v_CountAnsInQUes > 4 ) OR (v_CountAnsIsCorrects >2) THEN

SIGNAL SQLSTATE '12345'
SET MESSAGE_TEXT = "Can't insert more data check again";

END IF;
END $$
DELIMITER ;

-- Câu 8:
DROP TRIGGER IF EXISTS Trg_Gender;
DELIMITER //
CREATE TRIGGER Trg_Gender
BEFORE INSERT ON `Account`
FOR EACH ROW
BEGIN
IF NEW.Gender = 'Nam' THEN
SET NEW.Gender = 'M';
ELSEIF NEW.Gender = 'Nữ' THEN
SET NEW.Gender = 'F';
ELSE SET NEW.Gender = 'U';
END IF ;
END //
DELIMITER ;

-- Câu 9:
DROP TRIGGER IF EXISTS Check_Exam_Before_Delete;
DELIMITER //
CREATE TRIGGER Check_Exam_Before_Delete
BEFORE DELETE ON `exam`
FOR EACH ROW
BEGIN
DECLARE V_Message VARCHAR(255) DEFAULT CONCAT('Không cho xóa Exam này', OLD.CreateDate); 
IF (OLD.CreateDate > DATE_SUB(NOW(),INTERVAL 2 DAY)) THEN
SIGNAL SQLSTATE '12345'
SET MESSAGE_TEXT = V_Message;
END IF;
END //
DELIMITER ;

-- Câu 10:
-- INSERT:
DROP TRIGGER IF EXISTS Check_Ques_Before_Update;
DELIMITER //
CREATE TRIGGER Check_Ques_Before_Update
BEFORE INSERT ON `question`
FOR EACH ROW
BEGIN
IF NEW.QuestionID NOT IN (SELECT 
    Q.QuestionID
FROM
    question Q
        LEFT JOIN
    `exam question` EQ ON Q.QuestionID = EQ.QuestionID
WHERE
    EQ.ID IS NULL) THEN
SIGNAL SQLSTATE '12345'
SET MESSAGE_TEXT = 'Can not update this Question';
END IF;
END //
DELIMITER ;

-- DELETE:
DROP TRIGGER IF EXISTS Check_Ques_Before_Delete;
DELIMITER //
CREATE TRIGGER Check_Ques_Before_Delete
BEFORE DELETE ON `question`
FOR EACH ROW
BEGIN
DECLARE V_Message VARCHAR(255) DEFAULT CONCAT('Không cho xóa Question này với ID = ', OLD.QuestionID); 
IF OLD.QuestionID NOT IN (SELECT 
    Q.QuestionID
FROM
    question Q
        LEFT JOIN
    `exam question` EQ ON Q.QuestionID = EQ.QuestionID
WHERE
    EQ.ID IS NULL) THEN
SIGNAL SQLSTATE '12345'
SET MESSAGE_TEXT = V_Message;
END IF;
END //
DELIMITER ;
