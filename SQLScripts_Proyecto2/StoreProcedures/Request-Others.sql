-- Procedure for approving a certain request
CREATE PROCEDURE [dbo].[APSP_ApproveRequest](@oldDescription VARCHAR(200), @RealAmount FLOAT, @RealDescription VARCHAR(50))
AS
BEGIN
	BEGIN TRY
			BEGIN

				DECLARE @RequestId INT, @RequestAmount FLOAT
				SET @RequestId=(SELECT R.ID  FROM dbo.AP_Request R
											inner join dbo.AP_LotXCycle LC ON R.FK_LotXCycle = LC.ID
											inner join dbo.AP_Cycle C ON C.ID= LC.FK_Cycle
											WHERE R.RequestState ='Pendiente' and  R.RequestDescription=@oldDescription)
						IF(dbo.APFN_ServiceRequestID(@RequestId)<>0)
							BEGIN
								SET @RequestAmount=(SELECT SR.AmountHours  FROM AP_ServiceRequest SR
													WHERE @RequestId = SR.FK_Service)
								IF (@RequestAmount >= @RealAmount)
									BEGIN
										INSERT INTO dbo.AP_ServiceMovement(FK_ServiceRequest, Amount,MovementDate, MovementDescription)
										VALUES (@RequestId, @RealAmount,GETDATE(), @RealDescription)
										
										UPDATE dbo.AP_LotXCycle SET	ServicesBalance = ServicesBalance + @RealAmount FROM dbo.AP_Request R
										inner join dbo.AP_LotXCycle LC ON R.FK_LotXCycle = LC.ID
										inner join dbo.AP_Cycle C ON C.ID= LC.FK_Cycle
										WHERE  R.RequestDescription = @oldDescription
									END
								ELSE
									RETURN  0
							END
						ELSE IF(dbo.APFN_SupplyRequestID(@RequestId)<>0)
							BEGIN
								SET @RequestAmount=(SELECT SR.Amount  FROM AP_SupplyRequest SR
													WHERE @RequestId = SR.FK_Supply)
								IF (@RequestAmount >= @RealAmount)
									BEGIN
										INSERT INTO dbo.AP_SupplyMovement(FK_SupplyRequest, Amount, MovementDate, MovementDescription)
										VALUES (@RequestId, @RealAmount,GETDATE(), @RealDescription)

										UPDATE dbo.AP_LotXCycle SET	SuppliesBalance = SuppliesBalance + @RealAmount FROM dbo.AP_Request R
										inner join dbo.AP_LotXCycle LC ON R.FK_LotXCycle = LC.ID
										inner join dbo.AP_Cycle C ON C.ID= LC.FK_Cycle
										WHERE  R.RequestDescription = @oldDescription

									END
								ELSE 
									RETURN 0
							END
						ELSE IF(dbo.APFN_MachineryRequestID(@RequestId)<>0)
							BEGIN
								SET @RequestAmount=(SELECT MR.AmountHours  FROM AP_MachineryRequest MR
													WHERE @RequestId = MR.FK_Machinery)
								IF (@RequestAmount >= @RealAmount)
									BEGIN
										INSERT INTO dbo.AP_MachineryMovement(FK_MachineryRequest, Amount, MovementDate, MovementDescription)
										VALUES (@RequestId, @RealAmount,GETDATE(), @RealDescription)

										UPDATE dbo.AP_LotXCycle SET	MachineryBalance = MachineryBalance + @RealAmount FROM dbo.AP_Request R
										inner join dbo.AP_LotXCycle LC ON R.FK_LotXCycle = LC.ID
										inner join dbo.AP_Cycle C ON C.ID= LC.FK_Cycle
										WHERE  R.RequestDescription = @oldDescription
									END
								ELSE 
									RETURN 0
							END
						ELSE
							RETURN 0
				UPDATE dbo.AP_Request SET	RequestState = 'Aprobada' FROM dbo.AP_Request R
					inner join dbo.AP_LotXCycle LC ON R.FK_LotXCycle = LC.ID
					inner join dbo.AP_Cycle C ON C.ID= LC.FK_Cycle
					WHERE R.RequestState ='Pendiente' and  R.RequestDescription = @oldDescription
				RETURN 1
			END
				RETURN 0
	END TRY
	BEGIN CATCH
		RETURN @@ERROR * -1
	END CATCH
