/* Utilitary functions: Service */

GO
USE AgriculturalProperty

GO
-- Function for returning the ID of a Service with a Name as parameter
CREATE FUNCTION APFN_ServiceID(@Name VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @Result INT
	SET @Result = 0
	SELECT @Result = S.ID FROM dbo.AP_Service S
		WHERE S.Name = @Name
	RETURN @Result
END