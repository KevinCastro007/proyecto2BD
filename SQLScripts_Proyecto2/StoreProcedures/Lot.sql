/* Stored Procedures related with: Lot */

GO
USE AgriculturalProperty

GO
CREATE PROCEDURE APSP_InsertLot(@PropertyName VARCHAR(50), @Code VARCHAR(50))
AS
BEGIN
	BEGIN TRY
		IF (dbo.APFN_PropertyID(@PropertyName) <> 0 and dbo.APFN_LotID(@Code) = 0) 
		BEGIN
			INSERT INTO dbo.AP_Lot(FK_Property, Code) 
				VALUES(dbo.APFN_PropertyID(@PropertyName), @Code)
			RETURN 1
		END
		ELSE
			RETURN 0
	END TRY
	BEGIN CATCH
		RETURN @@ERROR * -1
	END CATCH
END