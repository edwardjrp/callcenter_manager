# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $("#client_search_phone").restric('alpha').restric('spaces')
  $("#client_search_phone").keyup( (event) ->
    if $(this).val().length > 12
      $(this).val($(this).val().substr(0,12));
      event.preventDefault()
    if $(this).val().length < 10
      $('#user_not_found_buttons').remove() if $('#user_not_found_buttons').length > 0 and ($('.ui-autocomplete').is(':visible')  or event.which == 8 )
    )
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
          console.log(data.length)
          if data.length > 0
          	response($.map(data, (phone) ->
	             phone_label = "No. #{@NumberFormatter.to_phone(phone.number)}"
	             phone_label =  phone_label + " Ext. #{phone.ext}" if phone.ext?
	             {label: phone_label, value: phone.number}  
	          ))
	          $('#user_not_found_buttons').remove() if $('#user_not_found_buttons').length > 0
          else
            $('.ui-autocomplete:visible').hide()
            $('#client_search_first_name').val('')
            $('#client_search_last_name').val('')
            $('#client_search').append(button_template_no_user) if $('#user_not_found_buttons').length == 0
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

button_template_no_user  = $('<div class="form-actions" id="user_not_found_buttons"><button type="submit" class="btn btn-primary"  id="add_user_button">Agregar usuario</button><button class="btn remote_parent left-margin-1" >Cancelar</button></div>')