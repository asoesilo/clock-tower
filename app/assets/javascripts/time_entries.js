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

  $('.modal-form').on('ajax:success', function hideModal(e, data, status, xhr){
    updateEntryRow(data.entry);
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
