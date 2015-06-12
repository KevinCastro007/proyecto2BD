USE AgriculturalProperty
GO

-- Function for returning the ID of a MachineryRequest with an ID as parameter
CREATE FUNCTION APFN_MachineryRequestID(@ID INT)
RETURNS INT
AS
BEGIN
	DECLARE @Result INT
	SET @Result = 0
	SELECT @Result = MR.ID FROM dbo.AP_MachineryRequest MR
		WHERE MR.ID = @ID
	RETURN @Result
END
