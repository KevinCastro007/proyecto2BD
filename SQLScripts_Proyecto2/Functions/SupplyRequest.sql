USE [AgriculturalProperty]
GO

-- Function for returning the ID of a SupplyRequest with an ID as parameter
CREATE FUNCTION dbo.APFN_SupplyRequestID(@ID INT)
RETURNS INT
AS
BEGIN
	DECLARE @Result INT
	SET @Result = 0
	SELECT @Result = SR.ID FROM dbo.AP_SupplyRequest SR
		WHERE SR.ID = @ID
	RETURN @Result
END
