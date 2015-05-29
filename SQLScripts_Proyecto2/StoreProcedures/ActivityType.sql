/* - Procedures related with Activity Type - */

GO
USE AgriculturalProperty

GO
CREATE PROCEDURE APSP_InsertActivityType(@Name VARCHAR(50))
AS
BEGIN
	BEGIN TRY
		IF (dbo.APFN_ActivityTypeID(@Name) = 0)
		BEGIN
			INSERT INTO dbo.AP_ActivityType(Name) VALUES(@Name)
			RETURN 1
		END
		ELSE
			RETURN 0
	END TRY
	BEGIN CATCH
		RETURN @@ERROR * -1
	END CATCH
END
