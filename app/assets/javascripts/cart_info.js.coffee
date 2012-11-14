jQuery ->
  socket = window.socket
  assign_client_to_current_cart()
  assign_service_method('#service_method_delivery')
  assign_service_method('#service_method_dine_in')
  assign_service_method('#service_method_pickup')

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
        datatype: 'SCRIPT'
        data: {client_id: $('#client_id').val()}
        beforeSend: (xhr) ->
          xhr.setRequestHeader("Accept", "text/javascript") 
        success: (script) ->
          eval(script)
        
assign_service_method = (target)->
  $('#cart_info').on 'click', target , (event) ->
    $('#choose_service_method').text('Modo de servicio: Actualizando')
    $.ajax
      type: 'post'
      url: "/carts/service_method"
      datatype: 'SCRIPT'
      data: {service_method: $(target).data('service-method')}
      beforeSend: (xhr) ->
        xhr.setRequestHeader("Accept", "text/javascript") 
      success: (script)->
        eval(script)


