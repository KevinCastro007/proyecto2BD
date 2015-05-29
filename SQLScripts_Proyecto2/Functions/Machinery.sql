/* Utilitary functions: Machinery */

GO
USE AgriculturalProperty

GO
-- Function for returning the ID of a Machinery with a Name as parameter
CREATE FUNCTION APFN_MachineryID(@Name VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @Result INT
	SET @Result = 0
	SELECT @Result = M.ID FROM dbo.AP_Machinery M
		WHERE M.Name = @Name
	RETURN @Result
END

GO
-- Function to get a specific Machinery Quantity with a Name as parameter
CREATE FUNCTION APFN_MachineryQuantity(@Name VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @Result INT
	SET @Result = 0
	SELECT @Result = M.Quantity FROM dbo.AP_Machinery M
		WHERE M.Name = @Name
	RETURN @Result
END