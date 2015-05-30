USE [AgriculturalProperty]
GO

-- Function for returning the ID of a ServiceRequest with an ID as parameter
CREATE FUNCTION dbo.APFN_ServiceRequestID(@ID INT)
RETURNS INT
AS
BEGIN
	DECLARE @Result INT
	SET @Result = 0
	SELECT @Result = SR.ID FROM dbo.AP_ServiceRequest SR
		WHERE SR.ID = @ID
	RETURN @Result
END
