
//Exportación del módulo correspondiente para las Solicitudes.
//Parámetros desde el Servidor: app, mssql y configuration.
module.exports = function (app, mssql, configuration) {
	//Suministros (server get)
	app.put('/request/:lotXCycleID', function (request, response) {
		//Parseo de datos del Request.
		var lotXCycleID = request.params.lotXCycleID;
		var activityID = request.body.activity.ID;
		var attendantID = request.body.attendant.ID;
		var requestType = request.body.type;
		var requestItem = request.body.item.name;
		var amount = request.body.amount;
		var state = request.body.state;
		//Conexión a la BD según: configuration.
		var connection = new mssql.Connection(configuration, function (err) {
			//Request de la Conexión.		
		    var request = new mssql.Request(connection);
		    request.input('FK_LotXCycle', mssql.Int, lotXCycleID);
		    request.input('FK_ActivityType', mssql.Int, activityID);
		    request.input('FK_Attendant', mssql.Int, attendantID);
		    request.input('RequestType', mssql.VarChar(50), requestType);
		    request.input('Request', mssql.VarChar(50), requestItem);
		    request.input('Amount', mssql.Float, amount);
		    request.input('State', mssql.VarChar(50), state);
		    //Ejecución del Store Procedure (SP).
		    request.execute('dbo.APSP_InsertRequest', function (err, recordsets, returnValue) {      	
		        console.log("Successful execution (SP: INSERT REQUEST)");
				var respuesta = {
					resultado: returnValue
				};		
				response.json(respuesta);
		    });   
		});
	});
};