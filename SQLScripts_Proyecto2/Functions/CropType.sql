/* Utilitary functions: Crop Type */

GO
USE AgriculturalProperty

GO
-- Function for returning the ID of a Crop Type with a Name as parameter
CREATE FUNCTION APFN_CropTypeID(@Name VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @Result INT
	SET @Result = 0
	SELECT @Result = CT.ID FROM dbo.AP_CropType CT
		WHERE CT.Name = @Name
	RETURN @Result
END