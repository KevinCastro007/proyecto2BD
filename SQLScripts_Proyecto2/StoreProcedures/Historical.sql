/* - Procedures related with Historical Activity - */

GO
USE AgriculturalProperty

/* - Procedure for obtain all the dates from Historical - */
GO 
CREATE PROCEDURE APSP_HistoricalDates(@FK_LotXCycle INT)
AS
BEGIN
	BEGIN TRY
		SELECT DISTINCT CONVERT(VARCHAR(10), HA.ActivityDate, 103) AS Date FROM dbo.AP_HistoricalActivity HA
			inner join dbo.AP_Request R ON R.ID = HA.FK_Request
			WHERE R.FK_LotXCycle = @FK_LotXCycle
	END TRY
	BEGIN CATCH 
		RETURN @@ERROR * -1
	END CATCH
END

/* - Procedure for obtain the Historical - */
GO 
CREATE PROCEDURE APSP_Historical(@FK_LotXCycle INT, @ActivityType VARCHAR(50), @Start DATE, @End DATE, @RequestType VARCHAR(50))
AS
BEGIN
	BEGIN TRY
		SELECT CONVERT(VARCHAR(10), HA.ActivityDate, 103) AS ActivityDate, AT.Name AS ActivityName, RT.Name AS RequestType, R.RequestDescription, R.RequestState FROM dbo.AP_HistoricalActivity HA
			inner join dbo.AP_ActivityType AT ON AT.ID = HA.FK_ActivityType
			inner join dbo.AP_Request R ON R.ID = HA.FK_Request
			inner join dbo.AP_RequestType RT ON RT.ID = R.FK_RequestType
			WHERE R.FK_LotXCycle = @FK_LotXCycle 
				and AT.Name = ISNULL(@ActivityType, AT.Name) 
				and	(HA.ActivityDate between ISNULL(@Start, HA.ActivityDate) and ISNULL(@End, HA.ActivityDate)) 
				and RT.Name = ISNULL(@RequestType, RT.Name)
	END TRY
	BEGIN CATCH 
		RETURN @@ERROR * -1
	END CATCH
END