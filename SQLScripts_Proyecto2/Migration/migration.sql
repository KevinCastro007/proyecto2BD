SP_CONFIGURE 'show advanced options', 1
RECONFIGURE WITH OVERRIDE
GO
SP_CONFIGURE 'Ad Hoc Distributed Queries', 1
RECONFIGURE WITH OVERRIDE
GO

declare @doc xml
select    @doc = BulkColumn
from    openrowset(
            bulk 'C:\prueba.xml', SINGLE_CLOB
        ) as xmlData
select  cliente.value('@id', 'int') AS IdCliente,
        pedido.value('@id', 'int') AS IdPedido,
        producto.value('@cod', 'varchar(15)') AS CodigoProducto,
        producto.value('@cant', 'int') AS Cantidad,
        producto.value('@imp', 'money') AS Importe 
from    @doc.nodes('/cliente') as x1(cliente)
cross apply x1.cliente.nodes('./pedido') as x2(pedido)
cross apply x2.pedido.nodes('./producto') as x3(producto)