-- Trigger para insertar la información de la creación de ciertas instancias.
USE RegistroNotas

-- Actualizar PostBy, PostDate y PostIn: RN_Miembro
GO
CREATE TRIGGER RNT_Miembro
ON dbo.RN_Miembro
AFTER INSERT 
AS
BEGIN
	UPDATE dbo.RN_Miembro SET PostBy = CURRENT_USER,
							  PostDate = GETDATE(),
							  PostIn = CONVERT(VARCHAR(50), CONNECTIONPROPERTY('client_net_address'))
		FROM INSERTED I
END

-- Actualizar PostBy, PostDate y PostIn: RN_EvaluacionMiembro
GO
CREATE TRIGGER RNT_EvaluacionMiembro
ON dbo.RN_EvaluacionMiembro
AFTER INSERT 
AS
BEGIN 
	UPDATE dbo.RN_EvaluacionMiembro SET PostBy = CURRENT_USER,
										PostDate = GETDATE(),
										PostIn = CONVERT(VARCHAR(50), CONNECTIONPROPERTY('client_net_address'))
		FROM INSERTED I
END