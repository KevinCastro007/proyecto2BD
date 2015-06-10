
//Variables en el contexto.
var cycle;
var cycles;

//Función que retorna un JSON con la estructura de un Ciclo 
//con respecto a la BD y la Vista correspondiente.
function cycleStructure() {
	var cycle = 
	{		
		ID: 0,
		period: ""
	};
	return cycle;
}

//Exportación del módulo correspondiente para los Ciclos.
//Parámetros desde el Servidor: app, mssql y configuration.
module.exports = function (app, mssql, configuration) {
	//Ciclos (server get)
	app.get('/cycles/:lotID', function (request, response) {	
		var lotID = request.params.lotID;
		//Conexión a la BD según: configuration.
		var connection = new mssql.Connection(configuration, function (err) {
			//Request de la Conexión.
		    var request = new mssql.Request(connection);
		    //Ejecución del Store Procedure (SP).
		    request.input('FK_Lot', mssql.Int, lotID);
		    request.execute('dbo.APSP_CyclesPeriod', function (err, recordsets, returnValue) {
		        //Inicialización del Array Respuesta.  		
		        cycles = new Array(recordsets[0].length);
		        for (var i = 0; i < recordsets[0].length; i++) {
		        	//JSON : Cycle
		        	cycle = new cycleStructure();
		        	cycle.ID = recordsets[0][i].ID;
		        	cycle.period = recordsets[0][i].Period;
		        	//Adjuntar el JSON al Array Respuesta.
		        	cycles[i] = cycle;
		        };	
				//Respuesta (Array : JSON)
				response.json(cycles);
		    });   
		});		
	});
};