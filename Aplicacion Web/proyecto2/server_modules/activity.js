
//Variables en el contexto.
var activity;
var activities;

//Función que retorna un JSON con la estructura de una Actividad 
//con respecto a la BD y la Vista correspondiente.
function activityStructure() {
	var activity = 
	{		
		ID: 0,
		name: ""
	};
	return activity;
}

//Exportación del módulo correspondiente para las Actividades.
//Parámetros desde el Servidor: app, mssql y configuration.
module.exports = function (app, mssql, configuration) {
	//Actividades (server get)
	app.get('/activities', function (request, response) {
		//Conexión a la BD según: configuration.
		var connection = new mssql.Connection(configuration, function (err) {
			//Request de la Conexión.
		    var request = new mssql.Request(connection);
		    //Ejecución del Store Procedure (SP).
		    request.execute('dbo.APSP_Activities', function (err, recordsets, returnValue) {      	
		        //Inicialización del Array Respuesta.  		
		        activities = new Array(recordsets[0].length);
		        for (var i = 0; i < recordsets[0].length; i++) {
		        	//JSON : Activity
		        	activity = new activityStructure();
		        	activity.ID = recordsets[0][i].ID;
		        	activity.name = recordsets[0][i].Name;
		        	//Adjuntar el JSON al Array Respuesta.
		        	activities[i] = activity;
		        };
				//Respuesta (Array : JSON)
				response.json(activities);
		    });   
		});		
	});
};