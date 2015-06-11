/* Utilitary functions: Property */

GO
USE AgriculturalProperty

GO
-- Function for returning the ID of a Property with a Name as parameter
CREATE FUNCTION APFN_PropertyID(@Name VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @Result INT
	SET @Result = 0
	SELECT @Result = P.ID FROM dbo.AP_Property P
		WHERE P.Name = @Name
	RETURN @Result
END