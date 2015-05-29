/* Stored Procedures related with: Manager - */

GO
USE AgriculturalProperty

GO
CREATE PROCEDURE APSP_InsertManager(@Department VARCHAR(50), @Name VARCHAR(50))
AS
BEGIN
	BEGIN TRY
		IF (dbo.APFN_DepartmentID(@Department) <> 0 and dbo.APFN_ManagerID(@Name) = 0)
		BEGIN
			INSERT INTO dbo.AP_Manager(FK_Department, Name)
				VALUES(dbo.APFN_DepartmentID(@Department), @Name)
			RETURN 1
		END
		ELSE
			RETURN 0
	END TRY
	BEGIN CATCH
		RETURN @@ERROR * -1
	END CATCH
END
