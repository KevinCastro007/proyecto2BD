/* - Procedures related with Historical Activity - */

GO
USE AgriculturalProperty

/* - Procedure for obtain all the values from Properties- */
GO 
CREATE PROCEDURE APSP_Historical(@FK_LotXCycle INT)
AS
BEGIN
	BEGIN TRY
		SELECT HA.ActivityDate, AT.Name AS ActivityName, RT.Name AS RequestType, R.RequestDescription, R.RequestState FROM dbo.AP_HistoricalActivity HA
			inner join dbo.AP_ActivityType AT ON AT.ID = HA.FK_ActivityType
			inner join dbo.AP_Request R ON R.ID = HA.FK_Request
			inner join dbo.AP_RequestType RT ON RT.ID = R.FK_RequestType
			WHERE R.FK_LotXCycle = @FK_LotXCycle
	END TRY
	BEGIN CATCH 
		RETURN @@ERROR * -1
	END CATCH
END