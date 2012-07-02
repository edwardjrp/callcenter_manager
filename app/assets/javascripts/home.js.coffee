# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  assign_client_to_current_cart()
  assign_service_method($('#service_method_delivery'))
  assign_service_method($('#service_method_carry_out'))
  assign_service_method($('#service_method_pickup'))
  
    
  $("#client_search_phone").restric('alpha').restric('spaces')
  
  $("#client_search_phone").keyup( (event) ->
    if $(this).val().length == 0
      $('#client_search_ext').val('')
      reset_form()
    if $(this).val().length > 12
      $(this).val($(this).val().substr(0,12));
      event.preventDefault()
    if $(this).val().length < 10
      if $('.ui-autocomplete').is(':visible')  or event.which == 8
        clear_extra_data()
        $('#client_search_panel').popover('hide') if $('.popover').length > 0
    )
  $('#client_search_ext').keyup (event) ->
    if $("#client_search_phone").val() != ''
      query_phone $("#client_search"), (phones) ->
        if phones.length > 0
          query_client $("#client_search")
        else
          $('#client_search_first_name').val('')
          $('#client_search_last_name').val('')
          $('#client_search').find('fieldset').append(email_input_field_template) if $('#client_search_email').length == 0
          $('#client_search').append(button_template_no_user) if $('#user_not_found_buttons').length == 0
          hide_pop_over()
          $('#add_user_button').click (event) ->
            event.preventDefault()
            $.ajax
              type: 'POST'
              url: "/clients"
              datatype: 'json'
              data: $('#client_search').serialize()
              beforeSend: (xhr) ->
                xhr.setRequestHeader("Accept", "application/json")
              success: (response) ->
                $('#client_search_first_name').val(response.first_name.toTitleCase())
                $('#client_search_last_name').val(response.last_name.toTitleCase())
                $('#client_id').val(response.id)
                send_alert('Cliente creado.', 'success')
                $('#client_search_phone').focus()
                show_pop_over()
                clear_extra_data()
              error: (response) ->
                send_alert(response.responseText, 'error')
              
              

  $("#client_search_phone").focus().autocomplete
    minLength: 2
    source: (request, response)->
      query_phone $("#client_search"), (phones) ->
        if phones.length > 0
          response($.map(phones, (phone) ->
             phone_label = "No. #{@NumberFormatter.to_phone(phone.number)}"
             phone_label =  phone_label + " Ext. #{phone.ext}" if phone.ext?
             {label: phone_label, value: phone.number}  
          ))
          clear_extra_data()
        else
          if $("#client_search_phone").val().length >= 10
            $('.ui-autocomplete:visible').hide()
            $('#client_search_first_name').val('')
            $('#client_search_last_name').val('')
            $('#client_search').find('fieldset').append(email_input_field_template) if $('#client_search_email').length == 0
            $('#client_search').append(button_template_no_user) if $('#user_not_found_buttons').length == 0
          
    select: (event, ui) ->
        ui.item.value = window.NumberFormatter.to_phone(ui.item.value)
        $('#client_search_ext').val(ui.item.label.match(/Ext.\s+(.+)/)[1]) if ui.item.label.match(/Ext.\s+(.+)/)?
        query_client $("#client_search")

    open: ->
        $('#client_search_ext').val('')
        reset_form()


email_input_field_template = $('<div class="control-group" id="client_search_email_controls"><label class="control-label" for="email">Email</label><div class="controls"><input class="input-xlarge" id="client_search_email" name="client[email]" type="text"></div></div>')
button_template_no_user  = $('<div class="form-actions" id="user_not_found_buttons"><button type="submit" class="btn btn-primary"  id="add_user_button">Agregar usuario</button><button class="btn remote_parent left-margin-1" >Cancelar</button></div>')


assign_client_to_current_cart = () ->
  $('#client_search input').on 'keypress', (event)->
    if event.which == 13 and $('#client_id').val()? and $('#client_id').val() > 0
      $.ajax
        type: 'post'
        url: "/carts"
        datatype: 'json'
        data: {client_id: $('#client_id').val()}
        beforeSend: (xhr) ->
          xhr.setRequestHeader("Accept", "application/json")
        success: (cart_info) ->
          $('#choose_client>span').text("#{cart_info.client.first_name} #{cart_info.client.last_name}")
          hide_pop_over()
          send_alert('Cliente asignado.', 'success')
          
assign_service_method = (target)->
  target.click (event) ->
    $('#choose_service_method').text('Modo de servicio: Actualizando')
    $.ajax
      type: 'post'
      url: "/carts/service_method"
      datatype: 'json'
      data: {service_method: target.data('service-method')}
      beforeSend: (xhr) ->
        xhr.setRequestHeader("Accept", "application/json")
      success: (response)->
        $('#choose_service_method').text("Modo de servicio: #{response.service_method}")
        $('#choose_service_method_dropdown').find('i').remove()
        target.prepend $('<i class="icon-ok"></i>')
      
show_pop_over = ->
  client_found_popover_options = {animation:false, placement: "bottom", trigger:"manual", title: "Cliente encontrado", content: 'Presione ENTER para asignar este cliente a la orden actual'}
  $('#client_search_panel').popover(client_found_popover_options)
  $('#client_search_panel').popover('show')

hide_pop_over = ->
  $('#client_search_panel').popover('hide') if $('.popover').length > 0  
reset_form = () ->
  $('#client_search_first_name').val('')
  $('#client_search_last_name').val('')
  $('#client_id').val('')

clear_extra_data = () ->
  $('#client_search_email_controls').remove()  if $('#client_search_email_controls').length > 0
  $('#user_not_found_buttons').remove() if $('#user_not_found_buttons').length > 0

send_alert = (msg, type)->
  $('.container>.row>.span12').prepend($("<div class=\"alert alert-#{type}\"><button class=\"close\" data-dismiss=\"alert\">×</button>#{msg}</div>"))

query_phone = (form, cb) ->
  $.ajax
    url: '/phones'
    datatype: 'json'
    data: form.serialize()
    beforeSend: (xhr) ->
      xhr.setRequestHeader("Accept", "application/json")
    success: (phones) ->
      cb(phones)
    
query_client = (form) ->
  $.ajax
    url: 'phones/clients'
    datatype: 'json'
    data: form.serialize()
    beforeSend: (xhr) ->
      xhr.setRequestHeader("Accept", "application/json")
    success: (client)->
      if client?
        $('#client_search_first_name').val(client.first_name)
        $('#client_search_last_name').val(client.last_name)
        $('#client_id').val(client.id)
        show_pop_over()
        clear_extra_data()