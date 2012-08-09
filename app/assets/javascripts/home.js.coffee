# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  assign_client_to_current_cart()
  assign_service_method($('#service_method_delivery'))
  assign_service_method($('#service_method_carry_out'))
  assign_service_method($('#service_method_pickup'))
    
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

  $('#client_search_panel').on 'click', '#add_client_button', (event) ->
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


client_create =  ()->
  $('#import_client').show()
  $('#client_search_first_name').val('')
  $('#client_search_first_name').removeAttr('readonly')
  $('#client_search_last_name').val('')
  $('#client_search_last_name').removeAttr('readonly')
  $('#client_search').find('fieldset').append(JST['clients/client_extra_fields']()) if $('#client_search_email').length == 0
  $('#client_search_address_city').select2
    placeholder: "Seleccione una Ciudad"
    data: _.map($('#client_search').find('fieldset').data('cities'), (c)-> {id: c.id, text: c.name})
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
          results: _.map(areas, (area)->
              {id: area.id, text: area.name}
            )
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
          $('#choose_client').text("Cliente: #{cart_info.client.first_name} #{cart_info.client.last_name}").attr('href', "/clients/#{cart_info.client.id}")
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
  $('#client_search_first_name').attr('readonly', 'readonly')
  $('#client_search_last_name').val('')
  $('#client_search_last_name').attr('readonly', 'readonly')
  $('#client_id').val('')
  window.hide_popover($('#client_search_panel'))

clear_extra_data = () ->
  $('#import_client').hide()
  $('#client_search_first_name').attr('readonly', 'readonly')
  $('#client_search_last_name').attr('readonly', 'readonly')
  $('#client_search_email').val('')
  window.del($('#client_search_email_controls'))
  window.del($('#client_search_idnumber_controls'))
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