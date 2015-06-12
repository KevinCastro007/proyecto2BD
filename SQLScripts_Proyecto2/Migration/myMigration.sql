SP_CONFIGURE 'show advanced options', 1
RECONFIGURE WITH OVERRIDE
GO
SP_CONFIGURE 'Ad Hoc Distributed Queries', 1
RECONFIGURE WITH OVERRIDE
GO

USE AgriculturalProperty

/*
GO
CREATE SEQUENCE APSQ_Count  
AS bigint   
	START WITH 1   
	INCREMENT BY 1  
	NO MAXVALUE
*/

GO
ALTER PROCEDURE APSP_MigrateData
AS
BEGIN
	BEGIN TRY
		DECLARE @Doc XML, @MaxRequest INT
		SELECT @Doc = BulkColumn 
			FROM OPENROWSET(BULK 'D:\XMLfarm.xml', SINGLE_CLOB) AS xmlDATA
		DECLARE @Property TABLE(ID INT IDENTITY(1,1), Name VARCHAR(50))
		DECLARE @CropType TABLE(ID INT IDENTITY(1, 1), Name VARCHAR(50))
		DECLARE @Cycle TABLE(ID INT IDENTITY(1,1), StartDate VARCHAR(10), EndDate VARCHAR(10))
		DECLARE @ActivityType TABLE(ID INT IDENTITY(1, 1), Name VARCHAR(50))
		DECLARE @Service TABLE(ID INT IDENTITY(1,1), Name VARCHAR(50), Cost FLOAT)
		DECLARE @Supply TABLE(ID INT IDENTITY(1,1), Name VARCHAR(50), Cost FLOAT)
		DECLARE @Machinery TABLE(ID INT IDENTITY(1,1), Name VARCHAR(50), Cost FLOAT)
		DECLARE @AttendantTemp TABLE(ID INT IDENTITY(1,1), Name VARCHAR(50))
		DECLARE @Attendant TABLE(ID INT IDENTITY(1,1), Name VARCHAR(50))
		DECLARE @Lot TABLE(ID INT IDENTITY(1,1), FK_Property INT, Code VARCHAR(50))	
		DECLARE @LotXCycle TABLE(ID INT IDENTITY(1,1), FK_Lot INT, FK_Cycle INT, FK_CropType INT)
		DECLARE @Request TABLE(ID INT IDENTITY(1, 1), FK_LotXCycle INT, FK_RequestType INT, FK_Attendant INT, FK_ActivityType INT, 
			RequestDescription VARCHAR(150), RequestState VARCHAR(50), RequestDate VARCHAR(10), TransactionDate VARCHAR(10))
		DECLARE @ServiceRequest TABLE(ID INT, FK_Service INT, AmountHours FLOAT)
		DECLARE @MachineryRequest TABLE(ID INT, FK_Machinery INT, AmountHours FLOAT)
		DECLARE @SupplyRequest TABLE(ID INT, FK_Supply INT, Amount FLOAT)

		DECLARE @Historical TABLE(FK_Request INT, ActivityDate DATE, ActivityDescription VARCHAR(150))
		DECLARE @ServiceMovement TABLE(FK_ServiceRequest INT, Amount FLOAT, MovementDate VARCHAR(10), MovementDescription VARCHAR(150))
		DECLARE @MachineryMovement TABLE(FK_MachineryRequest INT, Amount FLOAT, MovementDate VARCHAR(10), MovementDescription VARCHAR(150))
		DECLARE @SupplyMovement TABLE(FK_SupplyRequest INT, Amount FLOAT, MovementDate VARCHAR(10), MovementDescription VARCHAR(150))

		INSERT INTO @Cycle(StartDate, EndDate)
		SELECT DISTINCT 
			period.value('@startDate', 'VARCHAR(50)'), 
			period.value('@endDate', 'VARCHAR(50)')
		FROM @Doc.nodes('/company') AS x1(company)
		cross apply x1.company.nodes('./period') AS x2(period)

		INSERT INTO @Property(Name)
		SELECT DISTINCT 
			farm.value('@name', 'VARCHAR(50)')
		FROM @Doc.nodes('/company') AS x1(company)
		cross apply x1.company.nodes('./period') AS x2(period)
		cross apply x2.period.nodes('./farm') AS x3(farm)

		INSERT INTO @CropType(Name)
		SELECT DISTINCT 
			lot.value('@cropType', 'VARCHAR(50)')
		FROM @Doc.nodes('/company') AS x1(company)
		cross apply x1.company.nodes('./period') AS x2(period)
		cross apply x2.period.nodes('./farm') AS x3(farm)
		cross apply x3.farm.nodes('./lot') AS x4(lot)

		INSERT INTO @ActivityType(Name)
		SELECT DISTINCT 
			activity.value('@description', 'VARCHAR(50)')
		FROM @Doc.nodes('/company') AS x1(company)
		cross apply x1.company.nodes('./period') AS x2(period)
		cross apply x2.period.nodes('./farm') AS x3(farm)
		cross apply x3.farm.nodes('./lot') AS x4(lot)
		cross apply x4.lot.nodes('./activity') AS x5(activity)

		INSERT INTO @Service(Name, Cost)
		SELECT DISTINCT 
			service.value('@name', 'VARCHAR(50)'),
			0
		FROM @Doc.nodes('/company') AS x1(company)
		cross apply x1.company.nodes('./period') AS x2(period)
		cross apply x2.period.nodes('./farm') AS x3(farm)
		cross apply x3.farm.nodes('./lot') AS x4(lot)
		cross apply x4.lot.nodes('./activity') AS x5(activity)
		cross apply x5.activity.nodes('./service') AS x6(service)

		INSERT INTO @Supply(Name, Cost)
		SELECT DISTINCT 
			supply.value('@name', 'VARCHAR(50)'),
			0
		FROM @Doc.nodes('/company') AS x1(company)
		cross apply x1.company.nodes('./period') AS x2(period)
		cross apply x2.period.nodes('./farm') AS x3(farm)
		cross apply x3.farm.nodes('./lot') AS x4(lot)
		cross apply x4.lot.nodes('./activity') AS x5(activity)
		cross apply x5.activity.nodes('./supply') AS x6(supply)

		INSERT INTO @Machinery(Name, Cost)
		SELECT DISTINCT 
			machinery.value('@name', 'VARCHAR(50)'),
			0
		FROM @Doc.nodes('/company') AS x1(company)
		cross apply x1.company.nodes('./period') AS x2(period)
		cross apply x2.period.nodes('./farm') AS x3(farm)
		cross apply x3.farm.nodes('./lot') AS x4(lot)
		cross apply x4.lot.nodes('./activity') AS x5(activity)
		cross apply x5.activity.nodes('./machinery') AS x6(machinery)

		INSERT INTO @AttendantTemp(Name)
		SELECT DISTINCT 
			service.value('@requestFrom', 'VARCHAR(50)')
		FROM @Doc.nodes('/company') AS x1(company)
		cross apply x1.company.nodes('./period') AS x2(period)
		cross apply x2.period.nodes('./farm') AS x3(farm)
		cross apply x3.farm.nodes('./lot') AS x4(lot)
		cross apply x4.lot.nodes('./activity') AS x5(activity)
		cross apply x5.activity.nodes('./service') AS x6(service)
		INSERT INTO @AttendantTemp(Name)
		SELECT DISTINCT 
			supply.value('@requestFrom', 'VARCHAR(50)')
		FROM @Doc.nodes('/company') AS x1(company)
		cross apply x1.company.nodes('./period') AS x2(period)
		cross apply x2.period.nodes('./farm') AS x3(farm)
		cross apply x3.farm.nodes('./lot') AS x4(lot)
		cross apply x4.lot.nodes('./activity') AS x5(activity)
		cross apply x5.activity.nodes('./supply') AS x6(supply)
		INSERT INTO @AttendantTemp(Name)
		SELECT DISTINCT 
			machinery.value('@requestFrom', 'VARCHAR(50)')
		FROM @Doc.nodes('/company') AS x1(company)
		cross apply x1.company.nodes('./period') AS x2(period)
		cross apply x2.period.nodes('./farm') AS x3(farm)
		cross apply x3.farm.nodes('./lot') AS x4(lot)
		cross apply x4.lot.nodes('./activity') AS x5(activity)
		cross apply x5.activity.nodes('./machinery') AS x6(machinery)
		INSERT INTO @Attendant(Name)
		SELECT DISTINCT 
			A.Name 
		FROM @AttendantTemp A

		INSERT INTO @Lot(FK_Property, Code)
		SELECT DISTINCT
			(SELECT P.ID FROM @Property P
				WHERE P.Name = farm.value('@name', 'VARCHAR(50)')),	
			lot.value('@code', 'VARCHAR(50)')
		FROM @Doc.nodes('/company') AS x1(company)
		cross apply x1.company.nodes('./period') AS x2(period)
		cross apply x2.period.nodes('./farm') AS x3(farm)
		cross apply x3.farm.nodes('./lot') AS x4(lot)

		INSERT INTO @LotXCycle(FK_Lot, FK_Cycle, FK_CropType)
		SELECT 
			(SELECT L.ID FROM @Lot L
				WHERE L.Code = lot.value('@code', 'VARCHAR(50)')),
			(SELECT C.ID FROM @Cycle C
				WHERE C.StartDate = period.value('@startDate', 'VARCHAR(50)')
					and C.EndDate = period.value('@endDate', 'VARCHAR(50)')),
			(SELECT CT.ID FROM @CropType CT
				WHERE CT.Name = lot.value('@cropType', 'VARCHAR(50)'))	
		FROM @Doc.nodes('/company') AS x1(company)
		cross apply x1.company.nodes('./period') AS x2(period)
		cross apply x2.period.nodes('./farm') AS x3(farm)
		cross apply x3.farm.nodes('./lot') AS x4(lot)

		ALTER SEQUENCE APSQ_Count
		RESTART WITH 1;
		INSERT INTO @Request(FK_LotXCycle, FK_RequestType, FK_Attendant, FK_ActivityType, RequestDescription, RequestState, RequestDate, TransactionDate)
		SELECT 
			(SELECT LC.ID FROM @LotXCycle LC
				WHERE LC.FK_Lot = (SELECT L.ID FROM @Lot L
				WHERE L.Code = lot.value('@code', 'VARCHAR(50)'))
					and LC.FK_Cycle = (SELECT C.ID FROM @Cycle C
				WHERE C.StartDate = period.value('@startDate', 'VARCHAR(50)')
					and C.EndDate = period.value('@endDate', 'VARCHAR(50)'))
					and LC.FK_CropType = (SELECT CT.ID FROM @CropType CT
				WHERE CT.Name = lot.value('@cropType', 'VARCHAR(50)'))),
			1,			
			(SELECT A.ID FROM @Attendant A
				WHERE A.Name = service.value('@requestFrom', 'VARCHAR(50)')),
			(SELECT AT.ID FROM @ActivityType AT
				WHERE AT.Name = activity.value('@description', 'VARCHAR(50)')),
			'COD' + CONVERT(VARCHAR(10), (SELECT LC.ID FROM @LotXCycle LC
				WHERE LC.FK_Lot = (SELECT L.ID FROM @Lot L
				WHERE L.Code = lot.value('@code', 'VARCHAR(50)'))
					and LC.FK_Cycle = (SELECT C.ID FROM @Cycle C
				WHERE C.StartDate = period.value('@startDate', 'VARCHAR(50)')
					and C.EndDate = period.value('@endDate', 'VARCHAR(50)'))
					and LC.FK_CropType = (SELECT CT.ID FROM @CropType CT
				WHERE CT.Name = lot.value('@cropType', 'VARCHAR(50)')))) 
				+ CONVERT(VARCHAR(10), (SELECT AT.ID FROM @ActivityType AT
				WHERE AT.Name = activity.value('@description', 'VARCHAR(50)'))) 
				+ CONVERT(VARCHAR(10), 1) 
				+ CONVERT(VARCHAR(10), (SELECT S.ID FROM @Service S
				WHERE S.Name = service.value('@name', 'VARCHAR(50)')))  
				+ '. ' + service.value('@name', 'VARCHAR(50)') + ', cantidad: ' + CONVERT(VARCHAR(50), service.value('@duration', 'VARCHAR(50)')) + ' hora(s).',				
			service.value('@status', 'VARCHAR(50)'),
			service.value('@requestDate', 'VARCHAR(10)'),
			service.value('@transactionDate', 'VARCHAR(10)')
		FROM @Doc.nodes('/company') AS x1(company)
		cross apply x1.company.nodes('./period') AS x2(period)
		cross apply x2.period.nodes('./farm') AS x3(farm)
		cross apply x3.farm.nodes('./lot') AS x4(lot)
		cross apply x4.lot.nodes('./activity') AS x5(activity)
		cross apply x5.activity.nodes('./service') AS x6(service)
		INSERT INTO @ServiceRequest(ID, FK_Service, AmountHours)
		SELECT 
			NEXT value FOR APSQ_Count,
			(SELECT S.ID FROM @Service S
				WHERE S.Name = service.value('@name', 'VARCHAR(50)')),
			service.value('@duration', 'VARCHAR(50)')
		FROM @Doc.nodes('/company') AS x1(company)
		cross apply x1.company.nodes('./period') AS x2(period)
		cross apply x2.period.nodes('./farm') AS x3(farm)
		cross apply x3.farm.nodes('./lot') AS x4(lot)
		cross apply x4.lot.nodes('./activity') AS x5(activity)
		cross apply x5.activity.nodes('./service') AS x6(service)

		SELECT @MaxRequest = MAX(R.ID) FROM @Request R
		ALTER SEQUENCE APSQ_Count
		RESTART WITH 1;
		INSERT INTO @Request(FK_LotXCycle, FK_RequestType, FK_Attendant, FK_ActivityType, RequestDescription, RequestState, RequestDate, TransactionDate)
		SELECT 
			(SELECT LC.ID FROM @LotXCycle LC
				WHERE LC.FK_Lot = (SELECT L.ID FROM @Lot L
				WHERE L.Code = lot.value('@code', 'VARCHAR(50)'))
					and LC.FK_Cycle = (SELECT C.ID FROM @Cycle C
				WHERE C.StartDate = period.value('@startDate', 'VARCHAR(50)')
					and C.EndDate = period.value('@endDate', 'VARCHAR(50)'))
					and LC.FK_CropType = (SELECT CT.ID FROM @CropType CT
				WHERE CT.Name = lot.value('@cropType', 'VARCHAR(50)'))),
			2,
			(SELECT A.ID FROM @Attendant A
				WHERE A.Name = machinery.value('@requestFrom', 'VARCHAR(50)')),
			(SELECT AT.ID FROM @ActivityType AT
				WHERE AT.Name = activity.value('@description', 'VARCHAR(50)')),
			'COD' + CONVERT(VARCHAR(10), (SELECT LC.ID FROM @LotXCycle LC
				WHERE LC.FK_Lot = (SELECT L.ID FROM @Lot L
				WHERE L.Code = lot.value('@code', 'VARCHAR(50)'))
					and LC.FK_Cycle = (SELECT C.ID FROM @Cycle C
				WHERE C.StartDate = period.value('@startDate', 'VARCHAR(50)')
					and C.EndDate = period.value('@endDate', 'VARCHAR(50)'))
					and LC.FK_CropType = (SELECT CT.ID FROM @CropType CT
				WHERE CT.Name = lot.value('@cropType', 'VARCHAR(50)')))) 
				+ CONVERT(VARCHAR(10), (SELECT AT.ID FROM @ActivityType AT
				WHERE AT.Name = activity.value('@description', 'VARCHAR(50)'))) 
				+ CONVERT(VARCHAR(10), 1) 
				+ CONVERT(VARCHAR(10), (SELECT M.ID FROM @Machinery M
				WHERE M.Name = machinery.value('@name', 'VARCHAR(50)')))  
				+ '. ' + machinery.value('@name', 'VARCHAR(50)') + ', cantidad: ' + CONVERT(VARCHAR(50), machinery.value('@duration', 'VARCHAR(50)')) + ' hora(s).',
			machinery.value('@status', 'VARCHAR(50)'),
			machinery.value('@requestDate', 'VARCHAR(10)'),
			machinery.value('@transactionDate', 'VARCHAR(10)')
		FROM @Doc.nodes('/company') AS x1(company)
		cross apply x1.company.nodes('./period') AS x2(period)
		cross apply x2.period.nodes('./farm') AS x3(farm)
		cross apply x3.farm.nodes('./lot') AS x4(lot)
		cross apply x4.lot.nodes('./activity') AS x5(activity)
		cross apply x5.activity.nodes('./machinery') AS x6(machinery)
		INSERT INTO @MachineryRequest(ID, FK_Machinery, AmountHours)
		SELECT 
			(NEXT value FOR APSQ_Count) + @MaxRequest,
			(SELECT M.ID FROM @Machinery M
				WHERE M.Name = machinery.value('@name', 'VARCHAR(50)')),
			machinery.value('@duration', 'VARCHAR(50)')
		FROM    @Doc.nodes('/company') AS x1(company)
		cross apply x1.company.nodes('./period') AS x2(period)
		cross apply x2.period.nodes('./farm') AS x3(farm)
		cross apply x3.farm.nodes('./lot') AS x4(lot)
		cross apply x4.lot.nodes('./activity') AS x5(activity)
		cross apply x5.activity.nodes('./machinery') AS x6(machinery)

		SELECT @MaxRequest = MAX(R.ID) FROM @Request R
		ALTER SEQUENCE APSQ_Count
		RESTART WITH 1;
		INSERT INTO @Request(FK_LotXCycle, FK_RequestType, FK_Attendant, FK_ActivityType, RequestDescription, RequestState, RequestDate, TransactionDate)
		SELECT 
			(SELECT LC.ID FROM @LotXCycle LC
				WHERE LC.FK_Lot = (SELECT L.ID FROM @Lot L
				WHERE L.Code = lot.value('@code', 'VARCHAR(50)'))
					and LC.FK_Cycle = (SELECT C.ID FROM @Cycle C
				WHERE C.StartDate = period.value('@startDate', 'VARCHAR(50)')
					and C.EndDate = period.value('@endDate', 'VARCHAR(50)'))
					and LC.FK_CropType = (SELECT CT.ID FROM @CropType CT
				WHERE CT.Name = lot.value('@cropType', 'VARCHAR(50)'))),
			3,
			(SELECT A.ID FROM @Attendant A
				WHERE A.Name = supply.value('@requestFrom', 'VARCHAR(50)')),
			(SELECT AT.ID FROM @ActivityType AT
				WHERE AT.Name = activity.value('@description', 'VARCHAR(50)')),
			'COD' + CONVERT(VARCHAR(10), (SELECT LC.ID FROM @LotXCycle LC
				WHERE LC.FK_Lot = (SELECT L.ID FROM @Lot L
				WHERE L.Code = lot.value('@code', 'VARCHAR(50)'))
					and LC.FK_Cycle = (SELECT C.ID FROM @Cycle C
				WHERE C.StartDate = period.value('@startDate', 'VARCHAR(50)')
					and C.EndDate = period.value('@endDate', 'VARCHAR(50)'))
					and LC.FK_CropType = (SELECT CT.ID FROM @CropType CT
				WHERE CT.Name = lot.value('@cropType', 'VARCHAR(50)')))) 
				+ CONVERT(VARCHAR(10), (SELECT AT.ID FROM @ActivityType AT
				WHERE AT.Name = activity.value('@description', 'VARCHAR(50)'))) 
				+ CONVERT(VARCHAR(10), 1) 
				+ CONVERT(VARCHAR(10), (SELECT S.ID FROM @Supply S
				WHERE S.Name = supply.value('@name', 'VARCHAR(50)')))  
				+ '. ' + supply.value('@name', 'VARCHAR(50)') + ', cantidad: ' + CONVERT(VARCHAR(50), supply.value('@units', 'VARCHAR(50)')) + '.',
			supply.value('@status', 'VARCHAR(50)'),
			supply.value('@requestDate', 'VARCHAR(10)'),
			supply.value('@transactionDate', 'VARCHAR(10)')
		FROM @Doc.nodes('/company') AS x1(company)
		cross apply x1.company.nodes('./period') AS x2(period)
		cross apply x2.period.nodes('./farm') AS x3(farm)
		cross apply x3.farm.nodes('./lot') AS x4(lot)
		cross apply x4.lot.nodes('./activity') AS x5(activity)
		cross apply x5.activity.nodes('./supply') AS x6(supply)
		INSERT INTO @SupplyRequest(ID, FK_Supply, Amount)
		SELECT 
			(NEXT value FOR APSQ_Count) + @MaxRequest,
			(SELECT S.ID FROM @Supply S
				WHERE S.Name = supply.value('@name', 'VARCHAR(50)')),
			supply.value('@units', 'VARCHAR(50)')
		FROM @Doc.nodes('/company') AS x1(company)
		cross apply x1.company.nodes('./period') AS x2(period)
		cross apply x2.period.nodes('./farm') AS x3(farm)
		cross apply x3.farm.nodes('./lot') AS x4(lot)
		cross apply x4.lot.nodes('./activity') AS x5(activity)
		cross apply x5.activity.nodes('./supply') AS x6(supply)
		
		/*select * from @Request
		select * from @ServiceRequest
		select * from @MachineryRequest
		select * from @SupplyRequest*/

		/*INSERT INTO @Historical(FK_Request, ActivityDate, ActivityDescription)
		SELECT 
			R.ID,
			R.RequestDate,
			R.RequestDescription
		FROM @Request R
		select * from @Historical*/

		INSERT INTO @ServiceMovement(FK_ServiceRequest, Amount, MovementDate, MovementDescription)
		SELECT 
			SR.ID,
			SR.AmountHours,
			R.TransactionDate,
			'Fecha de proceso: ' + R.TransactionDate + '. ' + R.RequestDescription + ' Nuevo saldo de servicios: (CALCULAR)' 
			/*+ CONVERT(VARCHAR(200), (LC.ServicesBalance + dbo.APFN_ServiceCost(@Request) * @Amount))*/
		FROM @ServiceRequest SR
		inner join @Request R ON R.ID = SR.ID
		WHERE R.RequestState = 'Approved'

		select * from @ServiceMovement
		
		--select * FROM @ServiceMovement

	END TRY
	BEGIN CATCH
		/*IF @@TRANCOUNT = 1
			ROLLBACK*/

		RETURN @@ERROR * - 1
	END CATCH
END