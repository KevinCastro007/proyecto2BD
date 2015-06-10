
//Variables en el contexto.
var attendant;
var attendants;

//Función que retorna un JSON con la estructura de un Encargado 
//con respecto a la BD y la Vista correspondiente.
function attendantStructure() {
	var attendant = 
	{		
		ID: 0,
		name: ""
	};
	return attendant;
}

//Exportación del módulo correspondiente para los Encargados.
//Parámetros desde el Servidor: app, mssql y configuration.
module.exports = function (app, mssql, configuration) {
	//Encargados (server get)
	app.get('/attendants', function (request, response) {
		//Conexión a la BD según: configuration.
		var connection = new mssql.Connection(configuration, function (err) {
			//Request de la Conexión.
		    var request = new mssql.Request(connection);
		    //Ejecución del Store Procedure (SP).
		    request.execute('dbo.APSP_Attendants', function (err, recordsets, returnValue) {      	
		        //Inicialización del Array Respuesta.  		
		        attendants = new Array(recordsets[0].length);
		        for (var i = 0; i < recordsets[0].length; i++) {
		        	//JSON : Activity
		        	attendant = new attendantStructure();
		        	attendant.ID = recordsets[0][i].ID;
		        	attendant.name = recordsets[0][i].Name;
		        	//Adjuntar el JSON al Array Respuesta.
		        	attendants[i] = attendant;
		        };
				//Respuesta (Array : JSON)
				response.json(attendants);
		    });   
		});		
	});
};