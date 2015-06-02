/* - Procedures related with Service - */

GO
USE AgriculturalProperty

/* - Procedure for obtain all the values from Services - */
GO 
CREATE PROCEDURE APSP_Services
AS
BEGIN
	BEGIN TRY
		SELECT S.ID, S.Name FROM dbo.AP_Service S
	END TRY
	BEGIN CATCH 
		RETURN @@ERROR * -1
	END CATCH
END
