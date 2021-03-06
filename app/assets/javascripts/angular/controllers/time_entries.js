'use strict';

var ClockTower = angular.module('ClockTower');

var ConfirmationModalCtrl = function($scope, $modalInstance, message) {
  $scope.message = message;

  $scope.ok = function() {
    $modalInstance.close()
  };

  $scope.cancel = function() {
    $modalInstance.dismiss();
  };
};

ClockTower.controller('TimeEntriesCtrl', ['$scope', '$modal', 'TaskService', 'ProjectService', 'TimeEntryService',
  function($scope, $modal, TaskService, ProjectService, TimeEntryService) {
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

    var parseDate = function(dateString) {
      var match = dateString.match(/^(\d{4})-(\d{1,2})-(\d{1,2})$/);

      // Date.prototype.setMonth() is zero-based: 0 for January, 1 for February, and so on.
      // Thus, we need to substract 1.
      return (match) ? new Date(match[1], match[2]-1, match[3]) : null;
    };

    $scope.showEditIcon = function(entry) {
      entry.isHover = true;
    };

    $scope.hideEditIcon = function(entry) {
      entry.isHover = false;
    };

    var formatDate = function(input) {
      var year = input.getFullYear();

      // Date.prototype.getMonth() is zero-based: 0 for January, 1 for February, and so on.
      // Thus, we need to add 1.
      var month = input.getMonth() + 1;
      var date = input.getDate();

      return year + "-" + month + "-" + date;
    };

    $scope.createTimeEntry = function() {
      var task = $scope.task;
      var project = $scope.project;
      var duration = $scope.duration;
      var date = formatDate($scope.date);
      var comments = $scope.comments;

      TimeEntryService.create(task.id, project.id, date, duration, comments, function(response) {
        response.entry.date = parseDate(response.entry.date);
        $scope.timeEntries.push(response.entry);

        $scope.task = null;
        $scope.project = null;
        $scope.duration = null;
        $scope.date = null;
        $scope.comments = null;
      }, function(error) {
        // TODO: error handling
      });
    };

    var fetchTimeEntries = function() {
      TimeEntryService.get().success(function(data) {
        $scope.timeEntries = data;
        $scope.timeEntries.forEach(function(entry) {
          entry.date = parseDate(entry.date);
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
      // Use traditional Javascript dialog to prompt delete confirmation
      // if(window.confirm("Confirm to delete time entry.")) {
      //   console.log("delete time entry");
      // }

      // Use Angular UI to prompt delete confirmation
      var modalInstance = $modal.open({
        templateUrl: 'confirmationModal.html',
        controller: ConfirmationModalCtrl,
        size: 'sm',
        resolve: {
          message: function() {
            return "Confirm delete time entry?";
          }
        }
      });

      modalInstance.result.then(function() {

        TimeEntryService.delete(entry.id, function() {
          removeEntryFromArray(entry);
        }, function(error) {
          // TODO: error handling
        });
      }, function() {
        // Cancel delete
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

      TimeEntryService.update(entry.id, task.id, project.id, date, duration, comments, function(response) {
        setEditState(entry, false);

        var newEntry = response.entry;
        entry.task = newEntry.task;
        entry.project = newEntry.project;
        entry.date = parseDate(newEntry.date);
        entry.duration_in_hours = newEntry.duration_in_hours;
        entry.comments = newEntry.comments;
      }, function(error) {
        // TODO: Handle error
      });
    }

    $scope.cancelEdit = function(entry) {
      setEditState(entry, false);
    }

    var initializeData = function() {
      $scope.maxDate = new Date();
      $scope.minDate = new Date();
      $scope.minDate.setYear($scope.minDate.getFullYear() - 1);
      $scope.dateFormat = "yyyy-MM-dd"

      fetchTasks();
      fetchProjects();
      fetchTimeEntries();
    }

    $scope.myDate = new Date();

    initializeData();
  }
]);
