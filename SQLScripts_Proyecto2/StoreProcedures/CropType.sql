/* Stored Procedures related with: Crop Type - */

GO
USE AgriculturalProperty

GO
-- Procedure to obtain a Crop Type
CREATE PROCEDURE APSP_CropType(@ID INT)
AS
BEGIN
	BEGIN TRY
		SELECT CT.ID, CT.Name FROM dbo.AP_CropType CT
			WHERE CT.ID = @ID
	END TRY
	BEGIN CATCH
		RETURN @@ERROR * -1
	END CATCH
END

GO
-- Procedure for obtain all Crop Types
CREATE PROCEDURE APSP_CropTypes
AS
BEGIN
	BEGIN TRY
		SELECT CT.ID, CT.Name FROM dbo.AP_CropType CT
	END TRY
	BEGIN CATCH
		RETURN @@ERROR * -1
	END CATCH
END