/* - Filling data script the BD Agricultural Property - */
GO
USE AgriculturalProperty

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