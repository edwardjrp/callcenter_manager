# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery -> 
  $('#report_clear_search').click (event)->
    $(this).closest('form')[0].reset()
    $(this).closest('form').find("input[type='text']").val('')

  $('.datepicker').datepicker
    dateFormat: 'yy-mm-dd'
    maxDate: new Date()