-- Câu 1:
DELIMITER //
CREATE PROCEDURE Proce_Ques1 (IN in_dep_name VARCHAR (255))
BEGIN
SELECT A.AccountID, A.FullName, D.DepartmentName FROM `account` A
JOIN department D ON D.DepartmentID = A.DepartmentID
WHERE D.DepartmentName = in_dep_name;
END//
DELIMITER ;
CALL Proce_Ques1('');

-- Câu 2:
DELIMITER //
CREATE PROCEDURE Proce_Ques2 (IN in_group_name VARCHAR(200))
BEGIN
SELECT G.GroupName, count(GA.AccountID) FROM `group account` GA
JOIN `group` G ON GA.GroupID = G.GroupID
WHERE G.GroupName = in_group_name;
END//
DELIMITER ;
CALL Proce_Ques2('');

-- Câu 3:
DELIMITER //
CREATE PROCEDURE Proce_Ques3 (IN in_type_question VARCHAR(200))
BEGIN
SELECT TA.TypeName, count(TA.TypeID) FROM `type question` TQ
LEFT JOIN `question` Q ON TQ.TypeID = Q.TypeID
WHERE MONTH(Q.CreatorDate) = MONTH(now()) AND YEAR(Q.CreatorDate) = YEAR(NOW())
GROUP BY Q.TypeID;
END//
DELIMITER ;
CALL Proce_Ques3('');

-- Câu 4:
-- store:
DROP PROCEDURE IF EXISTS Proce_Ques4;
DELIMITER //
CREATE PROCEDURE Proce_Ques4(OUT out_ID TINYINT)
BEGIN
WITH CTE_CountTypeID AS (
SELECT count(Q.TypeID) AS SL FROM question Q
GROUP BY Q.TypeID
)
SELECT Q.TypeID INTO out_ID FROM question Q
GROUP BY Q.TypeID
HAVING COUNT(Q.TypeID) = (SELECT max(SL) FROM CTE_CountTypeID);
END//
DELIMITER ;
SET @ID =0;
CALL Proce_Ques4(@ID);
SELECT @ID;

-- Câu 5:
DROP PROCEDURE IF EXISTS Proce_Ques5;
DELIMITER //
CREATE PROCEDURE Proce_Ques5()
BEGIN
WITH CTE_MaxTypeID AS(
SELECT count(Q.TypeID) AS SL FROM question Q
GROUP BY Q.TypeID
)
SELECT TQ.TypeName, count(Q.TypeID) AS SL FROM question Q
JOIN `type question` TQ ON TQ.TypeID = Q.TypeID
GROUP BY Q.TypeID
HAVING count(Q.TypeID) = (SELECT MAX(SL) FROM CTE_MaxTypeID);
END//
DELIMITER ;
Call Proce_Ques5();
SET @ID =0;
Call Proce_Ques5(@ID);
SELECT * FROM `type question` WHERE TypeID = @ID;

-- Câu 6:
DELIMITER //
CREATE PROCEDURE Proce_Ques6(IN in_searchText VARCHAR(255))
BEGIN
SELECT 
    A.Username, G.Groupname
FROM
    account A
LEFT JOIN`group account` GA ON A.AccountID = GA.AccountID
RIGHT JOIN `group` G ON G.GroupID = GA.GroupID
WHERE A.Username LIKE CONCAT('%',in_searchText,'%') 
	OR G.GroupName LIKE CONCAT('%',in_searchText,'%');
END//
DELIMITER ;
CALL Proce_Ques6('');

-- Câu 7:
DELIMITER //
CREATE PROCEDURE Proce_Ques7(IN in_fullname VARCHAR(200), IN in_email VARCHAR(200))
BEGIN
	DECLARE v_Username VARCHAR(200) DEFAULT SUBSTRING_INDEX(in_email, '@', 1);
	DECLARE v_DepartmentID INT DEFAULT 0;
	DECLARE v_PositionID INT  DEFAULT 0;
	SELECT 
		DepartmentID
	INTO v_DepartmentID FROM Department
	WHERE
		DepartmentName = 'Phòng Chờ';
	SELECT 
		PositionID
	INTO v_PositionID FROM Position
	WHERE
		PositionName = 'Deverloper';
	INSERT INTO `account` (`Email`, `Username`, `FullName`,
	`DepartmentID`, `PositionID`, `CreateDate`)
	VALUES (in_Email, v_Username, v_Fullname,
	v_DepartmentID, v_PositionID, now());
	END//
	DELIMITER ;
	CALL Proce_Ques7('Banh Bao Xinh','banhbaoxinh@gyahoo.com');
    SELECT * FROM Account WHERE fullname = 'Banh Bao Xinh';

	-- Câu 8:
	DELIMITER //
	CREATE PROCEDURE Proce_Ques8(IN in_TypeName ENUM('Essay', 'Multiple Choice'))
	BEGIN
		SELECT 
		   Q.Content, Count(Q.Content) as Độ_dài_của_Content
		FROM
			Question Q
		WHERE LENGTH(Q.Content) = (SELECT MAX(LENGTH(Q.Content)) 
									FROM Question Q 
									JOIN `Type Question` TQ 
									ON Q.TypeID = TQ.TypeID 
									WHERE TQ.TypeName = in_TypeName);
