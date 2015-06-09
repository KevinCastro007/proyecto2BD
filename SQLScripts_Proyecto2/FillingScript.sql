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
INSERT INTO dbo.AP_Service(Name, Cost) VALUES('Trabajador', 15000)
INSERT INTO dbo.AP_Service(Name, Cost) VALUES('Ing Agronomo', 85000)
INSERT INTO dbo.AP_Service(Name, Cost) VALUES('Ing Agricola', 65000)
INSERT INTO dbo.AP_Service(Name, Cost) VALUES('Ing Ambiental', 75000)
INSERT INTO dbo.AP_Service(Name, Cost) VALUES('Biotecnologo', 85000)
INSERT INTO dbo.AP_Service(Name, Cost) VALUES('Ing Agronegocios', 35000)
INSERT INTO dbo.AP_Service(Name, Cost) VALUES('Ing Forestal', 54000)
INSERT INTO dbo.AP_Service(Name, Cost) VALUES('Ing Civil', 75000)
INSERT INTO dbo.AP_Service(Name, Cost) VALUES('Ing Diseño', 50000)
INSERT INTO dbo.AP_Service(Name, Cost) VALUES('Mecanico', 15000)
INSERT INTO dbo.AP_Service(Name, Cost) VALUES('Administrador de Negocios', 45000)
INSERT INTO dbo.AP_Service(Name, Cost) VALUES('Mantenimiento', 36000)
INSERT INTO dbo.AP_Service(Name, Cost) VALUES('Limpieza', 25000)


/* - Insertion in the table Supply: AP_Supply - */
INSERT INTO dbo.AP_Supply(Name, Cost, Quantity) VALUES('Semillas', 250, 1000)
INSERT INTO dbo.AP_Supply(Name, Cost, Quantity) VALUES('Fertilizante', 10000, 1000)
INSERT INTO dbo.AP_Supply(Name, Cost, Quantity) VALUES('Abono', 7500, 1000)
INSERT INTO dbo.AP_Supply(Name, Cost, Quantity) VALUES('Suplementos', 8500, 1000)
INSERT INTO dbo.AP_Supply(Name, Cost, Quantity) VALUES('Fungicidas', 9000, 1000)
INSERT INTO dbo.AP_Supply(Name, Cost, Quantity) VALUES('Herbicidas', 8500, 1000)
INSERT INTO dbo.AP_Supply(Name, Cost, Quantity) VALUES('Palas', 3000, 1000)
INSERT INTO dbo.AP_Supply(Name, Cost, Quantity) VALUES('Carretillos', 4500, 1000)
INSERT INTO dbo.AP_Supply(Name, Cost, Quantity) VALUES('Palines', 3500, 1000)
INSERT INTO dbo.AP_Supply(Name, Cost, Quantity) VALUES('Tornillos', 20, 1000)
INSERT INTO dbo.AP_Supply(Name, Cost, Quantity) VALUES('Aceite', 1500, 1000)
INSERT INTO dbo.AP_Supply(Name, Cost, Quantity) VALUES('Rastrillos', 4000, 1000)
INSERT INTO dbo.AP_Supply(Name, Cost, Quantity) VALUES('Cedazo', 6500, 1000)
INSERT INTO dbo.AP_Supply(Name, Cost, Quantity) VALUES('Plastico', 5500, 1000)
INSERT INTO dbo.AP_Supply(Name, Cost, Quantity) VALUES('Bolsas', 100, 1000)
INSERT INTO dbo.AP_Supply(Name, Cost, Quantity) VALUES('Frascos', 450, 1000)
INSERT INTO dbo.AP_Supply(Name, Cost, Quantity) VALUES('Madera', 4000, 1000)
INSERT INTO dbo.AP_Supply(Name, Cost, Quantity) VALUES('Tubos', 5000, 1000)
INSERT INTO dbo.AP_Supply(Name, Cost, Quantity) VALUES('Manguera', 2500, 1000)
INSERT INTO dbo.AP_Supply(Name, Cost, Quantity) VALUES('Clavos', 10, 1000)
INSERT INTO dbo.AP_Supply(Name, Cost, Quantity) VALUES('Destornillador', 1500, 1000)

/* - Insertion in the table Machinery: AP_Machinery - */
INSERT INTO dbo.AP_Machinery(Name, Cost) VALUES('Chapulin', 110000)
INSERT INTO dbo.AP_Machinery(Name, Cost) VALUES('Arado', 115000)
INSERT INTO dbo.AP_Machinery(Name, Cost) VALUES('Cortadora', 100000)
INSERT INTO dbo.AP_Machinery(Name, Cost) VALUES('Cosechadora', 400000)
INSERT INTO dbo.AP_Machinery(Name, Cost) VALUES('Fumigadora', 230000)
INSERT INTO dbo.AP_Machinery(Name, Cost) VALUES('Tractor', 225000)
INSERT INTO dbo.AP_Machinery(Name, Cost) VALUES('Camiones', 150000)
INSERT INTO dbo.AP_Machinery(Name, Cost) VALUES('Rociadores', 125000)
INSERT INTO dbo.AP_Machinery(Name, Cost) VALUES('Bagoneta', 200000)
INSERT INTO dbo.AP_Machinery(Name, Cost) VALUES('Bulldozer', 350000)
INSERT INTO dbo.AP_Machinery(Name, Cost) VALUES('Podadoras', 125000)
INSERT INTO dbo.AP_Machinery(Name, Cost) VALUES('Sierras', 75000)
INSERT INTO dbo.AP_Machinery(Name, Cost) VALUES('Recolectores', 200000)
INSERT INTO dbo.AP_Machinery(Name, Cost) VALUES('Bombas de agua', 175000)
INSERT INTO dbo.AP_Machinery(Name, Cost) VALUES('Cargadores', 150000)