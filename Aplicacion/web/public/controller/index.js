
// Controladores de las vistas de la página web
var myApp = angular.module('myApp', []);

//Main Controller
myApp.controller('mainController', function ($scope, $http) {	
	$scope.propertySelection = function () {
		$scope.lots = null;
		$scope.cycles = null;
		$http.get('/lots/' + $scope.access.property.ID).success(function (response) {
			$scope.lots = response;
		});	
	};
	$scope.lotSelection = function () {
		$scope.cycles = null;
		$http.get('/cycles/' + $scope.access.lot.ID).success(function (response) {
			$scope.cycles = response;
		});			
	};	
	$scope.cycleSelection = function () {
		var IDs = [$scope.access.lot.ID, $scope.access.cycle.ID];
		$http.get('/lotXCycle/' + IDs).success(function (response) {
			window.location = "main.html?fk="+response+"&property="+$scope.access.property.name+"&lot="+$scope.access.lot.code;
		});		
	};		
	$http.get('/properties').success(function (response) {
		$scope.properties = response;	
	});	
});