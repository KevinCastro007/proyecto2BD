SP_CONFIGURE 'show advanced options', 1
RECONFIGURE WITH OVERRIDE
GO
SP_CONFIGURE 'Ad Hoc Distributed Queries', 1
RECONFIGURE WITH OVERRIDE
GO

declare @doc xml
select    @doc = BulkColumn
from    openrowset(
            bulk 'C:\archivo.xml', SINGLE_CLOB
        ) as xmlData
		
select  farm.value('@name', 'varchar(50)') AS Finca,
		lot.value('@code', 'varchar(50)') AS Lote,
		period.value('@startDate', 'varchar(10)') AS FechaInicio,
		period.value('@endDate', 'varchar(10)') AS FechaFin,
		lot.value('@cropType', 'varchar(50)') AS Cultivo,
		activity.value('@description', 'varchar(50)') AS Descripcion,
		machinery.value('@name', 'varchar(50)') AS MachineryName,
		machinery.value('@requestFrom', 'varchar(50)') AS RequestFrom,
		machinery.value('@requestDate', 'varchar(50)') AS RequestDate,
		machinery.value('@transactionDate', 'varchar(50)') AS TransactionDate,
		machinery.value('@duration', 'varchar(50)') AS HoursAmount,
		machinery.value('@costPerHour', 'varchar(50)') AS HourCost,
		machinery.value('@status', 'varchar(50)') AS Status
from    @doc.nodes('/company') as x1(company)
cross apply x1.company.nodes('./period') as x2(period)
cross apply x2.period.nodes('./farm') as x3(farm)
cross apply x3.farm.nodes('./lot') as x4(lot)
cross apply x4.lot.nodes('./activity') as x5(activity)
cross apply x5.activity.nodes('./machinery') as x6(machinery)

select  farm.value('@name', 'varchar(50)') AS Finca,
		lot.value('@code', 'varchar(50)') AS Lote,
		period.value('@startDate', 'varchar(10)') AS FechaInicio,
		period.value('@endDate', 'varchar(10)') AS FechaFin,
		lot.value('@cropType', 'varchar(50)') AS Cultivo,
		activity.value('@description', 'varchar(50)') AS Descripcion,
		supply.value('@name', 'varchar(50)') AS SupplyName,
		supply.value('@requestFrom', 'varchar(50)') AS RequestFrom,
		supply.value('@requestDate', 'varchar(50)') AS RequestDate,
		supply.value('@transactionDate', 'varchar(50)') AS TransactionDate,
		supply.value('@units', 'varchar(50)') AS Amount,
		supply.value('@costPerUnit', 'varchar(50)') AS UnitCost,
		supply.value('@status', 'varchar(50)') AS Status
		from    @doc.nodes('/company') as x1(company)
cross apply x1.company.nodes('./period') as x2(period)
cross apply x2.period.nodes('./farm') as x3(farm)
cross apply x3.farm.nodes('./lot') as x4(lot)
cross apply x4.lot.nodes('./activity') as x5(activity)
cross apply x5.activity.nodes('./supply') as x6(supply)

select  farm.value('@name', 'varchar(50)') AS Finca,
		lot.value('@code', 'varchar(50)') AS Lote,
		period.value('@startDate', 'varchar(10)') AS FechaInicio,
		period.value('@endDate', 'varchar(10)') AS FechaFin,
		lot.value('@cropType', 'varchar(50)') AS Cultivo,
		activity.value('@description', 'varchar(50)') AS Descripcion,
		service.value('@name', 'varchar(50)') AS ServiceName,
		service.value('@requestFrom', 'varchar(50)') AS RequestFrom,
		service.value('@requestDate', 'varchar(50)') AS RequestDate,
		service.value('@transactionDate', 'varchar(50)') AS TransactionDate,
		service.value('@duration', 'varchar(50)') AS HoursAmount,
		service.value('@costPerHour', 'varchar(50)') AS HourCost,
		service.value('@status', 'varchar(50)') AS Status
from    @doc.nodes('/company') as x1(company)
cross apply x1.company.nodes('./period') as x2(period)
cross apply x2.period.nodes('./farm') as x3(farm)
cross apply x3.farm.nodes('./lot') as x4(lot)
cross apply x4.lot.nodes('./activity') as x5(activity)
cross apply x5.activity.nodes('./service') as x6(service)