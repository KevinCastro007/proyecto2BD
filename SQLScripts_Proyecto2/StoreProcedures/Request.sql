/* Stored Procedures related with: Request */

GO
USE AgriculturalProperty

GO
CREATE PROCEDURE APSP_InsertRequest(@LotCode VARCHAR(50), @CycleStart DATE, @CycleEnd DATE,  @ActivityType VARCHAR(50), @RequestType VARCHAR(50), @Date DATETIME, @Description VARCHAR(150), @Request VARCHAR(50), @Amount FLOAT, @State INT)
AS
BEGIN
	BEGIN TRY
		IF (dbo.APFN_RequestTypeID(@RequestType) <> 0 and dbo.APFN_RequestTypeManagerID(@RequestType) <> 0
			and dbo.APFN_LotID(@LotCode) <> 0 and dbo.APFN_CycleID(@CycleStart, @CycleEnd) and @Amount > 1) 
		BEGIN
			DECLARE @RequestID INT
			SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
			BEGIN TRANSACTION
				INSERT INTO dbo.AP_Request(FK_RequestManager, FK_LotXCycle, FK_RequestType, RequestDescription, State) 
					VALUES(dbo.APFN_RequestTypeManagerID(@RequestType), dbo.APFN_LotXCycleID(dbo.APFN_LotID(@LotCode), 
						dbo.APFN_CycleID(@CycleStart, @CycleEnd)), dbo.APFN_RequestTypeID(@RequestType), @Description, @State)

				@RequestID = SCOPE_IDENTITY()
				
				dbo.APSP_InsertActivityType(@ActivityType)

				INSERT INTO dbo.AP_HistoricalActivity(FK_ActivityType, FK_Request, ActivityDate, ActivityDescription)
					VALUES(dbo.APFN_ActivityTypeID(@ActivityType), @RequestID, @Date, @Description)

				IF (@RequestType = 'Servicio')
				BEGIN
					IF (dbo.APFN_ServiceID(@Request) <> 0)
					BEGIN	
						INSERT INTO dbo.AP_ServiceRequest(FK_Service, RequestID, AmountHours) 
							VALUES(dbo.APFN_ServiceID(@Request), @RequestID, @Amount)
						RETURN 1
					END
					ELSE
						RETURN 0
				END
				IF (@RequestType = 'Suministro')
				BEGIN 
					IF (dbo.APFN_SupplyQuantity(@Request) <> 0)
					BEGIN	
						INSERT INTO dbo.AP_SupplyRequest(FK_Service, RequestID, Amount) 
							VALUES(dbo.APFN_SupplyID(@Request), @RequestID, @Amount)
						RETURN 1
					END
					ELSE
						RETURN 0
				END
				ELSE
				BEGIN
					IF (dbo.APFN_MachineryQuantity(@Request) <> 0)
					BEGIN	
						INSERT INTO dbo.AP_MachineryRequest(FK_Service, RequestID, AmountHours) 
							VALUES(dbo.APFN_MachineryID(@Request), @RequestID, @Amount)
						RETURN 1
					END
					ELSE
						RETURN 0
				END
			COMMIT
		END
		ELSE
			RETURN 0
	END TRY
	BEGIN CATCH
		RETURN @@ERROR * -1
	END CATCH
END