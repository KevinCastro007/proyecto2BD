
//Variables en el contexto.
var service;
var services;

//Función que retorna un JSON con la estructura de un Servicio
//con respecto a la BD y la Vista correspondiente.
function serviceStructure() {
	var service = 
	{		
		ID: 0,
		name: ""
	};
	return service;
}

//Exportación del módulo correspondiente para los Servicios.
//Parámetros desde el Servidor: app, mssql y configuration.
module.exports = function (app, mssql, configuration) {
	//Servicios (server get)
	app.get('/services', function (request, response) {
		//Conexión a la BD según: configuration.
		var connection = new mssql.Connection(configuration, function (err) {
			//Request de la Conexión.
		    var request = new mssql.Request(connection);
		    //Ejecución del Store Procedure (SP).
		    request.execute('dbo.APSP_Services', function (err, recordsets, returnValue) {      	
		        //Inicialización del Array Respuesta.  		
		        services = new Array(recordsets[0].length);
		        for (var i = 0; i < recordsets[0].length; i++) {
		        	//JSON : Activity
		        	service = new serviceStructure();
		        	service.ID = recordsets[0][i].ID;
		        	service.name = recordsets[0][i].Name;
		        	//Adjuntar el JSON al Array Respuesta.
		        	services[i] = service;
		        };
				//Respuesta (Array : JSON)
				response.json(services);
		    });   
		});		
	});
};