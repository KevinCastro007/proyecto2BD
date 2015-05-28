/* Stored Procedures related with: Lot X Cycle - */

GO
USE AgriculturalProperty

GO
-- Procudedure for inserting a LotXCycle
CREATE PROCEDURE APSP_InsertLotXCycle(@LotCode VARCHAR(50), @CropType VARCHAR(50), @CycleStartDate DATE, @CycleEndDate DATE, @Attendant VARCHAR(50))
AS
BEGIN
	BEGIN TRY
		IF (dbo.APFN_CropTypeID(@CropType) <> 0 and dbo.APFN_CycleID(@CycleStartDate, @CycleEndDate) <> 0 and 
			dbo.APFN_AttendatID(@Attendant) <> 0 and dbo.APFN_LotID(@LotCode) <> 0) 
		BEGIN
			INSERT INTO dbo.AP_LotXCycle(FK_Lot, FK_CropType, FK_Cycle, FK_Attendant, ServicesBalance, SuppliesBalance, MachineryBalance)
				VALUES(dbo.APFN_LotID(@LotCode), dbo.APFN_CropTypeID(@CropType), dbo.APFN_CycleID(@CycleStartDate, @CycleEndDate), dbo.APFN_AttendatID(@Attendant), 0, 0, 0) 
			RETURN 1
		END
		ELSE
			RETURN 0		
	END TRY
	BEGIN CATCH
		RETURN @@ERROR * -1
	END CATCH
END
