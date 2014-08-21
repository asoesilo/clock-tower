'use strict';

var ClockTower = angular.module('ClockTower');
ClockTower.service('TimeEntryService', ['$http', '$resource', function($http, $resource) {
  var TimeEntry = $resource('./api/time_entries/:id', {id: '@id'}, {
    'update': { method: 'PUT' }
  });

  var getAllTimeEntries = function() {
    return TimeEntry.query();
  };

  var getTimeEntriesForProfile = function() {
    return $http.get('./api/profile/time_entries');
  };

  var createTimeEntry = function(taskId, projectId, entryDate, duration, comments, success, error) {
    var data = {
      time_entry: {
        task_id: taskId,
        project_id: projectId,
        entry_date: entryDate,
        duration_in_hours: duration,
        comments: comments
      }
    };

    var newTimeEntry = new TimeEntry(data);
    return newTimeEntry.$save(success, error);
  };

  var updateTimeEntry = function(id, taskId, projectId, entryDate, duration, comments, success, error) {
    var data = {
      time_entry: {
        task_id: taskId,
        project_id: projectId,
        entry_date: entryDate,
        duration_in_hours: duration,
        comments: comments
      }
    };

    return TimeEntry.update({id: id}, data, success, error);
  };

  var deleteTimeEntry = function(entryId, success, error) {
    return TimeEntry.remove({id: entryId}, success, error);
  };

  return {
    all: getAllTimeEntries,
    get: getTimeEntriesForProfile,
    create: createTimeEntry,
    update: updateTimeEntry,
    delete: deleteTimeEntry
  };
}]);