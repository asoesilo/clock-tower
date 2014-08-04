'use strict';

var ClockTower = angular.module('ClockTower');
ClockTower.service('ProjectService', ['$http', 'API_PATH', function($http, apiPath) {
  var getProjects = function() {
    return $http.get('/api/projects');
  }

  return {
    all: getProjects
  };
}]);