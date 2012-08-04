# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  assign_client_to_current_cart()
  assign_service_method($('#service_method_delivery'))
  assign_service_method($('#service_method_carry_out'))
  assign_service_method($('#service_method_pickup'))
  
  console.log JST['test'](t: 'super')
    
  $('.set_last_address').on 'click', (event)->
    target = $(event.currentTarget)
    $.ajax
      type: 'POST'
      url: "/carts/current_store"
      datatype: 'json'
      data: {order_target: { store_id: target.data('store-id'), address_id: target.data('address-id')}}
      beforeSend: (xhr) ->
        xhr.setRequestHeader("Accept", "application/json")
      success: (cart)->
        $('#choose_store').text("Tienda : #{cart.store.name}")
        $('.set_last_address').find('i').remove()
        $('.set_target_store').find('i').remove()
        $(".set_last_address[data-address-id=#{cart.client.target_address_id}]").prepend('<i class="icon-bookmark">')
        $(".set_target_store[data-store-id=#{cart.store.id}]").prepend('<i class="icon-ok">')
        
  $('.set_target_store').on 'click', (event)->
    target = $(event.currentTarget)
    $.ajax
      type: 'POST'
      url: "/carts/current_store"
      datatype: 'json'
      data: {order_target: { store_id: target.data('store-id')}}
      beforeSend: (xhr) ->
        xhr.setRequestHeader("Accept", "application/json")
      success: (cart)->
        $('#choose_store').text("Tienda : #{cart.store.name}")
        $('.set_target_store').find('i').remove()
        $(".set_target_store[data-store-id=#{cart.store.id}]").prepend('<i class="icon-ok">')
          

  
  $("#client_search_phone").blur ->
    $("#client_search_phone").val window.NumberFormatter.to_phone($("#client_search_phone").val())
  $("#client_search_phone").focus ->
    $("#client_search_phone").val window.NumberFormatter.to_clear($("#client_search_phone").val())  
  $("#client_search_phone").restric('alpha').restric('spaces')
  
  $("#client_search_phone").keyup( (event) ->
    if $(this).val().length == 0
      $('#client_search_ext').val('')
      reset_form()
    if $(this).val().length > 10
      $(this).val($(this).val().substr(0,10))  unless event.which == 13
      event.preventDefault()
    if $(this).val().length < 10
      if $('.ui-autocomplete').is(':visible')  or event.which == 8
        clear_extra_data()
        window.hide_popover($('#client_search_panel'))
    )
  $('#client_search_ext').keyup (event) ->
    if $("#client_search_phone").val() != ''
      query_phone $("#client_search"), (phones) ->
        if phones.length > 0
          query_client $("#client_search")
        else
          window.hide_popover($('#client_search_panel'))
          client_create()
              
              

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
            client_create()
          
    select: (event, ui) ->
        ui.item.value = window.NumberFormatter.to_phone(ui.item.value)
        $('#client_search_ext').val(ui.item.label.match(/Ext.\s+(.+)/)[1]) if ui.item.label.match(/Ext.\s+(.+)/)?
        query_client $("#client_search")

    open: ->
        $('#client_search_ext').val('')
        reset_form()

email_input_field_template = $('<div class="control-group" id="client_search_email_controls"><label class="control-label" for="email">Email</label><div class="controls"><input class="input-xlarge" id="client_search_email" name="client[email]" type="text"></div></div>')
city_select_template = $('<div class="control-group" id="client_search_address_city_controls"><label class="control-label" for="client_search_address_city">Ciudad</label><div class="controls"><select id="client_search_address_city"></select></div></div>')
area_select_template = $('<div class="control-group" id="client_search_address_area_controls"><label class="control-label" for="client_search_address_area">Sector</label><div class="controls"><input type="hidden" id="client_search_address_area" style=" display: none; "></div></div>')
street_select_template = $('<div class="control-group" id="client_search_address_street_controls"><label class="control-label" for="client_search_address_street">Calle</label><div class="controls"><input type="hidden" id="client_search_address_street" name="client[address][street_id]" style=" display: none; "></div></div>')
number_input_template = $('<div class="control-group" id="client_search_address_number_controls"><label class="control-label" for="client_search_address_number">No.</label><div class="controls"><input type="text" id="client_search_address_number" name="client[address][number]"></div></div>')
unit_type_select_template = $('<div class="control-group" id="client_search_address_unit_type_controls"><label class="control-label" for="client_search_address_unit_type">Tipo.</label><div class="controls"><select id="client_search_address_unit_type" name="client[address][unit_type]"><option value="casa">Casa</option><option value="oficina">Oficina</option><option value="edificio">Edificio</option></select></div></div>')
unit_number_input_template = $('<div class="control-group" id="client_search_address_unit_number_controls"><label class="control-label" for="client_search_address_unit_number">No. unidad</label><div class="controls"><input type="text" id="client_search_address_unit_number" name="client[address][unit_number]"></div></div>')
postal_code_input_template = $('<div class="control-group" id="client_search_address_postal_code_controls"><label class="control-label" for="client_search_address_postal_code">Codigo postal</label><div class="controls"><input type="text" id="client_search_address_postal_code" name="client[address][postal_code]"></div></div>')
delivery_instructions_input_template= $('<div class="control-group" id="client_search_address_delivery_instructions_controls"><label class="control-label" for="client_search_address_delivery_instructions">Instrucciones</label><div class="controls"><textarea id="client_search_address_delivery_instructions" rows=3 class="input-xlarge" name="client[address][delivery_instructions]"></textarea></div></div>')
button_template_no_user  = $('<div class="form-actions" id="user_not_found_buttons"><button type="submit" class="btn btn-primary"  id="add_client_button">Agregar usuario</button><button class="btn remote_parent left-margin-1" >Cancelar</button></div>')


