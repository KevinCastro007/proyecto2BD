/* Stored Procedures related with: Attendant - */

GO
USE AgriculturalProperty

GO
-- Procedure to obtain a Attendant
CREATE PROCEDURE APSP_Attendant(@ID INT)
AS
BEGIN
	BEGIN TRY
		SELECT A.ID, A.Name FROM dbo.AP_Attendant A
			WHERE A.ID = @ID
	END TRY
	BEGIN CATCH
		RETURN @@ERROR * -1
	END CATCH
END

GO
-- Procedure to obtain all the values from Attendant
CREATE PROCEDURE APSP_Attendants
AS
BEGIN
	BEGIN TRY
		SELECT A.ID, A.Name FROM dbo.AP_Attendant A
	END TRY
	BEGIN CATCH
		RETURN @@ERROR * -1
	END CATCH
END