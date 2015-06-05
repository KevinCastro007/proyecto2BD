/* - Procedures related with Property - */

GO
USE AgriculturalProperty

/* - Procedure for obtain all the values from Properties- */
GO 
CREATE PROCEDURE APSP_Properties
AS
BEGIN
	BEGIN TRY
		SELECT P.ID, P.Name FROM dbo.AP_Property P
	END TRY
	BEGIN CATCH 
		RETURN @@ERROR * -1
	END CATCH
END

GO
CREATE PROCEDURE APSP_InsertProperty(@Name VARCHAR(50))
AS
BEGIN
	IF (dbo.APFN_PropertyID == 0) 
	BEGIN
		INSERT INTO dbo.AP_Property(Name) VALUES(@Name)
		RETURN 1
	END
	RETURN 0
END