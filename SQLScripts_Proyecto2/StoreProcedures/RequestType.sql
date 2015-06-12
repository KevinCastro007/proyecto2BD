/* - Procedures related with Request Type - */

GO
USE AgriculturalProperty

/* - Procedure for obtain a Request Type- */
GO 
CREATE PROCEDURE APSP_RequestType(@ID INT)
AS
BEGIN
	SELECT RT.ID, RT.Name FROM dbo.AP_RequestType RT
		WHERE RT.ID = @ID
END

/* - Procedure for obtain all the values from Request Types- */
GO 
CREATE PROCEDURE APSP_RequestTypes
AS
BEGIN
	SELECT RT.ID, RT.Name FROM dbo.AP_RequestType RT
END