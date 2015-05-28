/* Utilitary functions: Manager */

GO
USE AgriculturalProperty

GO
-- Function for returning the ID of a Manager with a Name as parameter
CREATE FUNCTION APFN_ManagerID(@Name VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @Result INT
	SET @Result = 0
	SELECT @Result = M.ID FROM dbo.AP_Manager M
		WHERE M.Name = @Name
	RETURN @Result
END