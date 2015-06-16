
//Variables en el contexto.
var property;
var properties;

//Función que retorna un JSON con la estructura de una Propiedad 
//con respecto a la BD y la Vista correspondiente.
function propertyStructure() {
	var property = 
	{		
		ID: 0,
		name: ""
	};
	return property;
}

//Exportación del módulo correspondiente para las Propiedades.
//Parámetros desde el Servidor: app, mssql y configuration.
module.exports = function (app, mssql, configuration) {
	//Propiedades (server get)
	app.get('/properties', function (request, response) {
		//Conexión a la BD según: configuration.
		var connection = new mssql.Connection(configuration, function (err) {
			//Request de la Conexión.
		    var request = new mssql.Request(connection);
		    //Ejecución del Store Procedure (SP).
		    request.execute('dbo.APSP_Properties', function (err, recordsets, returnValue) {      	
		        //Inicialización del Array Respuesta.  		
		        properties = new Array(recordsets[0].length);
		        for (var i = 0; i < recordsets[0].length; i++) {
		        	//JSON : Propiedad
		        	property = new propertyStructure();
		        	property.ID = recordsets[0][i].ID;
		        	property.name = recordsets[0][i].Name;
		        	//Adjuntar el JSON al Array Respuesta.
		        	properties[i] = property;
		        };
				//Respuesta (Array : JSON)
				response.json(properties);
		    });   
		});		
	});
};