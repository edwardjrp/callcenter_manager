jQuery ->
  chat_socket = io.connect('http://localhost:3030')
  chat_socket.on 'connect', ()->
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
      
  chat_socket.on 'chat', (data)->
    message(data)
    
  chat_socket.on 'reconnect', () ->
    $('#lines').remove();
    message({user:'System', msg:' Reconnected to the server'});
    
  chat_socket.on 'error', (err)->
    console.log err
    err_data = {user: 'System', msg:  (err ? err : 'Se ha perdido la conexion')}
    message(err_data);
      
  $('#chat_send').submit (event)->
    event.preventDefault()
    chat_socket.emit('chat', {user: me(), msg: $('#chat_message').val()})
    $('#chat_message').val('')
  
  message = (data) ->
    $('#chatdisplay').append($('<p>').append($('<b>').text(data.user), data.msg))
    $("#chatdisplay").scrollTop($("#chatdisplay")[0].scrollHeight);
  
  me = ()->
    "#{$('#current_username').text()} : "
      
  prepare = (msg) ->
    sent = new Date()
    "enviado-#{sent.toString()}: #{msg}"
      
    
  
