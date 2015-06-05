
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
		.when('/request', {
			templateUrl : '../pages/request.html',
			controller 	: 'requestController'
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
			$http.get('/lotXCycle/' + sharedProperties.getValue()).success(function (response) {
				$scope.attendant = response.attendant;
				$scope.suppliesBalance = response.suppliesBalance;
				$scope.servicesBalance = response.servicesBalance;
				$scope.machineryBalance = response.machineryBalance;				
			});
	    }		
	};
});

//History Controller
myApp.controller('historyController', function ($scope, $http, sharedProperties) {
	var refresh = function () {
		$http.get('/activities').success(function (response) {
			$scope.activities = response;	
		});	
		$http.get('/historicalDates/' + sharedProperties.getValue()).success(function (response) {
			$scope.periods = response;	
		});			
		$scope.historical = "";		
	};	
	$scope.proceed = function () {
		console.log($scope.historical);
		$http.post('/historical/' + sharedProperties.getValue(), $scope.historical).success(function (response) {
			if (typeof(response) != 'undefined') {
				console.log(response);
				$scope.histories = response;	
				$scope.flag = true;
			} 
		});
	};	
	refresh();
});

//Request Controller
myApp.controller('requestController', function ($scope, $http, sharedProperties) {	
	var refresh = function () {
		$http.get('/activities').success(function (response) {
			$scope.activities = response;	
		});	
		$scope.request = "";		
	};
	$scope.typeSelection = function () {
		console.log($scope.request.type);
		if ($scope.request.type == 'Suministro') {
			$http.get('/supplies').success(function (response) {
				$scope.item = "Suministro:";
				$scope.items = response;	
			});		
		}
		else if ($scope.request.type == 'Servicio') {
			$http.get('/services').success(function (response) {
				$scope.item = "Servicio:";
				$scope.amount = " de Horas";
				$scope.items = response;	
			});				
		}
		else if ($scope.request.type == 'Maquinaria') {
			$http.get('/machinery').success(function (response) {
				$scope.item = "Maquinaria:";
				$scope.amount = " de Horas";
				$scope.items = response;	
			});					
		}
	};
	$scope.proceed = function () {
		if (typeof($scope.request.type) === 'undefined') {
			alert("Seleccione el Tipo!");
		}
		else if (typeof($scope.request.activity) === 'undefined') {
			alert("Seleccione la Actividad!");
		}
		else if (typeof($scope.request.item) === 'undefined') {
			alert("Seleccione el Servicio!");
		}	
		else if (typeof($scope.request.state) === 'undefined') {
			alert("Seleccione el Estado!");
		}		
		else {	
			$http.put('/request/' + sharedProperties.getValue(), $scope.request).success(function (response) {
				if (response.resultado) {
					refresh();
					alert("Solicitud procesada!");
					document.location.reload();
				}
				else {
					alert("Imposible realizar la Solicitud!");					
				}		
			});			
		}
	};
	refresh();
});