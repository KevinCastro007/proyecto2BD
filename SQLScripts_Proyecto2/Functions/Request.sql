
USE AgriculturalProperty

--Function for verifing the approval of a certain request
GO
CREATE FUNCTION APFN_ApproveRequestVerify(@oldDescription VARCHAR(200), @RealAmount FLOAT, @RealDescription VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @RequestId INT, @RequestAmount FLOAT
	SET @RequestId=  (SELECT R.ID  FROM dbo.AP_Request R
						WHERE R.RequestState = 'Pendiente' and  R.RequestDescription = @oldDescription)
	IF(dbo.APFN_ServiceRequestID(@RequestId) <> 0)
	BEGIN
		SET @RequestAmount = (SELECT SR.AmountHours  FROM AP_ServiceRequest SR
								WHERE @RequestId = SR.FK_Service)
		IF (@RequestAmount < @RealAmount)
			RETURN  0
	END
	ELSE IF(dbo.APFN_SupplyRequestID(@RequestId)<>0)
	BEGIN
		SET @RequestAmount = (SELECT SR.Amount  FROM AP_SupplyRequest SR
								WHERE @RequestId = SR.FK_Supply)
		IF (@RequestAmount < @RealAmount)
			RETURN 0
	END
	ELSE IF(dbo.APFN_MachineryRequestID(@RequestId)<>0)
	BEGIN
		SET @RequestAmount = (SELECT MR.AmountHours  FROM AP_MachineryRequest MR
								WHERE @RequestId = MR.FK_Machinery)
		IF (@RequestAmount < @RealAmount)
			RETURN 0
	END
	ELSE
		RETURN 0
	RETURN 1
END

GO
--Function for verifing the modification of a certain request
CREATE Function APFN_ModifyValidate(@oldDescription VARCHAR(200), @Name VARCHAR(50), @ActivityType VARCHAR(50), @Amount FLOAT)
RETURNS INT
AS
BEGIN
	BEGIN
		IF (@Name <> '')
					BEGIN
						DECLARE @RequestId INT
							SET @RequestId=(SELECT R.ID  FROM dbo.AP_Request R
												WHERE  R.RequestDescription = @oldDescription)
							IF(dbo.APFN_ServiceRequestID(@RequestId)<>0)
								BEGIN
									DECLARE @C INT
								END
							ELSE IF(dbo.APFN_SupplyRequestID(@RequestId)<>0)
								BEGIN
									DECLARE @W INT
								END
							ELSE IF(dbo.APFN_MachineryRequestID(@RequestId)<>0)
								BEGIN
									DECLARE @Z INT
								END
							ELSE
								RETURN 0

					END
		IF (@ActivityType <> '')
		BEGIN
			IF (dbo.APFN_ActivityTypeID(@ActivityType)<>0)
			BEGIN
				DECLARE @r int;
			END
		END
		IF (@Amount <> '')
		BEGIN
			DECLARE @RequestIdA INT
			SET @RequestIdA = (SELECT R.ID  FROM dbo.AP_Request R
								WHERE  R.RequestDescription = @oldDescription)
			IF(dbo.APFN_ServiceRequestID(@RequestIdA)<>0)
			BEGIN
				DECLARE @s int;
			END
			ELSE IF(dbo.APFN_SupplyRequestID(@RequestIdA)<>0)
			BEGIN
				DECLARE @a int;
			END
			ELSE IF(dbo.APFN_MachineryRequestID(@RequestIdA)<>0)
			BEGIN
				DECLARE @o int;
			END
			ELSE
				RETURN 0
		END
	 		RETURN 1	
	END
		RETURN 0	
END
GO
--Function for verifing the modification of a certain request
CREATE Function APFN_RequestID(@Request VARCHAR(50), @Description VARCHAR(50))
RETURNS INT
AS
BEGIN
			DECLARE @RequestId INT, @ID INT
			SET @RequestId = (SELECT R.ID  FROM dbo.AP_Request R
								WHERE  R.RequestDescription = @Description)
			IF(dbo.APFN_ServiceRequestID(@RequestId)<>0)
			BEGIN
				SET @ID = (SELECT S.ID  FROM dbo.AP_Service S 
							WHERE S.Name = @Request)
			END
			ELSE IF(dbo.APFN_SupplyRequestID(@RequestId)<>0)
			BEGIN
				SET @ID = (SELECT S.ID  FROM dbo.AP_Supply S 
							WHERE S.Name = @Request)
			END
			ELSE IF(dbo.APFN_MachineryRequestID(@RequestId)<>0)
			BEGIN
				SET @ID = (SELECT M.ID  FROM dbo.AP_Machinery M 
							WHERE M.Name = @Request)
			END
			RETURN @ID
END