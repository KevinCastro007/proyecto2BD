//Variables en el contexto.
var history;
var historical;
//Función que retorna un JSON con la estructura de un Historial 
//con respecto a la BD y la Vista correspondiente.
function historyStructure() {
	var history = 
	{		
		date: "",
		activity: "",
		attendant: "",
		requestType: "",
		//requestItem: "",
		//amount: 0,
		description: "",
		state: ""
	};
	return history;
}

//Exportación del módulo correspondiente para los Historiales.
//Parámetros desde el Servidor: app, mssql y configuration.
module.exports = function (app, mssql, configuration) {
	//Historiales (server get)
	app.post('/historical/:lotXCycleID', function (request, response) {	
		var lotXCycleID = request.params.lotXCycleID;
		var start = typeof(request.body.start) == 'undefined' ? null : (request.body.start.date == "" ? null : request.body.start.date);
		var end = typeof(request.body.end) == 'undefined' ? null : (request.body.end.date == "" ? null : request.body.end.date );
		var requestType = typeof(request.body.requestType) == 'undefined' ? null : (request.body.requestType == "" ? null : request.body.requestType);
		var activity = typeof(request.body.activity) == 'undefined' ? null : (request.body.activity.name == "" ? null : request.body.activity.name);
		var attendant = typeof(request.body.attendant) == 'undefined' ? null : (request.body.attendant.name == "" ? null : request.body.attendant.name);
		//Conexión a la BD según: configuration.
		var connection = new mssql.Connection(configuration, function (err) {
			//Request de la Conexión.
		    var request = new mssql.Request(connection);
		    request.input('FK_LotXCycle', mssql.Int, lotXCycleID);
		    request.input('Start', mssql.Date, start);
		    request.input('End', mssql.Date, end);
		    request.input('Attendant', mssql.VarChar(50), attendant);
		    request.input('ActivityType', mssql.VarChar(50), activity);
		    request.input('RequestType', mssql.VarChar(50), requestType);
		    //Ejecución del Store Procedure (SP).
		    request.execute('dbo.APSP_Historical', function (err, recordsets, returnValue) {
		        //Inicialización del Array Respuesta.
		        if (recordsets.length > 1) {
		        	console.log("Successful execution (SP: HISTORICAL)");
			        historical = new Array(recordsets[0].length);
			        for (var i = 0; i < recordsets[0].length; i++) {
			        	//JSON : Historial
			        	history = new historyStructure();
			        	history.date = recordsets[0][i].ActivityDate;
			        	history.activity = recordsets[0][i].ActivityName;
			        	history.attendant = recordsets[0][i].Attendant;
			        	history.requestType = recordsets[0][i].RequestType;
			        	history.description = recordsets[0][i].RequestDescription;
			        	history.state = recordsets[0][i].RequestState;
			        	//Adjuntar el JSON al Array Respuesta.
			        	historical[i] = history;
			        };	
			        var result = [returnValue, historical]
					//Respuesta (Array : JSON)
					response.json(result);		        	
		        }
		        else {
		        	response.json(undefined);		
		        }
		    }); 
		});		
	});
	app.get('/lastRequestRecord/:lotXCycleID', function (request, response) {	
		var lotXCycleID = request.params.lotXCycleID;
		//Conexión a la BD según: configuration.
		var connection = new mssql.Connection(configuration, function (err) {
			//Request de la Conexión.
		    var request = new mssql.Request(connection);
		    request.input('FK_LotXCycle', mssql.Int, lotXCycleID);
		    //Ejecución del Store Procedure (SP).
		    request.execute('dbo.APSP_LastRequest', function (err, recordsets, returnValue) {
		        //Inicialización del Array Respuesta.
		        if (recordsets[0] != []) {
		        	console.log("Successful execution (SP: HISTORICAL)");
			        historical = new Array(recordsets[0].length);
			        for (var i = 0; i < recordsets[0].length; i++) {
			        	//JSON : Historial
			        	history = new historyStructure();
			        	history.date = recordsets[0][i].ActivityDate;
			        	history.activity = recordsets[0][i].ActivityName;
			        	history.attendant = recordsets[0][i].Attendant;
			        	history.requestType = recordsets[0][i].RequestType;
			        	history.description = recordsets[0][i].RequestDescription;
			        	history.state = recordsets[0][i].RequestState;
			        	//Adjuntar el JSON al Array Respuesta.
			        	historical[i] = history;
			        };	
			        var result = [returnValue, historical]
					//Respuesta (Array : JSON)
					response.json(result);		        	
		        }
		        else {
		        	response.json(undefined);		
		        }
		    }); 
		});		
	});

	//Historiales (server get)
	app.get('/historicalDates/:lotXCycleID', function (request, response) {	
		var lotXCycleID = request.params.lotXCycleID;
		//Conexión a la BD según: configuration.
		var connection = new mssql.Connection(configuration, function (err) {
			//Request de la Conexión.
		    var request = new mssql.Request(connection);
		    request.input('FK_LotXCycle', mssql.Int, lotXCycleID);
		    //Ejecución del Store Procedure (SP).
		    request.execute('dbo.APSP_HistoricalDates', function (err, recordsets, returnValue) {
		        //Inicialización del Array Respuesta.  		
		        if (typeof(recordsets[0]) != 'undefined') {
			        var periods = new Array(recordsets[0].length + 1);
			        periods[0] = { date: "" };
			        for (var i = 0; i < recordsets[0].length; i++) {
			        	var period = {
			        		date: recordsets[0][i].Date
			        	};
			        	periods[i + 1] = period;
			        };	
					//Respuesta (Array : JSON)
					response.json(periods);		        	
		        }
		        else {
		        	response.json(undefined);		
		        }
		    });   
		});		
	});
};