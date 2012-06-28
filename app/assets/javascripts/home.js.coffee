# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $("#client_search_phone").restric 'alpha'
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
          response($.map(data, (phone) ->
             phone_label = "No. #{@NumberFormatter.to_phone(phone.number)}"
             phone_label =  phone_label + " Ext. #{phone.ext}" if phone.ext?
             {label: phone_label, value: phone.number}  
          ))
    select: (event, ui) ->
        ui.item.value = window.NumberFormatter.to_phone(ui.item.value)
        $('#client_search_ext').val(ui.item.label.match(/Ext.\s+(.+)/)[1]) if ui.item.label.match(/Ext.\s+(.+)/)?
        $.ajax
          url: 'phones/clients'
          datatype: 'json'
          data: $("#client_search").serialize()
          beforeSend: (xhr) ->
            xhr.setRequestHeader("Accept", "application/json")
          success: (data)->
            if data?
              $('#client_search_first_name').val(data.first_name)
              $('#client_search_last_name').val(data.last_name)
            

    open: ->
        $('#client_search_ext').val('')
        $('#client_search_first_name').val('')
        $('#client_search_last_name').val('')
           