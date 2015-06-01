/* Stored Procedures related with: Request */

GO
USE AgriculturalProperty

GO
CREATE PROCEDURE APSP_InsertRequest(@FK_LotXCycle INT,  @FK_ActivityType INT, @RequestType VARCHAR(50), @Request VARCHAR(50), @Description VARCHAR(150), @Amount FLOAT, @State VARCHAR(50))
AS
BEGIN
	BEGIN TRY
		IF (dbo.APFN_RequestTypeID(@RequestType) <> 0 and dbo.APFN_RequestTypeManagerID(@RequestType) <> 0 and @Amount > 1) 
		BEGIN
			DECLARE @RequestID INT
			IF (@RequestType = 'Servicio')
			BEGIN
				IF (dbo.APFN_ServiceID(@Request) <> 0)
				BEGIN	
					IF (@State = 'Aprobada')
					BEGIN
						SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
						BEGIN TRANSACTION
							INSERT INTO dbo.AP_Request(FK_RequestManager, FK_LotXCycle, FK_RequestType, RequestDescription, RequestState) 
								VALUES(dbo.APFN_RequestTypeManagerID(@RequestType), @FK_LotXCycle, dbo.APFN_RequestTypeID(@RequestType), @Description, @State)
							SET @RequestID = SCOPE_IDENTITY()				
							INSERT INTO dbo.AP_HistoricalActivity(FK_ActivityType, FK_Request, ActivityDate, ActivityDescription)
								VALUES(@FK_ActivityType, @RequestID, GETDATE(), @Description)					
							INSERT INTO dbo.AP_ServiceRequest(ID, FK_Service, AmountHours) 
								VALUES(@RequestID, dbo.APFN_ServiceID(@Request), @Amount)
							INSERT INTO dbo.AP_ServiceMovement(FK_ServiceRequest, AmountHours, MovementDate, MovementDescription)
								VALUES(@RequestID, @Amount, GETDATE(), @Description)	
						COMMIT
						RETURN 1
					END
					IF (@State = 'Pendiente')
					BEGIN
						SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
						BEGIN TRANSACTION
							INSERT INTO dbo.AP_Request(FK_RequestManager, FK_LotXCycle, FK_RequestType, RequestDescription, RequestState) 
								VALUES(dbo.APFN_RequestTypeManagerID(@RequestType), @FK_LotXCycle, dbo.APFN_RequestTypeID(@RequestType), @Description, @State)
							SET @RequestID = SCOPE_IDENTITY()				
							INSERT INTO dbo.AP_HistoricalActivity(FK_ActivityType, FK_Request, ActivityDate, ActivityDescription)
								VALUES(@FK_ActivityType, @RequestID, GETDATE(), @Description)					
							INSERT INTO dbo.AP_ServiceRequest(ID, FK_Service, AmountHours) 
								VALUES(@RequestID, dbo.APFN_ServiceID(@Request), @Amount)
						COMMIT
						RETURN 1
					END
				END
				ELSE
					RETURN 0
			END
			IF (@RequestType = 'Suministro')
			BEGIN 
				IF (dbo.APFN_SupplyQuantity(@Request) <> 0)
				BEGIN	
					IF (@State = 'Aprobada')
					BEGIN
						SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
						BEGIN TRANSACTION
							INSERT INTO dbo.AP_Request(FK_RequestManager, FK_LotXCycle, FK_RequestType, RequestDescription, RequestState) 
								VALUES(dbo.APFN_RequestTypeManagerID(@RequestType), @FK_LotXCycle, dbo.APFN_RequestTypeID(@RequestType), @Description, @State)
							SET @RequestID = SCOPE_IDENTITY()	
							INSERT INTO dbo.AP_HistoricalActivity(FK_ActivityType, FK_Request, ActivityDate, ActivityDescription)
								VALUES(@FK_ActivityType, @RequestID, GETDATE(), @Description)					
							INSERT INTO dbo.AP_SupplyRequest(ID, FK_Supply, Amount) 
								VALUES(@RequestID, dbo.APFN_SupplyID(@Request), @Amount)
							INSERT INTO dbo.AP_SupplyMovement(FK_SupplyRequest, Amount, MovementDate, MovementDescription)
								VALUES(@RequestID, @Amount, GETDATE(), @Description)
						COMMIT
						RETURN 1
					END
					IF (@State = 'Pendiente')
					BEGIN
						SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
						BEGIN TRANSACTION
							INSERT INTO dbo.AP_Request(FK_RequestManager, FK_LotXCycle, FK_RequestType, RequestDescription, RequestState) 
								VALUES(dbo.APFN_RequestTypeManagerID(@RequestType), @FK_LotXCycle, dbo.APFN_RequestTypeID(@RequestType), @Description, @State)
							SET @RequestID = SCOPE_IDENTITY()				
							INSERT INTO dbo.AP_HistoricalActivity(FK_ActivityType, FK_Request, ActivityDate, ActivityDescription)
								VALUES(@FK_ActivityType, @RequestID, GETDATE(), @Description)					
							INSERT INTO dbo.AP_SupplyRequest(ID, FK_Supply, Amount) 
								VALUES(@RequestID, dbo.APFN_SupplyID(@Request), @Amount)
						COMMIT
						RETURN 1
					END
				END
				ELSE
					RETURN 0
			END
			ELSE
			BEGIN
				IF (dbo.APFN_MachineryQuantity(@Request) <> 0)
				BEGIN	
					IF (@State = 'Aprobada')
					BEGIN
						SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
						BEGIN TRANSACTION
							INSERT INTO dbo.AP_Request(FK_RequestManager, FK_LotXCycle, FK_RequestType, RequestDescription, RequestState) 
								VALUES(dbo.APFN_RequestTypeManagerID(@RequestType), @FK_LotXCycle, dbo.APFN_RequestTypeID(@RequestType), @Description, @State)
							SET @RequestID = SCOPE_IDENTITY()				
							INSERT INTO dbo.AP_HistoricalActivity(FK_ActivityType, FK_Request, ActivityDate, ActivityDescription)
								VALUES(@FK_ActivityType, @RequestID, GETDATE(), @Description)					
							INSERT INTO dbo.AP_MachineryRequest(ID, FK_Machinery, AmountHours) 
								VALUES(@RequestID, dbo.APFN_MachineryID(@Request), @Amount)
							INSERT INTO dbo.AP_MachineryMovement(FK_MachineryRequest, AmountHours, MovementDate, MovementDescription)
								VALUES(@RequestID, @Amount, GETDATE(), @Description)	
						COMMIT
						RETURN 1
					END
					IF (@State = 'Pendiente')
					BEGIN
						SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
						BEGIN TRANSACTION
							INSERT INTO dbo.AP_Request(FK_RequestManager, FK_LotXCycle, FK_RequestType, RequestDescription, RequestState) 
								VALUES(dbo.APFN_RequestTypeManagerID(@RequestType), @FK_LotXCycle, dbo.APFN_RequestTypeID(@RequestType), @Description, @State)
							SET @RequestID = SCOPE_IDENTITY()				
							INSERT INTO dbo.AP_HistoricalActivity(FK_ActivityType, FK_Request, ActivityDate, ActivityDescription)
								VALUES(@FK_ActivityType, @RequestID, GETDATE(), @Description)					
							INSERT INTO dbo.AP_MachineryRequest(ID, FK_Machinery, AmountHours) 
								VALUES(@RequestID, dbo.APFN_MachineryID(@Request), @Amount)
						COMMIT
						RETURN 1					
					END
				END
				ELSE
					RETURN 0	
			END
		END
		ELSE
			RETURN 0
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT = 1
			ROLLBACK
		RETURN @@ERROR * -1
	END CATCH
END