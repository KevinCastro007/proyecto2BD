
// Controladores de las vistas de la página web
var myApp = angular.module('myApp', ['ngRoute']);		//Exportación del módulo.

// Configuración de las rutas (web views) con sus respectivos controladores
myApp.config(function ($routeProvider) {
	$routeProvider
		.when('/', {
			templateUrl : '../pages/home.html',
			controller 	: 'mainController'
		})
		.when('/activity', {
			templateUrl : '../pages/activity.html',
			controller 	: 'activityController'
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
//Main Controller
myApp.controller('mainController', ['$scope', '$http', function ($scope, $http) {
	$scope.message = function() {
		alert("Hola Usuario, desde el Main Controller!");
	}
}]);

//Activity Controller
myApp.controller('activityController', ['$scope', '$http', function ($scope, $http) {
	$scope.propertySelection = function() {
		$scope.lots = null;
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
	$http.get('/properties').success(function (response) {
		$scope.properties = response;	
	});	
}]);

//Supply Controller
myApp.controller('supplyController', ['$scope', '$http', function ($scope, $http) {
	$scope.message = function() {
		alert("Hola Usuario, desde el Supply Controller!");
	}
}]);

//Machinery Controller
myApp.controller('machineryController', ['$scope', '$http', function ($scope, $http) {
	$scope.message = function() {
		alert("Hola Usuario, desde el Machinery Controller!");
	}
}]);

//Service Controller
myApp.controller('serviceController', ['$scope', '$http', function ($scope, $http) {
	$scope.message = function() {
		alert("Hola Usuario, desde el Service Controller!");
	}
}]);