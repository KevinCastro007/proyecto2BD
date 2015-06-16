//Variables en el contexto.
var lot;
var lots;
//Función que retorna un JSON con la estructura de un Lote 
//con respecto a la BD y la Vista correspondiente.
function lotStructure() {
	var lot = 
	{		
		ID: 0,
		code: ""
	};
	return lot;
}

//Exportación del módulo correspondiente para los Lotes.
//Parámetros desde el Servidor: app, mssql y configuration.
module.exports = function (app, mssql, configuration) {
	//Lotes (server get)
	app.get('/lots/:propertyID', function (request, response) {	
		var propertyID = request.params.propertyID;
		//Conexión a la BD según: configuration.
		var connection = new mssql.Connection(configuration, function (err) {
			//Request de la Conexión.
		    var request = new mssql.Request(connection);
		    //Ejecución del Store Procedure (SP).
		    request.input('FK_Property', mssql.Int, propertyID);
		    request.execute('dbo.APSP_Lots', function (err, recordsets, returnValue) {
		        //Inicialización del Array Respuesta.  		
		        lots = new Array(recordsets[0].length);
		        for (var i = 0; i < recordsets[0].length; i++) {
		        	//JSON : Lote
		        	lot = new lotStructure();
		        	lot.ID = recordsets[0][i].ID;
		        	lot.code = recordsets[0][i].Code;
		        	//Adjuntar el JSON al Array Respuesta.
		        	lots[i] = lot;
		        };	
				//Respuesta (Array : JSON)
				response.json(lots);
		    });   
		});		
	});
};