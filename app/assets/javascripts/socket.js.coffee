jQuery ->
  socket = io.connect('http://localhost:3030')
  socket.on 'connect', ()->
    $('#chatdisplay').append($('<p>').append($('<em>').text(prepare("connected"))))
  
  $('#utils .nav a').on 'click', (event)->
    event.preventDefault()
    if $(this).closest('li').hasClass('active')
      target = $(".tab-pane##{$(this).attr('href').replace(/#/,'')}")
      target.removeClass('active').hide()
      $(this).closest('li').removeClass('active')
    else
      target= $(".tab-pane##{$(this).attr('href').replace(/#/,'')}")
      target.addClass('active').show()
      $(this).closest('li').addClass('active')
      
  socket.on 'chat', (data)->
    message(data)
    
  socket.on 'price', (data) ->
    order_reply = data.msg
    for order_item in order_reply.order_items
      for el in $('#current_carts_items').find('span.pricing')
        if $(el).parent().parent().find('input[type=text]').val() ==  order_item.quantity and $(el).parent().parent().data('cart-product-code') == order_item.code and _.isEmpty(_.difference(order_item.options, _.compact($(el).data('options').split(','))))
          $(el).text("$ #{Number(order_item.priced_at).toFixed(2)}")
    $('#order_net_amount').html("<strong>Neto: </strong>$#{order_reply.netamount}")
    $('#order_tax_amount').html("<strong>Impuestos: </strong>$#{order_reply.taxamount}")
    $('#order_payment_amount').html("<strong>Total: </strong>$#{order_reply.payment_amount}")

  socket.on 'start_price_sync', (data) ->
    $('#sync_message').html('<span class="label label-info">Esperando sincronización con pulse</span>')
  socket.on 'done_price_sync', (data) ->
    $('#sync_message').html('<span class="label label-info">Precio sincronizado</span>')

    
  socket.on 'data_error', (err)->
    switch err.type
      when 'pulse_connection'
        window.show_alert("La comunicación pulse Falló: #{err.msg}", 'error')
        $('#sync_message').html('<span class="label label-important">Los precios no estan sincronizados</span>')
      when 'db_error' then window.show_alert("No se pudo actualizar la base de datos #{err.msg}", 'error')
    
  socket.on 'reconnect', () ->
    $('#lines').remove();
    message({user:'System', msg:' Reconnected to the server'});
    
  socket.on 'error', (err)->
    console.log err
    window.show_alert(err, 'error')
    err_data = {user: 'System', msg:  (err ? err : 'Se ha perdido la conexion')}
    message(err_data);
      
  $('#chat_send').submit (event)->
    event.preventDefault()
    socket.emit('chat', {user: me(), msg: $('#chat_message').val()})
    $('#chat_message').val('')
  
  message = (data) ->
    $('#chatdisplay').append($('<p>').append($('<b>').text(data.user), window.truncate(data.msg, 30)))
    $("#chatdisplay").scrollTop($("#chatdisplay")[0].scrollHeight);
  
  me = ()->
    "#{$('#current_username').text()} : "
      
  prepare = (msg) ->
    sent = new Date()
    "enviado-#{sent.toString()}: #{msg}"
      
    
  
