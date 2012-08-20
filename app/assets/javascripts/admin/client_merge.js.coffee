
jQuery ->
  if $('#client_merge').size() > 0
    target_client = {}
    source_client = {}

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
              $('#client_merge').find('.msgBox').fadeOut("normal")
              $('#step-3').find('#client_personal_data_merge').html(JST['admin/clients/client_merge_personal'](target_client: target_client, source_client: source_client))
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
      console.log 'clicked'
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

