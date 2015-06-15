
// Controladores de las vistas de la página web
var myApp = angular.module('myApp', ['ngRoute']);

// Configuración de las rutas (web views) con sus respectivos controladores
myApp.config(function ($routeProvider) {
	$routeProvider
		.when('/', {
			templateUrl : '../pages/home.html',
			controller 	: 'homeController'
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
    var lotXCycleID = 0;
    var propertyID = 0;
    var interfaz = {
        getLotXCycle: function(){
            return lotXCycleID;
        },
        setLotXCycle: function(value){
            lotXCycleID = value;
        },     
        getProperty: function(){
            return propertyID;
        },
        setProperty: function(value){
            propertyID = value;
        }
    }
    return interfaz;
});

//Main Controller
myApp.controller('mainController', function ($scope, $http, sharedProperties) {
	$scope.propertySelection = function () {
		window.location = "main.html?name=" + $scope.access.property.name + "&id="+$scope.access.property.ID;
	};	
	$http.get('/properties').success(function (response) {
		$scope.properties = response;	
	});	
});

//Home Controller
myApp.controller('homeController', function ($scope, $http, sharedProperties) {
	$scope.salir = function () {
		window.location = ("../index.html"); 
	};
	$scope.init = function () {
		$scope.showLotInfo = false;
		$scope.showLotSelection = true;
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
			var property = ""; 
	        for (i = 0; i < get["id"].length; i++) {
	        	if (get["id"][i] == "#") {
	        		break;
	        	}
	        	property += get["id"][i]; 	
	        }   	
	        $scope.property = get["name"];
	        sharedProperties.setProperty(property);
	    }
		$http.get('/lots/' + sharedProperties.getProperty()).success(function (response) {
			$scope.lots = response;
		});
	};
	$scope.lotSelection = function () {
		$scope.cycles = null;
		$scope.showLotInfo = false;
		$http.get('/cycles/' + $scope.access.lot.ID).success(function (response) {
			$scope.cycles = response;
		});			
	};	
	$scope.cycleSelection = function () {
		$http.post('/lotXCycleID', $scope.access).success(function (response) {
			sharedProperties.setLotXCycle(response);
			$http.get('/lotXCycle/' + sharedProperties.getLotXCycle()).success(function (response) {
				$scope.cropType = response.cropType;
				$scope.suppliesBalance = response.suppliesBalance;
				$scope.servicesBalance = response.servicesBalance;
				$scope.machineryBalance = response.machineryBalance;		
				$scope.totalBalance = response.suppliesBalance + response.servicesBalance + response.machineryBalance;
			});	
			$scope.lot = $scope.access.lot.code;
			$scope.access = "";
			$scope.showLotInfo = true;		
			$scope.showLotSelection = false;		
		});			
	};	
	$scope.changeLot = function () {
		$scope.showLotInfo = false;		
		$scope.showLotSelection = true;
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
	$scope.init = function () {
		$scope.requestTypes = ['', 'Suministro', 'Maquinaria', 'Servicio'];	
	};
	$scope.lotSelection = function () {
		$scope.cycles = null;
		$scope.flag = false;
		$http.get('/cycles/' + $scope.access.lot.ID).success(function (response) {
			$scope.cycles = response;
		});			
	};	
	$scope.cycleSelection = function () {
		$http.post('/lotXCycleID', $scope.access).success(function (response) {
			sharedProperties.setLotXCycle(response);
			$http.get('/historicalDates/' + sharedProperties.getLotXCycle()).success(function (response) {
				$scope.periods = response;	
			});	
			$http.post('/historical/' + sharedProperties.getLotXCycle(), $scope.historical).success(function (response) {				
				if (response[1].length > 0) {
					$scope.partialBalance = response[0]
					$scope.histories = response[1];	
					$scope.flag = true;
				}  
				else {
					$scope.flag = false;
				}
			});			
		});					
	};	
	$scope.showResult = function () {
		$http.post('/historical/' + sharedProperties.getLotXCycle(), $scope.historical).success(function (response) {
			if (response[1].length > 0) {
				$scope.partialBalance = response[0]
				$scope.histories = response[1];	
				$scope.flag = true;
			}  
			else {
				$scope.flag = false;
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
		$http.get('/attendants').success(function (response) {
			$scope.attendants = response;	
		});			
		$scope.request = "";		
	};	
	$scope.init = function () {
		$scope.item = "Item";
		$scope.types = ['Suministro', 'Maquinaria', 'Servicio'];	
	};	
	$scope.lotSelection = function () {
		$scope.cycles = null;
		$scope.flag = false;
		$http.get('/cycles/' + $scope.access.lot.ID).success(function (response) {
			$scope.cycles = response;
		});			
	};	
	$scope.cycleSelection = function () {
		$http.post('/lotXCycleID', $scope.access).success(function (response) {
			sharedProperties.setLotXCycle(response);	
		});			
	};		
	$scope.typeSelection = function () {
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
		if (typeof($scope.request.attendant) === 'undefined') {
			alert("Seleccione el Encargado!");
		}		
		else if (typeof($scope.request.type) === 'undefined') {
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
			console.log($scope.request);
			$http.put('/request/' + sharedProperties.getLotXCycle(), $scope.request).success(function (response) {
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