SELECT 
    d.DepartmentID,
    d.DepartmentName,
    p.PositionName,
    COUNT(1),concat(A.Fullname)
FROM
    `account` a
        INNER JOIN
    department d ON a.DepartmentID = d.DepartmentID
        INNER JOIN
    position p ON a.PositionID = p.PositionID
GROUP BY d.DepartmentID , p.PositionID;