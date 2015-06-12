/* Stored Procedures related with: Lot */

GO
USE AgriculturalProperty

GO
CREATE PROCEDURE APSP_Lots(@FK_Property INT)
AS
BEGIN
	SELECT L.ID, L.Code FROM dbo.AP_Lot L
		WHERE L.FK_Property = @FK_Property
END
GO

CREATE PROCEDURE APSP_Lotsname(@Property VARCHAR(50))
AS
BEGIN
	SELECT L.Code FROM dbo.AP_Lot L
		WHERE L.FK_Property = dbo.APFN_PropertyID(@Property)
END