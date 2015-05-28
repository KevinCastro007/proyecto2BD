/* Utilitary functions: Deparment */

GO
USE AgriculturalProperty

GO
-- Function for returning the ID of a Deparment with a Name as parameter
CREATE FUNCTION APFN_DeparmentID(@Name VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @Result INT
	SET @Result = 0
	SELECT @Result = D.ID FROM dbo.AP_Deparment D
		WHERE D.Name = @Name
	RETURN @Result
END