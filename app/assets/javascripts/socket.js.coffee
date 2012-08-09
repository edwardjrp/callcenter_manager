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
        $('#order_info').find('.row:first').after("<div class='row bottom-margin-1'><div class=\"span2 \"><strong>Modo de servicio: </strong> #{cart.service_method}</div></div>")
        $('#order_info').find('.row:first').after("<div class='row bottom-margin-1'><div class=\"span2 \"><strong>Tienda: </strong> #{cart.store.name} - #{cart.store.storeid}</div></div>")  
        console.log cart
        progressbar_advance(1)
        socket.emit 'cart:price', {cart_id: cart.id}
      error: (err)->
        console.log err
  
  
  $('#checkout_Modal').on 'hide', ()->
    alert('FALTA CORREGIR ERROR DE DUPLICACION')
  
  
  if $('#client_search_panel').size() > 0
    $('#client_search_panel').on 'click', '#import_client_button', (event) ->
      event.preventDefault()
      phone = $('#client_search_phone').val()
      ext= $('#client_search_ext').val()
      unless phone? or phone.length != 10
        $("<div class='purr'>Debe ingresar un numero telefonico valido<div>").purr()
      else
        $("#import_client_modal").modal('show')
        socket.emit 'clients:olo:index', {phone: window.NumberFormatter.to_clear(phone), ext: ext}, (response)->
          $("#import_client_modal").find('.modal-footer').remove()
          if response? and response.type == 'success'
            if _.any(response.data)
              clients = response.data
              clients = [clients] unless _.isArray(clients)
              $("#import_client_modal").find('.modal-body').html(JST['clients/import_client'](clients: clients))
              $('#import_client_wizard').smartWizard
                labelNext: 'Siguiente'
                labelPrevious: 'Anterior'
                labelFinish: 'Terminar'
                onLeaveStep:leaveAStepCallback
            else
              $("#import_client_modal").modal('hide')
              $("<div class='purr'>No hay clientes en olo2 con este numero telefonico<div>").purr()
          else
            $("<div class='purr'>#{response.data}<div>").purr()



  socket.on 'cart:price:error', (err) ->
    $('#process_inf').text("Ha ocurrido un error en el proceso de colocación: #{err}")
    $('a#place_order').addClass('disabled')  
    $('a#place_order').off 'click'
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
        $('#order_cart_products').append("<div class='row bottom-margin-1 top-margin-1'><div class=\"span5\" data-cart-product-id='#{cart_product.id}'><h4>#{cart_product.quantity} x #{cart_product.product.productname}</h4><p><strong>Opciones: </strong> #{cart_product.options}<p></div></div>")
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
    $('a#place_order').removeClass('disabled')  
    $('a#place_order').on 'click', (event)->
      socket.emit 'cart:place', {cart_id: cart.id}  
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


leaveAStepCallback = (obj)->
  isStepValid = true
  step_num = obj.attr('rel')
  if step_num == '1' || step_num == 1
    isStepValid = false if $('#step-1').find('input[type=radio]:checked').size() == 0
    $('#import_client_wizard').smartWizard('showMessage','Debe selecionar un cliente primero');
  isStepValid
  

reset_modal =   '<div class="row">
            <div class="span8" id="process_inf">Inciando ...</div>
          </div>
          <div class="row">
            <div class="span8" id="progress_bar">
              <div class="progress progress-striped active">
                <div class="bar" style="width: 0%;"></div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="span4" id="client_info">
              <div class="row">
                <div class="span4 bottom-margin-1">
                  <h4>Validation de Datos del cliente</h4>
                </div>
              </div>
              <div class="row">
                <div class="span2" id="order_client_first_name"></div>
                <div class="span2" id="order_client_last_name"></div>
              </div>
              <div class="row">
                <div class="span2" id="order_client_email"></div>
                <div class="span2" id="order_client_idnumber"></div>
              </div>
              <div class="row">
                <div class="span4" id="order_client_phones"></div>
              </div>
              <div class="row">
                <div class="span4">
                  <hr>
                </div>
              </div>
              <div class="row">
                <div class="span4 bottom-margin-1">
                  <h4>Totales</h4>
                </div>
              </div>
              <div class="row">
                <div class="span4" id="order_totals"></div>
              </div>
              <div class="row">
                <div class="span4">
                  <hr>
                </div>
              </div>
            </div>
            <div class="span4" id="order_info">
              <div class="row">
                <div class="span4 bottom-margin-1">
                  <h4>Datos de la orden</h4>
                </div>
              </div>
              <div class="row">
                <div class="span4" id="order_cart_products"></div>
              </div>
            </div>
          </div>'