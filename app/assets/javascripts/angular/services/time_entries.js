'use strict';

var ClockTower = angular.module('ClockTower');
ClockTower.service('TimeEntryService', ['$http', 'API_PATH', function($http, apiPath) {
  var getTimeEntries = function() {
    return $http.get('./api/time_entries');
  }

  var createTimeEntry = function(userId, taskId, projectId, entryDate, duration, comments) {
    var data = {
      time_entry: {
        user_id: userId,
        task_id: taskId,
        project_id: projectId,
        entry_date: entryDate,
        duration_in_hours: duration,
        comments: comments
      }
    };

    return $http.post('./api/time_entries', data);
  }

  return {
    all: getTimeEntries,
    create: createTimeEntry
  };
}]);