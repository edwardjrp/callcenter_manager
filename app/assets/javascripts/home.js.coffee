# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  socket = window.socket
  
  if window.telephony?
    window.telephony.on 'connect', ->
      agent_id = window.pad($('#current_username').data('idnumber'), 11)
      window.telephony.emit "identificacion",{ cedula: agent_id }
      console.log "connected to telephony as #{agent_id}"

    window.telephony.on 'bridge', (phone) ->
      console.log phone
      if $('#client_search_phone').size() > 0
        $('#client_search_phone').val(phone)
        $('#client_search_phone').autocomplete("search","#{phone}")
        if $('.ui-menu-item').size() == 1
          console.log 'existing client'
          $('.ui-autocomplete:visible').hide()
          query_client()
        if $('.ui-menu-item').size() < 1
          if $("#client_search_phone").val() != ''
            console.log 'new client'
            client_create()
        window.show_alert "Llamada entrate", 'success'
      else 
        window.show_alert "Ha entrado una llamada desde #{phone} y no se encontro el formulario para colocarla", 'alert'




  $('#client_search_first_name').restric('numeric')
  $('#client_search_last_name').restric('numeric')
  $('#client_search').on 'keypress', '#client_search_idnumber', (event) ->
    if (event.which >= 97 && event.which <= 122)
      $("<div class='purr'>Solo se aceptan números en esta campo<div>").purr()


  $('#client_search').on 'blur', '#client_search_address_number', (event) ->
    target = $(event.currentTarget)
    if target.val() == ''
      if $('#client_search_address_street').val() != '' or $('#client_search_address_area').val() != '' or $('#client_search_address_city').val() != ''
        $("<div class='purr'>Inroducjo datos parciales para la dirección<div>").purr()

  if $('#client_search_panel').size() > 0
    $('#client_search_panel').on 'click', '#import_client_button', (event) ->
      event.preventDefault()
      phone = $('#client_search_phone').val()
      ext= $('#client_search_ext').val()
      unless phone? or phone.length != 10
        $("<div class='purr'>Debe ingresar un numero telefonico valido<div>").purr()
      else
        $("#import_client_modal").modal('show')
        $("#import_client_modal").find('.modal-footer').remove()
        socket.emit 'clients:olo:phone', {phone: window.NumberFormatter.to_clear(phone), ext: ext}, (response)->
          if response? and response.type == 'success'
            if _.any(response.data)
              clients = response.data
              clients = [clients] unless _.isArray(clients)
              $("#import_client_modal").find('.modal-body').html(JST['clients/import_client'](clients: clients))
              $('#import_client_wizard').data('clients', clients)
              $('#import_client_wizard').smartWizard
                labelNext: 'Siguiente'
                labelPrevious: 'Anterior'
                labelFinish: 'Terminar'
                onLeaveStep:leaveAStepCallback
                onFinish: FinishCallBack
            else
              $("#import_client_modal").modal('hide')
              $("<div class='purr'>No hay clientes en olo2 con este numero telefonico<div>").purr()
          else
            $("<div class='purr'>#{response.data}<div>").purr()
    
  $('.set_target_store_address').on 'click', (event)->
    target = $(event.currentTarget)
    $.ajax
      type: 'POST'
      url: "/carts/current_store"
      datatype: 'json'
      data: { order_target: { store_id: target.data('store-id'), address_id: target.data('address-id')} }
      beforeSend: (xhr) ->
        xhr.setRequestHeader("Accept", "application/json")
      success: (cart)->
        $('#choose_store').text("Tienda : #{cart.store.name}")
        $('.set_target_store_address').find('i').remove()
        $('.set_target_store').find('i').remove()
        $(".set_target_store_address[data-address-id=#{cart.client.target_address_id}]").prepend('<i class="icon-bookmark">')
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
             phone_label = "#{@NumberFormatter.to_phone(phone.number)}"
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
        clear_extra_data()
        window.show_popover($('#client_search_panel'), 'Cliente asignado', 'Presione ENTER para asignar el cliente creado a la orden actual.')
      error: (response) ->
        window.show_alert(response.responseText, 'error')

