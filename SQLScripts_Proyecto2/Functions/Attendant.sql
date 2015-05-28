/* Utilitary functions: Attendat */

GO
USE AgriculturalProperty

GO
-- Function for returning the ID of an Attendant with a Name as parameter
CREATE FUNCTION APFN_AttendantID(@Name VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @Result INT
	SET @Result = 0
	SELECT @Result = A.ID FROM dbo.AP_Attendant A
		WHERE A.Name = @Name
	RETURN @Result
END

