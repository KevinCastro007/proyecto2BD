/* - Procedures related with Activity - */

GO
USE AgriculturalProperty

/* - Procedure for obtain all the values from Activities - */
GO 
CREATE PROCEDURE APSP_Activities
AS
BEGIN
	BEGIN TRY
		SELECT A.ID, A.Name FROM dbo.AP_ActivityType A
	END TRY
	BEGIN CATCH 
		RETURN @@ERROR * -1
	END CATCH
END