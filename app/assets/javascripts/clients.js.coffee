# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('#add_address').on 'click', (event)->
    $('#add_address_modal').find('.modal-body').html(JST['clients/add_address']())
    $('#add_address_form').prepend("<input type='hidden' name='client_id' value='#{_.last(window.location.href.split('/')).match(/\d/)[0]}'>") unless $('#client_id').length > 0
    $('#client_address_city').select2
      placeholder: 'Selecione una ciudad'
      data: _.map( $('#add_address').data('cities'), (c) -> {id: c.id, text: c.name} )
    $('#client_address_area').select2
      placeholder: "Seleccione un sector"
      minimumInputLength: 2
      ajax:
        url: '/addresses/areas.json'
        datatype: 'json'
        data: (term, page)->
          q:term
          city_id: $('#client_address_city').val()
        results: (areas, page)->
          results: _.map(areas, (area)->
              {id: area.id, text: area.name}
            )
    $('#client_address_street').select2
      placeholder: "Seleccione una calle"
      minimumInputLength: 1
      ajax:
        url: '/addresses/streets.json'
        datatype: 'json'
        data: (term, page)->
          q:term
          area_id: $('#client_address_area').val()
        results: (streets, page)->
          results: $.map(streets, (street)->
              {id: street.id, text: street.name}
            )
    $('#add_address_modal_button').on 'click', (event)->
      target = event.currentTarger
      $.ajax
        type: 'POST'
        datatype: 'json'
        data: $('#add_address_form').serialize()
        url: '/addresses'
        beforeSend: (xhr) ->
          xhr.setRequestHeader("Accept", "application/json")
        success: (address)->
          $('#client_address_list').prepend(JST['clients/address'](address: address))
          $('#add_address_modal').modal('hide')
        error: (err)->
          for error in JSON.parse(err.responseText)
            $("<div class='purr'>#{error}<div>").purr()
            console.log error
    $('#add_address_modal').modal('show')