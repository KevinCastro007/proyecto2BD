/* - Procedures related with Supply - */

GO
USE AgriculturalProperty

/* - Procedure for obtain all the values from Supplies - */
GO 
CREATE PROCEDURE APSP_Supplies
AS
BEGIN
	BEGIN TRY
		SELECT S.ID, S.Name FROM dbo.AP_Supply S
	END TRY
	BEGIN CATCH 
		RETURN @@ERROR * -1
	END CATCH
END