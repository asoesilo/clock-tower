'use strict';

var ClockTower = angular.module('ClockTower');

ClockTower.controller('TimeEntriesCtrl', ['$scope', 'TaskService', 'ProjectService', 'TimeEntryService', function($scope, TaskService, ProjectService, TimeEntryService) {

  $scope.date = "";

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

  $scope.toggleCalendar = function($event, entry) {
    $event.preventDefault();
    $event.stopPropagation();

    if(entry !== undefined) {
      entry.calendarOpen = !entry.calendarOpen;
    }
    else {
      $scope.opened = !$scope.opened;
    }
  };

  // Disable weekend selection
  $scope.disabled = function(date, mode) {
    return ( mode === 'day' && ( date.getDay() === 0 || date.getDay() === 6 ) );
  };

  $scope.dateOptions = {
    formatYear: 'yy',
    startingDay: 1
  };

  $scope.formatViewDate = function(input){
    var months=['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    var year = input.getFullYear();
    var month = input.getMonth();
    var date = input.getDate();

    return (date<10?"0"+date:date) + " " + months[month] + " " + year;
  };

  $scope.showEditIcon = function(entry) {
    entry.isHover = true;
  };

  $scope.hideEditIcon = function(entry) {
    entry.isHover = false;
  };

  var formatDate = function(input) {
    var year = input.getFullYear();
    var month = input.getMonth();
    var date = input.getDate();

    return year + "-" + month + "-" + date;
  };

  $scope.createTimeEntry = function() {
    console.log("In create time entry");

    var task = $scope.task;
    var project = $scope.project;
    var duration = $scope.duration;
    var date = formatDate($scope.date);
    var comments = $scope.comments;

    TimeEntryService.create(task.id, project.id, date, duration, comments).then(function(response) {
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
      $scope.timeEntries.forEach(function(entry) {
        entry.date = new Date(entry.date);
      });
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

  var setEditState = function(entry, state) {
    entry.isEditState = state;
  };

  $scope.enterEditState = function(entry) {
    entry.newTask = {id: entry.task.id};
    entry.newProject = {id: entry.project.id};
    entry.newDate = entry.date;
    entry.newDuration = entry.duration_in_hours;
    entry.newComments = entry.comments;

    setEditState(entry, true);
  }

  $scope.saveEntry = function(entry) {
    var task = entry.newTask;
    var project = entry.newProject;
    var date = entry.newDate;
    var duration = entry.newDuration;
    var comments = entry.newComments;

    TimeEntryService.update(entry.id, task.id, project.id, date, duration, comments).then(function(response) {
      console.log('in end update response');
      if(response.data.error !== undefined) {
        // TODO: Handle error
      }
      else {
        console.log('in handle success');
        setEditState(entry, false);

        var newEntry = response.data.entry;
        entry.task = newEntry.task;
        entry.project = newEntry.project;
        entry.date = new Date(newEntry.date);
        entry.duration_in_hours = newEntry.duration_in_hours;
        entry.comments = newEntry.comments;
      }
    });
  }

  $scope.cancelEdit = function(entry) {
    setEditState(entry, false);
  }

  var initializeData = function() {
    $scope.maxDate = new Date();
    $scope.minDate = new Date();
    $scope.minDate.setYear($scope.minDate.getFullYear() - 1);
    $scope.dateFormat = "dd MMM yyyy"

    fetchTasks();
    fetchProjects();
    fetchTimeEntries();
  }

  $scope.myDate = new Date();

  initializeData();
}]);