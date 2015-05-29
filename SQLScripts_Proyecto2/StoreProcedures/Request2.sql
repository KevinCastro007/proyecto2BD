/* Store procedures for Requests*/

USE AgriculturalProperty
GO

-- Procedure for approving a certain request
CREATE PROCEDURE APSP_ApproveRequest(@StartDate DATE, @EndDate DATE)
AS
BEGIN
	BEGIN TRY
			BEGIN
				UPDATE dbo.AP_Request SET	State = 1 FROM dbo.AP_Request R
					inner join dbo.AP_LotXCycle LC ON R.FK_LotXCycle = LC.ID
					inner join dbo.AP_Cycle C ON C.ID= LC.FK_Cycle
					WHERE R.State =0 and  @StartDate =C.StartDate and @EndDate=C.EndDate
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
CREATE PROCEDURE APSP_ApproveRequestView(@Attendant VARCHAR(50))
AS
BEGIN
	BEGIN TRY
			BEGIN
				SELECT R.RequestDescription, C.StartDate, C.EndDate FROM dbo.AP_Request R
					inner join dbo.AP_Attendant A ON @Attendant = A.Name
					inner join dbo.AP_LotXCycle LC ON A.ID=LC.FK_Attendant
					inner join dbo.AP_Cycle C ON LC.FK_Cycle = C.ID
					WHERE R.State =	0
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
CREATE PROCEDURE APSP_ModifyRequest(@StartDate DATE, @EndDate DATE, @Description VARCHAR(150), @RequestType VARCHAR(50), @Amount FLOAT)
AS
BEGIN
	BEGIN TRY
			BEGIN
				IF (@Description <> '')
					BEGIN
						UPDATE dbo.AP_Request SET RequestDescription = @Description FROM dbo.AP_Request R
							inner join dbo.AP_LotXCycle LC ON R.FK_LotXCycle = LC.ID
							inner join dbo.AP_Cycle C ON C.ID= LC.FK_Cycle
							WHERE R.State =0 and  @StartDate =C.StartDate and @EndDate=C.EndDate
					END
				IF (@RequestType <> '')
					BEGIN
						IF (dbo.APFN_RequestTypeID(@RequestType)<>0)
							BEGIN
							UPDATE dbo.AP_Request SET FK_RequestType = dbo.APFN_RequestTypeID(@RequestType) FROM dbo.AP_Request R
								inner join dbo.AP_LotXCycle LC ON R.FK_LotXCycle = LC.ID
								inner join dbo.AP_Cycle C ON C.ID= LC.FK_Cycle
								WHERE R.State =0 and  @StartDate =C.StartDate and @EndDate=C.EndDate
							END
					END
				IF (@Amount <> '')
					BEGIN
					DECLARE @RequestId INT
							SET @RequestId=(SELECT R.ID  FROM dbo.AP_Request R
												inner join dbo.AP_LotXCycle LC ON R.FK_LotXCycle = LC.ID
												inner join dbo.AP_Cycle C ON C.ID= LC.FK_Cycle
												WHERE R.State =0 and  @StartDate =C.StartDate and @EndDate=C.EndDate)
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