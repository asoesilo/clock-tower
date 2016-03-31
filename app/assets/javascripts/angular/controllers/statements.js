'use strict';

var ClockTower = angular.module('ClockTower');

ClockTower.controller('StatementsCtrl', ['$scope', 'StatementService',
  function($scope, StatementService){

    function toggleOpen(statement){
      statement.isOpen = !statement.isOpen;
    }

    function toggleLoading(statement){
      statement.isLoading = !statement.isLoading;
    }

    function changeState(statement, state){
      return StatementService.update(statement, { state: state });
    }

    function openNextStatement(index){
      if (index < $scope.statements.length) {
        toggleOpen($scope.statements[index + 1]);
      }
    }

    $scope.payStatement = function payStatement(statement, index){
      toggleLoading(statement);

      changeState(statement, 'paid').success(function(data){
        statement.state = data.state;
        toggleLoading(statement);
        toggleOpen(statement);
        openNextStatement(index);
      });
    }

    $scope.openStatement = function openStatement(statement){
      toggleOpen(statement);
    }

    StatementService.all('locked').success(function(data, status){
      $scope.statements = data;
      toggleOpen($scope.statements[0]);
    })
  }
]);
