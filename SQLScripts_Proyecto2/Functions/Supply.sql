/* Utilitary functions: Supply */

GO
USE AgriculturalProperty

GO
-- Function for returning the ID of a Supply with a Name as parameter
CREATE FUNCTION APFN_SupplyID(@Name VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @Result INT
	SET @Result = 0
	SELECT @Result = S.ID FROM dbo.AP_Supply S
		WHERE S.Name = @Name
	RETURN @Result
END

/* - Procedure for obtain the Cost of a Supply - */
GO 
CREATE FUNCTION APFN_SupplyCost(@Name VARCHAR(50))
RETURNS FLOAT
AS
BEGIN
	DECLARE @Result FLOAT
	SET @Result = 0
	SELECT @Result = S.Cost FROM dbo.AP_Supply S
		WHERE S.Name = @Name
	RETURN @Result
END

