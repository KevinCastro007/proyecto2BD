
USE AgriculturalProperty

GO
CREATE TRIGGER APT_LotXCycle
ON dbo.AP_LotXCycle
AFTER INSERT, UPDATE 
AS
BEGIN
	UPDATE dbo.AP_LotXCycle SET UpdateBy = CURRENT_USER,
									UpdateDate = GETDATE(),
									UpdateIn = CONVERT(VARCHAR(50), CONNECTIONPROPERTY('client_net_address'))
		FROM INSERTED I
END

GO
CREATE TRIGGER APT_Request
ON dbo.AP_Request
AFTER INSERT, UPDATE 
AS
BEGIN 
	UPDATE dbo.AP_Request SET UpdateBy = CURRENT_USER,
								UpdateDate = GETDATE(),
								UpdateIn = CONVERT(VARCHAR(50), CONNECTIONPROPERTY('client_net_address'))
		FROM INSERTED I
END