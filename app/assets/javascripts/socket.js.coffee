jQuery ->
  socket = io.connect('http://localhost:3030')
  socket.on 'connect', ()->
    $('#chatdisplay').append($('<p>').append($('<em>').text(prepare("connected"))))
  
  $("#proceed_to_checkout_out").on 'click', (event)->
    $('#checkout_Modal').modal()
  
  $('#checkout_Modal').on 'show', ()->
    $.ajax
      type: 'GET'
      url: "/carts/current"
      datatype: 'json'
      beforeSend: (xhr) ->
        xhr.setRequestHeader("Accept", "application/json")
      success: (cart)->
        $('#process_inf').text("Procesando orden No. #{cart.id}")
        $('#progress_bar').find('.bar')
        progressbar_advance(1)
        socket.emit 'cart:price', {cart_id: cart.id}
      error: (err)->
        console.log err
  
  socket.on 'cart:price:error', (err) ->
    $('#process_inf').text("Ha ocurrido un error en el proceso de colocación: #{err}")
    progressbar_advance(0)
  
  socket.on 'cart:price:client', (data) ->
    client = data.client
    $('#order_client_first_name').html("<strong>Nombre:</strong> #{client.first_name}")
    $('#order_client_last_name').html("<strong>Apellido:</strong> #{client.last_name}")
    $('#order_client_email').html("<strong>Email:</strong> #{client.email}")
    $('#order_client_idnumber').html("<strong>Cédula:</strong> #{window.to_idnumber(client.idnumber)}")
    $('#process_inf').text("Cliente encontrado")
    progressbar_advance(2)
    console.log 'client'

  socket.on 'cart:price:client:phones', (data) ->
    phones = data.phones
    if phones.length > 0
      for phone in phones
        $('#order_client_phones').append("<div class='row'><div class=\"span2\"><strong>Numero: </strong> #{window.to_phone(phone.number)}</div><div class=\"span2\"><strong>Extension: </strong> #{phone.ext || 'N/A'}</div></div>")
      $('#process_inf').text("Mostrando numeros telefonicos")
    progressbar_advance(3)


  socket.on 'cart:price:cartproducts', (data) ->
    cart_products = data.results
    if cart_products.length > 0
      for cart_product in cart_products
        $('#order_cart_products').append("<div class='row'><div class=\"span5\" data-cart-product-id='#{cart_product.id}'><h4>#{cart_product.quantity} x #{cart_product.product.productname}</h4><p><strong>Opciones: </strong> #{cart_product.options}<p></div></div>")
      $('#process_inf').text("Mostrando lista de productos")
    progressbar_advance(4)

    
  socket.on 'cart:price:pulse:start', () ->
    $('#process_inf').text("Iniciando comunicación con pulse")
    progressbar_advance(5)


  socket.on 'cart:price:pulse:itempriced', (data) ->
    $('#order_cart_products').find(".span5[data-cart-product-id='#{data.item_id}']").append("<p><strong>Precio: </strong>$ #{Number(data.price).toFixed(2).toString()}</p>")

  socket.on 'cart:price:pulse:cartpriced', (data) ->
    $('#order_totals').append("<div class='row'><div class=\"span4\"'><p><strong>Neto: </strong>$#{data.net_amount}</p><p><strong>Impuestos: </strong>$<span id='order_tax'>#{data.tax_amount}</span></p><p><strong>Total: </strong>$#{data.payment_amount}</p></div></div>")
    $('#order_totals').append("<div class='row'><div class=\"span4\"'><label class=\"checkbox\"><input type=\"checkbox\" id='discount_tax'> Aplicar exoneración</label></div></div>")
    $('#order_totals').append("<div class='row'><div class=\"span4\"'><label class=\"checkbox\"><input type=\"checkbox\" id='discount_amount'> Aplicar descuento</label></div></div>")
    $('#order_totals').append("<div class='row'><div class=\"span4\"'><input type=\"text\" class=\"span2\" id='order_discount_amount' placeholder=\"Monto a descontar\"></div></div>")
    $('#order_totals').append("<div class='row'><div class=\"span4\"'><strong>Autorización</strong></div></div>")
    $('#order_totals').append("<div class='row'><div class=\"span4\"'><input type=\"text\" class=\"span2\" id='discount_user' placeholder=\"supervisor\"></div></div>")      
    $('#order_totals').append("<div class='row'><div class=\"span4\"'><input type=\"password\" class=\"span2\" id='discount_pass'></div></div>")     
    $('#order_totals').append("<div class='row'><div class=\"span4\"'><button type=\"submit\" class=\"btn\" id = 'require_discount_auth'>Autorizar</button></div></div>")
    $('#require_discount_auth').on 'click', (event)->
      target = $(event.currentTarget)
      $.ajax
        type: 'POST'
        url: "/carts/discount"
        datatype: 'json'
        data: {discount: { auth_user: $('#order_totals').find('#discount_user').val(), tax_discount_amount: $('#order_tax').text(),  auth_pass: $('#order_totals').find('#discount_pass').val(), discount_tax: $('#discount_tax').val(),  discount_amount: $('#discount_amount').val(), order_discount_amount: $('#order_discount_amount').val()}}
        beforeSend: (xhr) ->
          xhr.setRequestHeader("Accept", "application/json")
        success: (data)->
          target.after("<div class='row'><div class=\"span4\"'><strong>La Orden se colocara por #{data.new_payment_amount}</strong></div></div>")
          target.after("<div class='row'><div class=\"span4\"'>Orden autorizada por #{JSON.parse(data.authorized_by).first_name} #{JSON.parse(data.authorized_by).last_name}</div></div>")
          $('#process_inf').text("Descuento aprobado")
        error: (err)->
          console.log err
    $('#process_inf').text("Totales recibidos")  
    progressbar_advance(6)
    

  
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
    
  socket.on 'start_price_sync', (data) ->
    $('#sync_message').html('<span class="label label-info">Esperando sincronización con pulse</span>')
  socket.on 'cart_price_sync', (data) ->
    $('#order_net_amount').html("<strong>Neto: </strong>$#{data.net_amount}")
    $('#order_tax_amount').html("<strong>Impuestos: </strong>$#{data.tax_amount}")
    $('#order_payment_amount').html("<strong>Total: </strong>$#{data.payment_amount}")
    $('#sync_message').html("<span class=\"label label-info\">Precio total sincronizado</span>")
  socket.on 'item_price_sync', (data) ->
    $('#current_carts_items').find(".item[data-cart-product-id='#{data.item_id}']").find('span.pricing:first').html("$ #{Number(data.price).toFixed(2).toString()} <i class= 'icon-ok icon-white'></i>")

    
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
      
  progressbar_advance = (times) ->
    total_width = $('#progress_bar').width()
    new_width = (times*(total_width*0.1))
    console.log new_width
    $('#progress_bar').find('.bar').css({width: "#{new_width}px"})