client_create =  ()->
  $('#client_search_first_name').val('')
  $('#client_search_last_name').val('')
  $('#client_search').find('fieldset').append(email_input_field_template) if $('#client_search_email').length == 0
  $('#client_search').find('fieldset').append(city_select_template) if $('#client_search_address_city_controls').length == 0
  fill_option() if $('#client_search_address_city').find('option').length == 0
  $('#client_search_address_city').select2()
  $('#client_search').find('fieldset').append(area_select_template) if $('#client_search_address_area_controls').length == 0
  $('#client_search_address_area').select2
      placeholder: "Seleccione un sector"
      minimumInputLength: 2
      ajax:
        url: '/addresses/areas.json'
        datatype: 'json'
        data: (term, page)->
          q:term
          city_id: $('#client_search_address_city').val()
        results: (areas, page)->
          results: $.map(areas, (area)->
              {id: area.id, text: area.name}
            )
  $('#client_search').find('fieldset').append(street_select_template) if $('#client_search_address_street_controls').length == 0
  $('#client_search_address_street').select2
      placeholder: "Seleccione una calle"
      minimumInputLength: 1
      ajax:
        url: '/addresses/streets.json'
        datatype: 'json'
        data: (term, page)->
          q:term
          area_id: $('#client_search_address_area').val()
        results: (streets, page)->
          results: $.map(streets, (street)->
              {id: street.id, text: street.name}
            )
  $('#client_search').find('fieldset').append(number_input_template) if $('#client_search_address_number_controls').length == 0   
  $('#client_search').find('fieldset').append(unit_type_select_template) if $('#client_search_address_unit_type_controls').length == 0   
  $('#client_search').find('fieldset').append(unit_number_input_template) if $('#client_search_address_unit_number_controls').length == 0      
  $('#client_search').find('fieldset').append(postal_code_input_template) if $('#client_search_address_postal_code_controls').length == 0                 
  $('#client_search').find('fieldset').append(delivery_instructions_input_template) if $('#client_search_address_delivery_instructions_controls').length == 0
  $('#client_search').append(button_template_no_user) if $('#user_not_found_buttons').length == 0
  unless $('#add_client_button').data("events")? and $('#add_client_button').data("events").click? and $('#add_client_button').data("events").click.length > 0
    $('#add_client_button').on 'click', (event) ->
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
          window.show_alert('Cliente creado.', 'success')
          $('#client_search_phone').focus()
          window.show_popover($('#client_search_panel'), 'Cliente asignado', 'Presione ENTER para asignar el cliente creado a la orden actual.')
          clear_extra_data()
        error: (response) ->
          window.show_alert(response.responseText, 'error')

fill_option = ()->
  $.each $('#client_search').find('fieldset').data('cities'), (index, value) ->
    $('#client_search_address_city').append($("<option value=#{value[0]}>#{value[1]}</option>"))

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
          $('#choose_client').effect('highlight')
          window.hide_popover($('#client_search_panel'))
          window.show_alert('Cliente asignado.', 'success')
          
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
        window.del($('#choose_service_method_dropdown').find('i'))
        target.prepend $('<i class="icon-ok"></i>')
      
reset_form = ->
  $('#client_search_first_name').val('')
  $('#client_search_last_name').val('')
  $('#client_id').val('')
  window.hide_popover($('#client_search_panel'))

clear_extra_data = () ->
  $('#client_search_email').val('')
  window.del($('#client_search_email_controls'))
  window.del($('#user_not_found_buttons'))
  $("#client_search_address_city").select2("destroy")
  $('#client_search_address_area').select2("destroy")
  $('#client_search_address_street').select2("destroy")
  window.del($('#client_search_address_city_controls'))
  window.del($('#client_search_address_area_controls'))
  window.del($('#client_search_address_street_controls'))
  window.del($('#client_search_address_number_controls'))
  window.del($('#client_search_address_unit_type_controls'))
  window.del($('#client_search_address_unit_number_controls'))
  window.del($('#client_search_address_postal_code_controls'))
  window.del($('#client_search_address_delivery_instructions_controls'))

query_phone = (form, cb) ->
  $.ajax
    url: '/phones'
    datatype: 'json'
    data: form.serialize()
    beforeSend: (xhr) ->
      xhr.setRequestHeader("Accept", "application/json")
    success: (phones) ->
      cb(phones)
    error: (jqXHR, textStatus, errorThrown) ->
      console.log(errorThrown)
      console.log(textStatus)
    
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
        window.show_popover($('#client_search_panel'), "Cliente encontrado", 'Presione ENTER para asignar este cliente a la orden actual')
        clear_extra_data()
    error: (jqXHR, textStatus, errorThrown) ->
      console.log(errorThrown)
      console.log(jqXHR.responseText)
      console.log(jqXHR.statusCode())
      console.log(textStatus)