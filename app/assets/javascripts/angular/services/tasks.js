'use strict';

var ClockTower = angular.module('ClockTower');
ClockTower.service('TaskService', ['$http', 'API_PATH', function($http, apiPath) {
  var getTasks = function() {
    return $http.get('/api/tasks');
  }

  return {
    all: getTasks
  };
}]);