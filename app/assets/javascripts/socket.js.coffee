jQuery ->
  socket = window.socket
  socket.on 'connect', () ->
    socket.emit 'register', { full_name: window.user_name, idnumber: window.user_id, role: window.user_role }, (response)->
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
    for tab in $('#utils_labels').find('li')
      $(tab).removeClass('active')
    for tab_contents in $('#utils_labels').next().find('.tab-pane')
      $(tab_contents).removeClass('active')

  socket.on 'server_message', (data) ->
    messanger_id = window.pad(data.idnumber,11)
    if $('#chatbox').find("##{messanger_id}").size() > 0
      $('#chatbox').find("##{messanger_id}").closest('.tab-content').prev('ul').find("a[href=##{messanger_id}]").addClass('blink') unless $('#chatbox').find("##{messanger_id}").is(':visible') 
      $('#chatbox').find("##{messanger_id}").find('.chatdisplay').append($('<p>').append(window.truncate(data.msg, 30)))
      $('#chatbox').find("##{messanger_id}").find('.chatdisplay').scrollTop($('#chatbox').find("##{messanger_id}").find('.chatdisplay')[0].scrollHeight);
      $('#chatbox').find("##{messanger_id}").find('.chatdisplay').children().first().remove() if $('#chatbox').find("##{messanger_id}").find('.chatdisplay').children().size() > 50

    if  $('#chatbox').find("#admin_pane").size() > 0
      $('#chatbox').find("#admin_pane").find('.chatdisplay').append($('<p>').append(window.truncate(data.msg, 30)))
      $('#chatbox').find("#admin_pane").find('.chatdisplay').scrollTop($('#chatbox').find("#admin_pane").find('.chatdisplay')[0].scrollHeight);
      $('#chatbox').find("#admin_pane").find('.chatdisplay').children().first().remove() if $('#chatbox').find("#admin_pane").find('.chatdisplay').children().size() > 50
    window.chat_message.play()

  $('#chatbox').on 'submit', 'form', (event)->
    event.preventDefault()
    target = $(event.currentTarget)
    socket.emit 'send_message', { msg: target.find('.send_message').val(), to: target.closest('.active').attr('id'), idnumber: $('#chatbox').data('idnumber'), role: $('#chatbox').data('role') } , (data) ->
      target.prev('.chatdisplay').append($('<p class="my_msg">').append(window.truncate(data.msg, 30)))
      target.prev('.chatdisplay').scrollTop(target.prev('.chatdisplay')[0].scrollHeight);

    target[0].reset()
    target.find("input[type='text']").val('')   

  socket.on "cart:status:error", (msg)->
    $("<div class='purr'>#{msg}<div>").purr()
  
  socket.on "coupon:error", (msg)->
    $("<div class='purr'>#{msg}<div>").purr()
    
  socket.on 'cart:price:error', (msg)->
    $("<div class='purr'>#{msg}<div>").purr()
    
  socket.on 'disconnect', () ->
    $("<div class='purr'>Se perdio la conexión con el Webserver<div>").purr({removeTimer: 5000})

  socket.on 'reconnect', () ->
    $("<div class='purr'>Conexión con Webserver reestablecida<div>").purr()
    
  socket.on 'error', (err)->
    $("<div class='purr'>Ser perdio lo conexión al servidor<div>").purr() 
