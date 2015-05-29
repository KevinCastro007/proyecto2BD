/* Stored Procedures related with: Lot */

GO
USE AgriculturalProperty

GO
CREATE PROCEDURE APSP_CyclesPeriod(@FK_Lot INT)
AS
BEGIN
	BEGIN TRY
		DECLARE @LotXCycles TABLE(FK_Cycle INT)
		INSERT INTO @LotXCycles(FK_Cycle)
		SELECT LC.FK_Cycle FROM dbo.AP_LotXCycle LC
			inner join dbo.AP_Lot L ON L.ID = LC.FK_Lot
			WHERE LC.FK_Lot = @FK_Lot

		SELECT C.ID, (CONVERT(VARCHAR(50), C.StartDate) + ' -> ' + CONVERT(VARCHAR(50), C.EndDate)) AS Period FROM dbo.AP_Cycle C
			inner join @LotXCycles LC ON LC.FK_Cycle = C.ID
	END TRY
	BEGIN CATCH
		RETURN @@ERROR * -1
	END CATCH
END