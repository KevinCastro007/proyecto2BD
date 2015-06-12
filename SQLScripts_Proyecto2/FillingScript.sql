/* - Filling data script the BD Agricultural Property - */
GO
USE AgriculturalProperty

/* - Basic Data -*/
/* - Insertion in the table Crop Type: AP_CropType - */
INSERT INTO dbo.AP_CropType(Name) VALUES('Maiz')
INSERT INTO dbo.AP_CropType(Name) VALUES('Trigo')
INSERT INTO dbo.AP_CropType(Name) VALUES('Arroz')
INSERT INTO dbo.AP_CropType(Name) VALUES('Soja')
INSERT INTO dbo.AP_CropType(Name) VALUES('Palma')
INSERT INTO dbo.AP_CropType(Name) VALUES('Frijol')
INSERT INTO dbo.AP_CropType(Name) VALUES('Tomate')
INSERT INTO dbo.AP_CropType(Name) VALUES('Chile')

/* - Insertion in the table Property: AP_Property - */
INSERT INTO dbo.AP_Property(Name) VALUES('Hacienda Tio Pelon')
INSERT INTO dbo.AP_Property(Name) VALUES('Pindeco S.A')
INSERT INTO dbo.AP_Property(Name) VALUES('Tierra del Viejo')

/* - Insertion in the table Lot: AP_Lot - */
INSERT INTO dbo.AP_Lot(FK_Property, Code) VALUES(1, 'HTP1')
INSERT INTO dbo.AP_Lot(FK_Property, Code) VALUES(1, 'HTP2')
INSERT INTO dbo.AP_Lot(FK_Property, Code) VALUES(2, 'PI00')
INSERT INTO dbo.AP_Lot(FK_Property, Code) VALUES(2, 'PI01')
INSERT INTO dbo.AP_Lot(FK_Property, Code) VALUES(3, 'TV00')

/* - Insertion in the table Attendant: AP_Attendant - */
INSERT INTO dbo.AP_Attendant(Name) VALUES('Josefina Porras')
INSERT INTO dbo.AP_Attendant(Name) VALUES('Federico Diaz')
INSERT INTO dbo.AP_Attendant(Name) VALUES('Maria Petunia')
INSERT INTO dbo.AP_Attendant(Name) VALUES('Hector Castro')
INSERT INTO dbo.AP_Attendant(Name) VALUES('Juana de Arco')

/* - Insertion in the table Cycle: AP_Cycle - */
INSERT INTO dbo.AP_Cycle(StartDate, EndDate) VALUES('2015-01-05', '2015-05-07')
INSERT INTO dbo.AP_Cycle(StartDate, EndDate) VALUES('2015-06-11', '2015-11-18')
INSERT INTO dbo.AP_Cycle(StartDate, EndDate) VALUES('2016-01-12', '2016-05-29')

/* - Insertion in the table Lot X Cycle: AP_LotXCycle - */
INSERT INTO dbo.AP_LotXCycle(FK_Lot, FK_CropType, FK_Cycle, ServicesBalance, SuppliesBalance, MachineryBalance) VALUES(3, 1, 1, 0, 0, 0)
INSERT INTO dbo.AP_LotXCycle(FK_Lot, FK_CropType, FK_Cycle, ServicesBalance, SuppliesBalance, MachineryBalance) VALUES(3, 3, 2, 0, 0, 0)
INSERT INTO dbo.AP_LotXCycle(FK_Lot, FK_CropType, FK_Cycle, ServicesBalance, SuppliesBalance, MachineryBalance) VALUES(5, 6, 3, 0, 0, 0)

/* - Insertion in the table Activity Type: AP_ActivityType - */
INSERT INTO dbo.AP_ActivityType(Name) VALUES('Siembra')
INSERT INTO dbo.AP_ActivityType(Name) VALUES('Fumigacion')
INSERT INTO dbo.AP_ActivityType(Name) VALUES('Riego')
INSERT INTO dbo.AP_ActivityType(Name) VALUES('Cosechar')
INSERT INTO dbo.AP_ActivityType(Name) VALUES('Deshiervar')
INSERT INTO dbo.AP_ActivityType(Name) VALUES('Podar')
INSERT INTO dbo.AP_ActivityType(Name) VALUES('Arado')
INSERT INTO dbo.AP_ActivityType(Name) VALUES('Inspeccionar')

/* - Insertion in the table Department: AP_Department - */
INSERT INTO dbo.AP_Department(Name) VALUES('Prestacion de Servicios')
INSERT INTO dbo.AP_Department(Name) VALUES('Almacen de Maquinaria')
INSERT INTO dbo.AP_Department(Name) VALUES('Bodegon de Suministros')

/* - Insertion in the table Manager: AP_Manager - */
INSERT INTO dbo.AP_Manager(FK_Department, Name) VALUES(1, 'Manuel Rosales')
INSERT INTO dbo.AP_Manager(FK_Department, Name) VALUES(2, 'Bonita Manir')
INSERT INTO dbo.AP_Manager(FK_Department, Name) VALUES(3, 'Gonzalo Porras')

/* - Insertion in the table Request Type: AP_RequestType - */
INSERT INTO dbo.AP_RequestType(FK_Manager, Name) VALUES(1, 'Servicio')
INSERT INTO dbo.AP_RequestType(FK_Manager, Name) VALUES(2, 'Maquinaria')
INSERT INTO dbo.AP_RequestType(FK_Manager, Name) VALUES(3, 'Suministro')

