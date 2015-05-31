
//Variables en el contexto.
var supply;
var supplies;

//Función que retorna un JSON con la estructura de un Suministro
//con respecto a la BD y la Vista correspondiente.
function supplyStructure() {
	var supply = 
	{		
		ID: 0,
		name: ""
	};
	return supply;
}

//Exportación del módulo correspondiente para los Suministros.
//Parámetros desde el Servidor: app, mssql y configuration.
module.exports = function (app, mssql, configuration) {
	//Actividades (server get)
	app.get('/supplies', function (request, response) {
		//Conexión a la BD según: configuration.
		var connection = new mssql.Connection(configuration, function (err) {
			//Request de la Conexión.
		    var request = new mssql.Request(connection);
		    //Ejecución del Store Procedure (SP).
		    request.execute('dbo.APSP_Supplies', function (err, recordsets, returnValue) {      	
		        //Inicialización del Array Respuesta.  		
		        supplies = new Array(recordsets[0].length);
		        for (var i = 0; i < recordsets[0].length; i++) {
		        	//JSON : Activity
		        	supply = new supplyStructure();
		        	supply.ID = recordsets[0][i].ID;
		        	supply.name = recordsets[0][i].Name;
		        	//Adjuntar el JSON al Array Respuesta.
		        	supplies[i] = supply;
		        };
				//Respuesta (Array : JSON)
				response.json(supplies);
		    });   
		});		
	});
};