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

/* - Procedure for obtain the Cost of a Machine -*/
GO 
CREATE FUNCTION APFN_MachineCost(@Name VARCHAR(50))
RETURNS FLOAT
AS
BEGIN
	DECLARE @Result FLOAT
	SET @Result = 0
	SELECT @Result = M.Cost FROM dbo.AP_Machinery M
		WHERE M.Name = @Name
	RETURN @Result
END