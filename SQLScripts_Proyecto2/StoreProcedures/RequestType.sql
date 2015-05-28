/* - Procedures related with Request Type - */

GO
USE AgriculturalProperty

/* - Procedure for obtain a Request Type- */
GO 
CREATE PROCEDURE APSP_RequestType(@ID INT)
AS
BEGIN
	BEGIN TRY
		SELECT RT.ID, RT.Name FROM dbo.AP_RequestType RT
			WHERE RT.ID = @ID
	END TRY
	BEGIN CATCH 
		RETURN @@ERROR * -1
	END CATCH
END

/* - Procedure for obtain all the values from Request Types- */
GO 
CREATE PROCEDURE APSP_RequestTypes
AS
BEGIN
	BEGIN TRY
		SELECT RT.ID, RT.Name FROM dbo.AP_RequestType RT
	END TRY
	BEGIN CATCH 
		RETURN @@ERROR * -1
	END CATCH
END

GO
CREATE PROCEDURE APSP_InsertRequestType(@ManagerName INT, @Name VARCHAR(50))
AS
BEGIN
	BEGIN TRY
		IF (dbo.APFN_ManagerID(@ManagerName) <> 0 AND dbo.APFN_RequestTypeID(@Name) = 0)
		BEGIN
			INSERT INTO dbo.AP_RequestType(FK_Manager, Name)
				VALUES(dbo.APFN_ManagerID(@ManagerName), @Name)
			RETURN 1
		END
		ELSE
			RETURN 0
	END TRY
	BEGIN CATCH
		RETURN @@ERROR * -1
	END CATCH
END
