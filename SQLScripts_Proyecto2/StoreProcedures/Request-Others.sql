GO
USE AgriculturalProperty

GO
-- Procedure for approving a certain request
CREATE PROCEDURE dbo.APSP_ApproveRequest(@oldDescription VARCHAR(200), @RealAmount FLOAT, @RealDescription VARCHAR(50))
AS
BEGIN
	BEGIN TRY
		IF (dbo.APFN_ApproveRequestVerify(@oldDescription, @RealAmount, @RealDescription) = 1)
		BEGIN
			DECLARE @RequestId INT, @RequestAmount FLOAT, @Cost FLOAT
			SET @RequestId = (SELECT R.ID  FROM dbo.AP_Request R
								WHERE R.RequestState ='Pendiente' and  R.RequestDescription = @oldDescription)
			IF(dbo.APFN_ServiceRequestID(@RequestId) <> 0)
			BEGIN
				SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
				BEGIN TRANSACTION			
					INSERT INTO dbo.AP_ServiceMovement(FK_ServiceRequest, Amount, MovementDate, MovementDescription)
					VALUES (@RequestId, @RealAmount, GETDATE(), @RealDescription)
					UPDATE dbo.AP_Request SET RequestState = 'Aprobada' FROM dbo.AP_Request R
						WHERE R.RequestDescription = @oldDescription
					SET @Cost = (SELECT S.Cost  FROM dbo.AP_Service S
								inner join AP_ServiceRequest SR ON SR.FK_Service = S.ID
								inner join AP_Request R ON R.ID = SR.ID 
								WHERE R.RequestDescription = @oldDescription)
					UPDATE dbo.AP_LotXCycle SET	ServicesBalance = ServicesBalance + (@RealAmount*@Cost) FROM dbo.AP_Request R
					inner join dbo.AP_LotXCycle LC ON R.FK_LotXCycle = LC.ID
					WHERE  R.RequestDescription = @oldDescription
				COMMIT
			END		
			ELSE IF (dbo.APFN_SupplyRequestID(@RequestId) <> 0)
			BEGIN
				SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
				BEGIN TRANSACTION			
					INSERT INTO dbo.AP_SupplyMovement(FK_SupplyRequest, Amount, MovementDate, MovementDescription)
					VALUES (@RequestId, @RealAmount, GETDATE(), @RealDescription)		
					UPDATE dbo.AP_Request SET RequestState = 'Aprobada' FROM dbo.AP_Request R
						WHERE R.RequestDescription = @oldDescription	
						SET @Cost = (SELECT S.Cost  FROM dbo.AP_Supply S
								inner join AP_SupplyRequest SR ON SR.FK_Supply = S.ID
								inner join AP_Request R ON R.ID = SR.ID 
								WHERE R.RequestDescription = @oldDescription)	
					UPDATE dbo.AP_LotXCycle SET	SuppliesBalance = SuppliesBalance + (@RealAmount*@Cost)  FROM dbo.AP_Request R
					inner join dbo.AP_LotXCycle LC ON R.FK_LotXCycle = LC.ID 
					WHERE  R.RequestDescription = @oldDescription
				COMMIT
			END
			ELSE IF(dbo.APFN_MachineryRequestID(@RequestId) <> 0)
			BEGIN
				SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
				BEGIN TRANSACTION
					INSERT INTO dbo.AP_MachineryMovement(FK_MachineryRequest, Amount, MovementDate, MovementDescription)
					VALUES (@RequestId, @RealAmount, GETDATE(), @oldDescription)		
					UPDATE dbo.AP_Request SET RequestState = 'Aprobada' FROM dbo.AP_Request R
						WHERE R.RequestDescription = @oldDescription	
						SET @Cost = (SELECT M.Cost  FROM dbo.AP_Machinery M
								inner join AP_MachineryRequest MR ON MR.FK_Machinery = M.ID
								inner join AP_Request R ON R.ID = MR.ID 
								WHERE R.RequestDescription = @oldDescription)
					UPDATE dbo.AP_LotXCycle SET	MachineryBalance = MachineryBalance + (@RealAmount*@Cost)  FROM dbo.AP_Request R
					inner join dbo.AP_LotXCycle LC ON R.FK_LotXCycle = LC.ID
					WHERE  R.RequestDescription = @oldDescription
				COMMIT
			END	
			RETURN 1		
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
GO
-- Procedure for viewing the possible requests that aren't approve
CREATE PROCEDURE dbo.APSP_ApproveRequestView(@LotXCycle int)
AS
BEGIN
	BEGIN TRY
		SELECT R.RequestDescription FROM dbo.AP_Request R
			inner join dbo.AP_LotXCycle LC ON R.FK_LotXCycle = LC.ID
			WHERE R.RequestState = 'Pendiente' and LC.ID = @LotXCycle
	END TRY
	BEGIN CATCH
		RETURN @@ERROR * -1
	END CATCH
END

