/* Utilitary functions: Request Type */

GO
USE AgriculturalProperty

GO
-- Function for returning the ID of an Request Type with a Name as parameter
CREATE FUNCTION APFN_RequestTypeID(@Name VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @Result INT
	SET @Result = 0
	SELECT @Result = RT.ID FROM dbo.AP_RequestType RT
		WHERE RT.Name = @Name
	RETURN @Result
END

GO
CREATE FUNCTION APFN_RequestTypeManagerID(@RequestName VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @Result INT
	SET @Result = 0
	SELECT @Result = M.ID FROM dbo.AP_Manager M
		inner join dbo.AP_RequestType RT ON RT.FK_Manager = M.ID
		WHERE RT.Name = @RequestName
	RETURN @Result
END