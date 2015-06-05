
//Variables en el contexto.
var machine;
var machinery;

//Función que retorna un JSON con la estructura de una Máquina
//con respecto a la BD y la Vista correspondiente.
function machineStructure() {
	var machine = 
	{		
		ID: 0,
		name: ""
	};
	return machine;
}

//Exportación del módulo correspondiente para las Máquinas.
//Parámetros desde el Servidor: app, mssql y configuration.
module.exports = function (app, mssql, configuration) {
	//Máquinas (server get)
	app.get('/machinery', function (request, response) {
		//Conexión a la BD según: configuration.
		var connection = new mssql.Connection(configuration, function (err) {
			//Request de la Conexión.
		    var request = new mssql.Request(connection);
		    //Ejecución del Store Procedure (SP).
		    request.execute('dbo.APSP_Machinery', function (err, recordsets, returnValue) {      	
		        //Inicialización del Array Respuesta.  		
		        machinery = new Array(recordsets[0].length);
		        for (var i = 0; i < recordsets[0].length; i++) {
		        	//JSON : Machine
		        	machine = new machineStructure();
		        	machine.ID = recordsets[0][i].ID;
		        	machine.name = recordsets[0][i].Name;
		        	//Adjuntar el JSON al Array Respuesta.
		        	machinery[i] = machine;
		        };
				//Respuesta (Array : JSON)
				response.json(machinery);
		    });   
		});		
	});
};