/* Stored Procedures related with: Lot X Cycle - */

GO
USE AgriculturalProperty

GO
-- Procedure for returning the ID of a Lot X Cycle
CREATE PROCEDURE APSP_LotXCycleID(@FK_Lot INT, @FK_Cycle INT)
AS
BEGIN
	SELECT LC.ID FROM dbo.AP_LotXCycle LC
		WHERE LC.FK_Lot = @FK_Lot and LC.FK_Cycle = @FK_Cycle
END

GO
-- Procedure for returning the whole information of a Lot X Cycle
CREATE PROCEDURE APSP_LotXCycle(@ID INT)
AS
BEGIN
	SELECT CT.Name AS CropType, LC.ServicesBalance, LC.SuppliesBalance, LC.MachineryBalance FROM dbo.AP_LotXCycle LC
		inner join dbo.AP_CropType CT ON CT.ID = LC.FK_CropType
		WHERE LC.ID = @ID
END