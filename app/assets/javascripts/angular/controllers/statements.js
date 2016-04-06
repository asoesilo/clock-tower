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
        $scope.statements[index + 1].isOpen = true;
      }
    }

    $scope.payStatement = function payStatement(statement, index){
      toggleLoading(statement);

      changeState(statement, 'paid').success(function(data){
        $('#statement-count').text($('#statement-count').text() - 1);
        statement.state = data.state;
        toggleLoading(statement);
        toggleOpen(statement);
        openNextStatement(index);
      });
    }

    $scope.openStatement = function openStatement(statement){
      toggleOpen(statement);
    }

    $scope.loading = true;
    StatementService.all({state: 'locked'}).success(function(data, status){
      $scope.statements = data;
      $scope.loading = false;
      if ($scope.statements.length > 0){
        toggleOpen($scope.statements[0]);
      }
    })
  }
]);
