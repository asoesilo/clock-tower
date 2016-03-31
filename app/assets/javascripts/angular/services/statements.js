'use strict';

var ClockTower = angular.module('ClockTower');

ClockTower.service('StatementService', ['$http', 'API_PATH', function($http, apiPath) {

  function getStatements(state){
    return $http.get('/admin/api/statements', { params: { state: state } });
  }

  function updateStatement(statement, params){
    return $http({
      method: 'PUT',
      url: '/admin/api/statements/' + statement.id,
      params: params
    })
  }

  return {
    all: getStatements,
    update: updateStatement,
  };
}]);
