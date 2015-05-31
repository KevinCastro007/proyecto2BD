
// Controladores de las vistas de la página web
var myApp = angular.module('myApp', ['ngRoute']);		//Exportación del módulo.

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

var fk_LotXCycle = 0;
//Main Controller
myApp.controller('mainController', ['$scope', '$http', function ($scope, $http) {	
	$scope.salir = function () {
		window.location = ("/index.html"); 
	}
	$scope.propertySelection = function() {
		$scope.lots = null;
		$scope.cycles = null;
		$http.get('/lots/' + $scope.history.property.ID).success(function (response) {
			$scope.lots = response;
		});	
	}
	$scope.lotSelection = function() {
		$scope.cycles = null;
		$http.get('/cycles/' + $scope.history.lot.ID).success(function (response) {
			$scope.cycles = response;
		});			
	}	
	$scope.cycleSelection = function() {
		var IDs = [$scope.history.lot.ID, $scope.history.cycle.ID];
		$http.get('/lotXCycle/' + IDs).success(function (response) {
			fk_LotXCycle = response;
		});		
		window.location = ("/main.html");
	}		
	$http.get('/properties').success(function (response) {
		$scope.properties = response;	
	});	
}]);

//History Controller
myApp.controller('historyController', ['$scope', '$http', function ($scope, $http) {
	$http.get('/activities').success(function (response) {
		$scope.activities = response;	
	});
}]);

//Supply Controller
myApp.controller('supplyController', ['$scope', '$http', function ($scope, $http) {
	$http.get('/supplies').success(function (response) {
		$scope.supplies = response;	
	});	
	$http.get('/activities').success(function (response) {
		$scope.activities = response;	
	});
}]);

//Machinery Controller
myApp.controller('machineryController', ['$scope', '$http', function ($scope, $http) {
	$http.get('/machinery').success(function (response) {
		$scope.machinery = response;	
	});	
	$http.get('/activities').success(function (response) {
		$scope.activities = response;	
	});
}]);

//Service Controller
myApp.controller('serviceController', ['$scope', '$http', function ($scope, $http) {
	$http.get('/services').success(function (response) {
		$scope.services = response;	
	});	
	$http.get('/activities').success(function (response) {
		$scope.activities = response;	
	});
}]);