# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  if $('#olo_client_list').size() > 0
    socket = window.socket
    page = 1

    socket.emit 'clients:olo:index', {page: page}, (response)->
      $('#olo_client_list').html(JST['admin/clients/olo_index'](clients: response.data, page: page))

    $('#olo_client_list').on 'click', '.prev a', (event)->
      event.preventDefault()
      page--
      page = 1 if page < 1
      socket.emit 'clients:olo:index', {page: page}, (response)->
        $('#olo_client_list').html(JST['admin/clients/olo_index'](clients: response.data, page: page))

    $('#olo_client_list').on 'click', '.next a', (event)->
      event.preventDefault()
      page++ 
      socket.emit 'clients:olo:index', {page: page}, (response)->
        $('#olo_client_list').html(JST['admin/clients/olo_index'](clients: response.data, page: page))

    $('#olo_client_list').on 'click', '.olo_client_import', (event)->
      target = $(event.currentTarget)
      $("#admin_import_client_modal").modal('show')
      $("#admin_import_client_modal").find('.modal-footer').remove()
      socket.emit 'clients:olo:show', {id: target.closest('tr').data('client-id')}, (response)->
        if response? and response.type == 'success'
          if _.any(response.data)
            client = response.data
            $("#admin_import_client_modal").find('.modal-body').html(JST['admin/clients/admin_import_client']())
            $('#admin_import_client_wizard').data('client', client)
            $('#admin_import_client_wizard').smartWizard
              labelNext: 'Siguiente'
              labelPrevious: 'Anterior'
              labelFinish: 'Terminar'
              onLeaveStep:leaveAStepCallback
              onFinish: FinishCallBack
            $('#admin_import_client_wizard').smartWizard('showMessage',"Solor podra importar 4 de las #{client.addresses.length} direcciones de este cliente") if client.addresses > 4
            _.each _.first(client.addresses, 4), (address) ->
              $('#admin_import_client_wizard').find("#import_address_list").find('.row').append(JST['clients/import_address'](address: address)) if $("#import_address_#{address.id}").size() == 0
              $("#client_address_city_#{address.id}").select2
                  placeholder: "Seleccione una Ciudad"
                  data: _.map($('#olo_client_list').data('cities'), (c)-> {id: c.id, text: c.name})
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
          else
            $("#admin_import_client_modal").modal('hide')
            $("<div class='purr'>Este cliente parece no estar presente en OLO<div>").purr()
        else
          $("<div class='purr'>#{response.data}<div>").purr()

leaveAStepCallback = (obj)->
  isStepValid = true
  step_num = obj.attr('rel')
  client = $('#admin_import_client_wizard').data('client')
  console.log step_num
  console.log client
  if step_num == '1' || step_num == 1
    if _.any(_.map($('#admin_import_client_wizard').find("#import_address_list").find('.street_selection'), (street_el)-> $(street_el).select2('val')), (street_el_val)-> street_el_val == '')
      $('#admin_import_client_modal').smartWizard('showMessage','Las direcciones donde no ha elegido una calle no serán importadas')
    else
      $('#admin_import_client_modal').find('.msgBox').fadeOut("normal")
    current_client = client
    _.each _.first(current_client.addresses, 4), (address) ->
      $('#admin_import_client_modal').find("#import_phone_list").find('.row').append(JST['clients/import_phone'](address: address)) if $("#import_phone_#{address.id}").size() == 0
  else if step_num == '2' || step_num == 2
    if $('#admin_import_client_modal').find("#import_phone_list").find('input[type=checkbox]:checked').size() < 1
      isStepValid = false
      $('#admin_import_client_modal').smartWizard('showMessage','Debe importar al menos un numero telefonico')
    else
      $('#admin_import_client_modal').find('.msgBox').fadeOut("normal")
  isStepValid

FinishCallBack = (obj)->
  console.log 'ending'
  isValid = true
  client = $('#admin_import_client_wizard').data('client')
  address_obj_array = _.uniq(_.compact(_.map($('#admin_import_client_wizard').find("#import_address_list").find('.street_selection'), (street_el)-> $(street_el).closest('ul')[0] if $(street_el).select2('val') !='')))
  addresses = []
  _.each address_obj_array, (address_obj)->
    address =
      client_id: client.id
      street_id: $(address_obj).find('.street_selection:first').select2('val')
      number: $(address_obj).find('.number_selected:first').text()
      unit_type: $(address_obj).find('.unit_type_selected:first').text()
      unit_number: $(address_obj).find('.unit_number_selected:first').text()
      postal_code: $(address_obj).find('.postal_code_selected:first').text()
      delivery_instructions: $(address_obj).find('.delivery_instructions_selected:first').text()
    addresses.push address

  phone_obj_array = _.uniq(_.compact(_.map($('#admin_import_client_wizard').find("#import_phone_list").find('.phone_selection'), (phone_el)-> $(phone_el).closest('ul')[0] if $(phone_el).is(':checked'))))
  phones = []
  _.each phone_obj_array, (phone_obj)->
    phone =
      number: $(phone_obj).find('.number_selected:first').text()
      ext: $(phone_obj).find('.ext_selected:first').text()
    phones.push(phone)

  new_client = 
    first_name: client.name
    last_name: client.last_name
    email: client.email
    idnumber: client.idnumber
    active: (client.state != 'disabled')
    phones_attributes: phones
    addresses_attributes: addresses

  if client? and  _.any(phones)
    $.ajax
      type: 'POST'
      url: '/clients/import'
      datatype: 'json'
      data: {client: new_client}
      beforeSend: (xhr)->
        xhr.setRequestHeader("Accept", "application/json")
      success: (saved_client)->
        console.log saved_client
        $("#admin_import_client_modal").modal('hide')
        window.show_alert('El cliente se importo desde olo 2, por favor confirme que aparece en el listado de cleintes local', 'success')
      error: (err)->
        $('#admin_import_client_wizard').smartWizard('showMessage',"Un error impidio la importación")
  else
    isValid = false
  isValid