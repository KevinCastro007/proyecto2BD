/* - Procedures related with Supply - */

GO
USE AgriculturalProperty

/* - Procedure for obtain all the values from Supplies - */
GO 
CREATE PROCEDURE APSP_Supplies
AS
BEGIN
	SELECT S.ID, S.Name FROM dbo.AP_Supply S
END