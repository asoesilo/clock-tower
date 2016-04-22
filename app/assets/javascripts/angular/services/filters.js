'use strict';

var ClockTower = angular.module('ClockTower');

ClockTower.filter('escape', function() {
  return function(input){
    return escape(input);
  };
});