leaveAStepCallback = (obj)->
  isStepValid = true
  step_num = obj.attr('rel')
  clients = $('#import_client_wizard').data('clients')
  if step_num == '1' || step_num == 1
    isStepValid = false if $('#step-1').find('input[type=radio]:checked').size() == 0
    if isStepValid == false 
      $('#import_client_wizard').smartWizard('showMessage','Debe selecionar un cliente primero')
    else
      $('#import_client_wizard').find('.msgBox').fadeOut("normal")
      current_client = _.find clients, (client) -> client.id == Number($('#step-1').find('input[type=radio]:checked').val())
      $('#import_client_wizard').smartWizard('showMessage',"Solor podra importar 4 de las #{current_client.addresses.length} direcciones de este cliente") if current_client.addresses > 4
      _.each _.first(current_client.addresses, 4), (address) ->
        $('#import_client_wizard').find("#import_address_list").find('.row').append(JST['clients/import_address'](address: address)) if $("#import_address_#{address.id}").size() == 0
        $("#client_address_city_#{address.id}").select2
            placeholder: "Seleccione una Ciudad"
            data: _.map($('#client_search').find('fieldset').data('cities'), (c)-> {id: c.id, text: c.name})
        $("#client_address_area_#{address.id}").select2
          placeholder: "Seleccione un sector"
          minimumInputLength: 2
          ajax:
            url: '/addresses/areas.json'
            datatype: 'json'
            data: (term, page)->
              console.log address
              q:term
              city_id: $("#client_address_city_#{address.id}").val()
            results: (areas, page)->
              results: _.map(areas, (area)->
                  {id: area.id, text: area.name}
                )
        $("#client_address_street_#{address.id}").select2
          placeholder: "Seleccione una calle"
          minimumInputLength: 1
          ajax:
            url: '/addresses/streets.json'
            datatype: 'json'
            data: (term, page)->
              q:term
              area_id: $("#client_address_area_#{address.id}").val()
            results: (streets, page)->
              results: $.map(streets, (street)->
                  {id: street.id, text: street.name}
                )
  else if step_num == '2' || step_num == 2
    if _.any(_.map($('#import_client_wizard').find("#import_address_list").find('.street_selection'), (street_el)-> $(street_el).select2('val')), (street_el_val)-> street_el_val == '')
      $('#import_client_wizard').smartWizard('showMessage','Las direcciones donde no ha elegido una calle no serán importadas')
    else
      $('#import_client_wizard').find('.msgBox').fadeOut("normal")
    current_client = _.find clients, (client) -> client.id == Number($('#step-1').find('input[type=radio]:checked').val())
    _.each _.first(current_client.addresses, 4), (address) ->
      $('#import_client_wizard').find("#import_phone_list").find('.row').append(JST['clients/import_phone'](address: address)) if $("#import_phone_#{address.id}").size() == 0
  else if step_num == '3' || step_num == 3
    if $('#import_client_wizard').find("#import_phone_list").find('input[type=checkbox]:checked').size() < 1
      isStepValid = false
      $('#import_client_wizard').smartWizard('showMessage','Debe importar al menos un numero telefonico')
    else
      $('#import_client_wizard').find('.msgBox').fadeOut("normal")
  isStepValid
  
FinishCallBack = (obj)->
  isValid = true
  clients = $('#import_client_wizard').data('clients')
  current_client = _.find clients, (client) -> client.id == Number($('#step-1').find('input[type=radio]:checked').val())
  address_obj_array = _.uniq(_.compact(_.map($('#import_client_wizard').find("#import_address_list").find('.street_selection'), (street_el)-> $(street_el).closest('ul')[0] if $(street_el).select2('val') !='')))
  addresses = []
  _.each address_obj_array, (address_obj)->
    address =
      client_id: current_client.id
      street_id: $(address_obj).find('.street_selection:first').select2('val')
      number: $(address_obj).find('.number_selected:first').text()
      unit_type: $(address_obj).find('.unit_type_selected:first').text()
      unit_number: $(address_obj).find('.unit_number_selected:first').text()
      postal_code: $(address_obj).find('.postal_code_selected:first').text()
      delivery_instructions: $(address_obj).find('.delivery_instructions_selected:first').text()
    addresses.push address

  phone_obj_array = _.uniq(_.compact(_.map($('#import_client_wizard').find("#import_phone_list").find('.phone_selection'), (phone_el)-> $(phone_el).closest('ul')[0] if $(phone_el).is(':checked'))))
  phones = []
  _.each phone_obj_array, (phone_obj)->
    phone =
      number: $(phone_obj).find('.number_selected:first').text()
      ext: $(phone_obj).find('.ext_selected:first').text()
    phones.push(phone)

  new_client = 
    first_name: current_client.name
    last_name: current_client.last_name
    email: current_client.email
    idnumber: current_client.idnumber
    active: (current_client.state != 'disabled')
    phones_attributes: phones
    addresses_attributes: addresses

  if current_client? and  _.any(phones)
    $.ajax
      type: 'POST'
      url: '/clients/import'
      datatype: 'json'
      data: {client: new_client}
      beforeSend: (xhr)->
        xhr.setRequestHeader("Accept", "application/json")
      success: (saved_client)->
        console.log saved_client
        $("#import_client_modal").modal('hide')
        clear_extra_data()
        set_form_import(saved_client, _.find(phones, (phone)-> phone.number == $('#client_search_phone').val()))
        $('#client_search_phone').focus()
      error: (err)->
        error = JSON.parse(err.responseText)
        if error.msg?
          $('#import_client_wizard').smartWizard('showMessage',"El cliente ya esta presente")
        else
          $('#import_client_wizard').smartWizard('showMessage',"Un error impidio la importación")
  else
    isValid = false
  isValid

set_form_import = (client, phone)->
  $('#client_search_phone').val(window.to_phone(phone.number))
  $('#client_search_ext').val(phone.ext)
  $('#client_search_first_name').val(client.first_name)
  $('#client_search_first_name').attr('readonly', 'readonly')
  $('#client_search_last_name').val(client.last_name)
  $('#client_search_last_name').attr('readonly', 'readonly')
  $('#client_id').val(client.id)
  window.show_popover($('#client_search_panel'), 'Cliente Importado', 'Presione ENTER para asignar el cliente importado a la orden actual.')

client_create =  ()->
  $('#import_client').show()
  $('#client_search_first_name').val('')
  $('#client_search_first_name').removeAttr('readonly')
  $('#client_search_last_name').val('')
  $('#client_search_last_name').removeAttr('readonly')
  $('#client_search').find('fieldset').append(JST['clients/client_extra_fields']()) if $('#client_search_email').length == 0
  $('#client_search_idnumber').restric('alpha').restric('spaces')
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
  window.del($('#client_search_tax_number_rnc_controls'))
  window.del($('#client_search_tax_number_fiscal_type_controls'))
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