/* - Procedures related with Activity Type - */

GO
USE AgriculturalProperty

GO
CREATE PROCEDURE APSP_ActivityType(@Type int)
AS
BEGIN
	BEGIN TRY
		SELECT AT.Name FROM dbo.AP_ActivityType AT
		RETURN 1
	END TRY
	BEGIN CATCH
		RETURN @@ERROR * -1
	END CATCH
END

