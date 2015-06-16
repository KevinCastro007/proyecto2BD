//Importación de los módulos para el servidor.
var express = require('express');					//Express
var http = require('http');							//HTTP
var mssql = require('mssql');						//MSSQL SERVER 
var bodyParser = require('body-parser');			//JSON Parser

//Creación del servidor y configuración.
var app = express();								//Servidor Express.
var server = http.createServer(app);				//Creación del Servidor.
app.set('port', process.env.PORT || 8080);			//Puerto del Servidor.
app.use(express.static(__dirname + '/public'));		//Especificación de la carpeta public.
app.use(bodyParser.json());							//Parser de los JSON.

//Configuración de la Base de Datos.
var configuration = 
{
	user: 'sa',							//Nombre de Usuario de BD
	password: '123',					//Contraseña del Usuario
	server: 'localhost',				//Servidor de BD
	database: 'AgriculturalProperty'	//Base de Datos (BD)
}

//Importación de los módulos del servidor.
var fs = require('fs');
var routePath = __dirname + '/server_modules/';				//Especificación de la carpeta: server_modules.
fs.readdirSync(routePath).forEach(function (file) {
	//Envío por parámetros: app, mssql y configuration.
    require(routePath + file)(app, mssql, configuration);
});

//Servidor en listening.
server.listen(app.get('port'), function () {
  console.log('Express server listening on port ' + app.get('port'));
});