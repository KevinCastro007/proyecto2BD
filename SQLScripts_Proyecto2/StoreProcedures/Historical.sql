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
CREATE PROCEDURE APSP_Historical(@FK_LotXCycle INT, @Start DATE, @End DATE, @Attendant VARCHAR(50), @ActivityType VARCHAR(50), @RequestType VARCHAR(50))
AS
BEGIN
	BEGIN TRY
		DECLARE @QueryResult TABLE(ID INT, ActivityDate VARCHAR(10), ActivityName VARCHAR(50), Attendant VARCHAR(50), RequestType VARCHAR(50), RequestDescription VARCHAR(150), RequestState VARCHAR(50))
		DECLARE @PartialCost FLOAT
		INSERT INTO @QueryResult(ID, ActivityDate, ActivityName, Attendant, RequestType, RequestDescription, RequestState)
		SELECT R.ID, CONVERT(VARCHAR(10), H.ActivityDate, 103) AS ActivityDate, AT.Name AS ActivityName, A.Name AS Attendant, RT.Name AS RequestType, SUBSTRING(R.RequestDescription, CHARINDEX(' ', R.RequestDescription) + 1, LEN(R.RequestDescription)) AS RequestDescription, R.RequestState FROM dbo.AP_Historical H
			inner join dbo.AP_Request R ON R.ID = H.FK_Request
			inner join dbo.AP_Attendant A ON A.ID = R.FK_Attendant
			inner join dbo.AP_ActivityType AT ON AT.ID = R.FK_ActivityType
			inner join dbo.AP_RequestType RT ON RT.ID = R.FK_RequestType
			WHERE R.FK_LotXCycle = @FK_LotXCycle 
				and AT.Name = ISNULL(@ActivityType, AT.Name) 
				and A.Name = ISNULL(@Attendant, A.Name)
				and	(H.ActivityDate >= ISNULL(@Start, H.ActivityDate) and H.ActivityDate <= ISNULL(@End, H.ActivityDate)) 
				and RT.Name = ISNULL(@RequestType, RT.Name)

		SELECT @PartialCost = ISNULL(@PartialCost, 0) + ISNULL(SUM(ISNULL(SerM.Amount, 0)), 0) FROM dbo.AP_ServiceMovement SerM
			inner join dbo.AP_ServiceRequest SerR ON SerR.ID = SerM.FK_ServiceRequest
			inner join @QueryResult R ON R.ID = SerR.ID
		SELECT @PartialCost = ISNULL(@PartialCost, 0) + ISNULL(SUM(ISNULL(MacM.Amount, 0)), 0) FROM dbo.AP_MachineryMovement MacM
			inner join dbo.AP_MachineryRequest MacR ON MacR.ID = MacM.FK_MachineryRequest
			inner join @QueryResult R ON R.ID = MacR.ID
		SELECT @PartialCost = ISNULL(@PartialCost, 0) + ISNULL(SUM(ISNULL(SupM.Amount, 0)), 0) FROM dbo.AP_SupplyMovement SupM
			inner join dbo.AP_SupplyRequest SupR ON SupR.ID = SupM.FK_SupplyRequest
			inner join @QueryResult R ON R.ID = SupR.ID
		SELECT R.ID, R.ActivityDate, R.ActivityName, R.Attendant, R.RequestType, R.RequestDescription, R.RequestState FROM @QueryResult R
		RETURN @PartialCost
	END TRY
	BEGIN CATCH 
		RETURN @@ERROR * -1
	END CATCH
END

GO
CREATE PROCEDURE APSP_LastRequest(@FK_LotXCycle INT)
AS
BEGIN
	BEGIN TRY
		DECLARE @RequestID INT, @PartialCost FLOAT
		SELECT @RequestID = ISNULL(MAX(R.ID), 0) FROM AP_Request R
			WHERE R.FK_LotXCycle = @FK_LotXCycle

		SELECT @PartialCost = ISNULL(@PartialCost, 0) + ISNULL(SUM(ISNULL(SerM.Amount, 0)), 0) FROM dbo.AP_ServiceMovement SerM
			inner join dbo.AP_ServiceRequest SerR ON SerR.ID = SerM.FK_ServiceRequest
			WHERE SerR.ID = @RequestID
		SELECT @PartialCost = ISNULL(@PartialCost, 0) + ISNULL(SUM(ISNULL(MacM.Amount, 0)), 0) FROM dbo.AP_MachineryMovement MacM
			inner join dbo.AP_MachineryRequest MacR ON MacR.ID = MacM.FK_MachineryRequest
			WHERE MacR.ID = @RequestID
		SELECT @PartialCost = ISNULL(@PartialCost, 0) + ISNULL(SUM(ISNULL(SupM.Amount, 0)), 0) FROM dbo.AP_SupplyMovement SupM
			inner join dbo.AP_SupplyRequest SupR ON SupR.ID = SupM.FK_SupplyRequest
			WHERE SupR.ID = @RequestID

		SELECT CONVERT(VARCHAR(10), H.ActivityDate, 103) AS ActivityDate, AT.Name AS ActivityName, A.Name AS Attendant, RT.Name AS RequestType, SUBSTRING(R.RequestDescription, CHARINDEX(' ', R.RequestDescription) + 1, LEN(R.RequestDescription)) AS RequestDescription, R.RequestState FROM dbo.AP_Historical H
			inner join dbo.AP_Request R ON R.ID = H.FK_Request
			inner join dbo.AP_Attendant A ON A.ID = R.FK_Attendant
			inner join dbo.AP_ActivityType AT ON AT.ID = R.FK_ActivityType
			inner join dbo.AP_RequestType RT ON RT.ID = R.FK_RequestType
			WHERE R.ID = @RequestID
		RETURN @PartialCost
	END TRY
	BEGIN CATCH
		RETURN @@ERROR * -1 
	END CATCH
END



