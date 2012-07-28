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
      console.log order_item.priced_at
    console.log data
    
  socket.on 'reconnect', () ->
    $('#lines').remove();
    message({user:'System', msg:' Reconnected to the server'});
    
  socket.on 'error', (err)->
    console.log err
    err_data = {user: 'System', msg:  (err ? err : 'Se ha perdido la conexion')}
    message(err_data);
      
  $('#chat_send').submit (event)->
    event.preventDefault()
    socket.emit('chat', {user: me(), msg: $('#chat_message').val()})
    $('#chat_message').val('')
  
  message = (data) ->
    $('#chatdisplay').append($('<p>').append($('<b>').text(data.user), data.msg))
    $("#chatdisplay").scrollTop($("#chatdisplay")[0].scrollHeight);
  
  me = ()->
    "#{$('#current_username').text()} : "
      
  prepare = (msg) ->
    sent = new Date()
    "enviado-#{sent.toString()}: #{msg}"
      
    
  
