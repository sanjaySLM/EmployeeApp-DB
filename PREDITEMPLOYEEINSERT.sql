CREATE PROCEDURE PREDITEMPLOYEEINSERT
(
@id             int,
@name          VARCHAR(200),
@gender        VARCHAR(100),
@salary         DECIMAL (10,2),
@dateOfJoin    VARCHAR(100)
)
AS
BEGIN
UPDATE TBLEMPLOYEE
SET 
FLDEMPLOYEENAME =@name,
FLDGENDER =@gender ,
FLDSALARY =@salary ,
FLDDATEOFJOIN =@dateOfJoin
WHERE FLDEMPLOYEEID = 0
END