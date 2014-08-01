'use strict';

var ClockTower = angular.module('ClockTower');
ClockTower.service('TimeEntryService', ['$http', 'API_PATH', function($http, apiPath) {
  var getAllTimeEntries = function() {
    return $http.get('./api/time_entries');
  };

  var getTimeEntriesForProfile = function() {
    return $http.get('./api/profile/time_entries');
  };

  var createTimeEntry = function(taskId, projectId, entryDate, duration, comments) {
    var data = {
      time_entry: {
        task_id: taskId,
        project_id: projectId,
        entry_date: entryDate,
        duration_in_hours: duration,
        comments: comments
      }
    };

    return $http.post('./api/time_entries', data);
  };

  var updateTimeEntry = function(id, taskId, projectId, entryDate, duration, comments) {
    var data = {
      time_entry: {
        task_id: taskId,
        project_id: projectId,
        entry_date: entryDate,
        duration_in_hours: duration,
        comments: comments
      }
    };

    return $http.put('./api/time_entries/' + id, data);
  };

  var deleteTimeEntry = function(entryId) {
    return $http.delete('./api/time_entries/' + entryId);
  };

  return {
    all: getAllTimeEntries,
    get: getTimeEntriesForProfile,
    create: createTimeEntry,
    update: updateTimeEntry,
    delete: deleteTimeEntry
  };
}]);