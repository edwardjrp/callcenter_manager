jQuery ->
  socket = window.socket
  socket.on 'connect', () ->
    # $('#chatdisplay').append($('<p>').append($('<em>').text(prepare("connected"))))
    socket.emit 'register', { idnumber: $('#chatbox').data('idnumber'), role: $('#chatbox').data('role'), username: $('#chatbox').data('username') }, (response)->
      console.log response


  socket.on 'register_client', (operators) ->  
    $('#chatbox').find('.operator_tab').remove()
    $('#chatbox').find('.operator_pane').remove()
    console.log operators
    console.log 'hello'
    operators.length
    for operator in operators
      console.log operator
      $('#chatbox').find('.nav-tabs').append("<li class='operator_tab'><a href ='##{operator.idnumber}' data-toggle = 'tab'>#{operator.username}</a></li>")
      $('#chatbox').find('.tab-content').append(JST['chat/operator_tab'](operator: operator))


  
  $('#utils .top-tabs a').on 'click', (event)->
    event.preventDefault()
    target = $(".tab-pane##{$(this).attr('href').replace(/#/,'')}")
    if $(this).closest('li').hasClass('active')
      target.removeClass('active').hide()
      $(this).closest('li').removeClass('active')
    else
      target.addClass('active').show()
      $(this).closest('li').addClass('active')
      
#   socket.on 'chat', (data)->
#     message(data)    
    
#   socket.on 'reconnect', () ->
#     $('#lines').remove();
#     message({user:'System', msg:' Reconnected to the server'});
    
#   socket.on 'error', (err)->
#     console.log err
#     window.show_alert(err, 'error')
#     err_data = {user: 'System', msg:  (err ? err : 'Se ha perdido la conexion')}
#     message(err_data);
      
#   $('#chat_send').submit (event)->
#     event.preventDefault()
#     unless $('#chat_message').val() == ''
#       socket.emit('chat', {user: me(), msg: $('#chat_message').val()})
#       $('#chat_message').val('')
  
# message = (data) ->
#   $('#chatdisplay').append($('<p>').append($('<b>').text(data.user), window.truncate(data.msg, 30)))
#   $('#chatdisplay').children().first().remove() if $('#chatdisplay').children().size() > 50
#   $("#chatdisplay").scrollTop($("#chatdisplay")[0].scrollHeight);

# me = ()->
#   "#{$('#current_username').text()} : "
    
# prepare = (msg) ->
#   sent = new Date()
#   "enviado-#{sent.toString()}: #{msg}"