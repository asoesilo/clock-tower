'use strict';

var ClockTower = angular.module('ClockTower');
ClockTower.service('UserService', ['$http', 'API_PATH', function($http, apiPath) {
  var getUsers = function() {
    return $http.get('/api/users');
  }

  return {
    all: getUsers
  };
}]);