END//
DELIMITER ;

CALL Proce_Ques8 ('Essay');

CALL Proce_Ques8 ('Multiple Choice');

-- Câu 9:
DELIMITER //
CREATE PROCEDURE Proce_Ques9(IN in_ExamID INT)
BEGIN
	DELETE FROM
		exam
	WHERE ExamID = in_ExamID;

	DELETE FROM
		exam question
	WHERE ExamID = in_ExamID;
END//
DELIMITER ;

CALL Proce_Ques9(1);

-- Câu 10:
DELIMITER $$
CREATE PROCEDURE proc_question10()
BEGIN
	DECLARE v_beforeDeleteTotal INT DEFAULT 0;
    DECLARE v_afterDeleteTotal INT DEFAULT 0;
	SELECT 
		SUM(total)
	INTO v_beforeDeleteTotal FROM
		(SELECT 
			COUNT(a.ExamID) AS total
		FROM
			exam a UNION ALL SELECT 
			COUNT(eq.ExamID)
		FROM
			examquestion eq) temp_table;
            
	DELETE FROM exam 
	WHERE
		YEAR(NOW()) - YEAR(CreateDate) >= 3;
	
    SELECT 
		SUM(total)
	INTO v_afterDeleteTotal FROM
		(SELECT 
			COUNT(a.ExamID) AS total
		FROM
			exam a UNION ALL SELECT 
			COUNT(eq.ExamID)
		FROM
			examquestion eq) temp_table;
            
	select v_beforeDeleteTotal - v_afterDeleteTotal;
    
END$$
DELIMITER ;

CALL Proce_Ques10();

-- Cau 11:
DELIMITER $$
CREATE PROCEDURE proc_question11(IN in_depName VARCHAR(250))
BEGIN
	DECLARE V_depID TINYINT DEFAULT 0;
    DECLARE V_WaitingDepID INT DEFAULT 0;
    SELECT DepartmentID INTO V_depID FROM Department WHERE DepartmentName = in_depName;
    SELECT DepartmentID INTO V_WaitingDepID FROM Department WHERE DepartmentName = 'Phòng Chờ';
    UPDATE Account SET DepartmentID = V_WaitingDepID WHERE DepartmentID = V_depID;
    DELETE FROM Department WHERE DepartmentID = V_depID;
END$$
DELIMITER ;

-- Cau 12:
DROP PROCEDURE IF EXISTS pro_countQuestion_eachMonth_yearNow;
	DELIMITER //
CREATE PROCEDURE	pro_countQuestion_eachMonth_yearNow()
BEGIN
		WITH CTE_12month_year_now (month)  as
		(	SELECT 1 UNION
			SELECT 2 UNION
			SELECT 3 UNION
			SELECT 4 UNION
			SELECT 5 UNION
			SELECT 6 UNION
			SELECT 7 UNION
			SELECT 8 UNION
			SELECT 9 UNION
			SELECT 10 UNION
			SELECT 11 UNION
			SELECT 12	),
            
            
		CTE_Question_year_now as 
		(	SELECT * 
			FROM question as Q
			WHERE year(Q.CreateDate) = year(now()))


		SELECT 		CM.*, COUNT(QQ.questionID) as So_luong_cauhoi_duoc_tao
		FROM 		CTE_12month_year_now as CM
		LEFT JOIN 	CTE_Question_year_now as QQ
		ON CM.month = month(QQ.CreateDate)
		GROUP BY	CM.month;
        
        END //
	DELIMITER ;
CALL pro_countQuestion_eachMonth_yearNow();
