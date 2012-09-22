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
    type: 'GET'
    url: '/admin/import_logs'
    datatype: 'script'
    data: data: { page: ( window.getParameterByName('page') || 1 ) }
    success: (script) ->
      eval(script)