/* Utilitary functions: Lot X Cycle */

GO
USE AgriculturalProperty

GO
-- Function for returning the ID of a Lot X Cycle
CREATE FUNCTION APFN_LotXCycleID(@FK_CropType INT, @FK_Cycle INT, @FK_Attendant INT)
RETURNS INT
AS
BEGIN
	DECLARE @Result INT
	SET @Result = 0
	SELECT @Result = L.ID FROM dbo.AP_LotXCycle L
		WHERE L.FK_CropType  = @FK_CropType and L.FK_Cycle = @FK_Cycle and L.FK_Attendant = @FK_Attendant
	RETURN @Result
END