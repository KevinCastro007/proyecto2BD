
// Controladores de las vistas de la página web
var myApp = angular.module('myApp', ['ngRoute']);

// Configuración de las rutas (web views) con sus respectivos controladores
myApp.config(function ($routeProvider) {
	$routeProvider
		.when('/', {
			templateUrl : '../pages/home.html',
			controller 	: 'mainController'
		})
		.when('/history', {
			templateUrl : '../pages/history.html',
			controller 	: 'historyController'
		})
		.when('/supply', {
			templateUrl : '../pages/supply.html',
			controller 	: 'supplyController'
		})
		.when('/machinery', {
			templateUrl : '../pages/machinery.html',
			controller 	: 'machineryController'
		})
		.when('/service', {
			templateUrl : '../pages/service.html',
			controller 	: 'serviceController'
		})
		.otherwise({
			redirectTo : '/'
		});
});

myApp.factory('sharedProperties', function () {
    var fk_LotXCycle = 0; 
    var interfaz = {
        getValue: function(){
            return fk_LotXCycle;
        },
        setValue: function(value){
            fk_LotXCycle = value;
        }
    }
    return interfaz;
});

//Main Controller
myApp.controller('mainController', function ($scope, $http, sharedProperties) {	
	$scope.salir = function () {
		window.location = ("/index.html"); 
	};
	$scope.init = function () {
		var loc = document.location.href;
	    // Si existe el interrogante.
	    if(loc.indexOf('?') > 0) {
	        // Se obtiene la parte de la url que hay despues del interrogante.
	        var getString = loc.split('?')[1];
	        // Se obtiene un array con cada clave=valor
	        var GET = getString.split('&');
	        var get = {};
	        // Se recorre todo el array de valores.
	        for(var i = 0, l = GET.length; i < l; i++) {
	            var tmp = GET[i].split('=');
	            get[tmp[0]] = unescape(decodeURI(tmp[1]));
	        }
			$scope.lot = ""; 
	        for (i = 0; i < get["lot"].length; i++) {
	        	if (get["lot"][i] == "#") {
	        		break;
	        	}
	        	$scope.lot += get["lot"][i]; 	
	        }   	
	        $scope.property = get["property"];
	        sharedProperties.setValue(parseInt(get["fk"]));
	    }		
	};
});

//History Controller
myApp.controller('historyController', function ($scope, $http, sharedProperties) {
	var refresh = function () {
		$http.get('/activities').success(function (response) {
			$scope.activities = response;	
		});	
		$scope.historical = "";		
	};	
	$scope.proceed = function () {
		if (typeof($scope.historical.period) === 'undefined') {
			alert("Seleccione el Rango de Fechas!");
		}
		else if (typeof($scope.historical.requestsType) === 'undefined') {
			alert("Seleccione el Tipo de Solicitud!");
		}	
		else if (typeof($scope.historical.activity) === 'undefined') {
			alert("Seleccione la Actividad!");
		}		
		else {	

			alert(sharedProperties.getValue());	
		}
	};	
	refresh();
});

//Supply Controller
myApp.controller('supplyController', function ($scope, $http, $location, sharedProperties) {	
	var refresh = function () {
		$http.get('/supplies').success(function (response) {
			$scope.requestItems = response;	
		});	
		$http.get('/activities').success(function (response) {
			$scope.activities = response;	
		});	
		$scope.supplyRequest = "";		
	};
	$scope.proceed = function () {
		if (typeof($scope.supplyRequest.activity) === 'undefined') {
			alert("Seleccione la Actividad!");
		}
		else if (typeof($scope.supplyRequest.requestItem) === 'undefined') {
			alert("Seleccione el Suministro!");
		}	
		else if (typeof($scope.supplyRequest.state) === 'undefined') {
			alert("Seleccione el Estado!");
		}		
		else {		
			$scope.supplyRequest.requestType = 'Suministro';
			$http.put('/request/' + sharedProperties.getValue(), $scope.supplyRequest).success(function (response) {
				if (response.resultado) {
					refresh();
					alert("Solicitud procesada!");
				}
				else {
					alert("Imposible realizar la Solicitud!");					
				}		
			});	
		}
	};
	refresh();
});

//Machinery Controller
myApp.controller('machineryController', function ($scope, $http, sharedProperties) {	
	var refresh = function () {
		$http.get('/machinery').success(function (response) {
			$scope.requestItems = response;	
		});	
		$http.get('/activities').success(function (response) {
			$scope.activities = response;	
		});	
		$scope.machineryRequest = "";		
	};
	$scope.proceed = function () {
		if (typeof($scope.machineryRequest.activity) === 'undefined') {
			alert("Seleccione la Actividad!");
		}
		else if (typeof($scope.machineryRequest.requestItem) === 'undefined') {
			alert("Seleccione la Máquina!");
		}	
		else if (typeof($scope.machineryRequest.state) === 'undefined') {
			alert("Seleccione el Estado!");
		}		
		else {	
			$scope.machineryRequest.requestType = 'Maquinaria';	
			$http.put('/request/' + sharedProperties.getValue(), $scope.machineryRequest).success(function (response) {
				if (response.resultado) {
					refresh();
					alert("Solicitud procesada!");
				}
				else {
					alert("Imposible realizar la Solicitud!");					
				}		
			});		
		}
	};
	refresh();
});

//Service Controller
myApp.controller('serviceController', function ($scope, $http, sharedProperties) {	
	var refresh = function () {
		$http.get('/services').success(function (response) {
			$scope.requestItems = response;	
		});	
		$http.get('/activities').success(function (response) {
			$scope.activities = response;	
		});	
		$scope.serviceRequest = "";		
	};
	$scope.proceed = function () {
		if (typeof($scope.serviceRequest.activity) === 'undefined') {
			alert("Seleccione la Actividad!");
		}
		else if (typeof($scope.serviceRequest.requestItem) === 'undefined') {
			alert("Seleccione el Servicio!");
		}	
		else if (typeof($scope.serviceRequest.state) === 'undefined') {
			alert("Seleccione el Estado!");
		}		
		else {	
			$scope.serviceRequest.requestType = 'Servicio';	
			$http.put('/request/' + sharedProperties.getValue(), $scope.serviceRequest).success(function (response) {
				if (response.resultado) {
					refresh();
					alert("Solicitud procesada!");
				}
				else {
					alert("Imposible realizar la Solicitud!");					
				}		
			});			
		}
	};
	refresh();
});