/* Data base: Agricultural Property */

CREATE DATABASE AgriculturalProperty

GO
USE AgriculturalProperty

GO
CREATE TABLE AP_Property
(
	ID INT IDENTITY(1, 1) PRIMARY KEY not null,
	Name VARCHAR(50) not null
)

GO
CREATE TABLE AP_Cycle
(
	ID INT IDENTITY(1, 1) PRIMARY KEY not null,	
	StartDate DATE not null,
	EndDate DATE not null
)

GO
CREATE TABLE AP_CropType
(
	ID INT IDENTITY(1, 1) PRIMARY KEY not null,	
	Name VARCHAR(50) not null		
)

GO
CREATE TABLE AP_ActivityType
(
	ID INT IDENTITY(1, 1) PRIMARY KEY not null,	
	Name VARCHAR(50) not null		
)

GO
CREATE TABLE AP_Department
(
	ID INT IDENTITY(1, 1) PRIMARY KEY not null,	
	Name VARCHAR(50) not null		
)

GO
CREATE TABLE AP_Attendant
(
	ID INT IDENTITY(1, 1) PRIMARY KEY not null,	
	Name VARCHAR(50) not null		
)

GO
CREATE TABLE AP_Lot
(
	ID INT IDENTITY(1, 1) PRIMARY KEY not null,	
	FK_Property INT not null,
	CONSTRAINT FK_Property FOREIGN KEY(FK_Property) REFERENCES AP_Property(ID),	
	Code VARCHAR(50) not null		
)

GO
CREATE TABLE AP_Manager
(
	ID INT IDENTITY(1, 1) PRIMARY KEY not null,	
	FK_Department INT not null,
	CONSTRAINT FK_Department FOREIGN KEY(FK_Department) REFERENCES AP_Department(ID),	
	Name VARCHAR(50) not null
)

GO
CREATE TABLE AP_RequestType
(
	ID INT IDENTITY(1, 1) PRIMARY KEY not null,	
	FK_Manager INT not null,
	CONSTRAINT FK_Manager FOREIGN KEY(FK_Manager) REFERENCES AP_Manager(ID),	
	Name VARCHAR(50) not null
)

GO
CREATE TABLE AP_LotXCycle
(
	ID INT IDENTITY(1, 1) PRIMARY KEY not null,	
	FK_Lot INT not null,
	CONSTRAINT FK_Lot FOREIGN KEY(FK_Lot) REFERENCES AP_Lot(ID),
	FK_CropType INT not null,
	CONSTRAINT FK_CropType FOREIGN KEY(FK_CropType) REFERENCES AP_CropType(ID),	
	FK_Cycle INT not null,
	CONSTRAINT FK_Cycle FOREIGN KEY(FK_Cycle) REFERENCES AP_Cycle(ID),	
	FK_Attendant INT not null,
	CONSTRAINT FK_Attendant FOREIGN KEY(FK_Attendant) REFERENCES AP_Attendant(ID),	
	ServicesBalance FLOAT not null,
	SuppliesBalance FLOAT not null,
	MachineryBalance FLOAT not null
)

GO
CREATE TABLE AP_Request
(
	ID INT IDENTITY(1, 1) PRIMARY KEY not null,	
	FK_RequestManager INT not null,
	CONSTRAINT FK_RequestManager FOREIGN KEY(FK_RequestManager) REFERENCES AP_Manager(ID),		
	FK_LotXCycle INT not null,
	CONSTRAINT FK_LotXCycle FOREIGN KEY(FK_LotXCycle) REFERENCES AP_LotXCycle(ID),
	FK_RequestType INT not null,
	CONSTRAINT FK_RequestType FOREIGN KEY(FK_RequestType) REFERENCES AP_RequestType(ID),	
	RequestDescription VARCHAR(150) not null,
	RequestState VARCHAR(50) not null
)

GO
CREATE TABLE AP_HistoricalActivity
(
	ID INT IDENTITY(1, 1) PRIMARY KEY not null,	
	FK_ActivityType INT not null,
	CONSTRAINT FK_ActivityType FOREIGN KEY(FK_ActivityType) REFERENCES AP_ActivityType(ID),	
	FK_Request INT not null,
	CONSTRAINT FK_Request FOREIGN KEY(FK_Request) REFERENCES AP_Request(ID),	
	ActivityDate DATETIME not null,
	ActivityDescription VARCHAR(150) not null
)

GO
CREATE TABLE AP_Service
(
	ID INT IDENTITY(1, 1) PRIMARY KEY not null,
	Name VARCHAR(50) not null,
	Cost FLOAT not null
)

GO
CREATE TABLE AP_Supply
(
	ID INT IDENTITY(1, 1) PRIMARY KEY not null,
	Name VARCHAR(50) not null,
	Cost FLOAT not null,
	Quantity FLOAT not null
)

GO
CREATE TABLE AP_Machinery
(
	ID INT IDENTITY(1, 1) PRIMARY KEY not null,
	Name VARCHAR(50) not null,
	Cost FLOAT not null
)

GO
CREATE TABLE AP_ServiceRequest
(
	ID INT PRIMARY KEY not null,
	FK_Service INT not null,
	CONSTRAINT FK_Service FOREIGN KEY(FK_Service) REFERENCES AP_Service(ID),
	AmountHours FLOAT not null
)

GO
CREATE TABLE AP_SupplyRequest
(
	ID INT PRIMARY KEY not null,
	FK_Supply INT not null,
	CONSTRAINT FK_Supply FOREIGN KEY(FK_Supply) REFERENCES AP_Supply(ID),
	Amount FLOAT not null
)

GO
CREATE TABLE AP_MachineryRequest
(
	ID INT PRIMARY KEY not null,
	FK_Machinery INT not null,
	CONSTRAINT FK_Machinery FOREIGN KEY(FK_Machinery) REFERENCES AP_Machinery(ID),
	AmountHours FLOAT not null
)

GO
CREATE TABLE AP_ServiceMovement
(
	ID INT IDENTITY(1, 1) PRIMARY KEY not null,	
	FK_ServiceRequest INT not null,
	CONSTRAINT FK_ServiceRequest FOREIGN KEY(FK_ServiceRequest) REFERENCES AP_ServiceRequest(ID),	
	Amount FLOAT not null,
	MovementDate DATETIME not null,
	MovementDescription VARCHAR(150) not null
)

GO
CREATE TABLE AP_SupplyMovement
(
	ID INT IDENTITY(1, 1) PRIMARY KEY not null,	
	FK_SupplyRequest INT not null,
	CONSTRAINT FK_SupplyRequest FOREIGN KEY(FK_SupplyRequest) REFERENCES AP_SupplyRequest(ID),	
	Amount FLOAT not null,
	MovementDate DATETIME not null,
	MovementDescription VARCHAR(150) not null
)
GO
CREATE TABLE AP_MachineryMovement
(
	ID INT IDENTITY(1, 1) PRIMARY KEY not null,	
	FK_MachineryRequest INT not null,
	CONSTRAINT FK_MachineryRequest FOREIGN KEY(FK_MachineryRequest) REFERENCES AP_MachineryRequest(ID),	
	Amount FLOAT not null,
	MovementDate DATETIME not null,
	MovementDescription VARCHAR(150) not null
)
