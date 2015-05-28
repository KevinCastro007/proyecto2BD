/* Utilitary functions: Activity Type */

GO
USE AgriculturalProperty

GO
-- Function for returning the ID of an Activity Type with a Name as parameter
CREATE FUNCTION APFN_ActivityTypeID(@Name VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @Result INT
	SET @Result = 0
	SELECT @Result = AT.ID FROM dbo.AP_ActivityType AT
		WHERE AT.Name = @Name
	RETURN @Result
END