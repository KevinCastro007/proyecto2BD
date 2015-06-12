/* - Procedures related with Service - */

GO
USE AgriculturalProperty

/* - Procedure for obtain all the values from Services - */
GO 
CREATE PROCEDURE APSP_Services
AS
BEGIN
	SELECT S.ID, S.Name FROM dbo.AP_Service S
END
