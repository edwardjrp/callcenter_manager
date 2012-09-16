# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  if $('#import_logs_list').size() > 0
    setInterval (->
      refresh()
    ), 10000

refresh = () ->
  $.ajax
    url: '/admin/import_logs'
    type: 'GET'
    beforeSend: (xhr) ->
      xhr.setRequestHeader("Accept", "application/json")
    success: (import_logs) ->
      present_import_log = _.map($('.import_logs'), (dom_import_log)-> $(dom_import_log).data('import-log-id'))
      sent_import_logs = _.map(import_logs, (import_log)-> import_log.id)
      new_import_logs = _.difference(present_import_log, sent_import_logs)
      for import_log in import_logs
        unless _.include present_import_log,  import_log.id
          $('#import_logs_list').find('tbody').prepend("<tr><td>#{import_log.log_type}</td><td>#{import_log.state}</td><td>#{import_log.created_at}</td><td></td></tr>")
