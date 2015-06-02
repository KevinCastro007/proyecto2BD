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
	app.get('/historical/:lotXCycleID', function (request, response) {	
		var lotXCycleID = request.params.lotXCycleID;
		//Conexión a la BD según: configuration.
		var connection = new mssql.Connection(configuration, function (err) {
			//Request de la Conexión.
		    var request = new mssql.Request(connection);
		    request.input('FK_LotXCycle', mssql.Int, lotXCycleID);
		    //Ejecución del Store Procedure (SP).
		    request.execute('dbo.APSP_Historical', function (err, recordsets, returnValue) {
		        //Inicialización del Array Respuesta.  		
		        if (typeof(recordsets[0]) != 'undefined') {
		        	console.log("Successful execution (SP: HISTORICAL)");
			        historical = new Array(recordsets[0].length);
			        for (var i = 0; i < recordsets[0].length; i++) {
			        	//JSON : Historial
			        	history = new historyStructure();
			        	history.date = recordsets[0][i].ActivityDate;
			        	history.activity = recordsets[0][i].ActivityName;
			        	history.requestType = recordsets[0][i].RequestType;
			        	//history.requestItem = ;
			        	//history.amount = ;
			        	history.description = recordsets[0][i].RequestDescription;
			        	history.state = recordsets[0][i].RequestState;
			        	//Adjuntar el JSON al Array Respuesta.
			        	historical[i] = history;
			        };	
					//Respuesta (Array : JSON)
					response.json(historical);		        	
		        }
		        else {
		        	response.json(undefined);		
		        }
		    });   
		});		
	});
};