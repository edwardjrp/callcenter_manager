jQuery ->
  socket = window.socket
  socket.on 'connect', () -> 
    socket.emit 'register', { full_name: $('#chatbox').data('full_name'), idnumber: $('#chatbox').data('idnumber'), role: $('#chatbox').data('role') }, (response)->
      # console.log response
      
  # $('.item_remove, .show_options, .edit_options').tooltip({placement: 'bottom'})

  if $(".chatdisplay").size() > 0
    setInterval (->
      if $(".blink").size() > 0
        if $(".blink").css("font-weight") == 'normal'
          $(".blink").css("font-weight", 'bold')
        else
          $(".blink").css("font-weight", 'normal')
    ), 1000


  $('#chatbox').on 'shown', 'a[data-toggle="tab"]', (event) ->
    $(".blink").css("font-weight", 'normal')
    $(this).removeClass('blink')

  if $('#payments').size() > 0
    # console.log 'emit price'
    $('#actions').on 'click', '#place_order_button', (event)->
      event.preventDefault()
      target = $(event.currentTarget)
      socket.emit('cart:place',  $('#checkout_cart').data('id')) unless target.hasClass('disabled')
      target.addClass('disabled')
    socket.on 'cart:place:completed', (data)->
      $.ajax
        type: 'POST'
        url: "/carts/#{data.id}/completed"
        datatype: 'SCRIPT'
        data: data
        beforeSend: (xhr) ->
          xhr.setRequestHeader("Accept", "application/json")
        complete: ->
          window.location = '/'

    socket.emit 'cart:price', $('#checkout_cart').data('id')
    socket.on 'cart:priced', (data)->
      $('#checkout_cart_net').html("<strong> Monto neto: </strong>RD$ #{Number(data.order_reply.netamount).toFixed(2)}")
      $('#checkout_cart_tax').html("<strong>  Impuestos: </strong>RD$ #{Number(data.order_reply.taxamount).toFixed(2)}")
      $('#checkout_cart_total').html("<strong> Monto de la orden: </strong>RD$ #{Number(data.order_reply.payment_amount).toFixed(2)}")
      $('#actions').append('<a href="#" id="place_order_button" class="btn bottom-margin-1"><i class="icon-shopping-cart"></i> Colocar orden</a>') unless $('#place_order_button').size() > 0
      _.each data.items, (item)->
        $("#cart_product_#{item.cart_product_id}").find('.item_price').html("RD$ #{Number(item.priced_at).toFixed(2)}")

  socket.on 'register_client', (operators) ->  
    $('#chatbox').find('.operator_tab').remove()
    $('#chatbox').find('.operator_pane').remove()
    for operator in operators
      $('#chatbox').find('.nav-tabs').append("<li class='operator_tab'><a href ='##{operator.idnumber}' data-toggle = 'tab'>#{operator.full_name}</a></li>")
      $('#chatbox').find('.tab-content').append(JST['chat/operator_tab'](operator: operator))

  socket.on 'set_admin', (data) ->
    $('#chatbox').find('#admin_tab').remove()
    $('#chatbox').find('#admin_pane').remove()
    $('#chatbox').find('.nav-tabs').append("<li id='admin_tab' ><a href ='#admin_pane' data-toggle = 'tab'>administradores</a></li>")
    $('#chatbox').find('.tab-content').append(JST['chat/admin_tab']())
    $('#admin_pane').find('.chatdisplay').append($('<p>').append(window.truncate(data, 30)))
  
  $('#utils_labels a').on 'click', (event)->
    event.preventDefault()
    $(this).tab('show')

  if $('#desk').size() > 0
    $('#quick_coupons').find('tr').append("<td><a class='btn add_coupon'>Agregar</a></td>")
    $('#quick_coupons').prev('thead').find('tr').append('<th></th>')
    $('#quick_coupons').on 'click' , '.add_coupon', (event) ->
      event.preventDefault()
      target = $(event.currentTarget).closest('tr')
      socket.emit 'cart_coupons:create', {cart_id: target.data('cart-id'), coupon_code: target.data('coupon-code'), coupon_id: target.data('coupon-id'), target_products: target.data('coupon-products')}

  $('#close_utils').on 'click', (event)->
    console.log $('#utils_labels').next()
    for tab_contents in $('#utils_labels').next().find('.tab-pane')
      $(tab_contents).removeClass('active')

  socket.on 'server_message', (data) ->
    if $('#chatbox').find("##{data.idnumber}")
      $('#chatbox').find("##{data.idnumber}").closest('.tab-content').prev('ul').find("a[href=##{data.idnumber}]").addClass('blink') unless $('#chatbox').find("##{data.idnumber}").is(':visible') 
      $('#chatbox').find("##{data.idnumber}").find('.chatdisplay').append($('<p>').append(window.truncate(data.msg, 30)))
      $('#chatbox').find("##{data.idnumber}").find('.chatdisplay').scrollTop($('#chatbox').find("##{data.idnumber}").find('.chatdisplay')[0].scrollHeight);
      $('#chatbox').find("##{data.idnumber}").find('.chatdisplay').children().first().remove() if $('#chatbox').find("##{data.idnumber}").find('.chatdisplay').children().size() > 50

    if  $('#chatbox').find("#admin_pane")
      $('#chatbox').find("#admin_pane").find('.chatdisplay').append($('<p>').append(window.truncate(data.msg, 30)))
      $('#chatbox').find("#admin_pane").find('.chatdisplay').scrollTop($('#chatbox').find("#admin_pane").find('.chatdisplay')[0].scrollHeight);
      $('#chatbox').find("#admin_pane").find('.chatdisplay').children().first().remove() if $('#chatbox').find("#admin_pane").find('.chatdisplay').children().size() > 50

  $('#chatbox').on 'submit', 'form', (event)->
    event.preventDefault()
    target = $(event.currentTarget)
    socket.emit 'send_message', { msg: target.find('.send_message').val(), to: target.closest('.active').attr('id'), idnumber: $('#chatbox').data('idnumber'), role: $('#chatbox').data('role') } , (data) ->
      target.prev('.chatdisplay').append($('<p class="my_msg">').append(window.truncate(data.msg, 30)))
      target.prev('.chatdisplay').scrollTop(target.prev('.chatdisplay')[0].scrollHeight);

    target[0].reset()
    target.find("input[type='text']").val('')
    
  socket.on 'cart:price:error', (msg)->
    $("<div class='purr'>#{msg}<div>").purr()
    
  socket.on 'reconnect', () ->
    $("<div class='purr'>Conexión con Webserver reestablecida<div>").purr()
    
  socket.on 'error', (err)->
    $("<div class='purr'>Ser perdio lo conexión al servidor<div>").purr() 
