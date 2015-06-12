/* Stored Procedures related with: Attendant - */

GO
USE AgriculturalProperty

GO
-- Procedure to obtain all the values from Attendant
CREATE PROCEDURE APSP_Attendants
AS
BEGIN
	SELECT A.ID, A.Name FROM dbo.AP_Attendant A
END