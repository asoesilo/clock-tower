'use strict';

var ClockTower = angular.module('ClockTower');

ClockTower.controller('SummaryReportController', ['$scope', 'ProjectService', 'TaskService', 'UserService', function($scope, ProjectService, TaskService, UserService) {
  var initialize = function() {
    $scope.isFromCalendarOpen = false;
    $scope.isToCalendarOpen = false;
    $scope.dateFormat = "yyyy-MM-dd";

    fetchUsers();
    fetchProjects();
    fetchTasks();
  };

  $scope.toggleFromCalendar = function($event) {
    $event.preventDefault();
    $event.stopPropagation();

    $scope.isFromCalendarOpen = !$scope.isFromCalendarOpen;
  };

  $scope.toggleToCalendar = function($event) {
    $event.preventDefault();
    $event.stopPropagation();

    $scope.isToCalendarOpen = !$scope.isToCalendarOpen;
  };

  var fetchTasks = function() {
    TaskService.all().success(function(tasks) {
      $scope.tasks = tasks;
    });
  };

  var fetchProjects = function() {
    ProjectService.all().success(function(projects) {
      $scope.projects = projects;
    });
  };

  var fetchUsers = function() {
    UserService.all().success(function(users) {
      $scope.users = users;
    });
  };

  $scope.presetValues = function(from, to, users, projects, tasks) {
    $scope.from = from;
    $scope.to = to;
    $scope.selected_users = users;
    $scope.selected_projects = projects;
    $scope.selected_tasks = tasks;
  };

  initialize();
}]);

ClockTower.controller('UserReportController', ['$scope', 'UserService', function($scope, UserService) {
  var initialize = function() {
    $scope.isFromCalendarOpen = false;
    $scope.isToCalendarOpen = false;
    $scope.dateFormat = "yyyy-MM-dd";

    fetchUsers();
  };

  $scope.toggleFromCalendar = function($event) {
    $event.preventDefault();
    $event.stopPropagation();

    $scope.isFromCalendarOpen = !$scope.isFromCalendarOpen;
  };

  $scope.toggleToCalendar = function($event) {
    $event.preventDefault();
    $event.stopPropagation();

    $scope.isToCalendarOpen = !$scope.isToCalendarOpen;
  };

  var fetchUsers = function() {
    UserService.all().success(function(users) {
      $scope.users = users;
    });
  };

  $scope.presetValues = function(from, to, user) {
    $scope.from = from;
    $scope.to = to;
    $scope.selected_user = user;
  };

  initialize();
}]);
