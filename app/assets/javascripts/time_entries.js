$(function(){

  function formatDate(dateString){
    return moment(dateString).format('MMMM D[,] YYYY');
  };

  function updateEntryRow(entry){
    var tr = $("#entry-" + entry.id);

    tr.find('.task').text(entry.task.name);
    tr.find('.project').text(entry.project.name);
    tr.find('.date').text(formatDate(entry.date));
    tr.find('.hours').text(entry.duration_in_hours);
    tr.find('.comments').text(entry.comments);
  };

  $('#entry-edit').on('show.bs.modal', function setTimeEntryValues(e){
    var button = $(e.relatedTarget);
    var modal = $(this);
    var form = modal.find('#modal-form');

    var entryId = button.data('entryId');
    var url = ("/api/time_entries/" + entryId);
    if (button.data('admin') === true) {
      url = '/admin' + url
    }
    var project = button.data('projectId');
    var task = button.data('taskId');
    var hours = button.data('duration');
    var comments = button.data('comments');
    var entryDate = button.data('entryDate');
    // Entry date is a string with "", ex: '"2016-03-14"', This removes the ""
    entryDate = entryDate.replace(/"/g, '');

    modal.find('#project').val(project);
    modal.find('#task').val(task);
    modal.find('#hours').val(hours);
    modal.find('#entry_date').val(formatDate(entryDate));
    modal.find('#comments').val(comments);

    form.prop('action', url);
  });

  $('.modal-form').on('ajax:success', function hideModal(e, data, status, xhr){
    updateEntryRow(data.entry);
    console.log('hid')
    $('#entry-edit-' + data.entry.id).modal('hide');
  }).on('ajax:error', function alertErrors(e, data, status, xhr){
    alert('Could not edit Time Entry, ', data.responseJSON.errors);
  });

  $('.delete').on('ajax:success', function(e, data, status, xhr){
    $(this).closest('tr').remove();
  }).on('ajax:error', function alertErrors(e, data, status, xhr){
    alert('Could not delete Time Entry, ', data.responseJSON.errors);
  });
});
