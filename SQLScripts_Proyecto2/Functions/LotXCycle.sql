/* Utilitary functions: Lot X Cycle */

GO
USE AgriculturalProperty

GO
-- Function for returning the ID of a Lot X Cycle
CREATE FUNCTION APFN_LotXCycleID(@FK_Lot INT, @FK_Cycle INT)
RETURNS INT
AS
BEGIN
	DECLARE @Result INT
	SET @Result = 0
	SELECT @Result = L.ID FROM dbo.AP_LotXCycle L
		WHERE L.FK_Cycle = @FK_Cycle and L.FK_Lot = @FK_Lot
	RETURN @Result
END