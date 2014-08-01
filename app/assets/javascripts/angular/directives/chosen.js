'use strict';

var ClockTower = angular.module('ClockTower');

ClockTower.directive('chosen', function() {
  var linker = function(scope, element, attrs) {
    var list = attrs['chosen'];
    var item = attrs['ngModel'];

    scope.$watch(list, function() {
      element.trigger('liszt:updated');
      element.trigger('chosen:updated');
    });

    scope.$watch(item, function() {
      element.trigger('chosen:updated');
    });

    element.chosen();
  };

  return {
    restrict: 'A',
    link: linker,
    require: 'ngModel'
  };
});