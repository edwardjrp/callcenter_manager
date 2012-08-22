
jQuery ->
  if $('#client_merge').size() > 0
    target_client = {}
    source_client = {}
    merged_client = {}

    $('#client_merge').smartWizard
      labelNext: 'Siguiente'
      labelPrevious: 'Anterior'
      labelFinish: 'Terminar'
      onLeaveStep: (obj)->
        step_num= obj.attr('rel')
        isValidStep = true
        switch step_num
          when '1'
            if _.isEmpty(target_client)
              isValidStep = false
              $('#client_merge').smartWizard('showMessage',"Debe elegir un cliente")
            else
              $('#client_merge').find('.msgBox').fadeOut("normal")
          when '2'
            if _.isEmpty(source_client)
              isValidStep = false
              $('#client_merge').smartWizard('showMessage',"Debe elegir un cliente")
            else
              if target_client.id == source_client.id
                isValidStep = false
                $('#client_merge').smartWizard('showMessage',"El cliente a importar debe ser diferente")
              else
                $('#client_merge').find('.msgBox').fadeOut("normal")
                $('#step-3').find('#client_personal_data_merge').html(JST['admin/clients/client_merge_personal'](target_client: target_client, source_client: source_client))
          when '3'
            unless mandatory_fields_check()
              isValidStep = false
              $('#client_merge').smartWizard('showMessage',"Debe elegir los valores a importar, algunos valores son obligatorios")
            else
              $('#client_merge').find('.msgBox').fadeOut("normal")
              build_merger_client()
              console.log merged_client
              $('#merge_client_confirmation').html(JST['admin/clients/merged_client'](merged_client:merged_client))
        isValidStep

  

    $('#step-1').on 'click','.client_merge_search', (event)->
      event.preventDefault()
      form =$('#step-1').find('form')
      $.ajax
        type: 'GET'
        url: form.attr('action')
        data: form.serialize()
        datatype: 'JSON'
        beforeSend: (xhr)->
          xhr.setRequestHeader("Accept", "application/json")
        success: (clients)->
          $('#choose_destination_client').data('clients', clients)
          $('#choose_destination_client').html(JST['admin/clients/client_merge_table'](clients:clients))
        error: (err)->
          console.log err

    $('#step-2').on 'click','.client_merge_search', (event)->
      event.preventDefault()
      form =$('#step-2').find('form')
      $.ajax
        type: 'GET'
        url: form.attr('action')
        data: form.serialize()
        datatype: 'JSON'
        beforeSend: (xhr)->
          xhr.setRequestHeader("Accept", "application/json")
        success: (clients)->
          $('#choose_source_client').data('clients', clients)
          $('#choose_source_client').html(JST['admin/clients/client_merge_table'](clients:clients))
        error: (err)->
          console.log err

    $('#choose_destination_client').on 'click' , '.client_selection', (event)->
      target = $(event.currentTarget)
      target_client = _.find($('#choose_destination_client').data('clients'), (client)-> client.id ==  $('#choose_destination_client').find('input[type=radio]:checked').data('client-id'))

    $('#choose_source_client').on 'click' , '.client_selection', (event)->
      target = $(event.currentTarget)
      source_client = _.find($('#choose_source_client').data('clients'), (client)-> client.id ==  $('#choose_source_client').find('input[type=radio]:checked').data('client-id'))

  mandatory_fields_check = ()->
    isValid = true
    isValid = false if $('#client_personal_data_merge').find("input[name='client_merge_first_name']:checked").length == 0
    isValid = false if $('#client_personal_data_merge').find("input[name='client_merge_last_name']:checked").length == 0
    isValid = false if $('.merge_phone_selection:checked').length == 0
    isValid    

  build_merger_client = ()->
    merged_client.first_name = $('#client_personal_data_merge').find("input[name='client_merge_first_name']:checked").closest('td').data('client-first-name')
    merged_client.last_name = $('#client_personal_data_merge').find("input[name='client_merge_last_name']:checked").closest('td').data('client-last-name')
    merged_client.idnumber = $('#client_personal_data_merge').find("input[name='client_merge_idnumber']:checked").closest('td').data('client-idnumber')
    merged_client.email = $('#client_personal_data_merge').find("input[name='client_merge_email']:checked").closest('td').data('client-email')
    selected_phones = _.map($('.merge_phone_selection:checked').closest('tr'), (select_phone)-> $(select_phone).data('client-phone-id'))
    merged_client.phones_attributes = _.filter(_.union(target_client.phones , source_client.phones), (phone)-> _.include( selected_phones,phone.id))
    selected_addresses = _.map($('.merge_address_selection:checked').next(), (select_address)-> $(select_address).data('client-address-id'))
    merged_client.addresses_attributes = _.filter(_.union(target_client.addresses , source_client.addresses), (address)-> _.include(selected_addresses,address.id))