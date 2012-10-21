jQuery ->
  socket = window.socket
  assign_client_to_current_cart()
  assign_service_method($('#service_method_delivery'))
  assign_service_method($('#service_method_dine_in'))
  assign_service_method($('#service_method_pickup'))

  $('#filter_store').on 'click', (event)->
    event.stopPropagation()
    event.preventDefault()

  $('#filter_store').on 'keyup', (event)->
    if $(this).val() == ''
      for item in $(this).closest('ul').find('.filterable')
        $(item).show()
    else
      for item in $(this).closest('ul').find('.filterable')
        unless $(item).find('a').text().toLowerCase().match(new RegExp($(this).val().toLowerCase()))?
          $(item).hide()
        else
          $(item).show()



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
          $('#choose_service_method').text('Modo de servicio: N/A')
          $('#choose_service_method').effect('highlight')
          $('#choose_store').text('Tienda: N/A')
          $('#choose_store').effect('highlight')
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

