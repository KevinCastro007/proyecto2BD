/* Utilitary functions: Cycle */

GO
USE AgriculturalProperty

GO
-- Function for returning the ID of a Cycle with a Start Date and an End Date as parameter
CREATE FUNCTION APFN_CycleID(@StartDate VARCHAR(50),@EndDate VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @Result INT
	SET @Result = 0
	SELECT @Result = C.ID FROM dbo.AP_Cycle C
		WHERE C.StartDate = @StartDate and C.EndDate = @EndDate
	RETURN @Result
END