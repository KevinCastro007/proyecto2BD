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


-- Function for returning the ID of a Lot X Cycle by its lot and cycle
CREATE FUNCTION dbo.APFN_LotXCycle(@Lot VARCHAR(50), @Cycle VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @Result INT
	SET @Result = 0
	SELECT @Result = L.ID FROM dbo.AP_LotXCycle L
		WHERE L.FK_Cycle = dbo.APFN_Cycle(@Cycle) and L.FK_Lot = dbo.APFN_LotID(@Lot)
	RETURN @Result
END
GO