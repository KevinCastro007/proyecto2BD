/* Stored Procedures related with: Request */

GO
USE AgriculturalProperty

-- Agregar el tipo de actividad (conseguir el ID si ya esta o insertar y conseguir)
GO
CREATE PROCEDURE APSP_InsertRequest(@Description VARCHAR(150), @Attendant VARCHAR(50), @ActivityType VARCHAR(50), @RequestType VARCHAR(50), @Request VARCHAR(50), @Amount FLOAT)
AS
BEGIN
	BEGIN TRY
		IF (dbo.APFN_AttendatID(@Attendant) <> 0 and dbo.APFN_RequestTypeID(@RequestType) <> 0 
			and @Amount > 1 and dbo.APFN_RequestTypeManagerID(@RequestType) <> 0) 
		BEGIN
			-- BEGIN TRANSACTION
			INSERT INTO dbo.AP_Request(FK_RequestManager, FK_ResquestAttendant, FK_RequestType, RequestDescription, State) 
				VALUES(dbo.APFN_RequestTypeManagerID(@RequestType), dbo.APFN_AttendatID(@Attendant), dbo.APFN_RequestTypeID(@RequestType), @Description, 0)

			-- Insert HistoricalActivity
			IF (@RequestType = 'Servicio')
			BEGIN
				IF (dbo.APFN_ServiceID(@Request) <> 0)
				BEGIN	
					INSERT INTO dbo.AP_ServiceRequest(FK_Service, RequestID, AmountHours) 
						VALUES(dbo.APFN_ServiceID(@Request), SCOPE_IDENTITY(), @Amount)
					RETURN 1
				END
				ELSE
					RETURN 0
			END
			IF (@RequestType = 'Suministro')
			BEGIN 
				IF (dbo.APFN_SupplyID(@Request) <> 0)
				BEGIN	
					INSERT INTO dbo.AP_SupplyRequest(FK_Service, RequestID, Amount) 
						VALUES(dbo.APFN_SupplyID(@Request), SCOPE_IDENTITY(), @Amount)
					RETURN 1
				END
				ELSE
					RETURN 0
			END
			ELSE
			BEGIN
				IF (dbo.APFN_MachineryID(@Request) <> 0)
				BEGIN	
					INSERT INTO dbo.AP_MachineryRequest(FK_Service, RequestID, AmountHours) 
						VALUES(dbo.APFN_MachineryID(@Request), SCOPE_IDENTITY(), @Amount)
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
		RETURN @@ERROR * -1
	END CATCH
END