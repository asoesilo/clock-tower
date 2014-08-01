'use strict';

var ClockTower = angular.module('ClockTower');

ClockTower.controller('TimeEntriesCtrl', ['$scope', 'TaskService', 'ProjectService', 'TimeEntryService', function($scope, TaskService, ProjectService, TimeEntryService) {

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

  $scope.toggleCalendar = function($event) {
    $event.preventDefault();
    $event.stopPropagation();

    $scope.opened = !$scope.opened;
  };

  // Disable weekend selection
  $scope.disabled = function(date, mode) {
    return ( mode === 'day' && ( date.getDay() === 0 || date.getDay() === 6 ) );
  };

  $scope.dateOptions = {
    formatYear: 'yy',
    startingDay: 1
  };

  $scope.showEditIcon = function(entry) {
    entry.isHover = true;
  };

  $scope.hideEditIcon = function(entry) {
    entry.isHover = false;
  };

  var formatDate = function(date) {
    var yearStr = date.getFullYear();
    var monthStr = date.getMonth();
    var dateStr = date.getDate();

    return yearStr + "-" + monthStr + "-" + dateStr;
  };

  $scope.createTimeEntry = function() {
    console.log("In create time entry");

    var task = $scope.task;
    var project = $scope.project;
    var duration = $scope.duration;
    var date = formatDate($scope.date);
    var comments = $scope.comments;

    TimeEntryService.create(null, task.id, project.id, date, duration, comments).then(function(response) {
      if(response.data.error !== undefined) {
        // TODO: Handle error
      }
      else {
        $scope.timeEntries.push(response.data.entry);

        $scope.task = null;
        $scope.project = null;
        $scope.duration = null;
        $scope.date = null;
        $scope.comments = null;        
      }
    });

  };

  var fetchTimeEntries = function() {
    TimeEntryService.all().success(function(data) {
      $scope.timeEntries = data;
    });
  };

  var removeEntryFromArray = function(entry) {
    var index = $scope.timeEntries.indexOf(entry);
    if(index > -1) {
      $scope.timeEntries.splice(index, 1);
    }
  }

  $scope.deleteTimeEntry = function(entry) {
    console.log("in delete time entry");
    TimeEntryService.delete(entry.id).then(function(response) {
      if(response.data.errors !== undefined) {
        // TODO: Handle error
      }
      else {
        removeEntryFromArray(entry);
      }
    });
  };

  var initializeData = function() {
    $scope.maxDate = new Date();
    $scope.minDate = new Date();
    $scope.minDate.setYear($scope.minDate.getFullYear() - 1);
    $scope.format = 'dd-MMMM-yyyy';

    fetchTasks();
    fetchProjects();
    fetchTimeEntries();
  }

  $scope.myDate = new Date();

  initializeData();
}]);