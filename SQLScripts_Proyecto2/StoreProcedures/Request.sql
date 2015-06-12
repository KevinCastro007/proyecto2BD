/* Stored Procedures related with: Request */

GO
USE AgriculturalProperty

GO
ALTER PROCEDURE APSP_InsertRequest(@FK_LotXCycle INT,  @FK_ActivityType INT, @FK_Attendant INT, @RequestType VARCHAR(50), @Request VARCHAR(50), @Amount FLOAT, @State VARCHAR(50))
AS
BEGIN
	BEGIN TRY
		IF (dbo.APFN_RequestTypeID(@RequestType) <> 0 and @Amount > 0) 
		BEGIN
			DECLARE @RequestID INT
			IF (@RequestType = 'Servicio')
			BEGIN
				IF (dbo.APFN_ServiceID(@Request) <> 0)
				BEGIN	
					DECLARE @ServiceRequestDescription VARCHAR(150), @ServiceHistoricalDescription VARCHAR(150)
					SET @ServiceRequestDescription =  'COD' + CONVERT(VARCHAR(10), @FK_LotXCycle) + CONVERT(VARCHAR(10), @FK_ActivityType)
						+ CONVERT(VARCHAR(10), dbo.APFN_RequestTypeID(@RequestType)) + CONVERT(VARCHAR(10), dbo.APFN_ServiceID(@Request))
						+ '. ' + @Request + ', cantidad: ' + CONVERT(VARCHAR(50), @Amount) + ' hora(s).'
					SET @ServiceHistoricalDescription = 'Fecha de registro: ' + CONVERT(VARCHAR(10), GETDATE(), 103) + '. Solicitiud de ' + @RequestType + '. ' + @Request + ', cantidad: ' + CONVERT(VARCHAR(50), @Amount) + ' hora(s).'
					IF (@State = 'Aprobada')
					BEGIN
						DECLARE @ServiceMovementDescription VARCHAR(150)
						SELECT @ServiceMovementDescription = 'Fecha de proceso: ' + CONVERT(VARCHAR(10), GETDATE(), 103) + '. ' + @Request + ', cantidad: ' + CONVERT(VARCHAR(50), @Amount) + ' hora(s). Nuevo saldo de servicios: ' 
							+ CONVERT(VARCHAR(200), (LC.ServicesBalance + dbo.APFN_ServiceCost(@Request) * @Amount))
							FROM dbo.AP_LotXCycle LC 
							WHERE LC.ID = @FK_LotXCycle
						SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
						BEGIN TRANSACTION
							INSERT INTO dbo.AP_Request(FK_LotXCycle, FK_RequestType, FK_Attendant, FK_ActivityType, RequestDescription, RequestState) 
								VALUES(@FK_LotXCycle, dbo.APFN_RequestTypeID(@RequestType), @FK_Attendant, @FK_ActivityType, @ServiceRequestDescription, @State)
							SET @RequestID = SCOPE_IDENTITY()				
							INSERT INTO dbo.AP_Historical(FK_Request, ActivityDate, ActivityDescription)
								VALUES(@RequestID, GETDATE(), @ServiceHistoricalDescription)			
							INSERT INTO dbo.AP_ServiceRequest(ID, FK_Service, AmountHours) 
								VALUES(@RequestID, dbo.APFN_ServiceID(@Request), @Amount)
							INSERT INTO dbo.AP_ServiceMovement(FK_ServiceRequest, Amount, MovementDate, MovementDescription)
								VALUES(@RequestID, dbo.APFN_ServiceCost(@Request) * @Amount, GETDATE(), @ServiceMovementDescription)	
							UPDATE dbo.AP_LotXCycle SET ServicesBalance = ServicesBalance + dbo.APFN_ServiceCost(@Request) * @Amount
								FROM dbo.AP_LotXCycle LC 
								WHERE LC.ID = @FK_LotXCycle
						COMMIT
					END
					IF (@State = 'Pendiente')
					BEGIN
						SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
						BEGIN TRANSACTION
							INSERT INTO dbo.AP_Request(FK_LotXCycle, FK_RequestType, FK_Attendant, FK_ActivityType, RequestDescription, RequestState) 
								VALUES(@FK_LotXCycle, dbo.APFN_RequestTypeID(@RequestType), @FK_Attendant, @FK_ActivityType, @ServiceRequestDescription, @State)
							SET @RequestID = SCOPE_IDENTITY()				
							INSERT INTO dbo.AP_Historical(FK_Request, ActivityDate, ActivityDescription)
								VALUES(@RequestID, GETDATE(), @ServiceHistoricalDescription)			
							INSERT INTO dbo.AP_ServiceRequest(ID, FK_Service, AmountHours) 
								VALUES(@RequestID, dbo.APFN_ServiceID(@Request), @Amount)
						COMMIT
					END
					RETURN 1
				END
				ELSE
					RETURN 0
			END
			IF (@RequestType = 'Suministro')
			BEGIN 
				IF (dbo.APFN_SupplyID(@Request) <> 0)
				BEGIN
					DECLARE @SupplyRequestDescription VARCHAR(150), @SupplyHistoricalDescription VARCHAR(150)
					SET @SupplyRequestDescription = 'COD' + CONVERT(VARCHAR(10), @FK_LotXCycle) + CONVERT(VARCHAR(10), @FK_ActivityType)
						+ CONVERT(VARCHAR(10), dbo.APFN_RequestTypeID(@RequestType)) + CONVERT(VARCHAR(10), dbo.APFN_SupplyID(@Request))
						+ '. ' + @Request + ', cantidad: ' + CONVERT(VARCHAR(50), @Amount) + '.' 
					SET @SupplyHistoricalDescription = 'Fecha de registro: ' + CONVERT(VARCHAR(10), GETDATE(), 103) + '. Solicitiud de ' + @RequestType + '. ' + @Request + ', cantidad: ' + CONVERT(VARCHAR(50), @Amount) + '.'
					IF (@State = 'Aprobada')
					BEGIN
						DECLARE @SupplyMovementDescription VARCHAR(150)
						SELECT @SupplyMovementDescription = 'Fecha de proceso: ' + CONVERT(VARCHAR(10), GETDATE(), 103) + '. ' + @Request + ', cantidad: ' + CONVERT(VARCHAR(50), @Amount) + '. Nuevo saldo de suministros: ' 
							+ CONVERT(VARCHAR(200), (LC.SuppliesBalance + dbo.APFN_SupplyCost(@Request) * @Amount))
							FROM dbo.AP_LotXCycle LC 
							WHERE LC.ID = @FK_LotXCycle
						SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
						BEGIN TRANSACTION
							INSERT INTO dbo.AP_Request(FK_LotXCycle, FK_RequestType, FK_Attendant, FK_ActivityType, RequestDescription, RequestState) 
								VALUES(@FK_LotXCycle, dbo.APFN_RequestTypeID(@RequestType), @FK_Attendant, @FK_ActivityType, @SupplyRequestDescription, @State)
							SET @RequestID = SCOPE_IDENTITY()	
							INSERT INTO dbo.AP_Historical(FK_Request, ActivityDate, ActivityDescription)
								VALUES(@RequestID, GETDATE(), @SupplyHistoricalDescription)				
							INSERT INTO dbo.AP_SupplyRequest(ID, FK_Supply, Amount) 
								VALUES(@RequestID, dbo.APFN_SupplyID(@Request), @Amount)
							INSERT INTO dbo.AP_SupplyMovement(FK_SupplyRequest, Amount, MovementDate, MovementDescription)
								VALUES(@RequestID, dbo.APFN_SupplyCost(@Request) * @Amount, GETDATE(), @SupplyMovementDescription)			
							UPDATE dbo.AP_LotXCycle SET SuppliesBalance = SuppliesBalance + dbo.APFN_SupplyCost(@Request) * @Amount
								FROM dbo.AP_LotXCycle LC 
								WHERE LC.ID = @FK_LotXCycle
						COMMIT
					END
					IF (@State = 'Pendiente')
					BEGIN
						SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
						BEGIN TRANSACTION
							INSERT INTO dbo.AP_Request(FK_LotXCycle, FK_RequestType, FK_Attendant, FK_ActivityType, RequestDescription, RequestState) 
								VALUES(@FK_LotXCycle, dbo.APFN_RequestTypeID(@RequestType), @FK_Attendant, @FK_ActivityType, @SupplyRequestDescription, @State)
							SET @RequestID = SCOPE_IDENTITY()				
							INSERT INTO dbo.AP_Historical(FK_Request, ActivityDate, ActivityDescription)
								VALUES(@RequestID, GETDATE(), @SupplyHistoricalDescription)				
							INSERT INTO dbo.AP_SupplyRequest(ID, FK_Supply, Amount) 
								VALUES(@RequestID, dbo.APFN_SupplyID(@Request), @Amount)
						COMMIT
					END
					RETURN 1
				END
				ELSE
					RETURN 0
			END
			IF (@RequestType = 'Maquinaria')
			BEGIN 
				IF (dbo.APFN_MachineryID(@Request) <> 0)
				BEGIN
					DECLARE @MachineryRequestDescription VARCHAR(150), @MachineryHistoricalDescription VARCHAR(150)
					SET @MachineryRequestDescription = 'COD' + CONVERT(VARCHAR(10), @FK_LotXCycle) + CONVERT(VARCHAR(10), @FK_ActivityType)
						+ CONVERT(VARCHAR(10), dbo.APFN_RequestTypeID(@RequestType)) + CONVERT(VARCHAR(10), dbo.APFN_MachineryID(@Request))
						+ '. ' + @Request + ', cantidad: ' + CONVERT(VARCHAR(50), @Amount) + ' hora(s).'
					SET @MachineryHistoricalDescription = 'Fecha de registro: ' + CONVERT(VARCHAR(10), GETDATE(), 103) + '. Solicitiud de ' + @RequestType + '. ' + @Request + ', cantidad: ' + CONVERT(VARCHAR(50), @Amount) + ' hora(s).'
					IF (@State = 'Aprobada')
					BEGIN
						DECLARE @MachineryMovementDescription VARCHAR(150)
						SELECT @MachineryMovementDescription = 'Fecha de proceso: ' + CONVERT(VARCHAR(10), GETDATE(), 103) + '. ' + @Request + ', cantidad: ' + CONVERT(VARCHAR(50), @Amount) + ' hora(s). Nuevo saldo de maquinaria: ' 
							+ CONVERT(VARCHAR(200), (LC.MachineryBalance + dbo.APFN_MachineCost(@Request) * @Amount))
							FROM dbo.AP_LotXCycle LC 
							WHERE LC.ID = @FK_LotXCycle
						SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
						BEGIN TRANSACTION
							INSERT INTO dbo.AP_Request(FK_LotXCycle, FK_RequestType, FK_Attendant, FK_ActivityType, RequestDescription, RequestState) 
								VALUES(@FK_LotXCycle, dbo.APFN_RequestTypeID(@RequestType), @FK_Attendant, @FK_ActivityType, @MachineryRequestDescription, @State)
							SET @RequestID = SCOPE_IDENTITY()				
							INSERT INTO dbo.AP_Historical(FK_Request, ActivityDate, ActivityDescription)
								VALUES(@RequestID, GETDATE(), @MachineryHistoricalDescription)		
							INSERT INTO dbo.AP_MachineryRequest(ID, FK_Machinery, AmountHours) 
								VALUES(@RequestID, dbo.APFN_MachineryID(@Request), @Amount)
							INSERT INTO dbo.AP_MachineryMovement(FK_MachineryRequest, Amount, MovementDate, MovementDescription)
								VALUES(@RequestID, dbo.APFN_MachineCost(@Request) * @Amount, GETDATE(), @MachineryMovementDescription)	
							UPDATE dbo.AP_LotXCycle SET MachineryBalance = MachineryBalance + dbo.APFN_MachineCost(@Request) * @Amount
								FROM dbo.AP_LotXCycle LC 
								WHERE LC.ID = @FK_LotXCycle
						COMMIT
					END
					IF (@State = 'Pendiente')
					BEGIN
						SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
						BEGIN TRANSACTION
							INSERT INTO dbo.AP_Request(FK_LotXCycle, FK_RequestType, FK_Attendant, FK_ActivityType, RequestDescription, RequestState) 
								VALUES(@FK_LotXCycle, dbo.APFN_RequestTypeID(@RequestType), @FK_Attendant, @FK_ActivityType, @MachineryRequestDescription, @State)
							SET @RequestID = SCOPE_IDENTITY()				
							INSERT INTO dbo.AP_Historical(FK_Request, ActivityDate, ActivityDescription)
								VALUES(@RequestID, GETDATE(), @MachineryHistoricalDescription)			
							INSERT INTO dbo.AP_MachineryRequest(ID, FK_Machinery, AmountHours) 
								VALUES(@RequestID, dbo.APFN_MachineryID(@Request), @Amount)
						COMMIT				
					END
					RETURN 1	
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