GO
-- Procedure for modifing a request
CREATE PROCEDURE dbo.APSP_ModifyRequest(@oldDescription VARCHAR(200), @Name VARCHAR(50), @ActivityType VARCHAR(50), @Amount FLOAT)
AS
BEGIN
	BEGIN TRY
			BEGIN
				IF (@Name <> '')
					BEGIN
						DECLARE @RequestId INT
							SET @RequestId=(SELECT R.ID  FROM dbo.AP_Request R
												inner join dbo.AP_LotXCycle LC ON R.FK_LotXCycle = LC.ID
												inner join dbo.AP_Cycle C ON C.ID= LC.FK_Cycle
												WHERE  R.RequestDescription = @oldDescription)
							IF(dbo.APFN_ServiceRequestID(@RequestId)<>0)
								BEGIN
									UPDATE dbo.AP_ServiceRequest SET FK_Service = dbo.APFN_RequestID(@Name,@oldDescription) 
										FROM dbo.AP_ServiceRequest SR
										WHERE SR.ID = @RequestId
								END
							ELSE IF(dbo.APFN_SupplyRequestID(@RequestId)<>0)
								BEGIN
									UPDATE dbo.AP_SupplyRequest SET FK_Supply = dbo.APFN_RequestID(@Name,@oldDescription) 
									FROM dbo.AP_SupplyRequest SR
									WHERE SR.ID = @RequestId
								END
							ELSE IF(dbo.APFN_MachineryRequestID(@RequestId)<>0)
								BEGIN
									UPDATE dbo.AP_MachineryRequest SET FK_Machinery = dbo.APFN_RequestID(@Name,@oldDescription) 
									FROM dbo.AP_MachineryRequest MR
									WHERE MR.ID = @RequestId
								END
							ELSE
								RETURN 0

					END
				IF (@ActivityType <> '')
					BEGIN
						IF (dbo.APFN_ActivityTypeID(@ActivityType)<>0)
							BEGIN
							UPDATE dbo.AP_Request SET FK_ActivityType = dbo.APFN_ActivityTypeID(@ActivityType) FROM dbo.AP_Request R
							inner join dbo.AP_LotXCycle LC ON R.FK_LotXCycle = LC.ID
							inner join dbo.AP_Cycle C ON C.ID= LC.FK_Cycle
							WHERE  R.RequestDescription = @oldDescription
							END
					END
				IF (@Amount <> '')
					BEGIN
					DECLARE @RequestIdAmount INT
							SET @RequestIdAmount=(SELECT R.ID  FROM dbo.AP_Request R
												inner join dbo.AP_LotXCycle LC ON R.FK_LotXCycle = LC.ID
												inner join dbo.AP_Cycle C ON C.ID= LC.FK_Cycle
												WHERE  R.RequestDescription = @oldDescription)
							IF(dbo.APFN_ServiceRequestID(@RequestIdAmount)<>0)
								BEGIN
									UPDATE dbo.AP_ServiceRequest SET AmountHours=@Amount 
										FROM dbo.AP_ServiceRequest SR
										WHERE SR.ID = @RequestIdAmount
								END
							ELSE IF(dbo.APFN_SupplyRequestID(@RequestIdAmount)<>0)
								BEGIN
									UPDATE dbo.AP_SupplyRequest SET Amount=@Amount 
									FROM dbo.AP_SupplyRequest SR
									WHERE SR.ID = @RequestIdAmount
								END
							ELSE IF(dbo.APFN_MachineryRequestID(@RequestIdAmount)<>0)
								BEGIN
									UPDATE dbo.AP_MachineryRequest SET AmountHours=@Amount 
									FROM dbo.AP_MachineryRequest MR
									WHERE MR.ID = @RequestIdAmount
								END
							ELSE
								RETURN 0
					END

				RETURN 1
	
			END
				RETURN 0
	END TRY
	BEGIN CATCH
		RETURN @@ERROR * -1
	END CATCH
END

GO

-- Procedure for returning the Description of a certain request by it's lot code and cycle code
CREATE Procedure dbo.APSP_RequestDescription(@CodeLot VARCHAR(50),@Cycle VARCHAR(50) )
AS
	BEGIN
		SELECT R.RequestDescription FROM dbo.AP_Request R
		inner join dbo.AP_LotXCycle L ON R.FK_LotXCycle = L.ID
		WHERE L.FK_Cycle = dbo.APFN_Cycle(@Cycle) and L.FK_Lot = dbo.APFN_LotID(@CodeLot) and R.RequestState = 'Pendiente'
	END
GO

-- Procedure for returning the Description of a certain request by it's lot code and cycle code
CREATE Procedure dbo.APSP_RequestNames(@Description VARCHAR(200) )
AS
	BEGIN
		DECLARE @RequestId INT
							SET @RequestId=(SELECT R.ID  FROM dbo.AP_Request R
												inner join dbo.AP_LotXCycle LC ON R.FK_LotXCycle = LC.ID
												inner join dbo.AP_Cycle C ON C.ID= LC.FK_Cycle
												WHERE  R.RequestDescription = @Description)
		
				IF(dbo.APFN_ServiceRequestID(@RequestId)<>0)
						BEGIN
							SELECT S.Name  FROM dbo.AP_Service S
							
						END
				ELSE IF(dbo.APFN_SupplyRequestID(@RequestId)<>0)
						BEGIN
							SELECT S.Name  FROM dbo.AP_Supply S
						END
				ELSE IF(dbo.APFN_MachineryRequestID(@RequestId)<>0)
						BEGIN
							SELECT M.Name  FROM dbo.AP_Machinery M
						END
				ELSE
					RETURN 0
	END
GO