/* - Insertion in the table Service: AP_Service - */
INSERT INTO dbo.AP_Service(Name, Cost) VALUES('Trabajador', 1500)
INSERT INTO dbo.AP_Service(Name, Cost) VALUES('Ing Agronomo', 8500)
INSERT INTO dbo.AP_Service(Name, Cost) VALUES('Ing Agricola', 6500)
INSERT INTO dbo.AP_Service(Name, Cost) VALUES('Ing Ambiental', 7500)
INSERT INTO dbo.AP_Service(Name, Cost) VALUES('Biotecnologo', 8500)
INSERT INTO dbo.AP_Service(Name, Cost) VALUES('Ing Agronegocios', 3500)
INSERT INTO dbo.AP_Service(Name, Cost) VALUES('Ing Forestal', 5400)
INSERT INTO dbo.AP_Service(Name, Cost) VALUES('Ing Civil', 7500)
INSERT INTO dbo.AP_Service(Name, Cost) VALUES('Ing Diseño', 50000)
INSERT INTO dbo.AP_Service(Name, Cost) VALUES('Mecanico', 1500)
INSERT INTO dbo.AP_Service(Name, Cost) VALUES('Administrador de Negocios', 4500)
INSERT INTO dbo.AP_Service(Name, Cost) VALUES('Mantenimiento', 3600)
INSERT INTO dbo.AP_Service(Name, Cost) VALUES('Limpieza', 1500)


/* - Insertion in the table Supply: AP_Supply - */
INSERT INTO dbo.AP_Supply(Name, Cost) VALUES('Semillas de Maiz', 250, 1000)
INSERT INTO dbo.AP_Supply(Name, Cost) VALUES('Semillas de Trigo', 250, 1000)
INSERT INTO dbo.AP_Supply(Name, Cost) VALUES('Semillas de Soja', 250)
INSERT INTO dbo.AP_Supply(Name, Cost) VALUES('Semillas de Arroz', 250)
INSERT INTO dbo.AP_Supply(Name, Cost) VALUES('Semillas de Palma', 250)
INSERT INTO dbo.AP_Supply(Name, Cost) VALUES('Semillas de Frijol', 250)
INSERT INTO dbo.AP_Supply(Name, Cost) VALUES('Semillas de Tomate', 250)
INSERT INTO dbo.AP_Supply(Name, Cost) VALUES('Semillas de Chile', 250)
INSERT INTO dbo.AP_Supply(Name, Cost) VALUES('Fertilizante', 10000)
INSERT INTO dbo.AP_Supply(Name, Cost) VALUES('Abono', 7500)
INSERT INTO dbo.AP_Supply(Name, Cost) VALUES('Suplemento', 8500)
INSERT INTO dbo.AP_Supply(Name, Cost) VALUES('Fungicida', 9000)
INSERT INTO dbo.AP_Supply(Name, Cost) VALUES('Herbicida', 8500)
INSERT INTO dbo.AP_Supply(Name, Cost) VALUES('Pala', 3000)
INSERT INTO dbo.AP_Supply(Name, Cost) VALUES('Carretillo', 4500)
INSERT INTO dbo.AP_Supply(Name, Cost) VALUES('Palin', 3500)
INSERT INTO dbo.AP_Supply(Name, Cost) VALUES('Tornillos', 20)
INSERT INTO dbo.AP_Supply(Name, Cost) VALUES('Aceite', 1500)
INSERT INTO dbo.AP_Supply(Name, Cost) VALUES('Rastrillo', 4000)
INSERT INTO dbo.AP_Supply(Name, Cost) VALUES('Cedazo', 6500)
INSERT INTO dbo.AP_Supply(Name, Cost) VALUES('Plastico', 5500)
INSERT INTO dbo.AP_Supply(Name, Cost) VALUES('Bolsa jardinera', 100)
INSERT INTO dbo.AP_Supply(Name, Cost) VALUES('Frascos', 450)
INSERT INTO dbo.AP_Supply(Name, Cost) VALUES('Madera', 4000)
INSERT INTO dbo.AP_Supply(Name, Cost) VALUES('Tubos', 5000)
INSERT INTO dbo.AP_Supply(Name, Cost) VALUES('Manguera', 2500)
INSERT INTO dbo.AP_Supply(Name, Cost) VALUES('Clavos', 10)
INSERT INTO dbo.AP_Supply(Name, Cost) VALUES('Destornillador', 1500)

/* - Insertion in the table Machinery: AP_Machinery - */
INSERT INTO dbo.AP_Machinery(Name, Cost) VALUES('Chapulin', 1100)
INSERT INTO dbo.AP_Machinery(Name, Cost) VALUES('Arado', 1150)
INSERT INTO dbo.AP_Machinery(Name, Cost) VALUES('Cortadora', 1000)
INSERT INTO dbo.AP_Machinery(Name, Cost) VALUES('Cosechadora', 4000)
INSERT INTO dbo.AP_Machinery(Name, Cost) VALUES('Fumigadora', 2300)
INSERT INTO dbo.AP_Machinery(Name, Cost) VALUES('Tractor', 2250)
INSERT INTO dbo.AP_Machinery(Name, Cost) VALUES('Camion', 1500)
INSERT INTO dbo.AP_Machinery(Name, Cost) VALUES('Rociador', 1250)
INSERT INTO dbo.AP_Machinery(Name, Cost) VALUES('Bagoneta', 2000)
INSERT INTO dbo.AP_Machinery(Name, Cost) VALUES('Bulldozer', 3500)
INSERT INTO dbo.AP_Machinery(Name, Cost) VALUES('Podadora', 1250)
INSERT INTO dbo.AP_Machinery(Name, Cost) VALUES('Sierra', 750)
INSERT INTO dbo.AP_Machinery(Name, Cost) VALUES('Recolector', 2000)
INSERT INTO dbo.AP_Machinery(Name, Cost) VALUES('Bomba de agua', 1750)
INSERT INTO dbo.AP_Machinery(Name, Cost) VALUES('Cargador', 1500)