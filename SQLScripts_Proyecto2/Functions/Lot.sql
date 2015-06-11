/* Utilitary functions: Lot */

GO
USE AgriculturalProperty

GO
-- Function for returning the ID of a Lot with a Code as parameter
CREATE FUNCTION APFN_LotID(@Code VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @Result INT
	SET @Result = 0
	SELECT @Result = L.ID FROM dbo.AP_Lot L
		WHERE L.Code = @Code
	RETURN @Result
END