SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE PREMPLOYEESEARCH
@EMPLOYEENAME		NVARCHAR(100)	= NULL,
@SORTBY				VARCHAR(100)	= NULL,
@SORTDIRECTION		TINYINT			= NULL,
@PAGENUMBER			INT	,
@PAGESIZE			INT ,
@RESULTCOUNT		INT OUTPUT,
@TOTALPAGECOUNT		INT OUTPUT
AS
BEGIN
SET NOCOUNT ON;
DECLARE @ROWFROM BIGINT
DECLARE @ROWTO BIGINT

DECLARE @TEMPTABLE TABLE (FLDEMPLOYEEID SMALLINT, FLDROWNUMBER BIGINT IDENTITY (1,1))
	
	
SET @EMPLOYEENAME = ISNULL(@EMPLOYEENAME,'') + '%'
SET @SORTDIRECTION = ISNULL(@SORTDIRECTION, 0)
	

IF @SORTDIRECTION = 0	
BEGIN

	INSERT INTO @TEMPTABLE (FLDEMPLOYEEID)
	SELECT FLDEMPLOYEEID
	FROM TBLEMPLOYEE (NOLOCK)
	WHERE (@EMPLOYEENAME = '%' OR FLDEMPLOYEENAME LIKE @EMPLOYEENAME)
	ORDER BY 
		CASE 
		WHEN @SORTBY = 'FLDEMPLOYEENAME' THEN FLDEMPLOYEENAME	
		ELSE FLDEMPLOYEENAME
		END 

SET @RESULTCOUNT	= @@ROWCOUNT
SET @TOTALPAGECOUNT = DBO.FNTOTALPAGECOUNT(@RESULTCOUNT,@PAGESIZE)
SET @ROWFROM		= DBO.FNROWFROM(@PAGENUMBER,@PAGESIZE)
SET @ROWTO			= DBO.FNROWTO(@PAGENUMBER,@PAGESIZE)

END

IF @SORTDIRECTION = 1
BEGIN
INSERT INTO @TEMPTABLE (FLDEMPLOYEEID)
SELECT FLDEMPLOYEEID
FROM TBLEMPLOYEE (NOLOCK)
WHERE	(@EMPLOYEENAME = '%' OR FLDEMPLOYEENAME LIKE @EMPLOYEENAME)
ORDER BY 
CASE 
WHEN @SORTBY = 'FLDEMPLOYEENAME' THEN FLDEMPLOYEENAME	
ELSE FLDEMPLOYEENAME
END DESC			

SET @RESULTCOUNT	= @@ROWCOUNT
SET @TOTALPAGECOUNT = DBO.FNTOTALPAGECOUNT(@RESULTCOUNT,@PAGESIZE)
SET @ROWFROM		= DBO.FNROWFROM(@PAGENUMBER,@PAGESIZE)
SET @ROWTO			= DBO.FNROWTO(@PAGENUMBER,@PAGESIZE)

END


SELECT T.FLDEMPLOYEEID,E.FLDEMPLOYEENAME,E.FLDGENDER,E.FLDSALARY,E.FLDDATEOFJOIN
        FROM @TEMPTABLE T
		INNER JOIN TBLEMPLOYEE E (NOLOCK)
			ON T.FLDEMPLOYEEID = E.FLDEMPLOYEEID
	WHERE T.FLDROWNUMBER BETWEEN @ROWFROM AND @ROWTO
	ORDER BY T.FLDROWNUMBER
END
GO