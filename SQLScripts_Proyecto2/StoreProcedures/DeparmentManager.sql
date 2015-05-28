/* Stored Procedures related with: Manager - */

GO
USE AgriculturalProperty

GO
CREATE PROCEDURE APSP_InsertManager(@DeparmentName VARCHAR(50), @Name VARCHAR(50))
AS
BEGIN
	BEGIN TRY
		IF (dbo.APFN_DeparmentID(@DeparmentName) <> 0 and dbo.APFN_ManagerID(@Name) = 0)
		BEGIN
			INSERT INTO dbo.AP_Manager(FK_Deparment, Name)
				VALUES(dbo.APFN_DeparmentID(@DeparmentName), @Name)
			RETURN 1
		END
		ELSE
			RETURN 0
	END TRY
	BEGIN CATCH
		RETURN @@ERROR * -1
	END CATCH
END
