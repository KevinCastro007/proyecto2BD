/* Stored Procedures related with: Crop Type - */

GO
USE AgriculturalProperty

GO
-- Procedure to obtain a Crop Type
CREATE PROCEDURE APSP_CropType(@ID INT)
AS
BEGIN
	SELECT CT.ID, CT.Name FROM dbo.AP_CropType CT
		WHERE CT.ID = @ID
END

GO
-- Procedure for obtain all Crop Types
CREATE PROCEDURE APSP_CropTypes
AS
BEGIN
	SELECT CT.ID, CT.Name FROM dbo.AP_CropType CT
END