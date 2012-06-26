# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $("#client_search_phone").focus().autocomplete
    minLength: 2
    source: (request, response)->
      $.ajax
        url: '/phones'
        datatype: 'json'
        data: $("#client_search").serialize()
        beforeSend: (xhr) ->
          xhr.setRequestHeader("Accept", "application/json")
        success: (data)->
          # console.log(data)
          response($.map(data, (phone)->
            {label: 'No.'+@NumberFormatter.to_phone(phone.number)+' Ext.'+phone.ext, value: phone.number}  
          ))
       
           