END
GO
-- Procedure for viewing the possible requests that aren't approve
CREATE PROCEDURE [dbo].[APSP_ApproveRequestView](@LotXCycle int)
AS
BEGIN
	BEGIN TRY
			BEGIN
				SELECT R.RequestDescription FROM dbo.AP_Request R
				inner join dbo.AP_LotXCycle LC ON R.FK_LotXCycle = LC.ID
				inner join dbo.AP_Cycle C ON C.ID= LC.FK_Cycle
				WHERE R.RequestState =	'Pendiente' and Lc.ID= @LotXCycle
				RETURN 1
			END
				RETURN 0
	END TRY
	BEGIN CATCH
		RETURN @@ERROR * -1
	END CATCH
END

GO
-- Procedure for modifing a request
CREATE PROCEDURE [dbo].[APSP_ModifyRequest](@oldDescription VARCHAR(200), @Description VARCHAR(200), @RequestType VARCHAR(50), @Amount FLOAT)
AS
BEGIN
	BEGIN TRY
			BEGIN
				IF (@Description <> '')
					BEGIN
						UPDATE dbo.AP_Request SET RequestDescription = @Description FROM dbo.AP_Request R
						inner join dbo.AP_LotXCycle LC ON R.FK_LotXCycle = LC.ID
						inner join dbo.AP_Cycle C ON C.ID= LC.FK_Cycle
						WHERE  R.RequestDescription = @oldDescription
					END
				IF (@RequestType <> '')
					BEGIN
						IF (dbo.APFN_RequestTypeID(@RequestType)<>0)
							BEGIN
							UPDATE dbo.AP_Request SET FK_RequestType = dbo.APFN_RequestTypeID(@RequestType) FROM dbo.AP_Request R
							inner join dbo.AP_LotXCycle LC ON R.FK_LotXCycle = LC.ID
							inner join dbo.AP_Cycle C ON C.ID= LC.FK_Cycle
							WHERE  R.RequestDescription = @oldDescription
							END
					END
				IF (@Amount <> '')
					BEGIN
					DECLARE @RequestId INT
							SET @RequestId=(SELECT R.ID  FROM dbo.AP_Request R
												inner join dbo.AP_LotXCycle LC ON R.FK_LotXCycle = LC.ID
												inner join dbo.AP_Cycle C ON C.ID= LC.FK_Cycle
												WHERE  R.RequestDescription = @oldDescription)
							IF(dbo.APFN_ServiceRequestID(@RequestId)<>0)
								BEGIN
									UPDATE dbo.AP_ServiceRequest SET AmountHours=@Amount 
										FROM dbo.AP_ServiceRequest SR
										WHERE SR.FK_Service = @RequestId
								END
							ELSE IF(dbo.APFN_SupplyRequestID(@RequestId)<>0)
								BEGIN
									UPDATE dbo.AP_SupplyRequest SET Amount=@Amount 
									FROM dbo.AP_SupplyRequest SR
									WHERE SR.FK_Supply = @RequestId
								END
							ELSE IF(dbo.APFN_MachineryRequestID(@RequestId)<>0)
								BEGIN
									UPDATE dbo.AP_MachineryRequest SET AmountHours=@Amount 
									FROM dbo.AP_MachineryRequest MR
									WHERE MR.FK_Machinery = @RequestId
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
CREATE Procedure [dbo].[APSP_RequestDescription](@CodeLot VARCHAR(50),@Cycle VARCHAR(50) )
AS
	BEGIN
		SELECT R.RequestDescription FROM dbo.AP_Request R
		inner join dbo.AP_LotXCycle L ON R.FK_LotXCycle = L.ID
		WHERE L.FK_Cycle = dbo.APFN_Cycle(@Cycle) and L.FK_Lot = dbo.APFN_LotID(@CodeLot) and R.RequestState = 'Pendiente'
	END
GO

