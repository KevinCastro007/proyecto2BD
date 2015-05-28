/* Utilitary functions: Supply */

GO
USE AgriculturalProperty

GO
-- Function for returning the ID of a Supply with a Name as parameter
CREATE FUNCTION APFN_SupplyID(@Name VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @Result INT
	SET @Result = 0
	SELECT @Result = S.ID FROM dbo.AP_Supply S
		WHERE S.Name = @Name
	RETURN @Result
END