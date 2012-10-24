# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  socket = window.socket

  $('.best_in_place').best_in_place()

  $('.get_pulse_status').on 'click', (event) ->
    event.preventDefault()
    target = $(event.currentTarget)
    socket.emit 'cart:status', target.data('cart-id')

  socket.on 'cart:status:pulse',(data) ->
    if data
      cart = data.updated_cart
      $("#pulse_status_#{cart.id}").html("<strong>Estado en pulse:</strong> #{cart.order_progress}")

  $('#client_tax_numbers_list').on 'click', '.verified', (event)->
    event.preventDefault()
    target = $(event.currentTarget)
    $.ajax
      type: 'POST'
      url: "/tax_numbers/#{target.closest('.client_tax_number').data('tax-number').id}/verify"
      success: (tax_number)->
        target.text(tax_number)
      error: (err)->
        console.log err
        $("<div class='purr'>#{err.responseText}<div>").purr()
  

  $('#add_tax_number').on 'click', (event) ->
    event.preventDefault()
    target = $(event.currentTarget)
    $('#add_tax_number_modal').find('.modal-body').html(JST['clients/add_tax_number']())
    $('#add_tax_number_form').prepend("<input type='hidden' id='tax_number_client_id' name='client_id' value='#{_.last(window.location.href.split('/')).match(/\d+/)[0]}'>") unless $('#tax_number_client_id').length > 0
    $('#client_tax_number_rnc').restric('alpha').restric('spaces')
    $('#add_tax_number_modal').modal('show')


  $('#add_tax_number_modal_button').on 'click', (event)->
    event.preventDefault()
    target = event.currentTarger
    $.ajax
      type: 'POST'
      datatype: 'json'
      data: $('#add_tax_number_form').serialize()
      url: '/tax_numbers'
      beforeSend: (xhr) ->
        xhr.setRequestHeader("Accept", "application/json")
      success: (tax_number)->
        $('#client_tax_numbers_list').prepend(JST['clients/tax_number'](tax_number: tax_number))
        $('#add_tax_number_modal').modal('hide')
      error: (err)->
        $("<div class='purr'>#{err.responseText}<div>").purr()



  $('#add_address').on 'click', (event)->
    event.preventDefault()
    $('#add_address_modal').find('.modal-body').html(JST['clients/add_address']())
    $('#add_address_form').prepend("<input type='hidden' id='address_client_id' name='client_id' value='#{_.last(window.location.href.split('/')).match(/\d+/)[0]}'>") unless $('#address_client_id').length > 0
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
    $('#add_address_modal').modal('show')

  $('#add_address_modal_button').on 'click', (event)->
    event.preventDefault()
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

  $('#add_phone').on 'click', (event)->
    event.preventDefault()
    $('#add_phone_modal').find('.modal-body').html(JST['clients/add_phone']())
    $('#add_phone_form').prepend("<input type='hidden' id='phone_client_id' name='client_id' value='#{_.last(window.location.href.split('/')).match(/\d+/)[0]}'>") unless $('#phone_client_id').length > 0
    $('#client_phone_number').restric('alpha').restric('spaces')
    $('#client_ext_number').restric('alpha').restric('spaces')
    $('#add_phone_modal').modal('show')

  $('#add_phone_modal_button').on 'click', (event)->
    event.preventDefault()
    target = event.currentTarger
    $.ajax
      type: 'POST'
      datatype: 'json'
      data: $('#add_phone_form').serialize()
      url: '/phones'
      beforeSend: (xhr) ->
        xhr.setRequestHeader("Accept", "application/json")
      success: (phone)->
        $('#client_phone_list').prepend(JST['clients/phone'](phone: phone))
        $('#add_phone_modal').modal('hide')
      error: (err)->
        for error in JSON.parse(err.responseText)
          $("<div class='purr'>#{error}<div>").purr()

  $('#client_phone_list').on 'click', '.btn_edit', (event)->
    event.preventDefault()
    target = $(event.currentTarget)
    modal = target.closest('.client_phone').prev()
    phone = target.closest('.client_phone').data('phone')
    modal.modal('show')
    modal.find('.modal-body').html(JST['clients/edit_phone'](phone: phone))

  $('#client_tax_numbers_list').on 'click', '.btn_edit', (event)->
    event.preventDefault()
    target = $(event.currentTarget)
    modal = target.closest('.client_tax_number').prev()
    tax_number = target.closest('.client_tax_number').data('tax-number')
    modal.modal('show')
    modal.find('.modal-body').html(JST['clients/edit_tax_number'](tax_number: tax_number))

  $('#client_phone_list').on 'click', '.btn-primary', (event)->
    event.preventDefault()
    target = $(event.currentTarget)
    form = target.parent().prev().find('form')
    phone_id = target.parent().prev().find('form').data('phone-id')
    $.ajax
      type: 'PUT'
      datatype: 'json'
      data: form.serialize()
      url: "/phones/#{phone_id}"
      beforeSend: (xhr) ->
        xhr.setRequestHeader("Accept", "application/json")
      success: (phone)->
        $("#phone_#{phone.id}").replaceWith(JST['clients/phone'](phone: phone))
        target.closest('.modal').modal('hide')
        $("#phone_#{phone.id}").effect('highlight',  {}, 500)
      error: (err)->
        $("<div class='purr'>#{err.responseText}<div>").purr()

  $('#client_tax_numbers_list').on 'click', '.btn-primary', (event)->
    event.preventDefault()
    target = $(event.currentTarget)
    form = target.parent().prev().find('form')
    tax_number_id = target.parent().prev().find('form').data('tax-number-id')
    $.ajax
      type: 'PUT'
      datatype: 'json'
      data: form.serialize()
      url: "/tax_numbers/#{tax_number_id}"
      beforeSend: (xhr) ->
        xhr.setRequestHeader("Accept", "application/json")
      success: (tax_number)->
        $("#tax_number_#{tax_number.id}").replaceWith(JST['clients/tax_number'](tax_number: tax_number))
        target.closest('.modal').modal('hide')
        $("#tax_number_#{tax_number.id}").effect('highlight',  {}, 500)
      error: (err)->
        $("<div class='purr'>#{err.responseText}<div>").purr()



  $('#client_address_list').on 'click', '.btn-primary', (event)->
    event.preventDefault()
    target = $(event.currentTarget)
    form = target.parent().prev().find('form')
    address_id = target.parent().prev().find('form').data('address-id')
    form.find("input[name='address[street_id]']").val(form.find("input[name='address[street_id]']").data('street-id')) unless form.find("input[name='address[street_id]']") == ''
    $.ajax
      type: 'PUT'
      datatype: 'json'
      data: form.serialize()
      url: "/addresses/#{address_id}"
      beforeSend: (xhr) ->
        xhr.setRequestHeader("Accept", "application/json")
      success: (address)->
        $("#address_#{address.id}").replaceWith(JST['clients/address'](address: address))
        target.closest('.modal').modal('hide')
        $("#address_#{address.id}").effect('highlight',  {}, 500)
      error: (err)->
        $("<div class='purr'>#{err.responseText}<div>").purr()


  $('#client_address_list').on 'click', '.btn_edit', (event)->
    event.preventDefault()
    target = $(event.currentTarget)
    modal = target.closest('.client_address').prev()
    address = target.closest('.client_address').data('address')
    modal.modal('show')
    modal.find('.modal-body').html(JST['clients/edit_address'](address: address))
    $("#client_address_city_#{address.id}").select2
      placeholder: 'Selecione una ciudad'
      data: _.map( $('#add_address').data('cities'), (c) -> {id: c.id, text: c.name} )
    $("#client_address_area_#{address.id}").select2
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
    $("#client_address_street_#{address.id}").select2
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


  $('#client_tax_numbers_list').on 'click', '.btn_trash', (event)->
    event.preventDefault()
    target = $(event.currentTarget)
    if confirm('¿Seguro que desea borrar este número fiscal?')
      $.ajax
        type: 'DELETE'
        datatype: 'json'
        url: "/tax_numbers/#{target.closest('.client_tax_number').data('tax-number').id}"
        success: ()->
          target.closest('.client_tax_number').next('hr').remove()
          target.closest('.client_tax_number').remove()
        error: (err)->
          alert('No se pudo realizar la operación')


  $('#client_address_list').on 'click', '.btn_trash', (event)->
    event.preventDefault()
    target = $(event.currentTarget)
    if confirm('¿Seguro que desea borrar esta dirección?')
      $.ajax
        type: 'DELETE'
        datatype: 'json'
        url: "/addresses/#{target.closest('.client_address').data('address').id}"
        success: ()->
          target.closest('.client_address').next('hr').remove()
          target.closest('.client_address').remove()
        error: (err)->
          alert('No se pudo realizar la operación')

  $('#client_phone_list').on 'click', '.btn_trash', (event)->
    event.preventDefault()
    target = $(event.currentTarget)
    if confirm('¿Seguro que desea borrar este telefono?')
      $.ajax
        type: 'DELETE'
        datatype: 'json'
        url: "/phones/#{target.closest('.client_phone').data('phone').id}"
        success: ()->
          target.closest('.client_phone').next('hr').remove()
          target.closest('.client_phone').remove()
        error: (err)->
          $("<div class='purr'>#{err.responseText}<div>").purr()
  

  $('#client_phone_list').on 'click', '.set_last_phone', (event) ->
    event.preventDefault()
    target = $(event.currentTarget)
    $.ajax
      type: 'POST'
      datatype: 'json'
      url: "/clients/#{_.last(window.location.href.split('/')).match(/\d+/)[0]}/set_last_phone"
      data: { phone_id: target.closest('.client_phone').data('phone').id }
      success: (old_phone)->
        label = target.closest('.client_phone').find('.span4:first')
        label.html("<i class='icon-star'></i>#{label.html()}")
        target.remove()
        if old_phone?
          old_last_phone = $("#phone_#{old_phone.id}")
          old_last_phone.find('.span4:first').find('.icon-star').remove()
          old_last_phone.find('.btn-group').prepend('<button class="btn set_last_phone"><i class="icon-star"></i></button>') unless old_last_phone.find('.btn-group').find('.set_last_phone').size() > 0
      error: (err)->
        $("<div class='purr'>#{err.responseText}<div>").purr()

  $('#client_address_list').on 'click', '.set_last_address', (event) ->
    event.preventDefault()
    target = $(event.currentTarget)
    $.ajax
      type: 'POST'
      datatype: 'json'
      url: "/clients/#{_.last(window.location.href.split('/')).match(/\d+/)[0]}/set_last_address"
      data: { address_id: target.closest('.client_address').data('address').id }
      success: (old_address)->
        label = target.closest('.client_address').find('.span4:first')
        label.html("<i class='icon-star'></i>#{label.html()}")
        target.remove()
        if old_address?
          old_last_address = $("#address_#{old_address.id}")
          old_last_address.find('.span4:first').find('.icon-star').remove()
          old_last_address.find('.btn-group').prepend('<button class="btn set_last_address"><i class="icon-star"></i></button>') unless old_last_address.find('.btn-group').find('.set_last_address').size() > 0
      error: (err)->
        $("<div class='purr'>#{err.responseText}<div>").purr()







