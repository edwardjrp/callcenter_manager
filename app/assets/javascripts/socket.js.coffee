jQuery ->
  socket = window.socket
  socket.on 'connect', () -> 
    socket.emit 'register', { full_name: $('#chatbox').data('full_name'), idnumber: $('#chatbox').data('idnumber'), role: $('#chatbox').data('role') }, (response)->
      # console.log response
      
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


  socket.on 'cart:place:error', (msg) ->
    $("<div class='purr'>#{msg}<div>").purr()

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

  $('#quick_coupons').on 'click' , '.add_coupon', (event) ->
    event.preventDefault()
    target = $(event.currentTarget).closest('tr')
    socket.emit 'cart_coupons:create', {cart_id: target.data('cart-id'), coupon_code: target.data('coupon-code'), coupon_id: target.data('coupon-id'), target_products: target.data('coupon-products')}

  $('#close_utils').on 'click', (event)->
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
