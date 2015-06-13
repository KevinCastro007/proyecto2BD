/* - Procedures related with Activity Type - */

GO
USE AgriculturalProperty

GO
CREATE PROCEDURE APSP_ActivityTypes
AS
BEGIN
	SELECT AT.ID, AT.Name FROM dbo.AP_ActivityType AT
END

