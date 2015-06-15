SP_CONFIGURE 'show advanced options', 1
RECONFIGURE WITH OVERRIDE
GO
SP_CONFIGURE 'Ad Hoc Distributed Queries', 1
RECONFIGURE WITH OVERRIDE
GO
USE AgriculturalProperty

GO
CREATE SEQUENCE APSQ_Count  
AS bigint   
	START WITH 1   
	INCREMENT BY 1  
	NO MAXVALUE

GO
CREATE PROCEDURE APSP_MigrateData
AS
BEGIN
	BEGIN TRY
		DECLARE @Doc XML, @MaxRequest INT
		SELECT @Doc = BulkColumn 
			FROM OPENROWSET(BULK 'D:\XMLfarm.xml', SINGLE_CLOB) AS xmlDATA
		DECLARE @Property TABLE(ID INT IDENTITY(1, 1), Name VARCHAR(50))
		DECLARE @CropType TABLE(ID INT IDENTITY(1, 1), Name VARCHAR(50))
		DECLARE @Cycle TABLE(ID INT IDENTITY(1, 1), StartDate DATE, EndDate DATE)
		DECLARE @ActivityType TABLE(ID INT IDENTITY(1, 1), Name VARCHAR(50))
		DECLARE @Service TABLE(ID INT IDENTITY(1, 1), Name VARCHAR(50), Cost FLOAT)
		DECLARE @Supply TABLE(ID INT IDENTITY(1, 1), Name VARCHAR(50), Cost FLOAT)
		DECLARE @Machinery TABLE(ID INT IDENTITY(1, 1), Name VARCHAR(50), Cost FLOAT)
		DECLARE @AttendantTemp TABLE(ID INT IDENTITY(1, 1), Name VARCHAR(50))
		DECLARE @Attendant TABLE(ID INT IDENTITY(1, 1), Name VARCHAR(50))
		DECLARE @Lot TABLE(ID INT IDENTITY(1, 1), FK_Property INT, Code VARCHAR(50))	
		DECLARE @LotXCycle TABLE(ID INT IDENTITY(1, 1), FK_Lot INT, FK_Cycle INT, FK_CropType INT, ServicesBalance FLOAT, SuppliesBalance FLOAT, MachineryBalance FLOAT)
		DECLARE @Request TABLE(ID INT IDENTITY(1, 1), FK_LotXCycle INT, FK_RequestType INT, FK_Attendant INT, FK_ActivityType INT, 
			RequestDescription VARCHAR(150), RequestState VARCHAR(50), RequestDate DATE, TransactionDate DATE)
		DECLARE @ServiceRequest TABLE(ID INT, FK_Service INT, AmountHours FLOAT, Cost FLOAT)
		DECLARE @MachineryRequest TABLE(ID INT, FK_Machinery INT, AmountHours FLOAT, Cost FLOAT)
		DECLARE @SupplyRequest TABLE(ID INT, FK_Supply INT, Amount FLOAT, Cost FLOAT)

		DECLARE @Historical TABLE(FK_Request INT, ActivityDate DATE, ActivityDescription VARCHAR(150))
		DECLARE @ServiceMovement TABLE(FK_ServiceRequest INT, Amount FLOAT, MovementDate DATE, MovementDescription VARCHAR(150))
		DECLARE @MachineryMovement TABLE(FK_MachineryRequest INT, Amount FLOAT, MovementDate DATE, MovementDescription VARCHAR(150))
		DECLARE @SupplyMovement TABLE(FK_SupplyRequest INT, Amount FLOAT, MovementDate DATE, MovementDescription VARCHAR(150))

		INSERT INTO @Cycle(StartDate, EndDate)
		SELECT DISTINCT 
			(SUBSTRING(period.value('@startDate', 'VARCHAR(10)'), 4, 2) + '/' + 
				SUBSTRING(period.value('@startDate', 'VARCHAR(10)'), 0, 3) + '/' + 
				SUBSTRING(period.value('@startDate', 'VARCHAR(10)'), 7, LEN(period.value('@startDate', 'VARCHAR(10)')))),
			(SUBSTRING(period.value('@endDate', 'VARCHAR(10)'), 4, 2) + '/' + 
				SUBSTRING(period.value('@endDate', 'VARCHAR(10)'), 0, 3) + '/' + 
				SUBSTRING(period.value('@endDate', 'VARCHAR(10)'), 7, LEN(period.value('@endDate', 'VARCHAR(10)'))))			
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
			3500
		FROM @Doc.nodes('/company') AS x1(company)
		cross apply x1.company.nodes('./period') AS x2(period)
		cross apply x2.period.nodes('./farm') AS x3(farm)
		cross apply x3.farm.nodes('./lot') AS x4(lot)
		cross apply x4.lot.nodes('./activity') AS x5(activity)
		cross apply x5.activity.nodes('./service') AS x6(service)

		INSERT INTO @Supply(Name, Cost)
		SELECT DISTINCT 
			supply.value('@name', 'VARCHAR(50)'),
			1575
		FROM @Doc.nodes('/company') AS x1(company)
		cross apply x1.company.nodes('./period') AS x2(period)
		cross apply x2.period.nodes('./farm') AS x3(farm)
		cross apply x3.farm.nodes('./lot') AS x4(lot)
		cross apply x4.lot.nodes('./activity') AS x5(activity)
		cross apply x5.activity.nodes('./supply') AS x6(supply)

		INSERT INTO @Machinery(Name, Cost)
		SELECT DISTINCT 
			machinery.value('@name', 'VARCHAR(50)'),
			7575
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
		
		INSERT INTO @LotXCycle(FK_Lot, FK_Cycle, FK_CropType, ServicesBalance, SuppliesBalance, MachineryBalance)
		SELECT
			(SELECT L.ID FROM @Lot L
				WHERE L.Code = lot.value('@code', 'VARCHAR(50)')),
			(SELECT C.ID FROM @Cycle C
				WHERE C.StartDate = (SUBSTRING(period.value('@startDate', 'VARCHAR(10)'), 4, 2) + '/' + 
										SUBSTRING(period.value('@startDate', 'VARCHAR(10)'), 0, 3) + '/' + 
										SUBSTRING(period.value('@startDate', 'VARCHAR(10)'), 7, LEN(period.value('@startDate', 'VARCHAR(10)'))))
					and C.EndDate = (SUBSTRING(period.value('@endDate', 'VARCHAR(10)'), 4, 2) + '/' + 
										SUBSTRING(period.value('@endDate', 'VARCHAR(10)'), 0, 3) + '/' + 
										SUBSTRING(period.value('@endDate', 'VARCHAR(10)'), 7, LEN(period.value('@endDate', 'VARCHAR(10)'))))),
			(SELECT CT.ID FROM @CropType CT
				WHERE CT.Name = lot.value('@cropType', 'VARCHAR(50)')),
			0,
			0,
			0
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
				WHERE C.StartDate = (SUBSTRING(period.value('@startDate', 'VARCHAR(10)'), 4, 2) + '/' + 
										SUBSTRING(period.value('@startDate', 'VARCHAR(10)'), 0, 3) + '/' + 
										SUBSTRING(period.value('@startDate', 'VARCHAR(10)'), 7, LEN(period.value('@startDate', 'VARCHAR(10)'))))
					and C.EndDate = (SUBSTRING(period.value('@endDate', 'VARCHAR(10)'), 4, 2) + '/' + 
										SUBSTRING(period.value('@endDate', 'VARCHAR(10)'), 0, 3) + '/' + 
										SUBSTRING(period.value('@endDate', 'VARCHAR(10)'), 7, LEN(period.value('@endDate', 'VARCHAR(10)'))))
					and LC.FK_CropType = (SELECT CT.ID FROM @CropType CT
				WHERE CT.Name = lot.value('@cropType', 'VARCHAR(50)')))),
			1,			
			(SELECT A.ID FROM @Attendant A
				WHERE A.Name = service.value('@requestFrom', 'VARCHAR(50)')),
			(SELECT AT.ID FROM @ActivityType AT
				WHERE AT.Name = activity.value('@description', 'VARCHAR(50)')),
			'COD' + CONVERT(VARCHAR(10), (SELECT LC.ID FROM @LotXCycle LC
				WHERE LC.FK_Lot = (SELECT L.ID FROM @Lot L
				WHERE L.Code = lot.value('@code', 'VARCHAR(50)'))
					and LC.FK_Cycle = (SELECT C.ID FROM @Cycle C
				WHERE C.StartDate = (SUBSTRING(period.value('@startDate', 'VARCHAR(10)'), 4, 2) + '/' + 
										SUBSTRING(period.value('@startDate', 'VARCHAR(10)'), 0, 3) + '/' + 
										SUBSTRING(period.value('@startDate', 'VARCHAR(10)'), 7, LEN(period.value('@startDate', 'VARCHAR(10)'))))
					and C.EndDate = (SUBSTRING(period.value('@endDate', 'VARCHAR(10)'), 4, 2) + '/' + 
										SUBSTRING(period.value('@endDate', 'VARCHAR(10)'), 0, 3) + '/' + 
										SUBSTRING(period.value('@endDate', 'VARCHAR(10)'), 7, LEN(period.value('@endDate', 'VARCHAR(10)')))))
					and LC.FK_CropType = (SELECT CT.ID FROM @CropType CT
				WHERE CT.Name = lot.value('@cropType', 'VARCHAR(50)')))) 
				+ CONVERT(VARCHAR(10), (SELECT AT.ID FROM @ActivityType AT
				WHERE AT.Name = activity.value('@description', 'VARCHAR(50)'))) 
				+ CONVERT(VARCHAR(10), 1) 
				+ CONVERT(VARCHAR(10), (SELECT S.ID FROM @Service S
				WHERE S.Name = service.value('@name', 'VARCHAR(50)')))  
				+ '. ' + service.value('@name', 'VARCHAR(50)') + ', cantidad: ' + CONVERT(VARCHAR(50), service.value('@duration', 'VARCHAR(50)')) + ' hora(s).',				
			service.value('@status', 'VARCHAR(50)'),
			(SUBSTRING(service.value('@requestDate', 'VARCHAR(10)'), 4, 2) + '/' + 
				SUBSTRING(service.value('@requestDate', 'VARCHAR(10)'), 0, 3) + '/' + 
				SUBSTRING(service.value('@requestDate', 'VARCHAR(10)'), 7, LEN(service.value('@requestDate', 'VARCHAR(10)')))),			
			(SUBSTRING(service.value('@transactionDate', 'VARCHAR(10)'), 4, 2) + '/' + 
				SUBSTRING(service.value('@transactionDate', 'VARCHAR(10)'), 0, 3) + '/' + 
				SUBSTRING(service.value('@transactionDate', 'VARCHAR(10)'), 7, LEN(service.value('@transactionDate', 'VARCHAR(10)'))))
		FROM @Doc.nodes('/company') AS x1(company)
		cross apply x1.company.nodes('./period') AS x2(period)
		cross apply x2.period.nodes('./farm') AS x3(farm)
		cross apply x3.farm.nodes('./lot') AS x4(lot)
		cross apply x4.lot.nodes('./activity') AS x5(activity)
		cross apply x5.activity.nodes('./service') AS x6(service)
		INSERT INTO @ServiceRequest(ID, FK_Service, AmountHours, Cost)
		SELECT 
			NEXT value FOR APSQ_Count,
			(SELECT S.ID FROM @Service S
				WHERE S.Name = service.value('@name', 'VARCHAR(50)')),
			service.value('@duration', 'VARCHAR(50)'),
			(CONVERT(FLOAT, service.value('@duration', 'VARCHAR(50)')) 
				* CONVERT(FLOAT, service.value('@costPerHour', 'VARCHAR(50)')))
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
				WHERE C.StartDate = (SUBSTRING(period.value('@startDate', 'VARCHAR(10)'), 4, 2) + '/' + 
										SUBSTRING(period.value('@startDate', 'VARCHAR(10)'), 0, 3) + '/' + 
										SUBSTRING(period.value('@startDate', 'VARCHAR(10)'), 7, LEN(period.value('@startDate', 'VARCHAR(10)'))))
					and C.EndDate = (SUBSTRING(period.value('@endDate', 'VARCHAR(10)'), 4, 2) + '/' + 
										SUBSTRING(period.value('@endDate', 'VARCHAR(10)'), 0, 3) + '/' + 
										SUBSTRING(period.value('@endDate', 'VARCHAR(10)'), 7, LEN(period.value('@endDate', 'VARCHAR(10)')))))
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
				WHERE C.StartDate = (SUBSTRING(period.value('@startDate', 'VARCHAR(10)'), 4, 2) + '/' + 
										SUBSTRING(period.value('@startDate', 'VARCHAR(10)'), 0, 3) + '/' + 
										SUBSTRING(period.value('@startDate', 'VARCHAR(10)'), 7, LEN(period.value('@startDate', 'VARCHAR(10)'))))
					and C.EndDate = (SUBSTRING(period.value('@endDate', 'VARCHAR(10)'), 4, 2) + '/' + 
										SUBSTRING(period.value('@endDate', 'VARCHAR(10)'), 0, 3) + '/' + 
										SUBSTRING(period.value('@endDate', 'VARCHAR(10)'), 7, LEN(period.value('@endDate', 'VARCHAR(10)')))))
					and LC.FK_CropType = (SELECT CT.ID FROM @CropType CT
				WHERE CT.Name = lot.value('@cropType', 'VARCHAR(50)')))) 
				+ CONVERT(VARCHAR(10), (SELECT AT.ID FROM @ActivityType AT
				WHERE AT.Name = activity.value('@description', 'VARCHAR(50)'))) 
				+ CONVERT(VARCHAR(10), 2) 
				+ CONVERT(VARCHAR(10), (SELECT M.ID FROM @Machinery M
				WHERE M.Name = machinery.value('@name', 'VARCHAR(50)')))  
				+ '. ' + machinery.value('@name', 'VARCHAR(50)') + ', cantidad: ' + CONVERT(VARCHAR(50), machinery.value('@duration', 'VARCHAR(50)')) + ' hora(s).',
			machinery.value('@status', 'VARCHAR(50)'),
			(SUBSTRING(machinery.value('@requestDate', 'VARCHAR(10)'), 4, 2) + '/' + 
				SUBSTRING(machinery.value('@requestDate', 'VARCHAR(10)'), 0, 3) + '/' + 
				SUBSTRING(machinery.value('@requestDate', 'VARCHAR(10)'), 7, LEN(machinery.value('@requestDate', 'VARCHAR(10)')))),			
			(SUBSTRING(machinery.value('@transactionDate', 'VARCHAR(10)'), 4, 2) + '/' + 
				SUBSTRING(machinery.value('@transactionDate', 'VARCHAR(10)'), 0, 3) + '/' + 
				SUBSTRING(machinery.value('@transactionDate', 'VARCHAR(10)'), 7, LEN(machinery.value('@transactionDate', 'VARCHAR(10)'))))
		FROM @Doc.nodes('/company') AS x1(company)
		cross apply x1.company.nodes('./period') AS x2(period)
		cross apply x2.period.nodes('./farm') AS x3(farm)
		cross apply x3.farm.nodes('./lot') AS x4(lot)
		cross apply x4.lot.nodes('./activity') AS x5(activity)
		cross apply x5.activity.nodes('./machinery') AS x6(machinery)
		INSERT INTO @MachineryRequest(ID, FK_Machinery, AmountHours, Cost)
		SELECT 
			(NEXT value FOR APSQ_Count) + @MaxRequest,
			(SELECT M.ID FROM @Machinery M
				WHERE M.Name = machinery.value('@name', 'VARCHAR(50)')),
			machinery.value('@duration', 'VARCHAR(50)'),
			(CONVERT(FLOAT, machinery.value('@duration', 'VARCHAR(50)')) 
				* CONVERT(FLOAT, machinery.value('@costPerHour', 'VARCHAR(50)')))
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
				WHERE C.StartDate = (SUBSTRING(period.value('@startDate', 'VARCHAR(10)'), 4, 2) + '/' + 
										SUBSTRING(period.value('@startDate', 'VARCHAR(10)'), 0, 3) + '/' + 
										SUBSTRING(period.value('@startDate', 'VARCHAR(10)'), 7, LEN(period.value('@startDate', 'VARCHAR(10)'))))
					and C.EndDate = (SUBSTRING(period.value('@endDate', 'VARCHAR(10)'), 4, 2) + '/' + 
										SUBSTRING(period.value('@endDate', 'VARCHAR(10)'), 0, 3) + '/' + 
										SUBSTRING(period.value('@endDate', 'VARCHAR(10)'), 7, LEN(period.value('@endDate', 'VARCHAR(10)')))))
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
				WHERE C.StartDate = (SUBSTRING(period.value('@startDate', 'VARCHAR(10)'), 4, 2) + '/' + 
										SUBSTRING(period.value('@startDate', 'VARCHAR(10)'), 0, 3) + '/' + 
										SUBSTRING(period.value('@startDate', 'VARCHAR(10)'), 7, LEN(period.value('@startDate', 'VARCHAR(10)'))))
					and C.EndDate = (SUBSTRING(period.value('@endDate', 'VARCHAR(10)'), 4, 2) + '/' + 
										SUBSTRING(period.value('@endDate', 'VARCHAR(10)'), 0, 3) + '/' + 
										SUBSTRING(period.value('@endDate', 'VARCHAR(10)'), 7, LEN(period.value('@endDate', 'VARCHAR(10)')))))
					and LC.FK_CropType = (SELECT CT.ID FROM @CropType CT
				WHERE CT.Name = lot.value('@cropType', 'VARCHAR(50)')))) 
				+ CONVERT(VARCHAR(10), (SELECT AT.ID FROM @ActivityType AT
				WHERE AT.Name = activity.value('@description', 'VARCHAR(50)'))) 
				+ CONVERT(VARCHAR(10), 3) 
				+ CONVERT(VARCHAR(10), (SELECT S.ID FROM @Supply S
				WHERE S.Name = supply.value('@name', 'VARCHAR(50)')))  
				+ '. ' + supply.value('@name', 'VARCHAR(50)') + ', cantidad: ' + CONVERT(VARCHAR(50), supply.value('@units', 'VARCHAR(50)')) + '.',
			supply.value('@status', 'VARCHAR(50)'),
			(SUBSTRING(supply.value('@requestDate', 'VARCHAR(10)'), 4, 2) + '/' + 
				SUBSTRING(supply.value('@requestDate', 'VARCHAR(10)'), 0, 3) + '/' + 
				SUBSTRING(supply.value('@requestDate', 'VARCHAR(10)'), 7, LEN(supply.value('@requestDate', 'VARCHAR(10)')))),			
			(SUBSTRING(supply.value('@transactionDate', 'VARCHAR(10)'), 4, 2) + '/' + 
				SUBSTRING(supply.value('@transactionDate', 'VARCHAR(10)'), 0, 3) + '/' + 
				SUBSTRING(supply.value('@transactionDate', 'VARCHAR(10)'), 7, LEN(supply.value('@transactionDate', 'VARCHAR(10)'))))
		FROM @Doc.nodes('/company') AS x1(company)
		cross apply x1.company.nodes('./period') AS x2(period)
		cross apply x2.period.nodes('./farm') AS x3(farm)
		cross apply x3.farm.nodes('./lot') AS x4(lot)
		cross apply x4.lot.nodes('./activity') AS x5(activity)
		cross apply x5.activity.nodes('./supply') AS x6(supply)
		INSERT INTO @SupplyRequest(ID, FK_Supply, Amount, Cost)
		SELECT 
			(NEXT value FOR APSQ_Count) + @MaxRequest,
			(SELECT S.ID FROM @Supply S
				WHERE S.Name = supply.value('@name', 'VARCHAR(50)')),
			supply.value('@units', 'VARCHAR(50)'),
			(CONVERT(FLOAT, supply.value('@units', 'VARCHAR(50)')) * CONVERT(FLOAT, supply.value('@costPerUnit', 'VARCHAR(50)')))
		FROM @Doc.nodes('/company') AS x1(company)
		cross apply x1.company.nodes('./period') AS x2(period)
		cross apply x2.period.nodes('./farm') AS x3(farm)
		cross apply x3.farm.nodes('./lot') AS x4(lot)
		cross apply x4.lot.nodes('./activity') AS x5(activity)
		cross apply x5.activity.nodes('./supply') AS x6(supply)

		INSERT INTO @Historical(FK_Request, ActivityDate, ActivityDescription)
		SELECT 
			R.ID,
			R.RequestDate,
			'Fecha de registro: ' + CONVERT(VARCHAR(10), R.RequestDate, 103) + '. '  + R.RequestDescription
		FROM @Request R

		INSERT INTO @ServiceMovement(FK_ServiceRequest, Amount, MovementDate, MovementDescription)
		SELECT 
			SR.ID,
			SR.Cost,
			R.TransactionDate,
			'Fecha de proceso: ' + CONVERT(VARCHAR(10), R.TransactionDate, 103) + '. ' + R.RequestDescription + ' Costo: ' +  
			CONVERT(VARCHAR(50), SR.Cost)
		FROM @ServiceRequest SR
		inner join @Request R ON R.ID = SR.ID
		WHERE R.RequestState = 'Aprobada'
		UPDATE @LotXCycle SET ServicesBalance = ServicesBalance + SM.Amount
			FROM @ServiceMovement SM
			inner join @ServiceRequest SR ON SR.ID = SM.FK_ServiceRequest
			inner join @Request R ON R.ID = SR.ID
			inner join @LotXCycle LC ON LC.ID = R.FK_LotXCycle

		INSERT INTO @MachineryMovement(FK_MachineryRequest, Amount, MovementDate, MovementDescription)
		SELECT 
			MR.ID,
			MR.Cost,
			R.TransactionDate,
			'Fecha de proceso: ' + CONVERT(VARCHAR(10), R.TransactionDate, 103) + '. ' + R.RequestDescription + ' Costo: ' +  
			CONVERT(VARCHAR(50), MR.Cost)
		FROM @MachineryRequest MR
		inner join @Request R ON R.ID = MR.ID
		WHERE R.RequestState = 'Aprobada'
		UPDATE @LotXCycle SET MachineryBalance = MachineryBalance + MM.Amount
			FROM @MachineryMovement MM
			inner join @MachineryRequest MR ON MR.ID = MM.FK_MachineryRequest
			inner join @Request R ON R.ID = MR.ID
			inner join @LotXCycle LC ON LC.ID = R.FK_LotXCycle

		INSERT INTO @SupplyMovement(FK_SupplyRequest, Amount, MovementDate, MovementDescription)
		SELECT 
			SR.ID,
			SR.Cost,
			R.TransactionDate,
			'Fecha de proceso: ' + CONVERT(VARCHAR(10), R.TransactionDate, 103) + '. ' + R.RequestDescription + ' Costo: ' +  
			CONVERT(VARCHAR(50), SR.Cost)
		FROM @SupplyRequest SR
		inner join @Request R ON R.ID = SR.ID
		WHERE R.RequestState = 'Aprobada'
		UPDATE @LotXCycle SET SuppliesBalance = SuppliesBalance + SM.Amount
			FROM @SupplyMovement SM
			inner join @SupplyRequest SR ON SR.ID = SM.FK_SupplyRequest
			inner join @Request R ON R.ID = SR.ID
			inner join @LotXCycle LC ON LC.ID = R.FK_LotXCycle

		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		BEGIN TRANSACTION
			INSERT INTO AP_Property(Name)
				SELECT P.Name FROM @Property P
			INSERT INTO AP_CropType(Name)
				SELECT CT.Name FROM @CropType CT	
			INSERT INTO AP_Cycle(StartDate, EndDate)
				SELECT C.StartDate, C.EndDate FROM @Cycle C	
			INSERT INTO AP_ActivityType(Name)
				SELECT AT.Name FROM @ActivityType AT	
			INSERT INTO AP_Attendant(Name)
				SELECT A.Name FROM @Attendant A				
			--------------------------------------------------------------------------------------------------------------------
			INSERT INTO AP_Service(Name, Cost)
				SELECT S.Name, S.Cost FROM @Service S		
			INSERT INTO AP_Machinery(Name, Cost)
				SELECT M.Name, M.Cost FROM @Machinery M		
			INSERT INTO AP_Supply(Name, Cost)
				SELECT S.Name, S.Cost FROM @Supply S		
			--------------------------------------------------------------------------------------------------------------------
			INSERT INTO AP_Lot(FK_Property, Code)
				SELECT L.FK_Property, L.Code FROM @Lot L
			INSERT INTO AP_LotXCycle(FK_Lot, FK_CropType, FK_Cycle, ServicesBalance, SuppliesBalance, MachineryBalance)
				SELECT LC.FK_Lot, LC.FK_CropType, LC.FK_Cycle, LC.ServicesBalance, LC.SuppliesBalance, LC.MachineryBalance FROM @LotXCycle LC
			INSERT INTO AP_Request(FK_LotXCycle, FK_RequestType, FK_Attendant, FK_ActivityType, RequestDescription, RequestState)
				SELECT R.FK_LotXCycle, R.FK_RequestType, R.FK_Attendant, R.FK_ActivityType, R.RequestDescription, R.RequestState FROM @Request R
			INSERT INTO AP_ServiceRequest(ID, FK_Service, AmountHours)
				SELECT SR.ID, SR.FK_Service, SR.AmountHours FROM @ServiceRequest SR
			INSERT INTO AP_MachineryRequest(ID, FK_Machinery, AmountHours)
				SELECT MR.ID, MR.FK_Machinery, MR.AmountHours FROM @MachineryRequest MR
			INSERT INTO AP_SupplyRequest(ID, FK_Supply, Amount)
				SELECT SR.ID, SR.FK_Supply, SR.Amount FROM @SupplyRequest SR
			INSERT INTO AP_Historical(FK_Request, ActivityDate, ActivityDescription)
				SELECT H.FK_Request, H.ActivityDate, H.ActivityDescription FROM @Historical H			
			INSERT INTO AP_ServiceMovement(FK_ServiceRequest, Amount, MovementDate, MovementDescription)
				SELECT SM.FK_ServiceRequest, SM.Amount, SM.MovementDate, SM.MovementDescription FROM @ServiceMovement SM
			INSERT INTO AP_MachineryMovement(FK_MachineryRequest, Amount, MovementDate, MovementDescription)
				SELECT MM.FK_MachineryRequest, MM.Amount, MM.MovementDate, MM.MovementDescription FROM @MachineryMovement MM
			INSERT INTO AP_SupplyMovement(FK_SupplyRequest, Amount, MovementDate, MovementDescription)
				SELECT SM.FK_SupplyRequest, SM.Amount, SM.MovementDate, SM.MovementDescription FROM @SupplyMovement SM
		COMMIT
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT = 1
			SELECT ERROR_MESSAGE() 
			ROLLBACK
		RETURN @@ERROR * - 1
	END CATCH
END