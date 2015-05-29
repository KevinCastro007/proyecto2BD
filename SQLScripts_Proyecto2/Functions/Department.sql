/* Utilitary functions: Department */

GO
USE AgriculturalProperty

GO
-- Function for returning the ID of a Department with a Name as parameter
CREATE FUNCTION APFN_DepartmentID(@Name VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @Result INT
	SET @Result = 0
	SELECT @Result = D.ID FROM dbo.AP_Department D
		WHERE D.Name = @Name
	RETURN @Result
END