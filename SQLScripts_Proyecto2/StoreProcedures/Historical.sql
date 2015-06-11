/* - Procedures related with Historical Activity - */

GO
USE AgriculturalProperty

/* - Procedure for obtain all the dates from Historical - */
GO 
CREATE PROCEDURE APSP_HistoricalDates(@FK_LotXCycle INT)
AS
BEGIN
	BEGIN TRY
		SELECT DISTINCT CONVERT(VARCHAR(10), H.ActivityDate, 103) AS Date FROM dbo.AP_Historical H
			inner join dbo.AP_Request R ON R.ID = H.FK_Request
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
		SELECT CONVERT(VARCHAR(10), H.ActivityDate, 103) AS ActivityDate, AT.Name AS ActivityName, A.Name AS Attendant, RT.Name AS RequestType, SUBSTRING(R.RequestDescription, CHARINDEX(' ', R.RequestDescription) + 1, LEN(R.RequestDescription)) AS RequestDescription, R.RequestState FROM dbo.AP_Historical H
			inner join dbo.AP_Request R ON R.ID = H.FK_Request
			inner join dbo.AP_Attendant A ON A.ID = R.FK_Attendant
			inner join dbo.AP_ActivityType AT ON AT.ID = R.FK_ActivityType
			inner join dbo.AP_RequestType RT ON RT.ID = R.FK_RequestType
						WHERE R.FK_LotXCycle = @FK_LotXCycle 
				and AT.Name = ISNULL(@ActivityType, AT.Name) 
				and	(H.ActivityDate >= ISNULL(@Start, H.ActivityDate) and H.ActivityDate <= ISNULL(@End, H.ActivityDate)) 
				and RT.Name = ISNULL(@RequestType, RT.Name)
	END TRY
	BEGIN CATCH 
		RETURN @@ERROR * -1
	END CATCH
END