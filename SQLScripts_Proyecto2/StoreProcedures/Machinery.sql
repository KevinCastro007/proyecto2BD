/* - Procedures related with Machinery - */

GO
USE AgriculturalProperty

/* - Procedure for obtain all the values from Machinery - */
GO 
CREATE PROCEDURE APSP_Machinery
AS
BEGIN
	SELECT M.ID, M.Name FROM dbo.AP_Machinery M
END
