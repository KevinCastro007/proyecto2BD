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

GO
-- Procedure for returning the ID of a cycle with a lot code
CREATE Procedure APSP_ViewAllCycles(@CodeLot VARCHAR(50))
AS
BEGIN
	SELECT LC.FK_Cycle FROM dbo.AP_LotXCycle LC
		WHERE LC.FK_Lot = dbo.APFN_LotID(@CodeLot)
END

GO
-- Procedure for returning the start dates filtered by lot code
CREATE Procedure APSP_ViewAllCyclesStart(@CodeLot VARCHAR(50))
AS
BEGIN
	SELECT C.StartDate FROM dbo.AP_Cycle C
		inner join dbo.AP_LotXCycle LC on LC.FK_Cycle = C.ID 
		WHERE LC.FK_Cycle = @CodeLot	
END

GO
-- Procedure for returning the end dates filtered by lot code
CREATE Procedure APSP_ViewAllCyclesEnd(@CodeLot VARCHAR(50))
AS
BEGIN
	SELECT C.EndDate FROM dbo.AP_Cycle C
		inner join dbo.AP_LotXCycle LC on LC.FK_Cycle = C.ID 
		WHERE LC.FK_Cycle = @CodeLot
END

