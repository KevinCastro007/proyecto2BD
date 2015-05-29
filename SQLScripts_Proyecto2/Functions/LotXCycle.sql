/* Utilitary functions: Lot X Cycle */

GO
USE AgriculturalProperty

GO
-- Function for returning the ID of a Lot X Cycle
CREATE FUNCTION APFN_LotXCycleID(@LotID INT, @CycleID INT)
RETURNS INT
AS
BEGIN
	DECLARE @Result INT
	SET @Result = 0
	SELECT @Result = L.ID FROM dbo.AP_LotXCycle L
		WHERE L.FK_Cycle = @FK_Cycle and L.FK_Lot = @LotID
	RETURN @Result
END